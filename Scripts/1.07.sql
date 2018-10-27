-- Update Database to ver. 1.07. Generated on 5/1/2010
DROP PROCEDURE [spCase_GetDocumentPath]
GO

CREATE PROCEDURE [dbo].[spCase_GetDocumentPath]
 @CaseNbr int,
 @DocType varchar(25) = NULL,
 @DocPath varchar(90) OUTPUT
AS
BEGIN
 DECLARE @BasePath varchar(70), @CaseAddedDate datetime, @DateCode varchar(7)

 -- STEP 1: Get The Case Added Date
 SELECT @CaseAddedDate = dateadded 
 FROM tblCase
 WHERE CaseNbr = @CaseNbr

 -- RETURN Error 99 if no case found
 IF (ISDATE(@CaseAddedDate) = 0) 
 BEGIN
  RETURN 99
 END
 
 -- STEP 2. Get The Document Base Path
 IF @DocType = 'invoice' OR @DocType = 'voucher'
  BEGIN
   SELECT @BasePath = dirAcctDocument 
   FROM vwOfficeIMEData 
   WHERE officecode = 1 
  END
 ELSE 
  BEGIN
   SELECT @BasePath = dirdocument 
   FROM vwOfficeIMEData 
   WHERE officecode = 1
  END

 -- RETURN Error 98, no base path found
 IF (@BasePath IS NULL)
 BEGIN
  RETURN 98
 END

 -- STEP 3. Get The Date Code (use YY-MM of case added), pad with zero if neccessary
 SET @DateCode = CONVERT(varchar(4), YEAR(@CaseAddedDate)) + '-'
 IF (MONTH(@CaseAddedDate) < 10)
 BEGIN
  SET @DateCode = @DateCode + '0'
 END
 SET @DateCode = @DateCode + CONVERT(varchar(2), MONTH(@CaseAddedDate))
 
 -- Step 4. Combine The Base Directory with the date code (Base Directory (with trailing \) + Date Code + \ + CaseNbr + \) 
 SET @DocPath = @BasePath + @DateCode + '\' + CONVERT(varchar(20), @CaseNbr) + '\'

END


GO

DROP PROCEDURE [spRptFlashReport]
GO



CREATE PROCEDURE [dbo].[spRptFlashReport]
@month int,
@year int,
@sReport varchar (20) ,
@OfficeCode int
AS 
if @sReport = 'CurrentBilled'
begin
set nocount on

create table #lineItems
(DocumentType varchar(2),
 DocumentNbr int not null,
 LineNbr int,
 Description varchar(100),
 ReportCategory varchar(25),
 Revenue money not null,
 Expense money not null,
 ExtendedAmount money not null)

insert into #lineItems
select
  tblAcctHeader.DocumentType, tblAcctHeader.DocumentNbr, tblAcctDetail.LineNbr,
  tblProduct.Description,
  isnull(tblFRModifier.FRModifier, isnull(tblFRCategory.FRCategory, 'Other')) as ReportCategory,
  case when tblacctheader.documenttype = 'IN' then isnull(tblacctdetail.extendedamount,0) else 0 end as Revenue,
  case when tblacctheader.documenttype = 'VO' then isnull(tblacctdetail.extendedamount,0) else 0 end as Expense,
  isnull(tblacctdetail.ExtendedAmount,0) as ExtendedAmount
from tblAcctHeader
inner join tblAcctDetail on tblAcctHeader.documentnbr = tblAcctDetail.documentnbr and tblacctheader.documenttype = tblacctdetail.documenttype
left outer join tblCase on tblAcctHeader.casenbr = tblCase.casenbr
left outer join tblCaseType on tblCaseType.code = tblCase.casetype
left outer join tblProduct on tblProduct.prodcode = TblAcctDetail.prodcode
left outer join tblClient on tblCase.clientcode = tblClient.clientcode
left outer join tblCompany on tblClient.companycode = tblCompany.companycode
left outer join tblDoctor on tblCase.doctorcode = tblDoctor.doctorcode
left outer join tblServices on tblCase.servicecode = tblServices.servicecode
left outer join tblFRCategory on tblCase.casetype = tblFRCategory.CaseType and TblAcctDetail.prodcode = tblFRCategory.ProductCode
left outer join tblFRModifier on tblCase.casetype = tblFRModifier.casetype and tblAcctDetail.prodcode = tblFRModifier.ProductCode and
               tblClient.companycode = tblFRModifier.companycode
where (tblAcctHeader.documentstatus = 'Final') and (tblcase.officecode = @OfficeCode or @officecode = -1)
 and month(tblAcctHeader.DocumentDate) = @month and year(tblAcctHeader.DocumentDate) = @year

select ReportCategory, sum(FRUnits)as sumDocuments, sum(revenue) as SumRevenue, sum(expense) as SumExpense , sum(amount) as SumMargin from 
(
select
  ReportCategory,
  case
    when (select count(*) from #lineItems as counter
   where counter.DocumentType=#lineItems.DocumentType
   and counter.DocumentNbr=#lineItems.DocumentNbr
   and counter.ReportCategory=#lineItems.ReportCategory
   and counter.LineNbr<=#lineItems.LineNbr) = 1 then
      case  
        when DocumentType = 'IN' then
          case when ExtendedAmount < 0 then -1 else 1 end
        else 0
      end
    else 0 
  end as FRUnits,
  Revenue, Expense,
  case
    when DocumentType = 'IN' then ExtendedAmount
    else -ExtendedAmount
  end as Amount
from #lineItems
) as lines
group by ReportCategory
order by ReportCategory

drop table #lineItems

end

if @sReport = 'CurrentScheduled'
begin
select reportcategory,  count(casenbr) as  sumDocuments from 
(SELECT     dbo.tblCase.casenbr as casenbr, ISNULL
                          ((SELECT     frmodifier
                              FROM         dbo.tblfrmodifier
                              WHERE     dbo.tblFRModifier.casetype = dbo.tblcase.casetype AND dbo.tblfrmodifier.productcode = dbo.tblproduct.prodcode AND 
                                                    dbo.tblfrmodifier.companycode = tblclient.companycode), ISNULL(dbo.tblFRCategory.FRCategory, 'Other')) AS ReportCategory

FROM         dbo.tblFRCategory RIGHT OUTER JOIN
                      dbo.tblproduct ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode RIGHT OUTER JOIN
                      dbo.tblClient INNER JOIN
                      dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON dbo.tblproduct.description = dbo.tblServices.description AND 
                      dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
WHERE      (tblcase.officecode = @OfficeCode or @officecode = -1) and dbo.tblcase.status <> 8 and dbo.tblcase.status <> 9 and (dbo.TblCase.invoiceamt = 0 or dbo.tblcase.invoiceamt is null) 
and month(dbo.tblcase.commitdate) = @month and year(dbo.tblcase.commitdate) = @year) as a
group by reportcategory 

end

if @sReport = 'FutureScheduled'
begin
if @month = 12 begin
 select @month = 1
 select @year = @year + 1
end
else
begin
 select @month = @month + 1
end

select reportcategory,  count(casenbr)as  sumDocuments from 
(SELECT     dbo.tblCase.casenbr as casenbr, ISNULL
                          ((SELECT     frmodifier
                              FROM         dbo.tblfrmodifier
                              WHERE     dbo.tblFRModifier.casetype = dbo.tblcase.casetype AND dbo.tblfrmodifier.productcode = dbo.tblproduct.prodcode AND 
                                                    dbo.tblfrmodifier.companycode = tblclient.companycode), ISNULL(dbo.tblFRCategory.FRCategory, 'Other')) AS ReportCategory

FROM         dbo.tblFRCategory RIGHT OUTER JOIN
                      dbo.tblproduct ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode RIGHT OUTER JOIN
                      dbo.tblClient INNER JOIN
                      dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON dbo.tblproduct.description = dbo.tblServices.description AND 
                      dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
WHERE    (tblcase.officecode = @OfficeCode or @officecode = -1) and dbo.tblcase.status <> 8 and dbo.tblcase.status <> 9 and  (dbo.TblCase.invoiceamt = 0 or dbo.tblcase.invoiceamt is null) and month(dbo.tblcase.commitdate) = @month and year(dbo.tblcase.commitdate) = @year) as a
group by reportcategory 
end


GO



update tblQueues
 set StatusDesc='Finalized Invoices ready to export to Great Plains'
 where statusCode=18
GO
update tblQueues
 set StatusDesc='Finalized Vouchers ready to export to Great Plains'
 where statusCode=19
GO


update tblControl set DBVersion='1.07'
GO