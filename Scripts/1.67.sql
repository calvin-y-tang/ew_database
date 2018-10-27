CREATE INDEX [IdxtblCase_BY_ChartNbrClaimNbrOfficeCode] ON [tblCase]([ChartNbr],[ClaimNbr],[OfficeCode])
GO


CREATE INDEX [IdxtblDoctor_BY_OPTypeOPSubType] ON [tblDoctor]([OPType],[OPSubType])
GO

CREATE INDEX [IdxtblDoctor_BY_LastNameFirstNameMiddleInitial] ON [tblDoctor]([LastName],[FirstName],[MiddleInitial])
GO


CREATE INDEX [IdxtblExaminee_BY_LastNameFirstNameMiddleInitialDOBStateCityPhone1] ON [tblExaminee]([LastName],[FirstName],[MiddleInitial],[DOB],[State],[City],[Phone1])
GO



----------------------------------------------------------------------


CREATE TABLE [tblCaseTranscription] (
  [TranscriptionID] INTEGER IDENTITY(1,1) NOT NULL,
  [TranscriptionStatusCode] INTEGER NOT NULL,
  [DateAdded] DATETIME,
  [DateEdited] DATETIME,
  [UserIDEdited] VARCHAR(20),
  [DictationFile] VARCHAR(100),
  [CaseNbr] INTEGER,
  [ReportTemplate] VARCHAR(15),
  [ReportTemplateFile] VARCHAR(100),
  [CoverLetterFile] VARCHAR(100),
  [TransCode] INTEGER,
  [DateAssigned] DATETIME,
  [ReportFile] VARCHAR(100),
  [DateRptReceived] DATETIME,
  [DateCompleted] DATETIME,
  CONSTRAINT [PK_tblCaseTranscription] PRIMARY KEY ([TranscriptionID])
)
GO

CREATE INDEX [IdxtblCaseTranscription_BY_CaseNbr] ON [tblCaseTranscription]([CaseNbr])
GO

CREATE INDEX [IdxtblCaseTranscription_BY_TransCode] ON [tblCaseTranscription]([TransCode])
GO

CREATE TABLE [tblTranscriptionStatus] (
  [TranscriptionStatusCode] INTEGER IDENTITY(1,1) NOT NULL,
  [Descrip] VARCHAR(15),
  CONSTRAINT [PK_tblTranscriptionStatus] PRIMARY KEY ([TranscriptionStatusCode])
)
GO


ALTER TABLE [tblCase]
  ADD [RptInitialDraftDate] DATETIME
GO

ALTER TABLE [tblCase]
  ADD [RptSentDate] DATETIME
GO


ALTER TABLE [tblCompany]
  ADD [ReportTemplate] VARCHAR(15)
GO


ALTER TABLE [tblDoctor]
  ADD [ReportTemplate] VARCHAR(15)
GO


ALTER TABLE [tblIMEData]
  ADD [TranscriptionCapability] BIT
GO

ALTER TABLE [tblIMEData]
  ADD [UseCustomRptCoverLetterDir] BIT
GO

ALTER TABLE [tblIMEData]
  ADD [DirRptCoverLetter] VARCHAR(70)
GO

ALTER TABLE [tblIMEData]
  ADD [DirDictationFiles] VARCHAR(70)
GO

ALTER TABLE [tblIMEData]
  ADD [DirTranscription] VARCHAR(70)
GO


ALTER TABLE [tblTranscription]
  ADD [DirExport] VARCHAR(70)
GO

ALTER TABLE [tblTranscription]
  ADD [RequireReportTemplate] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblTranscription]
  ADD [RequireCoverLetter] BIT DEFAULT 0 NOT NULL
GO


ALTER TABLE [tblUser]
  ADD [TransCode] INTEGER
GO


ALTER TABLE [tblWebUser]
  ADD [AllowTranscriptionRequest] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblWebUser]
  ADD [NotifyTranscriptionAssignment] BIT DEFAULT 0 NOT NULL
GO

DROP VIEW [vwCompany]
GO


CREATE VIEW [dbo].[vwCompany]
AS
    SELECT TOP 100 PERCENT
         tblCompany.*
    FROM tblCompany
    ORDER BY intname

GO




UPDATE tblControl SET DBVersion='1.67'
GO
