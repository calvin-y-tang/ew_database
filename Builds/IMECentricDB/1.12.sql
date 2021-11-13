CREATE TABLE [tblEWFacility] (
  [EWFacilityID] INTEGER NOT NULL,
  [DBID] INTEGER,
  [Name] VARCHAR(30),
  [ShortName] VARCHAR(15),
  [Address1] VARCHAR(50),
  [Address2] VARCHAR(50),
  [City] VARCHAR(50),
  [State] VARCHAR(2),
  [Zip] VARCHAR(10),
  [Phone] VARCHAR(15),
  [Fax] VARCHAR(15),
  [FedTaxID] VARCHAR(20),
  [Active] BIT NOT NULL,
  CONSTRAINT [PK_EWFacility] PRIMARY KEY CLUSTERED ([EWFacilityID])
)
GO

CREATE TABLE [tblEWCaseType] (
  [EWCaseTypeID] INTEGER DEFAULT ((0)) NOT NULL,
  [SeqNo] INTEGER DEFAULT ((0)) NOT NULL,
  [ShortName] VARCHAR(15) NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  CONSTRAINT [PK_EWCaseTypeID] PRIMARY KEY CLUSTERED ([EWCaseTypeID])
)
GO

CREATE TABLE [tblEWServiceType] (
  [EWServiceTypeID] INTEGER DEFAULT ((0)) NOT NULL,
  [SeqNo] INTEGER NOT NULL,
  [ShortName] VARCHAR(15) DEFAULT ((0)) NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  CONSTRAINT [PK_EWServiceType] PRIMARY KEY CLUSTERED ([EWServiceTypeID])
)
GO


ALTER TABLE [tblAcctHeader]
  ADD [CompanyCode] INTEGER
GO

ALTER TABLE [tblAcctHeader]
  ADD [ClientCode] INTEGER
GO

ALTER TABLE [tblAcctHeader]
  ADD [EWFacilityID] INTEGER
GO


ALTER TABLE [tblCaseType]
  ADD [GPCaseType] VARCHAR(2)
GO

ALTER TABLE [tblCaseType]
  ADD [EWCaseTypeID] INTEGER
GO


ALTER TABLE [tblIMEData]
  ADD [UseEWFacility] BIT DEFAULT ((0)) NOT NULL
GO


ALTER TABLE [tblOffice]
  ADD [EWFacilityID] INTEGER
GO

ALTER TABLE [tblOffice]
  ADD [GPLocation] VARCHAR(3)
GO

ALTER TABLE [tblOffice]
  ADD [GPUserID] VARCHAR(10)
GO


ALTER TABLE [tblServices]
  ADD [EWServiceTypeID] INTEGER
GO

DROP VIEW [vwAcctDocuments]
GO


CREATE VIEW dbo.vwAcctDocuments
AS
SELECT  TOP 100 PERCENT
  dbo.tblCase.casenbr,
        dbo.tblAcctHeader.documenttype,
        dbo.tblAcctHeader.documentnbr,
        dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename,
        CASE WHEN dbo.tbldoctor.credentials IS NOT NULL
             THEN dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname
                  + ', ' + dbo.tbldoctor.credentials
             ELSE dbo.tblDoctor.[prefix] + ' ' + dbo.tblDoctor.firstname + ' '
                  + dbo.tblDoctor.lastname
        END AS doctorname,
        dbo.tblCase.clientcode,
        dbo.tblCompany.companycode,
        dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname,
        dbo.tblCompany.intname AS companyname,
        tblAcctHeader.ClientCode AS invClientCode,
        tblAcctHeader.CompanyCode AS invCompanyCode,
        invCl.lastname + ', ' + invCl.firstname AS invClientName,
        invCom.intname AS invCompanyName,
        dbo.tblCase.priority,
        dbo.tblCase.dateadded,
        dbo.tblCase.claimnbr,
        dbo.tblCase.doctorlocation,
        dbo.tblCase.Appttime,
        dbo.tblCase.dateedited,
        dbo.tblCase.useridedited,
        dbo.tblClient.email AS adjusteremail,
        dbo.tblClient.fax AS adjusterfax,
        dbo.tblCase.marketercode,
        dbo.tblCase.useridadded,
        dbo.tblAcctHeader.documentdate,
        dbo.tblAcctHeader.INBatchSelect,
        dbo.tblAcctHeader.VOBatchSelect,
        dbo.tblAcctHeader.taxcode,
        dbo.tblAcctHeader.taxtotal,
        dbo.tblAcctHeader.documenttotal,
        dbo.tblAcctHeader.documentstatus,
        dbo.tblAcctHeader.batchnbr,
        dbo.tblCase.servicecode,
        dbo.tblAcctHeader.officecode,
        dbo.tblDoctor.doctorcode,
        dbo.tblAcctHeader.apptdate,
        tblcase.casetype
FROM    dbo.tblAcctHeader
        INNER JOIN dbo.tblCase ON dbo.tblCase.casenbr = dbo.TblAcctHeader.casenbr
        LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblAcctHeader.DrOpCode = dbo.tblDoctor.doctorcode
        LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
        LEFT OUTER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
        LEFT OUTER JOIN dbo.tblCompany ON dbo.tblCompany.companycode = dbo.tblClient.companycode
        LEFT OUTER JOIN dbo.tblClient AS invCl ON dbo.tblAcctHeader.clientcode = invCl.clientcode
        LEFT OUTER JOIN dbo.tblCompany AS invCom ON dbo.tblAcctHeader.companycode = invCom.companycode
ORDER BY dbo.tblAcctHeader.documentdate


GO

DROP VIEW [vwregister]
GO

CREATE VIEW [dbo].[vwregister]
AS  SELECT  dbo.TblAcctDetail.extendedamount,
            dbo.tblproduct.INglacct,
            dbo.tblproduct.VOglacct,
            dbo.TblAcctDetail.longdesc,
            dbo.vwAcctDocuments.*
    FROM    dbo.TblAcctDetail
            INNER JOIN dbo.tblproduct ON dbo.TblAcctDetail.prodcode = dbo.tblproduct.prodcode
            INNER JOIN dbo.vwAcctDocuments ON dbo.TblAcctDetail.documenttype = dbo.vwAcctDocuments.documenttype
                                              AND dbo.TblAcctDetail.documentnbr = dbo.vwAcctDocuments.documentnbr

GO

DROP VIEW [vwregistertotal]
GO

CREATE VIEW [dbo].[vwregistertotal]
AS  SELECT  dbo.vwAcctDocuments.*
    FROM    dbo.vwAcctDocuments

GO

DROP VIEW [vwExportSummaryWithSecurity]
GO


CREATE VIEW dbo.vwExportSummaryWithSecurity
AS  SELECT TOP 100 PERCENT
            dbo.tblCase.casenbr,
            dbo.TblAcctHeader.documenttype,
            dbo.TblAcctHeader.documentnbr,
            dbo.tblacctingtrans.statuscode,
            dbo.tblQueues.statusdesc,
            dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename,
            dbo.tblacctingtrans.DrOpType,
            CASE ISNULL(dbo.tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE dbo.tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(dbo.tbldoctor.lastname, '') + ', '
                          + ISNULL(dbo.tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(dbo.tbldoctor.lastname, '') + ', '
                          + ISNULL(dbo.tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '')
                     WHEN 'OP' THEN dbo.tbldoctor.companyname
                   END
              ELSE CASE dbo.tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(dbo.tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '')
                     WHEN 'OP' THEN dbo.tbldoctor.companyname
                   END
            END AS doctorname,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname,
            dbo.tblCompany.intname AS companyname,
            dbo.tblCase.priority,
            dbo.tblCase.ApptDate,
            dbo.tblCase.dateadded,
            dbo.tblCase.claimnbr,
            dbo.tblCase.doctorlocation,
            dbo.tblCase.Appttime,
            dbo.tblCase.dateedited,
            dbo.tblCase.useridedited,
            dbo.tblClient.email AS adjusteremail,
            dbo.tblClient.fax AS adjusterfax,
            dbo.tblCase.marketercode,
            dbo.tblCase.useridadded,
            dbo.TblAcctHeader.documentdate,
            dbo.TblAcctHeader.INBatchSelect,
            dbo.TblAcctHeader.VOBatchSelect,
            dbo.TblAcctHeader.taxcode,
            dbo.TblAcctHeader.taxtotal,
            dbo.TblAcctHeader.documenttotal,
            dbo.TblAcctHeader.documentstatus,
            dbo.tblCase.clientcode,
            dbo.tblCase.doctorcode,
            dbo.TblAcctHeader.batchnbr,
            dbo.tblCase.officecode,
            dbo.tblCase.schedulercode,
            dbo.tblClient.companycode,
            dbo.tblCase.QARep,
            dbo.tblCase.PanelNbr,
            DATEDIFF(day, dbo.tblacctingtrans.laststatuschg, GETDATE()) AS IQ,
            dbo.tblCase.mastersubcase,
            tblqueues_1.statusdesc AS CaseStatus,
            tbluserofficefunction.userid,
            tblqueues.functioncode,
            tblservices.shortdesc AS service
    FROM    dbo.tblAcctHeader
            INNER JOIN dbo.tblacctingtrans ON dbo.TblAcctHeader.seqno = dbo.tblacctingtrans.SeqNO
            INNER JOIN dbo.tblCase ON dbo.TblAcctHeader.casenbr = tblcase.casenbr
            LEFT OUTER JOIN dbo.tblCompany ON tblacctheader.companycode = tblcompany.companycode
            LEFT OUTER JOIN dbo.tblClient ON dbo.tblacctheader.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblQueues ON dbo.tblacctingtrans.statuscode = dbo.tblQueues.statuscode
            INNER JOIN dbo.tblQueues tblqueues_1 ON dbo.tblcase.status = tblQueues_1.statuscode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblacctheader.DrOpCode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            INNER JOIN dbo.tblservices ON dbo.tblservices.servicecode = dbo.tblcase.servicecode
            INNER JOIN dbo.tblUserOffice ON dbo.tblCase.officecode = dbo.tblUserOffice.officecode
            INNER JOIN dbo.tbluserofficefunction ON dbo.tblUserOffice.userid = dbo.tbluserofficefunction.userid
                                                    AND dbo.tbluserofficefunction.officecode = dbo.tblcase.officecode
                                                    AND dbo.tblqueues.functioncode = dbo.tbluserofficefunction.functioncode
    WHERE   ( dbo.tblacctingtrans.statuscode <> 20 )
            AND ( dbo.TblAcctHeader.batchnbr IS NULL )
            AND ( dbo.TblAcctHeader.documentstatus = 'Final' )
    ORDER BY dbo.TblAcctHeader.documentdate,
            dbo.tblCase.priority,
            dbo.tblCase.ApptDate


GO

DROP VIEW [vwexportsummary]
GO



CREATE VIEW dbo.vwexportsummary
AS  SELECT TOP 100 PERCENT
            dbo.tblCase.casenbr,
            dbo.TblAcctHeader.documenttype,
            dbo.TblAcctHeader.documentnbr,
            dbo.tblacctingtrans.statuscode,
            dbo.tblQueues.statusdesc,
            dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename,
            dbo.tblacctingtrans.DrOpType,
            CASE ISNULL(dbo.tblcase.panelnbr, 0)
              WHEN 0
              THEN CASE dbo.tblacctingtrans.droptype
                     WHEN 'DR'
                     THEN ISNULL(dbo.tbldoctor.lastname, '') + ', '
                          + ISNULL(dbo.tbldoctor.firstname, '')
                     WHEN ''
                     THEN ISNULL(dbo.tbldoctor.lastname, '') + ', '
                          + ISNULL(dbo.tbldoctor.firstname, '')
                     WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '')
                     WHEN 'OP' THEN dbo.tbldoctor.companyname
                   END
              ELSE CASE dbo.tblacctingtrans.droptype
                     WHEN 'DR' THEN ISNULL(dbo.tblcase.doctorname, '')
                     WHEN '' THEN ISNULL(dbo.tblcase.doctorname, '')
                     WHEN 'OP' THEN dbo.tbldoctor.companyname
                   END
            END AS doctorname,
            dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname,
            dbo.tblCompany.intname AS companyname,
            dbo.tblCase.priority,
            dbo.tblCase.ApptDate,
            dbo.tblCase.dateadded,
            dbo.tblCase.claimnbr,
            dbo.tblCase.doctorlocation,
            dbo.tblCase.Appttime,
            dbo.tblCase.dateedited,
            dbo.tblCase.useridedited,
            dbo.tblClient.email AS adjusteremail,
            dbo.tblClient.fax AS adjusterfax,
            dbo.tblCase.marketercode,
            dbo.tblCase.useridadded,
            dbo.TblAcctHeader.documentdate,
            dbo.TblAcctHeader.INBatchSelect,
            dbo.TblAcctHeader.VOBatchSelect,
            dbo.TblAcctHeader.taxcode,
            dbo.TblAcctHeader.taxtotal,
            dbo.TblAcctHeader.documenttotal,
            dbo.TblAcctHeader.documentstatus,
            dbo.tblCase.clientcode,
            dbo.tblCase.doctorcode,
            dbo.TblAcctHeader.batchnbr,
            dbo.tblCase.officecode,
            dbo.tblCase.schedulercode,
            dbo.tblClient.companycode,
            dbo.tblCase.QARep,
            dbo.tblCase.PanelNbr,
            DATEDIFF(day, dbo.tblacctingtrans.laststatuschg, GETDATE()) AS IQ,
            dbo.tblCase.mastersubcase,
            tblqueues_1.statusdesc AS CaseStatus
    FROM    dbo.tblAcctHeader
            INNER JOIN dbo.tblacctingtrans ON dbo.TblAcctHeader.seqno = dbo.tblacctingtrans.SeqNO
            INNER JOIN dbo.tblCase ON dbo.TblAcctHeader.casenbr = tblcase.casenbr
            LEFT OUTER JOIN dbo.tblCompany ON tblacctheader.companycode = tblcompany.companycode
            LEFT OUTER JOIN dbo.tblClient ON dbo.tblacctheader.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblQueues ON dbo.tblacctingtrans.statuscode = dbo.tblQueues.statuscode
            INNER JOIN dbo.tblQueues tblqueues_1 ON dbo.tblcase.status = tblQueues_1.statuscode
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblacctheader.DrOpCode = dbo.tblDoctor.doctorcode
            LEFT OUTER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
    WHERE   ( dbo.tblacctingtrans.statuscode <> 20 )
            AND ( dbo.TblAcctHeader.batchnbr IS NULL )
            AND ( dbo.TblAcctHeader.documentstatus = 'Final' )
    ORDER BY dbo.TblAcctHeader.documentdate,
            dbo.tblCase.priority,
            dbo.tblCase.ApptDate


GO

DROP PROCEDURE [spClientCases]
GO



CREATE  PROCEDURE [dbo].[spClientCases]
@clientcode as integer
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr,  'C' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
WHERE dbo.tblcase.clientcode = @clientcode
UNION
SELECT     TOP 100 PERCENT dbo.tblCase.casenbr,  'B' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
WHERE dbo.tblcase.billclientcode = @clientcode
ORDER BY dbo.tblCase.ApptDate DESC

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
        and ( tblAcctHeader.officecode = @OfficeCode
              or @officecode = -1
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






UPDATE  tblAcctHeader
SET     CompanyCode = gpi.companycode,
        ClientCode = gpi.clientcode
FROM    tblGPInvoice AS gpi
        INNER JOIN tblAcctHeader AS a ON documentnbr = InvoiceNbr
WHERE   a.CompanyCode IS NULL AND documenttype = 'IN'
GO
UPDATE  tblAcctHeader
SET     CompanyCode = gpi.companycode,
        ClientCode = gpi.clientcode
FROM    tblGPInvoice AS gpi
        INNER JOIN tblAcctHeader AS a ON RelatedDocumentNbr = InvoiceNbr
WHERE   a.CompanyCode IS NULL  AND documenttype = 'VO'
GO
UPDATE  tblAcctHeader
SET     ClientCode = ISNULL(c.billclientcode, c.clientcode)
FROM    tblCase AS c
        INNER JOIN tblAcctHeader AS a ON c.casenbr=a.casenbr
WHERE   a.ClientCode IS NULL  AND documenttype = 'VO' AND a.documentstatus='Final'
GO
UPDATE  tblAcctHeader
SET    CompanyCode=c.companycode
FROM    tblClient AS c
        INNER JOIN tblAcctHeader AS a ON c.clientcode=a.ClientCode
WHERE   a.CompanyCode IS NULL AND a.ClientCode IS NOT NULL  AND documenttype = 'VO' AND a.documentstatus='Final'

GO



update tblControl set DBVersion='1.12'
GO

