------------------------------------------------------------------------------------------
--Added new columns to tblcase for MEI dml 07/19/10
------------------------------------------------------------------------------------------

ALTER TABLE [tblCase]
  ADD [bln3DayNotifClaimant] bit default (0),
      [bln3DayNotifAttorney] bit default (0),
      [bln14DayNotifClaimant] bit default (0),
      [bln14DayNotifAttorney] bit default (0),
      [blnImedNotifClaimant] bit default (0),
      [blnImedNotifAttorney] bit default (0)

GO

------------------------------------------------------------------------------------------
--Include Pages in spCaseDocuments and spCaseReports
------------------------------------------------------------------------------------------


DROP PROCEDURE [spCaseReports]
GO

CREATE PROCEDURE [dbo].[spCaseReports] ( @casenbr integer )
AS 
    SELECT TOP 100 PERCENT
            casenbr,
            document,
            type,
            description,
            sfilename,
            dateadded,
            useridadded,
            reporttype,
            PublishOnWeb,
            dateedited,
            useridedited,
            seqno,
            PublishedTo,
            Source,
            FileSize,
            Pages
    FROM    dbo.tblCaseDocuments
    WHERE   ( casenbr = @casenbr )
            AND ( type = 'Report' )
    ORDER BY dateadded DESC

GO

DROP PROCEDURE [spCaseDocuments]
GO

CREATE PROCEDURE [dbo].[spCaseDocuments] ( @casenbr integer )
AS 
    SELECT  casenbr,
            document,
            type,
            description,
            sfilename,
            dateadded,
            useridadded,
            PublishOnWeb,
            dateedited,
            useridedited,
            seqno,
            PublishedTo,
            Source,
            FileSize,
            Pages
    FROM    dbo.tblCaseDocuments
    WHERE   ( casenbr = @casenbr )
            AND ( type <> 'Report' )
    ORDER BY dateadded DESC

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwDoctorSchedule]
AS
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, NULL AS panelnote, 
                        CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interperter' ELSE '' END AS Interpreter
FROM          dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode LEFT OUTER JOIN
                        dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON 
                        dbo.tblDoctorSchedule.schedcode = dbo.tblCase.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      (dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'Hold') OR
                        ((dbo.tblDoctorSchedule.status = 'scheduled') AND (dbo.tblcase.schedcode IS NOT NULL))
UNION
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, CAST(dbo.tblCasePanel.panelnote AS varchar(50)) 
                        AS panelnote, CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interperter' ELSE '' END AS Interpreter
FROM          dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                        dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr RIGHT OUTER JOIN
                        dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode ON 
                        dbo.tblCasePanel.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      ((dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'scheduled') OR
                        (dbo.tblDoctorSchedule.status = 'Hold')) AND dbo.tblcase.panelnbr IS NOT NULL
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwDoctorSchedulewithoffice]
AS
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, NULL AS panelnote, tbldoctoroffice.officecode, 
                        CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL END AS scheduledescription, 
                        tblservices.shortdesc, tblimedata.fax, CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interperter' ELSE '' END AS Interpreter
FROM          dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode LEFT OUTER JOIN
                        dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode ON 
                        dbo.tblDoctorSchedule.schedcode = dbo.tblCase.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      (dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'Hold') OR
                        ((dbo.tblDoctorSchedule.status = 'scheduled') AND (dbo.tblcase.schedcode IS NOT NULL))
UNION
SELECT      TOP 100 PERCENT dbo.tblDoctorSchedule.locationcode, dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime, 
                        dbo.tblDoctorSchedule.description, dbo.tblDoctorSchedule.status, dbo.tblDoctorSchedule.doctorcode, dbo.tblDoctorSchedule.schedcode, 
                        dbo.tblCase.casenbr, dbo.tblCompany.extname AS company, dbo.tblExaminee.firstname + ' ' + dbo.tblExaminee.lastname AS examineename, 
                        dbo.tblLocation.location, dbo.tblIMEData.companyname, ISNULL(dbo.tblDoctor.firstname, '') + ' ' + ISNULL(dbo.tblDoctor.lastname, '') 
                        + ', ' + ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblCase.claimnbr, dbo.tblClient.firstname + ' ' + dbo.tblClient.lastname AS clientname, 
                        dbo.tblCaseType.description AS casetypedesc, dbo.tblServices.description AS servicedesc, CAST(dbo.tblCase.specialinstructions AS varchar(1000)) 
                        AS specialinstructions, dbo.tblCase.WCBNbr, dbo.tblLocation.Phone AS doctorphone, dbo.tblLocation.fax AS doctorfax, dbo.tblCase.photoRqd, 
                        dbo.tblClient.phone1 AS clientphone, dbo.tblCase.DoctorName AS paneldesc, dbo.tblCase.PanelNbr, CAST(dbo.tblCasePanel.panelnote AS varchar(50)) 
                        AS panelnote, tbldoctoroffice.officecode, CASE WHEN dbo.tblcase.casenbr IS NULL THEN dbo.tbldoctorschedule.casenbr1desc ELSE NULL 
                        END AS scheduledescription, tblservices.shortdesc, tblimedata.fax, 
                        CASE WHEN tblcase.interpreterrequired = 1 THEN 'Interperter' ELSE '' END AS Interpreter
FROM          dbo.tblCaseType INNER JOIN
                        dbo.tblClient INNER JOIN
                        dbo.tblCase ON dbo.tblClient.clientcode = dbo.tblCase.clientcode INNER JOIN
                        dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                        dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr ON dbo.tblCaseType.code = dbo.tblCase.casetype INNER JOIN
                        dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode INNER JOIN
                        dbo.tblCasePanel ON dbo.tblCase.PanelNbr = dbo.tblCasePanel.panelnbr RIGHT OUTER JOIN
                        dbo.tblLocation INNER JOIN
                        dbo.tblDoctorSchedule INNER JOIN
                        dbo.tblDoctor ON dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctor.doctorcode ON 
                        dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode ON 
                        dbo.tblCasePanel.schedcode = dbo.tblDoctorSchedule.schedcode LEFT OUTER JOIN
                        dbo.tblIMEData INNER JOIN
                        dbo.tblOffice INNER JOIN
                        dbo.tblDoctorOffice ON dbo.tblOffice.officecode = dbo.tblDoctorOffice.officecode ON dbo.tblIMEData.IMEcode = dbo.tblOffice.imecode ON 
                        dbo.tblDoctorSchedule.doctorcode = dbo.tblDoctorOffice.doctorcode
WHERE      ((dbo.tblDoctorSchedule.status = 'open') OR
                        (dbo.tblDoctorSchedule.status = 'scheduled') OR
                        (dbo.tblDoctorSchedule.status = 'Hold')) AND dbo.tblcase.panelnbr IS NOT NULL
ORDER BY dbo.tblDoctorSchedule.date, dbo.tblDoctorSchedule.starttime
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

---------------------------------------------------------------------------------------------
--Add new permission token for setting company EWFacility and Inv Remit Addr Facility
---------------------------------------------------------------------------------------------


INSERT  INTO tbluserfunction
        (
          functioncode,
          functiondesc
        )
        SELECT  'CompanySetEWFacility',
                'Company - Set ExamWorks Facility'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CompanySetEWFacility' )

GO
INSERT  INTO tbluserfunction
        (
          functioncode,
          functiondesc
        )
        SELECT  'CompanySetInvAddrEWFacility',
                'Company - Override Invoice Remit Address'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CompanySetInvAddrEWFacility' )

GO

---------------------------------------------------------------------------------------------
--Include EWServiceType on product level, increase tblClaimInfo field size
---------------------------------------------------------------------------------------------



ALTER TABLE [tblProduct]
  ADD [EWServiceTypeID] INTEGER
GO


ALTER TABLE [tblClaimInfo]
  ALTER COLUMN [DoctorNameWithDegree] VARCHAR(100)
GO

ALTER TABLE [tblClaimInfo]
  ALTER COLUMN [DoctorSpecialty] VARCHAR(50)
GO



----------------------------------------------------------------------
--Gary's changes for MEI web portal
----------------------------------------------------------------------

DROP TABLE [dbo].[tblQuestionCoverLetter]
GO

CREATE TABLE [dbo].[tblQuestionCoverLetter]
(
[QuestionID] [int] NOT NULL IDENTITY(1, 1),
[BusUnitID] [int] NULL,
[CompanyID] [int] NULL,
[Jurisdiction] [int] NULL,
[QuestionText] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CoverLetterType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO

DROP TABLE [dbo].[tblQuestionCoverLetterHistory]
GO

CREATE TABLE [dbo].[tblQuestionCoverLetterHistory]
(
[CaseNbr] [int] NOT NULL,
[QuestionID] [int] NOT NULL,
[DocName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ControlName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Val] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IMECentricCode] [int] NOT NULL,
[DateEdited] [datetime] NOT NULL DEFAULT (getdate())
)
GO

CREATE PROCEDURE [proc_GetLanguageComboItems]

AS

SELECT DISTINCT * from tblLanguage


GO


CREATE PROCEDURE [proc_QuestionCoverLetter_LoadByPrimaryKey]

@QuestionID int

AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [QuestionID],
  [BusUnitID],
  [CompanyID],
  [Jurisdiction],
  [QuestionText],
  [CoverLetterType]
 FROM [tblQuestionCoverLetter]
 WHERE
  ([QuestionID] = @QuestionID)

 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [proc_QuestionCoverLetterHistoryDelete]
(
 @CaseNbr int,
 @IMECentricCode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblQuestionCoverLetterHistory]
 WHERE
  [CaseNbr] = @CaseNbr AND
  [IMECentricCode] = @IMECentricCode
 SET @Err = @@Error

 RETURN @Err
END

GO


CREATE PROCEDURE [proc_QuestionCoverLetterHistoryInsert]
(
 @CaseNbr int,
 @ControlName varchar(200),
 @IMECentricCode int,
 @Val varchar(2000),
 @QuestionID int,
 @DocName varchar(100),
 @UserID varchar(50),
 @DateEdited datetime
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblQuestionCoverLetterHistory]
 (
  [CaseNbr],
  [ControlName],
  [IMECentricCode],
  [Val],
  [QuestionID],
  [DocName],
  [UserID],
  [DateEdited]
 )
 VALUES
 (
  @CaseNbr,
  @ControlName,
  @IMECentricCode,
  @Val,
  @QuestionID,
  @DocName,
  @UserID,
  @DateEdited
 )

 SET @Err = @@Error


 RETURN @Err
END

GO


CREATE PROCEDURE [proc_QuestionCoverLetterHistoryLoadByCaseAndIMECentricCode]
(
 @CaseNbr int,
 @IMECentricCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT
  [CaseNbr],
  [ControlName],
  [IMECentricCode],
  [Val],
  [QuestionID],
  [DocName],
  [UserID],
  [DateEdited]
 FROM [tblQuestionCoverLetterHistory]
 WHERE
  ([CaseNbr] = @CaseNbr) AND
  ([IMECentricCode] = @IMECentricCode)

 SET @Err = @@Error

 RETURN @Err
END

GO

DROP VIEW [vw_WebCoverLetterInfo]
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
 tblCase.ApptDate AS Apptdate,
 tblCase.claimnbr AS claimnbr,
 tblCase.doctorspecialty AS Specialtydesc,
 
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
 tblExaminee.insured AS insured,
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
 
 --company
 tblCompany.intname company,
 
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
 
 --doctor
 'Dr. ' + tblDoctor.firstname + ' ' + tblDoctor.lastname AS doctorsalutation

FROM  tblCase 
 INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
 INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
 LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
 LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
 LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
 LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
 LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
 LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode

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

DROP PROCEDURE [proc_GetReferralSearch]
GO


CREATE PROCEDURE [proc_GetReferralSearch]

@WebUserID int = 0

AS

SET NOCOUNT OFF
DECLARE @Err int

 SELECT DISTINCT
  tblWebQueues.statuscode, 
  tblCase.casenbr, 
  tblCase.DoctorName AS provider, 
  tblCase.ApptDate, 
  tblCase.chartnbr, 
  tblServices.shortdesc AS service, 
  tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename, 
  tblWebQueues.description AS WebStatus, 
  tblQueues.WebStatusCode, 
  tblWebQueues.statuscode, 
  tblCase.claimnbr, 
  tblWebUserAccount.WebUserID,
        ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr 
        FROM tblCase 
        INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
        INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
        INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
        INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
        INNER JOIN tblclient on tblCase.clientcode = tblClient.clientcode 
        INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode 
        INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
   AND tblPublishOnWeb.tabletype = 'tblCase' 
   AND tblPublishOnWeb.PublishOnWeb = 1 
        INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
   AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType 

 WHERE tblWebUserAccount.WebUserID = COALESCE(@WebUserID,tblWebUserAccount.WebUserID)
        
SET @Err = @@Error
RETURN @Err
 

GO

DROP PROCEDURE [proc_Company_LoadByParentCompany]
GO


CREATE PROCEDURE [proc_Company_LoadByParentCompany]

@IntName varchar(100)

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT tblCompany.intname + ' - ' + city +', ' + state intname, *

 FROM [tblCompany]
 
 WHERE IntName LIKE '%' + @IntName + '%'
 
 ORDER BY tblCompany.IntName 


 SET @Err = @@Error

 RETURN @Err
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

DROP PROCEDURE [proc_CoverLetterQuestionLoadByType]
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

DROP PROCEDURE [proc_CoverLetterGetBookmarkValuesByCase]
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

DROP PROCEDURE [proc_IMECase_Insert]
GO


CREATE PROCEDURE [proc_IMECase_Insert]
(
 @casenbr int = NULL output,
 @chartnbr int = NULL,
 @doctorlocation varchar(10) = NULL,
 @clientcode int = NULL,
 @marketercode varchar(15) = NULL,
 @schedulercode varchar(15) = NULL,
 @priority varchar(15) = NULL,
 @status int = NULL,
 @casetype int = NULL,
 @dateadded datetime = NULL,
 @dateedited datetime = NULL,
 @useridadded varchar(15) = NULL,
 @useridedited varchar(15) = NULL,
 @schedcode int = NULL,
 @ApptDate datetime = NULL,
 @Appttime datetime = NULL,
 @claimnbr varchar(50) = NULL,
 @dateofinjury datetime = NULL,
 @allegation text = NULL,
 @calledinby varchar(50) = NULL,
 @notes text = NULL,
 @schedulenotes text = NULL,
 @requesteddoc varchar(50) = NULL,
 @datemedsrecd datetime = NULL,
 @typemedsrecd varchar(50) = NULL,
 @transreceived datetime = NULL,
 @shownoshow int = NULL,
 @rptstatus varchar(50) = NULL,
 @reportverbal bit = NULL,
 @emailclient bit = NULL,
 @emaildoctor bit = NULL,
 @emailPattny bit = NULL,
 @faxclient bit = NULL,
 @faxdoctor bit = NULL,
 @faxPattny bit = NULL,
 @apptrptsselect bit = NULL,
 @chartprepselect bit = NULL,
 @apptselect bit = NULL,
 @awaittransselect bit = NULL,
 @intransselect bit = NULL,
 @inqaselect bit = NULL,
 @drchartselect bit = NULL,
 @datedrchart datetime = NULL,
 @billedselect bit = NULL,
 @miscselect bit = NULL,
 @invoicedate datetime = NULL,
 @invoiceamt money = NULL,
 @plaintiffattorneycode int = NULL,
 @defenseattorneycode int = NULL,
 @commitdate datetime = NULL,
 @servicecode int = NULL,
 @issuecode int = NULL,
 @doctorcode int = NULL,
 @WCBNbr varchar(50) = NULL,
 @specialinstructions text = NULL,
 @usdvarchar1 varchar(50) = NULL,
 @usdvarchar2 varchar(50) = NULL,
 @usddate1 datetime = NULL,
 @usddate2 datetime = NULL,
 @usdtext1 text = NULL,
 @usdtext2 text = NULL,
 @usdint1 int = NULL,
 @usdint2 int = NULL,
 @usdmoney1 money = NULL,
 @usdmoney2 money = NULL,
 @bComplete bit = NULL,
 @bhanddelivery bit = NULL,
 @sinternalcasenbr varchar(70) = NULL,
 @sreqdegree varchar(20) = NULL,
 @sreqspecialty varchar(50) = NULL,
 @doctorspecialty varchar(50) = NULL,
 @feecode int = NULL,
 @voucherselect bit = NULL,
 @voucheramt money = NULL,
 @voucherdate datetime = NULL,
 @icd9code varchar(70) = NULL,
 @reccode int = NULL,
 @billclientcode int = NULL,
 @billcompany varchar(100) = NULL,
 @billcontact varchar(70) = NULL,
 @billaddr1 varchar(70) = NULL,
 @billaddr2 varchar(70) = NULL,
 @billcity varchar(70) = NULL,
 @billstate varchar(2) = NULL,
 @billzip varchar(10) = NULL,
 @billARKey varchar(100) = NULL,
 @billfax varchar(15) = NULL,
 @officecode int = NULL,
 @QARep varchar(15) = NULL,
 @photoRqd bit = NULL,
 @CertifiedMail bit = NULL,
 @ICD9Code2 varchar(70) = NULL,
 @ICD9Code3 varchar(70) = NULL,
 @ICD9Code4 varchar(70) = NULL,
 @PanelNbr int = NULL,
 @DoctorName varchar(100) = NULL,
 @HearingDate smalldatetime = NULL,
 @CertMailNbr varchar(30) = NULL,
 @laststatuschg datetime = NULL,
 @Jurisdiction varchar(5) = NULL,
 @prevappt datetime = NULL,
 @mastersubcase varchar(1) = NULL,
 @mastercasenbr int = NULL,
 @PublishOnWeb bit = NULL,
 @WebNotifyEmail varchar(200) = NULL,
 @AssessmentToAddress varchar(50) = NULL,
 @OCF25Date smalldatetime = NULL,
 @DateForminDispute smalldatetime = NULL,
 @AssessingFacility varchar(100) = NULL,
 @referralmethod int = NULL,
 @referraltype int = NULL,
 @CSR1 varchar(15) = NULL,
 @CSR2 varchar(15) = NULL,
 @LegalEvent bit = NULL,
 @PILegalEvent bit = NULL,
 @Transcode int = NULL,
 @PublishDocuments bit = NULL,
 @DateReceived datetime = NULL,
 @usddate3 datetime = NULL,
 @usddate4 datetime = NULL,
 @usddate5 datetime = NULL,
 @UsdBit1 bit = NULL,
 @UsdBit2 bit = NULL,
 @ClaimNbrExt varchar(50) = NULL,
 @DefParaLegal int = NULL,
 @AttorneyNote text = NULL,
 @BillingNote text = NULL,
 @InterpreterRequired bit = NULL,
 @TransportationRequired bit = NULL,
 @LanguageID int = NULL
 )
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCase]
 (
  [chartnbr],
  [doctorlocation],
  [clientcode],
  [marketercode],
  [schedulercode],
  [priority],
  [status],
  [casetype],
  [dateadded],
  [dateedited],
  [useridadded],
  [useridedited],
  [schedcode],
  [ApptDate],
  [Appttime],
  [claimnbr],
  [dateofinjury],
  [allegation],
  [calledinby],
  [notes],
  [schedulenotes],
  [requesteddoc],
  [datemedsrecd],
  [typemedsrecd],
  [transreceived],
  [shownoshow],
  [rptstatus],
  [reportverbal],
  [emailclient],
  [emaildoctor],
  [emailPattny],
  [faxclient],
  [faxdoctor],
  [faxPattny],
  [apptrptsselect],
  [chartprepselect],
  [apptselect],
  [awaittransselect],
  [intransselect],
  [inqaselect],
  [drchartselect],
  [datedrchart],
  [billedselect],
  [miscselect],
  [invoicedate],
  [invoiceamt],
  [plaintiffattorneycode],
  [defenseattorneycode],
  [commitdate],
  [servicecode],
  [issuecode],
  [doctorcode],
  [WCBNbr],
  [specialinstructions],
  [usdvarchar1],
  [usdvarchar2],
  [usddate1],
  [usddate2],
  [usdtext1],
  [usdtext2],
  [usdint1],
  [usdint2],
  [usdmoney1],
  [usdmoney2],
  [bComplete],
  [bhanddelivery],
  [sinternalcasenbr],
  [sreqdegree],
  [sreqspecialty],
  [doctorspecialty],
  [feecode],
  [voucherselect],
  [voucheramt],
  [voucherdate],
  [icd9code],
  [reccode],
  [billclientcode],
  [billcompany],
  [billcontact],
  [billaddr1],
  [billaddr2],
  [billcity],
  [billstate],
  [billzip],
  [billARKey],
  [billfax],
  [officecode],
  [QARep],
  [photoRqd],
  [CertifiedMail],
  [ICD9Code2],
  [ICD9Code3],
  [ICD9Code4],
  [PanelNbr],
  [DoctorName],
  [HearingDate],
  [CertMailNbr],
  [laststatuschg],
  [Jurisdiction],
  [prevappt],
  [mastersubcase],
  [mastercasenbr],
  [PublishOnWeb],
  [WebNotifyEmail],
  [AssessmentToAddress],
  [OCF25Date],
  [DateForminDispute],
  [AssessingFacility],
  [referralmethod],
  [referraltype],
  [CSR1],
  [CSR2],
  [LegalEvent],
  [PILegalEvent],
  [Transcode],
  [PublishDocuments],
  [DateReceived],
  [usddate3],
  [usddate4],
  [usddate5],
  [UsdBit1],
  [UsdBit2],
  [ClaimNbrExt],
  [DefParaLegal],
  [AttorneyNote],
  [BillingNote],
  [InterpreterRequired],
  [TransportationRequired],
  [LanguageID]  
 )
 VALUES
 (
  @chartnbr,
  @doctorlocation,
  @clientcode,
  @marketercode,
  @schedulercode,
  @priority,
  @status,
  @casetype,
  @dateadded,
  @dateedited,
  @useridadded,
  @useridedited,
  @schedcode,
  @ApptDate,
  @Appttime,
  @claimnbr,
  @dateofinjury,
  @allegation,
  @calledinby,
  @notes,
  @schedulenotes,
  @requesteddoc,
  @datemedsrecd,
  @typemedsrecd,
  @transreceived,
  @shownoshow,
  @rptstatus,
  @reportverbal,
  @emailclient,
  @emaildoctor,
  @emailPattny,
  @faxclient,
  @faxdoctor,
  @faxPattny,
  @apptrptsselect,
  @chartprepselect,
  @apptselect,
  @awaittransselect,
  @intransselect,
  @inqaselect,
  @drchartselect,
  @datedrchart,
  @billedselect,
  @miscselect,
  @invoicedate,
  @invoiceamt,
  @plaintiffattorneycode,
  @defenseattorneycode,
  @commitdate,
  @servicecode,
  @issuecode,
  @doctorcode,
  @WCBNbr,
  @specialinstructions,
  @usdvarchar1,
  @usdvarchar2,
  @usddate1,
  @usddate2,
  @usdtext1,
  @usdtext2,
  @usdint1,
  @usdint2,
  @usdmoney1,
  @usdmoney2,
  @bComplete,
  @bhanddelivery,
  @sinternalcasenbr,
  @sreqdegree,
  @sreqspecialty,
  @doctorspecialty,
  @feecode,
  @voucherselect,
  @voucheramt,
  @voucherdate,
  @icd9code,
  @reccode,
  @billclientcode,
  @billcompany,
  @billcontact,
  @billaddr1,
  @billaddr2,
  @billcity,
  @billstate,
  @billzip,
  @billARKey,
  @billfax,
  @officecode,
  @QARep,
  @photoRqd,
  @CertifiedMail,
  @ICD9Code2,
  @ICD9Code3,
  @ICD9Code4,
  @PanelNbr,
  @DoctorName,
  @HearingDate,
  @CertMailNbr,
  @laststatuschg,
  @Jurisdiction,
  @prevappt,
  @mastersubcase,
  @mastercasenbr,
  @PublishOnWeb,
  @WebNotifyEmail,
  @AssessmentToAddress,
  @OCF25Date,
  @DateForminDispute,
  @AssessingFacility,
  @referralmethod,
  @referraltype,
  @CSR1,
  @CSR2,
  @LegalEvent,
  @PILegalEvent,
  @Transcode,
  @PublishDocuments,
  @DateReceived,
  @usddate3,
  @usddate4,
  @usddate5,
  @UsdBit1,
  @UsdBit2,
  @ClaimNbrExt,
  @DefParaLegal,
  @AttorneyNote,
  @BillingNote,
  @InterpreterRequired,
  @TransportationRequired,
  @LanguageID  
 )

 SET @Err = @@Error

 SELECT @casenbr = SCOPE_IDENTITY()

 RETURN @Err
END

GO

DROP PROCEDURE [proc_IMECase_Update]
GO


CREATE PROCEDURE [proc_IMECase_Update]
(
 @casenbr int,
 @chartnbr int = NULL,
 @doctorlocation varchar(10) = NULL,
 @clientcode int = NULL,
 @marketercode varchar(15) = NULL,
 @schedulercode varchar(15) = NULL,
 @priority varchar(15) = NULL,
 @status int = NULL,
 @casetype int = NULL,
 @dateadded datetime = NULL,
 @dateedited datetime = NULL,
 @useridadded varchar(15) = NULL,
 @useridedited varchar(15) = NULL,
 @schedcode int = NULL,
 @ApptDate datetime = NULL,
 @Appttime datetime = NULL,
 @claimnbr varchar(50) = NULL,
 @dateofinjury datetime = NULL,
 @allegation text = NULL,
 @calledinby varchar(50) = NULL,
 @notes text = NULL,
 @schedulenotes text = NULL,
 @requesteddoc varchar(50) = NULL,
 @datemedsrecd datetime = NULL,
 @typemedsrecd varchar(50) = NULL,
 @transreceived datetime = NULL,
 @shownoshow int = NULL,
 @rptstatus varchar(50) = NULL,
 @reportverbal bit = NULL,
 @emailclient bit = NULL,
 @emaildoctor bit = NULL,
 @emailPattny bit = NULL,
 @faxclient bit = NULL,
 @faxdoctor bit = NULL,
 @faxPattny bit = NULL,
 @apptrptsselect bit = NULL,
 @chartprepselect bit = NULL,
 @apptselect bit = NULL,
 @awaittransselect bit = NULL,
 @intransselect bit = NULL,
 @inqaselect bit = NULL,
 @drchartselect bit = NULL,
 @datedrchart datetime = NULL,
 @billedselect bit = NULL,
 @miscselect bit = NULL,
 @invoicedate datetime = NULL,
 @invoiceamt money = NULL,
 @plaintiffattorneycode int = NULL,
 @defenseattorneycode int = NULL,
 @commitdate datetime = NULL,
 @servicecode int = NULL,
 @issuecode int = NULL,
 @doctorcode int = NULL,
 @WCBNbr varchar(50) = NULL,
 @specialinstructions text = NULL,
 @usdvarchar1 varchar(50) = NULL,
 @usdvarchar2 varchar(50) = NULL,
 @usddate1 datetime = NULL,
 @usddate2 datetime = NULL,
 @usdtext1 text = NULL,
 @usdtext2 text = NULL,
 @usdint1 int = NULL,
 @usdint2 int = NULL,
 @usdmoney1 money = NULL,
 @usdmoney2 money = NULL,
 @bComplete bit = NULL,
 @bhanddelivery bit = NULL,
 @sinternalcasenbr varchar(70) = NULL,
 @sreqdegree varchar(20) = NULL,
 @sreqspecialty varchar(50) = NULL,
 @doctorspecialty varchar(50) = NULL,
 @feecode int = NULL,
 @voucherselect bit = NULL,
 @voucheramt money = NULL,
 @voucherdate datetime = NULL,
 @icd9code varchar(70) = NULL,
 @reccode int = NULL,
 @billclientcode int = NULL,
 @billcompany varchar(100) = NULL,
 @billcontact varchar(70) = NULL,
 @billaddr1 varchar(70) = NULL,
 @billaddr2 varchar(70) = NULL,
 @billcity varchar(70) = NULL,
 @billstate varchar(2) = NULL,
 @billzip varchar(10) = NULL,
 @billARKey varchar(100) = NULL,
 @billfax varchar(15) = NULL,
 @officecode int = NULL,
 @QARep varchar(15) = NULL,
 @photoRqd bit = NULL,
 @CertifiedMail bit = NULL,
 @ICD9Code2 varchar(70) = NULL,
 @ICD9Code3 varchar(70) = NULL,
 @ICD9Code4 varchar(70) = NULL,
 @PanelNbr int = NULL,
 @DoctorName varchar(100) = NULL,
 @HearingDate smalldatetime = NULL,
 @CertMailNbr varchar(30) = NULL,
 @laststatuschg datetime = NULL,
 @Jurisdiction varchar(5) = NULL,
 @prevappt datetime = NULL,
 @mastersubcase varchar(1) = NULL,
 @mastercasenbr int = NULL,
 @PublishOnWeb bit = NULL,
 @WebNotifyEmail varchar(200) = NULL,
 @AssessmentToAddress varchar(50) = NULL,
 @OCF25Date smalldatetime = NULL,
 @DateForminDispute smalldatetime = NULL,
 @AssessingFacility varchar(100) = NULL,
 @referralmethod int = NULL,
 @referraltype int = NULL,
 @CSR1 varchar(15) = NULL,
 @CSR2 varchar(15) = NULL,
 @LegalEvent bit = NULL,
 @PILegalEvent bit = NULL,
 @Transcode int = NULL,
 @PublishDocuments bit = NULL,
 @DateReceived datetime = NULL,
 @usddate3 datetime = NULL,
 @usddate4 datetime = NULL,
 @usddate5 datetime = NULL,
 @UsdBit1 bit = NULL,
 @UsdBit2 bit = NULL,
 @ClaimNbrExt varchar(50) = NULL,
 @DefParaLegal int = NULL,
 @AttorneyNote text = NULL,
 @BillingNote text = NULL,
 @InterpreterRequired bit = NULL,
 @TransportationRequired bit = NULL,
 @LanguageID int = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblCase]
 SET
  [chartnbr] = @chartnbr,
  [doctorlocation] = @doctorlocation,
  [clientcode] = @clientcode,
  [marketercode] = @marketercode,
  [schedulercode] = @schedulercode,
  [priority] = @priority,
  [status] = @status,
  [casetype] = @casetype,
  [dateadded] = @dateadded,
  [dateedited] = @dateedited,
  [useridadded] = @useridadded,
  [useridedited] = @useridedited,
  [schedcode] = @schedcode,
  [ApptDate] = @ApptDate,
  [Appttime] = @Appttime,
  [claimnbr] = @claimnbr,
  [dateofinjury] = @dateofinjury,
  [allegation] = @allegation,
  [calledinby] = @calledinby,
  [notes] = @notes,
  [schedulenotes] = @schedulenotes,
  [requesteddoc] = @requesteddoc,
  [datemedsrecd] = @datemedsrecd,
  [typemedsrecd] = @typemedsrecd,
  [transreceived] = @transreceived,
  [shownoshow] = @shownoshow,
  [rptstatus] = @rptstatus,
  [reportverbal] = @reportverbal,
  [emailclient] = @emailclient,
  [emaildoctor] = @emaildoctor,
  [emailPattny] = @emailPattny,
  [faxclient] = @faxclient,
  [faxdoctor] = @faxdoctor,
  [faxPattny] = @faxPattny,
  [apptrptsselect] = @apptrptsselect,
  [chartprepselect] = @chartprepselect,
  [apptselect] = @apptselect,
  [awaittransselect] = @awaittransselect,
  [intransselect] = @intransselect,
  [inqaselect] = @inqaselect,
  [drchartselect] = @drchartselect,
  [datedrchart] = @datedrchart,
  [billedselect] = @billedselect,
  [miscselect] = @miscselect,
  [invoicedate] = @invoicedate,
  [invoiceamt] = @invoiceamt,
  [plaintiffattorneycode] = @plaintiffattorneycode,
  [defenseattorneycode] = @defenseattorneycode,
  [commitdate] = @commitdate,
  [servicecode] = @servicecode,
  [issuecode] = @issuecode,
  [doctorcode] = @doctorcode,
  [WCBNbr] = @WCBNbr,
  [specialinstructions] = @specialinstructions,
  [usdvarchar1] = @usdvarchar1,
  [usdvarchar2] = @usdvarchar2,
  [usddate1] = @usddate1,
  [usddate2] = @usddate2,
  [usdtext1] = @usdtext1,
  [usdtext2] = @usdtext2,
  [usdint1] = @usdint1,
  [usdint2] = @usdint2,
  [usdmoney1] = @usdmoney1,
  [usdmoney2] = @usdmoney2,
  [bComplete] = @bComplete,
  [bhanddelivery] = @bhanddelivery,
  [sinternalcasenbr] = @sinternalcasenbr,
  [sreqdegree] = @sreqdegree,
  [sreqspecialty] = @sreqspecialty,
  [doctorspecialty] = @doctorspecialty,
  [feecode] = @feecode,
  [voucherselect] = @voucherselect,
  [voucheramt] = @voucheramt,
  [voucherdate] = @voucherdate,
  [icd9code] = @icd9code,
  [reccode] = @reccode,
  [billclientcode] = @billclientcode,
  [billcompany] = @billcompany,
  [billcontact] = @billcontact,
  [billaddr1] = @billaddr1,
  [billaddr2] = @billaddr2,
  [billcity] = @billcity,
  [billstate] = @billstate,
  [billzip] = @billzip,
  [billARKey] = @billARKey,
  [billfax] = @billfax,
  [officecode] = @officecode,
  [QARep] = @QARep,
  [photoRqd] = @photoRqd,
  [CertifiedMail] = @CertifiedMail,
  [ICD9Code2] = @ICD9Code2,
  [ICD9Code3] = @ICD9Code3,
  [ICD9Code4] = @ICD9Code4,
  [PanelNbr] = @PanelNbr,
  [DoctorName] = @DoctorName,
  [HearingDate] = @HearingDate,
  [CertMailNbr] = @CertMailNbr,
  [laststatuschg] = @laststatuschg,
  [Jurisdiction] = @Jurisdiction,
  [prevappt] = @prevappt,
  [mastersubcase] = @mastersubcase,
  [mastercasenbr] = @mastercasenbr,
  [PublishOnWeb] = @PublishOnWeb,
  [WebNotifyEmail] = @WebNotifyEmail,
  [AssessmentToAddress] = @AssessmentToAddress,
  [OCF25Date] = @OCF25Date,
  [DateForminDispute] = @DateForminDispute,
  [AssessingFacility] = @AssessingFacility,
  [referralmethod] = @referralmethod,
  [referraltype] = @referraltype,
  [CSR1] = @CSR1,
  [CSR2] = @CSR2,
  [LegalEvent] = @LegalEvent,
  [PILegalEvent] = @PILegalEvent,
  [Transcode] = @Transcode,
  [PublishDocuments] = @PublishDocuments,
  [DateReceived] = @DateReceived,
  [usddate3] = @usddate3,
  [usddate4] = @usddate4,
  [usddate5] = @usddate5,
  [UsdBit1] = @UsdBit1,
  [UsdBit2] = @UsdBit2,
  [ClaimNbrExt] = @ClaimNbrExt,
  [DefParaLegal] = @DefParaLegal,
  [AttorneyNote] = @AttorneyNote,
  [BillingNote] = @BillingNote,
  [InterpreterRequired] = @InterpreterRequired,
  [TransportationRequired] = @TransportationRequired,
  [LanguageID] = @LanguageID  
 WHERE
  [casenbr] = @casenbr


 SET @Err = @@Error


 RETURN @Err
END

GO

DROP PROCEDURE [proc_GetDoctorScheduleByDate]
GO


CREATE PROCEDURE [dbo].[proc_GetDoctorScheduleByDate]

@DoctorCode varchar(50) = NULL,
@LocationCode varchar(50) = NULL,
@ApptDate varchar(20) = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT 
   schedcode, 
   tblDoctor.doctorcode, 
   starttime, 
   duration 
   FROM tblDoctor 
   INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode AND tblDoctorSchedule.status = 'open' 
   INNER JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode 
   WHERE tblDoctorLocation.locationcode = COALESCE(@LocationCode,tblDoctorLocation.LocationCode) 
   AND tblDoctorLocation.locationcode IN (SELECT DISTINCT locationcode FROM tblLocation WHERE tblLocation.insidedr = 1) 
   AND tblDoctor.doctorcode = COALESCE(@DoctorCode,tblDoctor.DoctorCode)
   AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 
   ORDER BY starttime 


 SET @Err = @@Error

 RETURN @Err
END


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

DROP PROCEDURE [proc_CaseDocuments_LoadByCaseNbrAndWebUserID]
GO


CREATE PROCEDURE [proc_CaseDocuments_LoadByCaseNbrAndWebUserID] 

@CaseNbr int,
@WebUserID int = NULL,
@IsAdmin int = 0

AS

IF @IsAdmin = 1
 BEGIN
  SELECT DISTINCT tblCaseDocuments.*, 
  tblPublishOnWeb.PublishasPDF 
  FROM tblCaseDocuments 
   INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey  
  WHERE casenbr = @CaseNbr AND tblCaseDocuments.PublishOnWeb = 1
 END
ELSE
 BEGIN
  SELECT DISTINCT tblCaseDocuments.*, 
  tblPublishOnWeb.PublishasPDF 
  FROM tblCaseDocuments 
  INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments' 
   AND (tblPublishOnWeb.PublishOnWeb = 1)
   AND (tblPublishOnWeb.UserCode IN 
    (SELECT UserCode 
     FROM tblWebUserAccount 
     WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
     AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
   AND (casenbr = @CaseNbr)
   AND (tblCaseDocuments.PublishOnWeb = 1) 
 END

GO

DROP PROCEDURE [proc_GetProviderSearch]
GO


CREATE PROCEDURE [proc_GetProviderSearch]

AS

SET NOCOUNT OFF
DECLARE @Err int


 SELECT DISTINCT 
  tblLocation.locationcode,
  tbldoctor.lastname, 
  tblDoctor.firstname, 
  tbldoctor.credentials, 
        tblSpecialty.description specialty,
        tblSpecialty.specialtycode,
        tblLocation.zip, 
        tblLocation.city,
        tblLocation.location, 
        tblLocation.state, 
        tbldoctor.prepaid, 
        tblLocation.county,
        tblLocation.phone,
        tblDoctor.ProvTypeCode,
        tblDoctorKeyword.keywordID,
        tblDoctor.doctorcode, 
        ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname 
        FROM tblDoctor
        LEFT JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode
        LEFT JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode
        LEFT JOIN tbldoctordocuments ON tblDoctor.doctorcode = tbldoctordocuments.doctorcode AND tbldoctordocuments.publishonweb = 1
        LEFT JOIN tblDoctorKeyWord ON tblDoctor.doctorcode = tblDoctorKeyWord.doctorcode
        LEFT JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode AND tblDoctorLocation.publishonweb = 1
        LEFT JOIN tblLocation ON tblDoctorLocation.locationcode = tblLocation.locationcode
        WHERE (tblDoctor.status = 'Active') AND (OPType = 'DR') AND (tblDoctor.publishonweb = 1) AND (tblLocation.locationcode is not null)

SET @Err = @@Error
RETURN @Err
 


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

DROP PROCEDURE [proc_ExamineeCheckForDupe]
GO


CREATE PROCEDURE [proc_ExamineeCheckForDupe]

@FirstName varchar(50) = NULL,
@LastName varchar(50) = NULL,
@Phone1 varchar(50) = NULL

AS

SET NOCOUNT OFF
DECLARE @Err int


SELECT TOP 1 chartnbr FROM tblExaminee WHERE chartnbr > 0 
 AND FirstName LIKE '%' + COALESCE(@FirstName,FirstName) + '%'
 AND LastName LIKE '%' + COALESCE(@LastName,LastName) + '%'
 AND 
  REPLACE( REPLACE( REPLACE( REPLACE(Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ) = 
  COALESCE(REPLACE( REPLACE( REPLACE( REPLACE(@Phone1, '(', '' ), ')', '' ), ' ', '' ), '-', '' ),Phone1) 
 ORDER BY chartnbr
 
SET @Err = @@Error
RETURN @Err

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


update tblControl set DBVersion='1.17'
GO
