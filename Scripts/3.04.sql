PRINT N'Altering [dbo].[tblConfirmationRule]...';


GO
ALTER TABLE [dbo].[tblConfirmationRule]
    ADD [ParentCompanyID] INT NULL;


GO
PRINT N'Altering [dbo].[tblConfirmationRuleDetail]...';


GO
ALTER TABLE [dbo].[tblConfirmationRuleDetail]
    ADD [MasterConfirmationRuleDetailID] INT NULL,
        [SeqNo]                          INT NULL;


GO
PRINT N'Altering [dbo].[tblEWTransDept]...';


GO
ALTER TABLE [dbo].[tblEWTransDept]
    ADD [EnableAdditionalDocuments] BIT NULL;


GO
PRINT N'Altering [dbo].[tblTranscription]...';


GO
ALTER TABLE [dbo].[tblTranscription]
    ADD [UseAdditionalDocuments] BIT NULL;


GO
PRINT N'Creating [dbo].[tblDoctorDPSSortModel]...';


GO
CREATE TABLE [dbo].[tblDoctorDPSSortModel] (
    [DPSDoctorSortModelID] INT          IDENTITY (1, 1) NOT NULL,
    [DoctorCode]           INT          NOT NULL,
    [CaseType]             INT          NOT NULL,
    [SortModel]            INT          NOT NULL,
    [UserIDAdded]          VARCHAR (30) NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDEdited]         VARCHAR (30) NULL,
    [DateEdited]           DATETIME     NULL,
    CONSTRAINT [PK_tblDoctorDPSSortModel] PRIMARY KEY CLUSTERED ([DPSDoctorSortModelID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSBundle]...';


GO
CREATE TABLE [dbo].[tblDPSBundle] (
    [BundleID]            INT           IDENTITY (1, 1) NOT NULL,
    [SubmittedBy]         VARCHAR (30)  NULL,
    [SubmittedDate]       DATETIME      NULL,
    [SortModel]           INT           NULL,
    [Priority]            INT           NULL,
    [DueDate]             DATETIME      NULL,
    [Status]              INT           NULL,
    [SpecialInstructions] VARCHAR (500) NULL,
    [CombinedWithID]      INT           NULL,
    [ContactName]         VARCHAR (100) NULL,
    [ContactPhone]        VARCHAR (15)  NULL,
    [ContactEmail]        VARCHAR (70)  NULL,
    [NotifyWhenComplete]  BIT           NULL,
    [UserIDAdded]         VARCHAR (30)  NULL,
    [DateAdded]           DATETIME      NULL,
    [UserIDEdited]        VARCHAR (30)  NULL,
    [DateEdited]          DATETIME      NULL,
    [CaseNbr]             INT           NULL,
    [HideFromQueue]       BIT           NULL,
    [HideFromQueueDate]   DATETIME      NULL,
    CONSTRAINT [PK_tblDPSBundle] PRIMARY KEY CLUSTERED ([BundleID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSBundleCaseDocument]...';


GO
CREATE TABLE [dbo].[tblDPSBundleCaseDocument] (
    [BundleID]  INT NOT NULL,
    [CaseDocID] INT NOT NULL,
    [Selected]  BIT NULL,
    CONSTRAINT [PK_tblDPSBundleCaseDocument] PRIMARY KEY CLUSTERED ([CaseDocID] ASC, [BundleID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSSortModel]...';


GO
CREATE TABLE [dbo].[tblDPSSortModel] (
    [SortModelID] INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_tblDPSSortModel] PRIMARY KEY CLUSTERED ([SortModelID] ASC)
);


GO
PRINT N'Creating [dbo].[tblOfficeDPSSortModel]...';


GO
CREATE TABLE [dbo].[tblOfficeDPSSortModel] (
    [DPSOfficeSortModelID] INT          IDENTITY (1, 1) NOT NULL,
    [Officecode]           INT          NOT NULL,
    [CaseType]             INT          NOT NULL,
    [SortModel]            INT          NOT NULL,
    [UserIDAdded]          VARCHAR (30) NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDEdited]         VARCHAR (30) NULL,
    [DateEdited]           DATETIME     NULL,
    CONSTRAINT [PK_tblOfficeDPSSortModel] PRIMARY KEY CLUSTERED ([DPSOfficeSortModelID] ASC)
);


GO
PRINT N'Creating [dbo].[tblTranscriptionJobFile]...';


GO
CREATE TABLE [dbo].[tblTranscriptionJobFile] (
    [TransJobFileID]     INT           IDENTITY (1, 1) NOT NULL,
    [TranscriptionJobID] INT           NOT NULL,
    [CaseDocID]          INT           NOT NULL,
    [FileType]           VARCHAR (50)  NOT NULL,
    [TransFileName]      VARCHAR (200) NULL,
    CONSTRAINT [PK_tblTranscriptionJobFile] PRIMARY KEY CLUSTERED ([TransJobFileID] ASC)
);


GO
PRINT N'Creating [dbo].[tblConfirmationRuleDetail_AfterInsert_TRG]...';


GO
CREATE TRIGGER tblConfirmationRuleDetail_AfterInsert_TRG 
  ON tblConfirmationRuleDetail
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON
  UPDATE tblConfirmationRuleDetail
   SET tblConfirmationRuleDetail.SeqNo = (SELECT MAX(SeqNo)+1 FROM tblConfirmationRuleDetail WHERE MasterConfirmationRuleDetailID=Inserted.MasterConfirmationRuleDetailID)
   FROM Inserted
   WHERE tblConfirmationRuleDetail.ConfirmationRuleDetailID = Inserted.ConfirmationRuleDetailID
   AND Inserted.MasterConfirmationRuleDetailID IS NOT NULL
  UPDATE tblConfirmationRuleDetail
   SET tblConfirmationRuleDetail.MasterConfirmationRuleDetailID = Inserted.ConfirmationRuleDetailID, tblConfirmationRuleDetail.SeqNo = 1
   FROM Inserted
   WHERE tblConfirmationRuleDetail.ConfirmationRuleDetailID = Inserted.ConfirmationRuleDetailID
   AND Inserted.MasterConfirmationRuleDetailID IS NULL
SET NOCOUNT OFF
END
GO
PRINT N'Creating [dbo].[vwDPSCases]...';


GO
CREATE VIEW [dbo].[vwDPSCases]
	AS SELECT DISTINCT	C.CaseNbr,
						C.ExtCaseNbr, 
						B.BundleID, 
						DATEDIFF(d, B.DateEdited, GetDate()) AS IQ,  
						E.FirstName + ' ' + E.LastName AS ExamineeName,  
						Com.IntName as CompanyName, 
						D.FirstName + ' ' + D.LastName AS DoctorName, 
						C.ApptTime, 
						B.ContactName, 
						B.DateEdited AS CompletedDate,
						B.[Status] As BundleStatus,
						B.HideFromQueue,
						B.HideFromQueueDate,
						C.OfficeCode,
						C.ServiceCode,
						C.SchedulerCode,
						C.QARep,
						C.MarketerCode,
						Com.ParentCompanyID,
						C.DoctorLocation,
						D.DoctorCode,
						Com.CompanyCode,
						C.CaseType,
						E.ChartNbr
FROM tblDPSBundle AS B
LEFT OUTER JOIN tblCase AS C ON B.CaseNbr = C.CaseNbr
LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr = E.ChartNbr
LEFT OUTER JOIN tblDoctor AS D ON C.Doctorcode = D.DoctorCode
LEFT OUTER JOIN tblCompany AS Com ON C.CompanyCode = Com.CompanyCode
GO



PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase] DROP COLUMN [TATExamToClientNotify], COLUMN [TATExamToRepReceived], COLUMN [TATQACompleteToRepSent], COLUMN [TATRepReceivedToQAComplete], COLUMN [TATRepSentToInvoiced], COLUMN [TATRptRecievedToQAComplete];


GO


PRINT N'Dropping [dbo].[proc_BackFillData_TATDaysCalculation]...';


GO
DROP PROCEDURE [dbo].[proc_BackFillData_TATDaysCalculation];


GO
PRINT N'Dropping [dbo].[proc_TATDaysCalculation]...';


GO
DROP PROCEDURE [dbo].[proc_TATDaysCalculation];


GO
PRINT N'Dropping [dbo].[fnGetTATDays]...';


GO
DROP FUNCTION [dbo].[fnGetTATDays];


GO


INSERT INTO tbluserfunction VALUES ('DPSSendRecords', 'Case – Send Records to DPS')
GO

UPDATE tblConfirmationRuleDetail SET MasterConfirmationRuleDetailID=ConfirmationRuleDetailID, SeqNo=1
GO




UPDATE tblControl SET DBVersion='3.04'
GO
