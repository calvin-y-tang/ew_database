
IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [OrigApptMadeDate] DATETIME NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblDPSSortModel]...';


GO
ALTER TABLE [dbo].[tblDPSSortModel]
    ADD [Explanation]  VARCHAR (100) NULL,
        [PublishOnWeb] BIT           NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblNotifyPreference]...';


GO
ALTER TABLE [dbo].[tblNotifyPreference]
    ADD [UserType] VARCHAR (2) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [OCRSystemID] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblWebReferral]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD [DPSDueDate]             DATETIME      NULL,
        [SortModelID]            INT           NULL,
        [DPSDeliverWebPortal]    BIT           NULL,
        [DPSDeliverEmailLink]    BIT           NULL,
        [DPSDeliverOther]        BIT           NULL,
        [DPSSpecialInstructions] VARCHAR (500) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblOCRDocument]...';


GO
CREATE TABLE [dbo].[tblOCRDocument] (
    [OCRDocumentID]       INT           IDENTITY (1, 1) NOT NULL,
    [OCRSystemID]         INT           NULL,
    [CaseDocID]           INT           NOT NULL,
    [OCRStatusID]         INT           NOT NULL,
    [ExtOCRDocumentID]    VARCHAR (50)  NULL,
    [DateAdded]           DATETIME      NOT NULL,
    [UserIDAdded]         VARCHAR (20)  NOT NULL,
    [DateEdited]          DATETIME      NULL,
    [UserIDEdited]        VARCHAR (20)  NULL,
    [DateDue]             DATETIME      NULL,
    [DateCompleted]       DATETIME      NULL,
    [OriginalFileName]    VARCHAR (200) NULL,
    [OriginalFileDateUtc] DATETIME      NULL,
    [OriginalFileSizeKB]  BIGINT        NULL,
    [OCRServer]           VARCHAR (15)  NULL,
    [Priority]            INT           NULL,
    [Source]              VARCHAR (20)  NULL,
    CONSTRAINT [PK_tblOCRDocument] PRIMARY KEY CLUSTERED ([OCRDocumentID] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblGPInvoice].[IX_tblGPInvoice_InvHeaderID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblGPInvoice_InvHeaderID]
    ON [dbo].[tblGPInvoice]([InvHeaderID] ASC);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblGPVoucher].[IX_tblGPVoucher_VoHeaderID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblGPVoucher_VoHeaderID]
    ON [dbo].[tblGPVoucher]([VoHeaderID] ASC);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[DF_tblOCRDocument_Priority]...';


GO
ALTER TABLE [dbo].[tblOCRDocument]
    ADD CONSTRAINT [DF_tblOCRDocument_Priority] DEFAULT ((0)) FOR [Priority];


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblCaseDocuments_AfterInsert_TRG]...';


GO

ALTER TRIGGER tblCaseDocuments_AfterInsert_TRG
	ON tblCaseDocuments 
AFTER INSERT
AS 
BEGIN
	
	UPDATE tblCaseDocuments
	   SET tblCaseDocuments.MasterCaseNbr = tblCase.MasterCaseNbr	
	  FROM inserted 
			INNER JOIN tblCase ON tblCase.CaseNbr = inserted.CaseNbr 
	 WHERE tblCaseDocuments.SeqNo = inserted.SeqNo

	 -- create corresponding entry in tblOCRDocument 
      INSERT INTO tblOCRDocument 
          (CaseDocID, OCRStatusID, DateAdded, UserIDAdded, Source)
      SELECT NewDoc.SeqNo, 
             10, -- New
             GETDATE(), 
             NewDoc.UserIDAdded, 
             'InsertTrigger'
        FROM inserted AS NewDoc

END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[vwConfirmationResultsReport]...';


GO
ALTER VIEW vwConfirmationResultsReport
AS 
		SELECT  
		c.Office, 
		c.ExtCaseNbr AS 'Case Nbr', 
		FORMAT(c.ApptTime,'MM-dd-yy') AS 'Appt',
		c.ExamineefirstName + ' ' + c.ExamineelastName AS Examinee, 
		ISNULL(c.PAttorneyCompany,'') AS 'Attorney Firm', 
		ISNULL(c.pAttorneyfirstName, '') + ISNULL(c.pAttorneylastName, '') AS Attorney, 
		c.Company, 
		ct.ShortDesc AS 'Case Type', 
		s.ShortDesc AS Service, 
		cl.ContactType AS 'Contact Type', 
		IIF(cl.ContactMethod=1,'Phone','Text') AS 'Contact Method', 
		cl.Phone,  
		FORMAT(cl.TargetCallTime,'M-d-yy h:mmtt') AS 'Call Target Time', 
		FORMAT(cl.ContactedDateTime,'M-d-yy h:mmtt') AS 'Actual Call Date Time', 
		cl.NbrOfCallAttempts AS 'Nbr Attempts', 
		cr.Description AS 'Call Result', 
		IIF(ca.apptConfirmedByExaminee=1 OR ca.apptConfirmedByAttorney=1, 'Yes','No') AS Confirmed,
		c.officeCode,
		cl.StartDate,
		cs.Name AS StatusDescription,
		d.FirstName + ' ' + d.LastName AS 'Doctor Name',
		l.Location AS 'Exam Location',		
		CONVERT(date, cb.DateBatchPrepared) AS SentDate,
		c.Employer
	FROM tblconfirmationlist AS cl
	LEFT OUTER JOIN tblconfirmationresult AS cr ON cr.confirmationresultid = cl.confirmationresultid
	INNER JOIN tblcaseappt AS ca ON ca.caseapptid = cl.CaseApptID
	INNER JOIN vwdocument AS c ON c.casenbr = ca.CaseNbr
	INNER JOIN tblServices AS s ON c.servicecode = s.servicecode
	INNER JOIN tblCaseType AS ct ON c.casetype = ct.code
	INNER JOIN tblConfirmationStatus AS cs ON cl.ConfirmationStatusID = cs.ConfirmationStatusID
	LEFT OUTER JOIN tblConfirmationBatch AS cb ON cl.BatchNbr = cb.BatchNbr
	LEFT OUTER JOIN tblDoctor AS d ON ca.DoctorCode = d.DoctorCode
	INNER JOIN tblLocation AS l ON ca.LocationCode = l.LocationCode
	WHERE (cl.Selected = 1) 
	AND (cl.ConfirmationStatusID IN (NULL,3,4,5,112))
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
-- Issue 11547 - Add Secondary Email for V2 Client Portal Notifications
INSERT INTO tblNotifyAudience
(
    NotifyEventID,
    NotifyMethodID,
    UserType,
    ActionType,
    DateAdded,
    UserIDAdded,
    DateEdited,
    UserIDEdited,
    DefaultPreferenceValue,
    TableType
)
SELECT
NotifyEventID,
NotifyMethodID,
'SD',
ActionType,
DateAdded,
UserIDAdded,
DateEdited,
UserIDEdited,
0,
TableType
FROM tblNotifyAudience
WHERE UserType='CL'
and NotifyMethodID=2
GO

UPDATE NP SET NP.UserType = WU.UserType 
from tblNotifyPreference AS NP INNER JOIN tblWebUser AS WU ON NP.WebUserID = WU.WebUserID

INSERT INTO tblNotifyPreference
  (
      WebUserID,
      NotifyEventID,
      NotifyMethodID,
      DateEdited,
      UserIDEdited,
      PreferenceValue,
      UserType
  )
  SELECT DISTINCT
  NP.WebUserID,
  NA.NotifyEventID,
  NA.NotifyMethodID,
  GETDATE(),
  'System',
  NA.DefaultPreferenceValue,
  NA.UserType
  FROM tblNotifyPreference AS NP
  INNER JOIN tblNotifyAudience AS NA ON NA.UserType = 'SD'
  WHERE NP.UserType = 'CL'

GO





insert into tbluserfunction (functioncode, functiondesc)
 select 'EditApptCancelReason', 'Appointment - Edit Cancel Reason'
 where not exists (select functionCode from tblUserFunction where functionCode='EditApptCancelReason')
GO


INSERT INTO tblDataField
(
    DataFieldID,
    TableName,
    FieldName,
    Descrip
)
VALUES
(   215,  -- DataFieldID - int
    'tblCase', -- TableName - varchar(35)
    'OrigApptMadeDate', -- FieldName - varchar(35)
    'Exam Scheduled'  -- Descrip - varchar(70)
    )
GO
UPDATE tblTATCalculationMethod SET EndDateFieldID=215 WHERE TATCalculationMethodID=7
GO





UPDATE tblCase SET OrigApptMadeDate=(SELECT TOP 1 DateAdded FROM tblCaseAppt WHERE tblCaseAppt.CaseNbr=tblCase.CaseNbr ORDER BY CaseApptID DESC)
GO
