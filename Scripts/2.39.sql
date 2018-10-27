
CREATE TABLE [tblEWCoverLetter] (
  [EWCoverLetterID] INTEGER NOT NULL,
  [Description] VARCHAR(140) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [ExternalName] VARCHAR(140) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [Active] BIT NOT NULL,
  [TemplateFilename] VARCHAR(255) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [EnableAdditionalQuestionsSect] BIT NOT NULL,
  [IncludeClaimsHistorySect] BIT NOT NULL,
  [IncludeMedicalRecordsSect] BIT NOT NULL,
  [AllowSelReqCompanyName] BIT NOT NULL,
  [UserIDAdded] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateAdded] DATETIME,
  [UserIDEdited] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateEdited] DATETIME,
  CONSTRAINT [PK_tblEWCoverLetter] PRIMARY KEY CLUSTERED ([EWCoverLetterID])
)
GO

CREATE TABLE [tblEWCoverLetterClientSpecData] (
  [EWCoverLetterClientSpecDataID] INTEGER NOT NULL,
  [EWCoverLetterID] INTEGER NOT NULL,
  [SpecifiedData] VARCHAR(500) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [Required] BIT NOT NULL,
  [UserIDAdded] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateAdded] DATETIME,
  [UserIDEdited] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateEdited] DATETIME,
  CONSTRAINT [PK_tblEWCoverLetterClientSpecData] PRIMARY KEY CLUSTERED ([EWCoverLetterClientSpecDataID])
)
GO

CREATE TABLE [tblCompanyCoverLetter] (
  [CompanyCoverLetterID] INTEGER IDENTITY(1,1) NOT NULL,
  [CompanyCode] INTEGER NOT NULL,
  [EWCoverLetterID] INTEGER NOT NULL,
  [UserIDAdded] VARCHAR(30),
  [DateAdded] DATETIME,
  CONSTRAINT [PK_tblCompanyCoverLetter] PRIMARY KEY CLUSTERED ([CompanyCoverLetterID])
)
GO

CREATE UNIQUE INDEX [IdxtblCompanyCoverLetter_UNIQUE_CompanyCodeEWCoverLetterID] ON [tblCompanyCoverLetter]([CompanyCode],[EWCoverLetterID])
GO

CREATE TABLE [tblEWCoverLetterCompanyName] (
  [EWCoverLetterCompanyNameID] INTEGER NOT NULL,
  [EWCoverLetterID] INTEGER NOT NULL,
  [CompanyName] VARCHAR(80) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [UserIDAdded] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateAdded] DATETIME,
  [UserIDEdited] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateEdited] DATETIME,
  CONSTRAINT [PK_tblEWCoverLetterCompanyName] PRIMARY KEY CLUSTERED ([EWCoverLetterCompanyNameID])
)
GO

CREATE TABLE [tblEWCoverLetterState] (
  [EWCoverLetterStateID] INTEGER NOT NULL,
  [EWCoverLetterID] INTEGER NOT NULL,
  [StateCode] VARCHAR(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [UserIDAdded] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  [DateAdded] DATETIME NOT NULL,
  CONSTRAINT [PK_tblEWCoverLetterState] PRIMARY KEY CLUSTERED ([EWCoverLetterStateID])
)
GO

CREATE UNIQUE INDEX [IdxtblEWCoverLetterState_UNIQUE_EWCoverLetterIDStateCode] ON [tblEWCoverLetterState]([EWCoverLetterID],[StateCode])
GO

CREATE TABLE [tblEWCoverLetterBusLine] (
  [EWCoverLetterBusLineID] INTEGER NOT NULL,
  [EWCoverLetterID] INTEGER NOT NULL,
  [EWBusLineID] INTEGER NOT NULL,
  [UserIDAdded] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateAdded] DATETIME,
  CONSTRAINT [PK_tblEWCoverLetterBusLine] PRIMARY KEY CLUSTERED ([EWCoverLetterBusLineID])
)
GO

CREATE UNIQUE INDEX [IdxtblEWCoverLetterBusLine_UNIQUE_EWCoverLetterIDEWBusLineID] ON [tblEWCoverLetterBusLine]([EWCoverLetterID],[EWBusLineID])
GO

CREATE TABLE [tblEWCoverLetterQuestion] (
  [EWCoverLetterQuestionID] INTEGER NOT NULL,
  [EWCoverLetterID] INTEGER NOT NULL,
  [QuestionText] VARCHAR(1500) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [Required] BIT NOT NULL,
  [DefaultChecked] BIT NOT NULL,
  [UserIDAdded] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateAdded] DATETIME,
  [UserIDEdited] VARCHAR(30) COLLATE SQL_Latin1_General_CP1_CI_AS,
  [DateEdited] DATETIME,
  CONSTRAINT [PK_tblEWCoverLetterQuestion] PRIMARY KEY CLUSTERED ([EWCoverLetterQuestionID])
)
GO


ALTER TABLE [tblCompany]
  ADD [AllowCoverLetterGeneration] BIT
GO


ALTER TABLE [tblEWCompany]
  ADD [AllowCoverLetterGeneration] BIT
GO



UPDATE tblControl SET DBVersion='2.39'
GO
