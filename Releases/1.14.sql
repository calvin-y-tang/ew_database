------------------------------------------------------------
--Add EWFacilityID and EWInvAddrEWFacilityID to tblCompany
------------------------------------------------------------


ALTER TABLE [tblCompany]
  ADD [EWFacilityID] INTEGER
GO

ALTER TABLE [tblCompany]
  ADD [EWInvAddrEWFacilityID] INTEGER
GO

------------------------------------------------------------
--Add new table tblEWLocation which has all GP location 
--and link tblOffice with new EWLocationID field
------------------------------------------------------------

CREATE TABLE [tblEWLocation] (
  [EWLocationID] INTEGER NOT NULL,
  [Name] VARCHAR(30),
  [GPLocation] VARCHAR(3),
  [Active] BIT,
  CONSTRAINT [PK_tblEWLocation] PRIMARY KEY ([EWLocationID])
)
GO


ALTER TABLE [tblAcctHeader]
  ADD [EWLocationID] INTEGER
GO


ALTER TABLE [tblEWFacility]
  ADD [GPUserID] VARCHAR(10)
GO

ALTER TABLE [tblEWFacility]
  ADD [GPEntityPrefix] VARCHAR(3)
GO


ALTER TABLE [tblOffice]
  ADD [EWLocationID] INTEGER
GO


------------------------------------------------------------
--Change flash report to use EW Facility parameter instead of office
------------------------------------------------------------


DROP PROCEDURE [spRptFlashReport]
GO

CREATE PROCEDURE [dbo].[spRptFlashReport]
@Month int,
@Year int,
@sReport varchar (20) ,
@EWFacilityID int
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
select  tblAcctHeader.DocumentType,
        tblAcctHeader.DocumentNbr,
        tblAcctDetail.LineNbr,
        tblProduct.Description,
        isnull(tblFRModifier.FRModifier,
               isnull(tblFRCategory.FRCategory, 'Other')) as ReportCategory,
        case when tblacctheader.documenttype = 'IN'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Revenue,
        case when tblacctheader.documenttype = 'VO'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Expense,
        isnull(tblacctdetail.ExtendedAmount, 0) as ExtendedAmount
from    tblAcctHeader
        inner join tblAcctDetail on tblAcctHeader.documentnbr = tblAcctDetail.documentnbr
                                    and tblacctheader.documenttype = tblacctdetail.documenttype
        left outer join tblCase on tblAcctHeader.casenbr = tblCase.casenbr
        --left outer join tblCaseType on tblCaseType.code = tblCase.casetype
        left outer join tblProduct on tblProduct.prodcode = TblAcctDetail.prodcode
        --left outer join tblClient on tblAcctHeader.clientcode = tblClient.clientcode
        --left outer join tblCompany on tblAcctHeader.companycode = tblCompany.companycode
        --left outer join tblDoctor on tblCase.doctorcode = tblDoctor.doctorcode
        --left outer join tblServices on tblCase.servicecode = tblServices.servicecode
        left outer join tblFRCategory on tblCase.casetype = tblFRCategory.CaseType
                                         and TblAcctDetail.prodcode = tblFRCategory.ProductCode
        left outer join tblFRModifier on tblCase.casetype = tblFRModifier.casetype
                                         and tblAcctDetail.prodcode = tblFRModifier.ProductCode
                                         and tblAcctHeader.companycode = tblFRModifier.companycode
where   ( tblAcctHeader.documentstatus = 'Final' )
        and ( tblAcctHeader.EWFacilityID = @EWFacilityID
              or @EWFacilityID = -1
            )
        and month(tblAcctHeader.DocumentDate) = @month
        and year(tblAcctHeader.DocumentDate) = @year

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
SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
                    ISNULL(frmodifier,
                           ISNULL(dbo.tblFRCategory.FRCategory, 'Other')) AS ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
                    LEFT OUTER JOIN dbo.tblproduct ON dbo.tblproduct.description = dbo.tblServices.description
                    LEFT OUTER JOIN dbo.tblFRCategory ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode
                                                         AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblfrmodifier ON dbo.tblFRModifier.casetype = dbo.tblcase.casetype
                                                         AND dbo.tblfrmodifier.productcode = dbo.tblproduct.prodcode
                                                         AND dbo.tblfrmodifier.companycode = tblclient.companycode
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year
        ) AS a
GROUP BY reportcategory 

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

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
                    ISNULL(frmodifier,
                           ISNULL(dbo.tblFRCategory.FRCategory, 'Other')) AS ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
                    LEFT OUTER JOIN dbo.tblproduct ON dbo.tblproduct.description = dbo.tblServices.description
                    LEFT OUTER JOIN dbo.tblFRCategory ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode
                                                         AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblfrmodifier ON dbo.tblFRModifier.casetype = dbo.tblcase.casetype
                                                         AND dbo.tblfrmodifier.productcode = dbo.tblproduct.prodcode
                                                         AND dbo.tblfrmodifier.companycode = tblclient.companycode
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year
        ) AS a
GROUP BY reportcategory 

end



GO
update tblControl set DBVersion='1.14'
GO
