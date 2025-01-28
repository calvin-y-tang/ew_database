-----------------------------------------------------------------------
--Created new user function to view accounting tab on a case
--This will allow users to enter accounting notes
-----------------------------------------------------------------------

insert into tbluserfunction(functioncode, functiondesc) values('ViewAcctTab', 'Accounting - View Accting Tab on Case')
go


-----------------------------------------------------------------------
--Add a new DateReturned field for Abeton Record Obtainment
-----------------------------------------------------------------------

ALTER TABLE [tblRecordsObtainmentDetail]
  ADD [DateReturned] DATETIME
GO


-----------------------------------------------------------------------
--Use a separate field to store the GP Facility ID information
-----------------------------------------------------------------------


ALTER TABLE [tblEWFacility]
  ADD [GPFacility] VARCHAR(3)
GO


-----------------------------------------------------------------------
--Cleaned up extraneous user function that was not used
-----------------------------------------------------------------------
delete from tbluserfunction where functioncode = 'CommitRpt'

-----------------------------------------------------------------------
--Add new exception for attaching Reports
-----------------------------------------------------------------------


SET IDENTITY_INSERT tblExceptionList ON

INSERT INTO [tblexceptionlist] ([ExceptionID],[Description],[Status],[DateAdded],[UserIDAdded],[DateEdited],[UserIDEdited])VALUES(22,'Attach Report','Active','Jun 24 2010 12:00:00:000AM','Admin','Jun 24 2010 12:00:00:000AM','Admin')

SET IDENTITY_INSERT tblExceptionList OFF


-----------------------------------------------------------------------
--Added FileFormat and PDF HideFormGraphics
-----------------------------------------------------------------------


ALTER TABLE [tblDocument]
  ADD [FileFormat] VARCHAR(10)
GO

ALTER TABLE [tblDocument]
  ADD [HideFormGraphics] BIT DEFAULT ((0))
GO

-----------------------------------------------------------------------
--Make tblEWFacility Active field default to 0
-----------------------------------------------------------------------

ALTER TABLE tblEWFacility
  ADD CONSTRAINT DF_tblEWFacility_Active
  DEFAULT 0 FOR Active
GO
-----------------------------------------------------------------------
--Set FileFormat for existing records
-----------------------------------------------------------------------

UPDATE tblDocument
  SET FileFormat='Word'
  WHERE sfilename IS NOT NULL AND RIGHT(sfilename, 3) IN ('dot', 'doc')

UPDATE tblDocument
  SET FileFormat='Dymo'
  WHERE sfilename IS NOT NULL AND RIGHT(sfilename, 3) IN ('lwt', 'lwl')

UPDATE tblDocument SET FileFormat='Word' WHERE DOCUMENT='direction'

UPDATE tblDocument
  SET FileFormat='Word'
  WHERE sfilename IS NOT NULL AND RIGHT(sfilename, 4) IN ('docx', 'dotx')
GO

  
-----------------------------------------------------------------------
--Replace Commit Date with Forecast Date with new Case Type Parameter
-----------------------------------------------------------------------

CREATE TABLE [tblFRForecast] (
  [ServiceCode] INTEGER NOT NULL,
  [CaseType] INTEGER NOT NULL,
  [CalcFrom] VARCHAR(10) NOT NULL,
  [DaysToForecastDate] INTEGER NOT NULL,
  CONSTRAINT [PK_tblFRForecast] PRIMARY KEY ([ServiceCode],[CaseType])
)
GO


ALTER TABLE [tblCase]
  ADD [ForecastDate] DATETIME
GO
UPDATE tblCase SET ForecastDate=commitdate
 WHERE commitdate IS NOT NULL AND ForecastDate IS NULL
GO



ALTER TABLE [tblGroupFunction]
  ALTER COLUMN [functioncode] VARCHAR(30) NOT NULL
GO

DROP VIEW [vwapptlogbyappt]
GO

CREATE VIEW dbo.vwapptlogbyappt
AS  SELECT TOP 100 PERCENT
            dbo.tblCase.ApptDate,
            dbo.tblCaseType.ShortDesc AS [Case Type],
            dbo.tblCase.DoctorName AS Doctor,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS client,
            dbo.tblCompany.intname AS Company,
            dbo.tblCase.doctorlocation,
            dbo.tblLocation.location,
            dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS Examinee,
            dbo.tblCase.marketercode,
            dbo.tblCase.schedulercode,
            dbo.tblExaminee.SSN,
            dbo.tblQueues.statusdesc,
            dbo.tblDoctor.doctorcode,
            dbo.tblCase.clientcode,
            dbo.tblCompany.companycode,
            dbo.tblCase.dateadded,
            ISNULL(dbo.tblClient.phone1, '') + ' '
            + ISNULL(dbo.tblClient.phone1ext, '') AS clientphone,
            dbo.tblCase.Appttime,
            dbo.tblCase.casenbr,
            dbo.tblCase.priority,
            dbo.tblCase.commitdate,
            dbo.tblCase.status,
            dbo.tblCase.servicecode,
            dbo.tblServices.shortdesc,
            dbo.tblSpecialty.description,
            dbo.tblCase.officecode,
            dbo.tblOffice.description AS OfficeName,
            GETDATE() AS today,
            dbo.tblCase.QARep AS QARepcode,
            dbo.tblCase.HearingDate,
            dbo.tblCase.casetype,
            dbo.tblCase.PanelNbr,
            dbo.tblCase.mastersubcase,
            ( SELECT TOP 1
                        eventdate
              FROM      tblcasehistory
              WHERE     tblcasehistory.casenbr = tblcase.casenbr
                        AND type = 'Reschedule'
              ORDER BY  eventdate DESC
            ) AS LastRescheduled,
            dbo.tblDoctor.ProvTypeCode,
            dbo.tblDoctor.phone AS DoctorPhone,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname AS DoctorSortName,
            dbo.tblCase.ExternalDueDate,
            dbo.tblCase.InternalDueDate,
            dbo.tblCase.ForecastDate
    FROM    dbo.tblCase
            INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
            INNER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
            INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
            INNER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode
            LEFT OUTER JOIN dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode
            LEFT OUTER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
            LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode
            LEFT OUTER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
            LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode
    WHERE   ( dbo.tblCase.status <> 9 )
    GROUP BY dbo.tblCase.ApptDate,
            dbo.tblCaseType.ShortDesc,
            dbo.tblCase.DoctorName,
            dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname,
            dbo.tblCompany.intname,
            dbo.tblCase.doctorlocation,
            dbo.tblLocation.location,
            dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname,
            dbo.tblCase.marketercode,
            dbo.tblCase.schedulercode,
            dbo.tblExaminee.SSN,
            dbo.tblQueues.statusdesc,
            dbo.tblDoctor.doctorcode,
            dbo.tblCase.clientcode,
            dbo.tblCompany.companycode,
            dbo.tblCase.dateadded,
            ISNULL(dbo.tblClient.phone1, '') + ' '
            + ISNULL(dbo.tblClient.phone1ext, ''),
            dbo.tblCase.Appttime,
            dbo.tblCase.casenbr,
            dbo.tblCase.priority,
            dbo.tblCase.commitdate,
            dbo.tblCase.status,
            dbo.tblCase.servicecode,
            dbo.tblServices.shortdesc,
            dbo.tblSpecialty.description,
            dbo.tblCase.officecode,
            dbo.tblOffice.description,
            dbo.tblCase.QARep,
            dbo.tblCase.HearingDate,
            dbo.tblCase.casetype,
            dbo.tblCase.PanelNbr,
            dbo.tblCase.mastersubcase,
            dbo.tblDoctor.ProvTypeCode,
            dbo.tblDoctor.phone,
            dbo.tblDoctor.lastname + ', ' + dbo.tblDoctor.firstname,
            dbo.tblCase.ExternalDueDate,
            dbo.tblCase.InternalDueDate,
            dbo.tblCase.ForecastDate


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
and month(dbo.tblcase.ForecastDate) = @month and year(dbo.tblcase.ForecastDate) = @year) as a
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
WHERE    (tblcase.officecode = @OfficeCode or @officecode = -1) and dbo.tblcase.status <> 8 and dbo.tblcase.status <> 9 and  (dbo.TblCase.invoiceamt = 0 or dbo.tblcase.invoiceamt is null) and month(dbo.tblcase.ForecastDate) = @month and year(dbo.tblcase.ForecastDate) = @year) as a
group by reportcategory 
end



GO

UPDATE tblUserFunction
 SET functioncode='apptbyforecastrpt', functiondesc='Report - Appointments by Forecast Date' WHERE functioncode='apptbycommitrpt'
UPDATE tblGroupFunction
 SET functioncode='apptbyforecastrpt' WHERE functioncode='apptbycommitrpt'
GO

INSERT INTO tblFRForecast
  SELECT ServiceCode, -1, CalcFrom, DaysToCommitDate
  FROM tblServices WHERE CalcFrom IS NOT NULL
GO



----------------------------------------------------------------------
--Gary's changes for MEI web portal
----------------------------------------------------------------------

CREATE TABLE [tblQuestionCoverLetter] (
  [QuestonID] INTEGER IDENTITY(1,1) NOT NULL,
  [BusUnitID] INTEGER,
  [CompanyID] INTEGER,
  [Jurisdiction] INTEGER,
  [QuestionText] VARCHAR(2000) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [CoverLetterType] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS
)
GO

CREATE TABLE [tblQuestionCoverLetterHistory] (
  [CaseNbr] INTEGER NOT NULL,
  [QuestionID] INTEGER NOT NULL,
  [DocName] VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [ControlName] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [Val] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [UserID] VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [IMECentricCode] INTEGER NOT NULL,
  [DateEdited] DATETIME DEFAULT (getdate()) NOT NULL
)
GO


CREATE VIEW vw_WebCoverLetterInfo

AS

SELECT
 --case     
 tblCase.casenbr AS Casenbr,
 tblCase.chartnbr AS Chartnbr,
 tblCase.doctorlocation AS Doctorlocation,
 tblCase.clientcode AS clientcode,
 tblCase.Appttime AS Appttime,
 tblCase.dateofinjury AS DOI,
 tblCase.notes AS Casenotes,
 tblCase.DoctorName AS doctorformalname,
 tblCase.ClaimNbrExt AS ClaimNbrExt,
 tblCase.Jurisdiction AS Jurisdiction,
 
 --examinee
 tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
 tblExaminee.addr1 AS examineeaddr1,
 tblExaminee.addr2 AS examineeaddr2,
 tblExaminee.city AS ExamineeCity,
 tblExaminee.state AS ExamineeState,
 tblExaminee.zip AS ExamineeZip,
 tblExaminee.phone1 AS examineephone,
 tblExaminee.SSN AS ExamineeSSN,
 tblExaminee.sex AS ExamineeSex,
 tblExaminee.DOB AS ExamineeDOB,
 tblExaminee.employer AS Employer,
 tblExaminee.treatingphysician AS TreatingPhysician,
 tblExaminee.EmployerAddr1 AS Employeraddr1,
 tblExaminee.EmployerCity AS Employercity,
 tblExaminee.EmployerState AS Employerstate,
 tblExaminee.EmployerZip AS Employerzip,
 tblExaminee.EmployerPhone AS Employerphone,
 tblExaminee.EmployerFax AS Employerfax,
 tblExaminee.EmployerEmail AS Employeremail,
 
 --case type
 tblCaseType.description AS Casetype,

 --service
 tblServices.description AS servicedesc,
 
 --client
 tblClient.firstname + ' ' + tblClient.lastname AS clientname,
 tblClient.firstname + ' ' + tblClient.lastname AS clientname2,
 tblClient.phone1 AS clientphone,
 tblClient.fax AS Clientfax,
 
 --defense attorney
 cc1.firstname + ' ' + cc1.lastname AS dattorneyname,
 cc1.company AS dattorneycompany,
 cc1.address1 AS dattorneyaddr1,
 cc1.address2 AS dattorneyaddr2,
 cc1.phone AS dattorneyphone,
 cc1.fax AS dattorneyfax,
 cc1.email AS dattorneyemail,
 
 --plaintiff attorney
 cc2.firstname + ' ' + cc2.lastname AS pattorneyname,
 cc2.company AS pattorneycompany,
 cc2.address1 AS pattorneyaddr1,
 cc2.address2 AS pattorneyaddr2,
 cc2.phone AS pattorneyphone,
 cc2.fax AS pattorneyfax,
 cc2.email AS pattorneyemail,

 tblCase.ApptDate AS Apptdate,
 tblCase.claimnbr AS claimnbr,
 tblCase.sreqspecialty AS Specialtydesc
FROM  tblCase 
 INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
 LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
 LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
 LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
 LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
 LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
 LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode

GO


CREATE PROCEDURE [proc_Company_LoadByParentCompany]

@IntName varchar(100)

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT tblCompany.intname + ' - ' + city +', ' + state as IntName, *

 FROM [tblCompany]
 
 WHERE IntName LIKE '%' + @IntName + '%'
 
 ORDER BY tblCompany.IntName 


 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [proc_CoverLetterGetBookmarkValuesByCase]

@CaseNbr int

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [vw_WebCoverLetterInfo]
 
 WHERE CaseNbr = @CaseNbr

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [proc_CoverLetterQuestionLoadByType]

@CoverLetterType VARCHAR(50)

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblQuestionCoverLetter]
 
 WHERE CoverLetterType = @CoverLetterType

 SET @Err = @@Error

 RETURN @Err
END

GO

DROP VIEW [vw_WebCaseSummary]
GO


CREATE VIEW vw_WebCaseSummary

AS

SELECT     
 --case     
 tblCase.casenbr,
 tblCase.chartnbr,
 tblCase.doctorlocation,
 tblCase.clientcode,
 tblCase.Appttime,
 tblCase.dateofinjury,
 REPLACE(REPLACE(REPLACE(CAST(tblCase.notes AS VARCHAR(2000)),CHAR(10),' '),CHAR(13),' '),CHAR(9),' ') notes,
 tblCase.DoctorName,
 tblCase.ClaimNbrExt,
 tblCase.ApptDate,
 tblCase.claimnbr,
 tblCase.WCBNbr,
 tblCase.specialinstructions,
 tblCase.HearingDate,
 tblCase.requesteddoc,
 tblCase.sreqspecialty,
 tblCase.schedulenotes,
 
 --examinee
 tblExaminee.lastname,
 tblExaminee.firstname,
 tblExaminee.addr1,
 tblExaminee.addr2,
 tblExaminee.city,
 tblExaminee.state,
 tblExaminee.zip,
 tblExaminee.phone1,
 tblExaminee.phone2,
 tblExaminee.SSN,
 tblExaminee.sex,
 tblExaminee.DOB,
 tblExaminee.note,
 tblExaminee.county,
 tblExaminee.prefix,
 tblExaminee.fax,
 tblExaminee.email,
 tblExaminee.insured,
 tblExaminee.employer,
 tblExaminee.treatingphysician,
 tblExaminee.InsuredAddr1,
 tblExaminee.InsuredCity,
 tblExaminee.InsuredState,
 tblExaminee.InsuredZip,
 tblExaminee.InsuredSex,
 tblExaminee.InsuredRelationship,
 tblExaminee.InsuredPhone,
 tblExaminee.InsuredPhoneExt,
 tblExaminee.InsuredFax,
 tblExaminee.InsuredEmail,
 tblExaminee.ExamineeStatus,
 tblExaminee.TreatingPhysicianAddr1,
 tblExaminee.TreatingPhysicianCity,
 tblExaminee.TreatingPhysicianState,
 tblExaminee.TreatingPhysicianZip,
 tblExaminee.TreatingPhysicianPhone,
 tblExaminee.TreatingPhysicianPhoneExt,
 tblExaminee.TreatingPhysicianFax,
 tblExaminee.TreatingPhysicianEmail,
 tblExaminee.EmployerAddr1,
 tblExaminee.EmployerCity,
 tblExaminee.EmployerState,
 tblExaminee.EmployerZip,
 tblExaminee.EmployerPhone,
 tblExaminee.EmployerPhoneExt,
 tblExaminee.EmployerFax,
 tblExaminee.EmployerEmail,
 tblExaminee.Country,
 tblExaminee.policynumber,
 tblExaminee.EmployerContactFirstName,
 tblExaminee.EmployerContactLastName,
 tblExaminee.TreatingPhysicianLicenseNbr,
 tblExaminee.TreatingPhysicianTaxID,

 --case type
 tblCaseType.code,
 tblCaseType.description,
 tblCaseType.instructionfilename,
 tblCaseType.WebID,
 tblCaseType.ShortDesc,

 --services
 tblServices.description AS servicedescription,
 tblServices.DaysToCommitDate,
 tblServices.CalcFrom,
 tblServices.ServiceType,

 --office
 tblOffice.description AS officedesc,

 --client
 tblClient.companycode,
 tblClient.clientnbrold,
 tblClient.lastname AS clientlname,
 tblClient.firstname AS clientfname,

 --defense attorney
 cc1.cccode,
 cc1.lastname AS defattlastname,
 cc1.firstname AS defattfirstname,
 cc1.company AS defattcompany,
 cc1.address1 AS defattadd1,
 cc1.address2 AS defattadd2,
 cc1.city AS defattcity,
 cc1.state AS defattstate,
 cc1.zip AS defattzip,
 cc1.phone AS defattphone,
 cc1.phoneextension AS defattphonext,
 cc1.fax AS defattfax,
 cc1.email AS defattemail,
 cc1.prefix AS defattprefix,

 --plaintiff attorney
 cc2.lastname AS plaintattlastname,
 cc2.firstname AS plaintattfirstname,
 cc2.company AS plaintattcompany,
 cc2.address1 AS plaintattadd1,
 cc2.address2 AS plaintattadd2,
 cc2.city AS plaintattcity,
 cc2.state AS plaintattstate,
 cc2.zip AS plaintattzip,
 cc2.phone AS plaintattphone,
 cc2.phoneextension AS plaintattphonext,
 cc2.fax AS plaintattfax,
 cc2.email AS plaintattemail,
 cc2.prefix AS plaintattprefix

FROM tblCase 
 INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
 LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
 LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
 LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
 LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
 LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
 LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode

GO

DROP PROCEDURE [proc_GetAdminReferralSummaryNew]
GO


CREATE PROCEDURE [dbo].[proc_GetAdminReferralSummaryNew]

@WebStatus varchar(50)

AS

SET NOCOUNT OFF
DECLARE @Err int

  SELECT TOP 100 PERCENT 
  tblCase.casenbr, 
  tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
  tblClient.lastname + ', ' + tblClient.firstname AS clientname, 
  tblCompany.intname AS companyname, 
  tblCase.ApptDate,
  tblCase.claimnbr, 
  tblServices.description AS service, 
  tblCase.DoctorName AS provider, 
  tblWebQueues.description AS WebStatus,
  tblWebQueues.statuscode, 
  ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr,
  tblClient.clientcode
  FROM tblCase
  INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
  INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
  INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
  INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
  INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
  LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
  WHERE (tblWebQueues.statuscode = @WebStatus)
  AND (tblCase.Casenbr IN
   (SELECT DISTINCT TableKey FROM tblPublishOnWeb
   WHERE tblPublishOnWeb.TableType = 'tblCase' 
   AND tblPublishOnWeb.PublishOnWeb = 1 AND TableKey > 0))
  AND (tblCase.status <> 0)

SET @Err = @@Error
RETURN @Err

GO

DROP PROCEDURE [proc_GetReferralSummaryNew]
GO


CREATE PROCEDURE [dbo].[proc_GetReferralSummaryNew]

@WebStatus varchar(50),
@WebUserID int

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int
 
 SELECT DISTINCT TOP 100 PERCENT 
  tblCase.casenbr, 
  tblCase.dateadded, 
  tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename, 
  tblClient.lastname + ', ' + tblClient.firstname AS clientname, 
  tblCompany.intname AS companyname, 
  tblCase.ApptDate, 
  tblCase.claimnbr, 
  tblServices.description AS service, 
  tblCase.DoctorName AS provider, 
  tblWebQueues.description AS WebStatus, 
  tblWebQueues.statuscode, 
  ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr 
  FROM tblCase 
  INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
  INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
  INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
  INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
  INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
  LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
  INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
   AND tblPublishOnWeb.tabletype = 'tblCase' 
   AND tblPublishOnWeb.PublishOnWeb = 1 
  INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
   AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
   AND tblWebUserAccount.WebUserID = @WebUserID
  WHERE (tblWebQueues.statuscode = @WebStatus)
  AND (tblCase.status <> 0)

 SET @Err = @@Error

 RETURN @Err
END


GO

DROP PROCEDURE [proc_ValidateUserNew]
GO


CREATE PROCEDURE [proc_ValidateUserNew]

@UserID varchar(100),
@Password varchar(30)

AS

DECLARE @UserType CHAR(2)

SET @UserType = (SELECT UserType FROM tblWebUser WHERE UserID = @UserID AND Password = @Password)

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.*,
  tblClient.lastname,
  tblClient.firstname,
  tblClient.clientcode,
  tblClient.email,
  ISNULL(tblClient.DefOfficeCode,0) AS DefOfficeCode,
  tblCompany.intname AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode AND tblClient.status = 'Active'
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'CL'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblClient.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND OPType = 'OP' AND tblDoctor.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'OP'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.*, 
  tblCCAddress.lastname,
  tblCCAddress.firstname,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode AND tblCCAddress.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND tblWebUserAccount.UserType IN ('AT','CC')  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND tblWebUser.Active = 1
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblDoctor.lastname,
  tblDoctor.firstname,
  tblDoctor.emailAddr AS Email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND tblDoctor.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'DR'   
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND ISNULL(tblDoctor.PublishOnWeb,0) = 1
  AND tblWebUser.Active = 1
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.*, 
  tblTranscription.transcompany AS lastname,
  tblTranscription.email,
  tblWebUser.WebUserID AS firstname,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.Transcode AND tblTranscription.status = 'Active'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.Transcode
   AND tblWebUserAccount.UserType = 'TR'  
 WHERE tblWebUser.UserID = @UserID 
  AND tblWebUser.Password = @Password
  AND tblWebUser.Active = 1
END

GO

DROP PROCEDURE [proc_GetSuperUserComboItems]
GO


CREATE PROCEDURE [proc_GetSuperUserComboItems]

AS

SELECT DISTINCT tblwebuseraccount.webuserid AS webID, tblCompany.intname company, firstname + ' ' + lastname + ' - ' + tblCompany.intname name 
 FROM tblclient 
 INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblwebuseraccount ON tblCCAddress.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblwebuseraccount ON tblDoctor.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblwebuseraccount ON tblTranscription.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND tblWebUserAccount.UserType = 'TR' 
ORDER BY company, name



GO

DROP PROCEDURE [proc_GetSuperUserSelUserListItems]
GO


CREATE PROCEDURE [proc_GetSuperUserSelUserListItems]

@WebUserID int

AS

SELECT DISTINCT cast(clientcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
tblCompany.intname company, firstname + ' ' + lastname + ' - ' + tblCompany.intname name 
 FROM tblclient 
 INNER JOIN tblwebuseraccount ON tblClient.clientcode = tblwebuseraccount.usercode and isuser = 0 AND tblWebUserAccount.UserType = 'CL'
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
 WHERE tblwebuseraccount.WebUserID = @WebUserID
UNION
SELECT DISTINCT cast(cccode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblwebuseraccount ON tblCCAddress.cccode = tblwebuseraccount.usercode and isuser = 0 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
 WHERE tblwebuseraccount.WebUserID = @WebUserID 
UNION
SELECT DISTINCT cast(doctorcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblwebuseraccount ON tblDoctor.doctorcode = tblwebuseraccount.usercode and isuser = 0 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
 WHERE tblwebuseraccount.WebUserID = @WebUserID 
UNION
SELECT DISTINCT cast(transcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblwebuseraccount ON tblTranscription.transcode = tblwebuseraccount.usercode and isuser = 0 AND tblWebUserAccount.UserType = 'TR' 
 WHERE tblwebuseraccount.WebUserID = @WebUserID 
ORDER BY company, name





GO

DROP PROCEDURE [proc_AdminGetUserGrid]
GO


CREATE PROCEDURE [proc_AdminGetUserGrid]

AS

SET NOCOUNT OFF
DECLARE @Err int

  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, tblCompany.intname company, firstname + ' ' + lastname + ' - ' +  tblCompany.intname name
        FROM tblclient
        INNER JOIN tblwebuser ON tblclient.clientcode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'CL')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'        
        INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode

  UNION
  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name
        FROM tblCCAddress
        INNER JOIN tblwebuser ON tblCCAddress.cccode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'AT' OR tblWebUser.UserType = 'CC')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')        

  UNION
  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name
        FROM tblDoctor
        INNER JOIN tblwebuser ON tblDoctor.doctorcode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'DR' OR tblWebUser.UserType = 'OP')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')           

  UNION
  SELECT DISTINCT transcompany, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name
        FROM tblTranscription
        INNER JOIN tblwebuser ON tblTranscription.transcode = tblwebuser.IMECentricCode AND tblWebUser.UserType = 'TR'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.transcode
   AND tblWebUserAccount.UserType = 'TR'         

SET @Err = @@Error
RETURN @Err
 


GO

DROP PROCEDURE [proc_GetCaseDetails]
GO


CREATE PROCEDURE [proc_GetCaseDetails] 

@caseNbr int 

AS 

SELECT DISTINCT
 tblCase.casenbr, 
 tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename, 
 tblClient.lastname + ', ' + tblClient.firstname AS clientname, 
 tblCompany.intname AS companyname, 
 tblCase.ApptDate, 
 tblCase.claimnbr, 
 tblCase.claimnbrext, 
 tblCase.invoicedate,
 tblCase.invoiceamt,
 tblLocation.location,
 datediff(day,apptdate,eventdate) RPTAT,
 tblServices.description AS service, 
 isnull(tblCase.DoctorName, tblCase.requesteddoc) AS provider, 
 tblWebQueues.description AS WebStatus, 
 tblQueues.statusdesc AS Status, 
 tblWebQueues.statuscode, 
 ISNULL(tblCase.sinternalcasenbr, tblCase.casenbr) AS webcontrolnbr
FROM tblCase 
 INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
 INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
 INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
 LEFT JOIN tblCaseHistory ON tblCase.casenbr = tblCaseHistory.casenbr AND tblCaseHistory.type = 'FinalRpt'
 LEFT JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
 LEFT JOIN tblCompany 
 INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode ON tblCase.clientcode = tblClient.clientcode 
 LEFT JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode
WHERE tblCase.casenbr = @caseNbr

GO

DROP PROCEDURE [proc_GetSuperUserAvailUserListItems]
GO


CREATE PROCEDURE [proc_GetSuperUserAvailUserListItems]

@WebUserID int

AS

SELECT DISTINCT cast(clientcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
tblCompany.intname company, firstname + ' ' + lastname + ' - ' + tblCompany.intname name 
 FROM tblclient 
 INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
 WHERE tblwebuseraccount.WebUserID <> @WebUserID
UNION
SELECT DISTINCT cast(cccode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblwebuseraccount ON tblCCAddress.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
UNION
SELECT DISTINCT cast(doctorcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblwebuseraccount ON tblDoctor.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
UNION
SELECT DISTINCT cast(transcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblwebuseraccount ON tblTranscription.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'TR' 
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
ORDER BY company, name



GO

DROP PROCEDURE [proc_AdminGetWebUserDataByWebUserID]
GO


CREATE PROCEDURE [proc_AdminGetWebUserDataByWebUserID]

@WebUserID int,
@UserType varchar(2)

AS

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.*,
  tblClient.firstname + ' ' + tblClient.lastname AS FullName,
  tblClient.email,
  tblCompany.intname AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'  
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.*,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.DoctorCode AND OPType = 'OP'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'OP'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.*,
  tblCCAddress.firstname + ' ' + tblCCAddress.lastname AS FullName,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND tblWebUserAccount.UserType IN ('AT','CC')   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.*,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.DoctorCode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'DR'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.*,
  tblTranscription.transcompany AS FullName,
  tblTranscription.Email,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.Transcode
   AND tblWebUserAccount.UserType = 'TR'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END

GO

DROP PROCEDURE [proc_Company_LoadAll]
GO


CREATE PROCEDURE [proc_Company_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCompany]
 
 ORDER BY intname


 SET @Err = @@Error

 RETURN @Err
END

GO

-----------------------------------------------------------------------
--Change UseEWFacility to ShowEWFacilityOnInvVo
-----------------------------------------------------------------------

EXEC sp_rename '[tblIMEData].[UseEWFacility]', 'ShowEWFacilityOnInvVo', 'COLUMN'
GO

---------------------------------------------------------------------------------
--New fields for tblcase and new table tblLanguage dml 06/30/10
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--Added new columns to tblcase - dml 06/29/10
---------------------------------------------------------------------------------

Alter table [dbo].[tblcase] add
	[TransportationRequired] bit NULL Default (0),
	[InterpreterRequired] bit NULL Default (0),
	[LanguageID] int NULL
go


/****** Object:  Table [dbo].[tblLanguage]    Script Date: 06/30/2010 10:52:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblLanguage](
	[LanguageID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tblLanguage] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

INSERT INTO [tbllanguage] ([Description])VALUES('French')
INSERT INTO [tbllanguage] ([Description])VALUES('German')
INSERT INTO [tbllanguage] ([Description])VALUES('Somalian')
INSERT INTO [tbllanguage] ([Description])VALUES('Spanish')
INSERT INTO [tbllanguage] ([Description])VALUES('Hmong')
INSERT INTO [tbllanguage] ([Description])VALUES('Other')
INSERT INTO [tbllanguage] ([Description])VALUES('Vietnamese')

go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwdocument]
AS
SELECT     dbo.tblCase.casenbr, dbo.tblCase.claimnbr, dbo.tblExaminee.addr1 AS examineeaddr1, dbo.tblExaminee.addr2 AS examineeaddr2, 
                      dbo.tblExaminee.city + ', ' + dbo.tblExaminee.state + '  ' + dbo.tblExaminee.zip AS examineecitystatezip, dbo.tblExaminee.SSN, 
                      dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, dbo.tblCompany.extname AS company, dbo.tblClient.phone1 + ' ' + ISNULL(dbo.tblClient.phone1ext,
                       ' ') AS clientphone, dbo.tblClient.phone2 + ' ' + ISNULL(dbo.tblClient.phone2ext, ' ') AS clientphone2, dbo.tblLocation.addr1 AS doctoraddr1, 
                      dbo.tblLocation.addr2 AS doctoraddr2, dbo.tblLocation.city + ', ' + dbo.tblLocation.state + '  ' + dbo.tblLocation.zip AS doctorcitystatezip, dbo.tblCase.ApptDate, 
                      dbo.tblCase.Appttime, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, dbo.tblExaminee.phone1 AS examineephone, 
                      dbo.tblExaminee.sex, dbo.tblExaminee.DOB, dbo.tblLocation.Phone AS doctorphone, dbo.tblClient.addr1 AS clientaddr1, dbo.tblClient.addr2 AS clientaddr2, 
                      dbo.tblClient.city + ', ' + dbo.tblClient.state + '  ' + dbo.tblClient.zip AS clientcitystatezip, dbo.tblClient.fax AS clientfax, dbo.tblClient.email AS clientemail, 
                      dbo.tblUser.firstname + ' ' + dbo.tblUser.lastname AS scheduler, dbo.tblCase.marketercode AS marketer, dbo.tblCase.dateadded AS datecalledin, 
                      dbo.tblCase.dateofinjury AS DOI, dbo.tblCase.allegation, dbo.tblCase.notes, dbo.tblCase.casetype, 
                      'Dear ' + dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineesalutation, dbo.tblCase.status, dbo.tblCase.calledinby, dbo.tblCase.chartnbr, 
                      'Dear ' + dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientsalutation, 
                      'Dear ' + dbo.tblDoctor.firstname + ' ' + dbo.tblDoctor.lastname + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorsalutation, dbo.tblLocation.insidedr, 
                      dbo.tblLocation.email AS doctoremail, dbo.tblLocation.fax AS doctorfax, dbo.tblLocation.faxdrschedule, dbo.tblLocation.medrcdletter, dbo.tblLocation.drletter, 
                      dbo.tblCase.reportverbal, dbo.tblCase.datemedsrecd AS medsrecd, tblCCAddress_2.firstname + ' ' + tblCCAddress_2.lastname AS Pattorneyname, 
                      'Dear ' + ISNULL(tblCCAddress_2.firstname, '') + ' ' + ISNULL(tblCCAddress_2.lastname, '') AS Pattorneysalutation, tblCCAddress_2.company AS Pattorneycompany, 
                      tblCCAddress_2.address1 AS Pattorneyaddr1, tblCCAddress_2.address2 AS Pattorneyaddr2, 
                      tblCCAddress_2.city + ', ' + tblCCAddress_2.state + '  ' + tblCCAddress_2.zip AS Pattorneycitystatezip, 
                      tblCCAddress_2.phone + ISNULL(tblCCAddress_2.phoneextension, '') AS Pattorneyphone, tblCCAddress_2.fax AS Pattorneyfax, 
                      tblCCAddress_2.email AS Pattorneyemail, tblCCAddress_1.firstname + ' ' + tblCCAddress_1.lastname AS Dattorneyname, 'Dear ' + ISNULL(tblCCAddress_1.firstname, 
                      '') + ' ' + ISNULL(tblCCAddress_1.lastname, '') AS Dattorneysalutation, tblCCAddress_1.company AS Dattorneycompany, tblCCAddress_1.address1 AS Dattorneyaddr1, 
                      tblCCAddress_1.address2 AS Dattorneyaddr2, tblCCAddress_1.city + ', ' + tblCCAddress_1.state + '  ' + tblCCAddress_1.zip AS Dattorneycitystatezip, 
                      tblCCAddress_1.phone + ' ' + ISNULL(tblCCAddress_1.phoneextension, '') AS Dattorneyphone, tblCCAddress_1.fax AS Dattorneyfax, 
                      tblCCAddress_1.email AS Dattorneyemail, tblCCAddress_1.fax, tblCCAddress_3.firstname + ' ' + tblCCAddress_3.lastname AS DParaLegalname, 
                      'Dear ' + ISNULL(tblCCAddress_3.firstname, '') + ' ' + ISNULL(tblCCAddress_3.lastname, '') AS DParaLegalsalutation, 
                      tblCCAddress_3.company AS DParaLegalcompany, tblCCAddress_3.address1 AS DParaLegaladdr1, tblCCAddress_3.address2 AS DParaLegaladdr2, 
                      tblCCAddress_3.city + ', ' + tblCCAddress_3.state + '  ' + tblCCAddress_3.zip AS DParaLegalcitystatezip, 
                      tblCCAddress_3.phone + ' ' + ISNULL(tblCCAddress_3.phoneextension, '') AS DParaLegalphone, tblCCAddress_3.email AS DParaLegalemail, 
                      tblCCAddress_3.fax AS DParaLegalfax, dbo.tblCase.typemedsrecd, dbo.tblCase.plaintiffattorneycode, dbo.tblCase.defenseattorneycode, dbo.tblCase.servicecode, 
                      dbo.tblCase.faxPattny, dbo.tblCase.faxdoctor, dbo.tblCase.faxclient, dbo.tblCase.emailclient, dbo.tblCase.emaildoctor, dbo.tblCase.emailPattny, 
                      dbo.tblCase.invoicedate, dbo.tblCase.invoiceamt, dbo.tblCase.commitdate, dbo.tblCase.WCBNbr, dbo.tblCase.specialinstructions, dbo.tblCase.priority, 
                      dbo.tblServices.description AS servicedesc, dbo.tblCase.usdvarchar1 AS caseusdvarchar1, dbo.tblCase.usdvarchar2 AS caseusdvarchar2, 
                      dbo.tblCase.usddate1 AS caseusddate1, dbo.tblCase.usddate2 AS caseusddate2, dbo.tblCase.usdtext1 AS caseusdtext1, dbo.tblCase.usdtext2 AS caseusdtext2, 
                      dbo.tblCase.usdint1 AS caseusdint1, dbo.tblCase.usdint2 AS caseusdint2, dbo.tblCase.usdmoney1 AS caseusdmoney1, dbo.tblCase.usdmoney2 AS caseusdmoney2, 
                      dbo.tblClient.title AS clienttitle, dbo.tblClient.prefix AS clientprefix, dbo.tblClient.suffix AS clientsuffix, dbo.tblClient.usdvarchar1 AS clientusdvarchar1, 
                      dbo.tblClient.usdvarchar2 AS clientusdvarchar2, dbo.tblClient.usddate1 AS clientusddate1, dbo.tblClient.usddate2 AS clientusddate2, 
                      dbo.tblClient.usdtext1 AS clientusdtext1, dbo.tblClient.usdtext2 AS clientusdtext2, dbo.tblClient.usdint1 AS clientusdint1, dbo.tblClient.usdint2 AS clientusdint2, 
                      dbo.tblClient.usdmoney1 AS clientusdmoney1, dbo.tblClient.usdmoney2 AS clientusdmoney2, dbo.tblDoctor.notes AS doctornotes, dbo.tblDoctor.prefix AS doctorprefix, 
                      dbo.tblDoctor.addr1 AS doctorcorrespaddr1, dbo.tblDoctor.addr2 AS doctorcorrespaddr2, 
                      dbo.tblDoctor.city + ', ' + dbo.tblDoctor.state + '  ' + dbo.tblDoctor.zip AS doctorcorrespcitystatezip, dbo.tblDoctor.phone + ' ' + ISNULL(dbo.tblDoctor.phoneExt, ' ') 
                      AS doctorcorrespphone, dbo.tblDoctor.faxNbr AS doctorcorrespfax, dbo.tblDoctor.emailAddr AS doctorcorrespemail, dbo.tblDoctor.qualifications, dbo.tblDoctor.prepaid, 
                      dbo.tblDoctor.county AS doctorcorrespcounty, dbo.tblLocation.county AS doctorcounty, dbo.tblLocation.vicinity AS doctorvicinity, 
                      dbo.tblExaminee.county AS examineecounty, dbo.tblExaminee.prefix AS examineeprefix, dbo.tblExaminee.usdvarchar1 AS examineeusdvarchar1, 
                      dbo.tblExaminee.usdvarchar2 AS examineeusdvarchar2, dbo.tblExaminee.usddate1 AS examineeusddate1, dbo.tblExaminee.usddate2 AS examineeusddate2, 
                      dbo.tblExaminee.usdtext1 AS examineeusdtext1, dbo.tblExaminee.usdtext2 AS examineeusdtext2, dbo.tblExaminee.usdint1 AS examineeusdint1, 
                      dbo.tblExaminee.usdint2 AS examineeusdint2, dbo.tblExaminee.usdmoney1 AS examineeusdmoney1, dbo.tblExaminee.usdmoney2 AS examineeusdmoney2, 
                      dbo.tblDoctor.usdvarchar1 AS doctorusdvarchar1, dbo.tblDoctor.usdvarchar2 AS doctorusdvarchar2, dbo.tblDoctor.usddate1 AS doctorusddate1, 
                      dbo.tblDoctor.usddate2 AS doctorusddate2, dbo.tblDoctor.usdtext1 AS doctorusdtext1, dbo.tblDoctor.usdtext2 AS doctorusdtext2, 
                      dbo.tblDoctor.usdint1 AS doctorusdint1, dbo.tblDoctor.usdint2 AS doctorusdint2, dbo.tblDoctor.usdmoney1 AS doctorusdmoney1, 
                      dbo.tblDoctor.usdmoney2 AS doctorusdmoney2, dbo.tblCase.schedulenotes, dbo.tblCase.requesteddoc, dbo.tblCompany.usdvarchar1 AS companyusdvarchar1, 
                      dbo.tblCompany.usdvarchar2 AS companyusdvarchar2, dbo.tblCompany.usddate1 AS companyusddate1, dbo.tblCompany.usddate2 AS companyusddate2, 
                      dbo.tblCompany.usdtext1 AS companyusdtext1, dbo.tblCompany.usdtext2 AS companyusdtext2, dbo.tblCompany.usdint1 AS companyusdint1, 
                      dbo.tblCompany.usdint2 AS companyusdint2, dbo.tblCompany.usdmoney1 AS companyusdmoney1, dbo.tblCompany.usdmoney2 AS companyusdmoney2, 
                      dbo.tblDoctor.WCNbr AS doctorwcnbr, dbo.tblCaseType.description AS casetypedesc, dbo.tblLocation.location, dbo.tblCase.doctorlocation, 
                      dbo.tblCase.sinternalcasenbr AS internalcasenbr, dbo.tblDoctor.credentials AS doctordegree, dbo.tblSpecialty.description AS specialtydesc, 
                      dbo.tblExaminee.note AS chartnotes, dbo.tblExaminee.fax AS examineefax, dbo.tblExaminee.email AS examineeemail, dbo.tblExaminee.insured AS examineeinsured, 
                      dbo.tblCase.clientcode, dbo.tblCase.doctorcode, dbo.tblCase.feecode, dbo.tblClient.companycode, dbo.tblClient.notes AS clientnotes, 
                      dbo.tblCompany.notes AS companynotes, dbo.tblClient.billaddr1, dbo.tblClient.billaddr2, dbo.tblClient.billcity, dbo.tblClient.billstate, dbo.tblClient.billzip, 
                      dbo.tblClient.billattn, dbo.tblClient.ARKey, dbo.tblCase.icd9code, dbo.tblDoctor.remitattn, dbo.tblDoctor.remitaddr1, dbo.tblDoctor.remitaddr2, dbo.tblDoctor.remitcity, 
                      dbo.tblDoctor.remitstate, dbo.tblDoctor.remitzip, dbo.tblCase.doctorspecialty, dbo.tblServices.shortdesc, dbo.tblDoctor.licensenbr AS doctorlicense, 
                      dbo.tblLocation.notes AS doctorlocationnotes, dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontact, 
                      'Dear ' + dbo.tblLocation.contactfirst + ' ' + dbo.tblLocation.contactlast AS doctorlocationcontactsalutation, dbo.tblRecordStatus.description AS medsstatus, 
                      dbo.tblExaminee.employer, dbo.tblExaminee.treatingphysician, dbo.tblExaminee.city AS examineecity, dbo.tblExaminee.state AS examineestate, 
                      dbo.tblExaminee.zip AS examineezip, dbo.tblDoctor.SSNTaxID AS DoctorTaxID, dbo.tblCase.billclientcode AS casebillclientcode, 
                      dbo.tblCase.billaddr1 AS casebilladdr1, dbo.tblCase.billaddr2 AS casebilladdr2, dbo.tblCase.billcity AS casebillcity, dbo.tblCase.billstate AS casebillstate, 
                      dbo.tblCase.billzip AS casebillzip, dbo.tblCase.billARKey AS casebillarkey, dbo.tblCase.billcompany AS casebillcompany, dbo.tblCase.billcontact AS casebillcontact, 
                      dbo.tblSpecialty.specialtycode, dbo.tblDoctorLocation.correspondence AS doctorcorrespondence, dbo.tblExaminee.lastname AS examineelastname, 
                      dbo.tblExaminee.firstname AS examineefirstname, dbo.tblCase.billfax AS casebillfax, dbo.tblClient.billfax AS clientbillfax, dbo.tblCase.officecode, 
                      dbo.tblDoctor.lastname AS doctorlastname, dbo.tblDoctor.firstname AS doctorfirstname, dbo.tblDoctor.middleinitial AS doctormiddleinitial, 
                      ISNULL(LEFT(dbo.tblDoctor.firstname, 1), '') + ISNULL(LEFT(dbo.tblDoctor.middleinitial, 1), '') + ISNULL(LEFT(dbo.tblDoctor.lastname, 1), '') AS doctorinitials, 
                      dbo.tblCase.QARep, dbo.tblClient.lastname AS clientlastname, dbo.tblClient.firstname AS clientfirstname, tblCCAddress_1.prefix AS dattorneyprefix, 
                      tblCCAddress_1.lastname AS dattorneylastname, tblCCAddress_1.firstname AS dattorneyfirstname, tblCCAddress_2.prefix AS pattorneyprefix, 
                      tblCCAddress_2.lastname AS pattorneylastname, tblCCAddress_2.firstname AS pattorneyfirstname, dbo.tblLocation.contactprefix AS doctorlocationcontactprefix, 
                      dbo.tblLocation.contactfirst AS doctorlocationcontactfirstname, dbo.tblLocation.contactlast AS doctorlocationcontactlastname, 
                      dbo.tblExaminee.middleinitial AS examineemiddleinitial, dbo.tblCase.ICD9Code2, dbo.tblCase.ICD9Code3, dbo.tblCase.ICD9Code4, dbo.tblExaminee.InsuredAddr1, 
                      dbo.tblExaminee.InsuredCity, dbo.tblExaminee.InsuredState, dbo.tblExaminee.InsuredZip, dbo.tblExaminee.InsuredSex, dbo.tblExaminee.InsuredRelationship, 
                      dbo.tblExaminee.InsuredPhone, dbo.tblExaminee.InsuredPhoneExt, dbo.tblExaminee.InsuredFax, dbo.tblExaminee.InsuredEmail, dbo.tblExaminee.ExamineeStatus, 
                      dbo.tblExaminee.TreatingPhysicianAddr1, dbo.tblExaminee.TreatingPhysicianCity, dbo.tblExaminee.TreatingPhysicianState, dbo.tblExaminee.TreatingPhysicianZip, 
                      dbo.tblExaminee.TreatingPhysicianPhone, dbo.tblExaminee.TreatingPhysicianPhoneExt, dbo.tblExaminee.TreatingPhysicianFax, 
                      dbo.tblExaminee.TreatingPhysicianEmail, dbo.tblExaminee.TreatingPhysicianLicenseNbr, dbo.tblExaminee.EmployerAddr1, dbo.tblExaminee.EmployerCity, 
                      dbo.tblExaminee.EmployerState, dbo.tblExaminee.EmployerZip, dbo.tblExaminee.EmployerPhone, dbo.tblExaminee.EmployerPhoneExt, 
                      dbo.tblExaminee.EmployerFax, dbo.tblExaminee.EmployerEmail, dbo.tblExaminee.TreatingPhysicianTaxID, dbo.tblExaminee.Country, dbo.tblDoctor.UPIN, 
                      dbo.tblDoctor.schedulepriority, dbo.tblDoctor.feecode AS drfeecode, dbo.tblCase.PanelNbr, dbo.tblstate.StateName AS Jurisdiction, dbo.tblCase.photoRqd, 
                      dbo.tblCase.CertMailNbr, dbo.tblCase.HearingDate, dbo.tblCase.DoctorName, dbo.tblLocation.state AS doctorstate, dbo.tblClient.state AS clientstate, 
                      dbo.tblDoctor.state AS doctorcorrespstate, tblCCAddress_1.state AS dattorneystate, tblCCAddress_2.state AS pattorneystate, dbo.tblCase.prevappt, 
                      dbo.tblCase.mastersubcase, dbo.tblCase.mastercasenbr, dbo.tblLocation.city AS doctorcity, dbo.tblLocation.zip AS doctorzip, dbo.tblClient.city AS clientcity, 
                      dbo.tblClient.zip AS clientzip, dbo.tblExaminee.policynumber, tblCCAddress_2.city AS pattorneycity, tblCCAddress_2.zip AS pattorneyzip, 
                      dbo.tblDoctorSchedule.duration AS ApptDuration, dbo.tblDoctor.companyname AS PracticeName, dbo.tblCase.AssessmentToAddress, dbo.tblCase.OCF25Date, 
                      dbo.tblCase.AssessingFacility, dbo.tblCase.DateForminDispute, dbo.tblExaminee.EmployerContactLastName, dbo.tblExaminee.EmployerContactFirstName, 
                      dbo.tblDoctor.NPINbr AS DoctorNPINbr, dbo.tblCase.PublishOnWeb, dbo.tblProviderType.description AS DoctorProviderType, dbo.tblDoctor.ProvTypeCode, 
                      dbo.tblCase.Jurisdiction AS JurisdictionCode, dbo.tblCase.LegalEvent, dbo.tblCase.PILegalEvent, dbo.tblCase.transcode, dbo.tblTranscription.transcompany, 
                      dbo.tblCase.DateReceived, dbo.tblCase.usddate3 AS caseusddate3, dbo.tblCase.usddate4 AS caseusddate4, dbo.tblCase.UsdBit1 AS caseusdboolean1, 
                      dbo.tblCase.UsdBit2 AS caseusdboolean2, dbo.tblCase.usddate5 AS caseusddate5, dbo.tblDoctor.usddate3 AS doctorusddate3, 
                      dbo.tblDoctor.usddate4 AS doctorusddate4, dbo.tblDoctor.usdvarchar3 AS doctorusdvarchar3, dbo.tblDoctor.usddate5 AS doctorusddate5, 
                      dbo.tblDoctor.usddate6 AS doctorusddate6, dbo.tblDoctor.usddate7 AS doctorusddate7, dbo.tblCase.ClaimNbrExt, dbo.tblCase.sreqspecialty AS RequestedSpecialty, 
                      dbo.tblQueues.statusdesc, dbo.tblCase.AttorneyNote, dbo.tblCaseType.ShortDesc AS CaseTypeShortDesc, dbo.tblCase.ExternalDueDate, 
                      dbo.tblCase.InternalDueDate, dbo.tblLocation.ExtName AS LocationExtName, dbo.tblVenue.County AS Venue, dbo.tblOffice.description AS office, 
                      dbo.tblOffice.usdvarchar1 AS OfficeUSDVarChar1, dbo.tblOffice.usdvarchar2 AS OfficeUSDVarChar2, dbo.tblCase.TransportationRequired, 
                      dbo.tblCase.InterpreterRequired, dbo.tblLanguage.Description AS Language
FROM         dbo.tblCCAddress AS tblCCAddress_3 RIGHT OUTER JOIN
                      dbo.tblLanguage RIGHT OUTER JOIN
                      dbo.tblOffice INNER JOIN
                      dbo.tblExaminee INNER JOIN
                      dbo.tblCase INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode ON dbo.tblExaminee.chartnbr = dbo.tblCase.chartnbr INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode ON dbo.tblOffice.officecode = dbo.tblCase.officecode ON 
                      dbo.tblLanguage.LanguageID = dbo.tblCase.LanguageID LEFT OUTER JOIN
                      dbo.tblVenue ON dbo.tblCase.VenueID = dbo.tblVenue.VenueID ON tblCCAddress_3.cccode = dbo.tblCase.DefParaLegal LEFT OUTER JOIN
                      dbo.tblTranscription ON dbo.tblCase.transcode = dbo.tblTranscription.transcode LEFT OUTER JOIN
                      dbo.tblDoctorSchedule ON dbo.tblCase.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                      dbo.tblstate ON dbo.tblCase.Jurisdiction = dbo.tblstate.Statecode LEFT OUTER JOIN
                      dbo.tblDoctorLocation ON dbo.tblCase.doctorlocation = dbo.tblDoctorLocation.locationcode AND 
                      dbo.tblCase.doctorcode = dbo.tblDoctorLocation.doctorcode LEFT OUTER JOIN
                      dbo.tblRecordStatus ON dbo.tblCase.reccode = dbo.tblRecordStatus.reccode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblProviderType RIGHT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblProviderType.ProvTypeCode = dbo.tblDoctor.ProvTypeCode ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblUser ON dbo.tblCase.schedulercode = dbo.tblUser.userid LEFT OUTER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode LEFT OUTER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_1 ON dbo.tblCase.defenseattorneycode = tblCCAddress_1.cccode LEFT OUTER JOIN
                      dbo.tblCCAddress AS tblCCAddress_2 ON dbo.tblCase.plaintiffattorneycode = tblCCAddress_2.cccode
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---------------------------------------------------------------------------------
--Revised System Tables structure
---------------------------------------------------------------------------------

DROP TABLE tblEWCaseType
GO
DROP TABLE tblEWServiceType
GO
DROP TABLE tblEWFacility
GO


CREATE TABLE [tblEWCompanyType] (
  [EWCompanyTypeID] INTEGER,
  [SeqNo] INTEGER,
  [Name] VARCHAR(20),
  CONSTRAINT [PK_EWCompanyType] PRIMARY KEY ([EWCompanyTypeID])
)
GO

CREATE TABLE [tblEWServiceType] (
  [EWServiceTypeID] INTEGER,
  [SeqNo] INTEGER,
  [Name] VARCHAR(25),
  CONSTRAINT [PK_EWServiceType] PRIMARY KEY ([EWServiceTypeID])
)
GO

CREATE TABLE [tblEWBusLine] (
  [EWBusLineID] INTEGER,
  [SeqNo] INTEGER,
  [Name] VARCHAR(15),
  CONSTRAINT [PK_EWCaseType] PRIMARY KEY ([EWBusLineID])
)
GO

CREATE TABLE [tblEWFacility] (
  [EWFacilityID] INTEGER,
  [FacilityName] VARCHAR(40),
  [LegalName] VARCHAR(40),
  [SeqNo] INTEGER,
  [DBID] INTEGER,
  [ShortName] VARCHAR(10),
  [Accting] VARCHAR(5),
  [GPFacility] VARCHAR(3),
  [Address] VARCHAR(50),
  [City] VARCHAR(20),
  [State] VARCHAR(2),
  [Zip] VARCHAR(10),
  [Phone] VARCHAR(15),
  [Fax] VARCHAR(15),
  [FedTaxID] VARCHAR(20),
  [DateAquired] DATETIME,
  [Active] BIT,
  [ShowOnInvVo] BIT DEFAULT (0)
  CONSTRAINT [PK_EWFacility] PRIMARY KEY ([EWFacilityID])
)
GO


EXEC sp_rename '[tblCaseType].[EWCaseTypeID]', 'EWBusLineID', 'COLUMN'
GO

------------------------------------------------------------
--Change FileFormat to TemplateFormat
------------------------------------------------------------


EXEC sp_rename '[tblDocument].[FileFormat]', 'TemplateFormat', 'COLUMN'
GO

------------------------------------------------------------
--Set default inches to 0
------------------------------------------------------------

ALTER TABLE [dbo].[tblRecordHistory] ADD CONSTRAINT [DF_tblRecordHistory_Inche] DEFAULT ((0)) FOR [Inches]
GO


update tblControl set DBVersion='1.13'
GO
