
--Chnages for National Doctor Database
CREATE TABLE [tblEWDrDocType] (
  [EWDrDocTypeID] INTEGER NOT NULL,
  [Name] VARCHAR(30),
  [FolderID] INTEGER,
  [Confidential] BIT,
  CONSTRAINT [PK_tblEWDrDocType] PRIMARY KEY ([EWDrDocTypeID])
)
GO

ALTER TABLE [tblSpecialty]
  ADD [BoardCertAvailable] BIT
GO

ALTER TABLE [tblControl]
  ADD [NDB] BIT
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [EWDoctorDocumentID] INTEGER
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [EWDoctorID] INTEGER
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [EWDrDocTypeID] INTEGER
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [SpecialtyCode] VARCHAR(50)
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [EWAccreditationID] INTEGER
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [State] VARCHAR(2)
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [LicenseNbr] VARCHAR(50)
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [FileExists] BIT
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [Confidential] BIT
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [FolderID] INTEGER
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [Notes] TEXT
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [AllowEdit] BIT
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [FileSize] BIGINT
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [OriginalFilePath] VARCHAR(120)
GO

ALTER TABLE [tblDoctorDocuments]
  ADD [ConvertStatus] VARCHAR(25)
GO

ALTER TABLE [tblIMEData]
  ADD [DrDocFolderID] INTEGER
GO

ALTER TABLE [tblDoctor]
  ADD [EWDoctorID] INTEGER
GO

ALTER TABLE [tblDoctor]
  ADD [PracticingDoctor] BIT
GO

ALTER TABLE [tblDoctor]
  ADD [DOB] DATETIME
GO

ALTER TABLE [tblEWFolderDef]
  ADD [DocumentStorage] BIT
GO


--Changes for Appointment History
CREATE TABLE [dbo].[tblApptStatus]
(
[ApptStatusID] [int] NOT NULL,
[Name] [varchar] (20) NULL
)
GO

ALTER TABLE [dbo].[tblApptStatus] ADD CONSTRAINT [PK_tblApptStatus] PRIMARY KEY CLUSTERED  ([ApptStatusID])
GO

CREATE TABLE [dbo].[tblCaseAppt]
(
[CaseApptID] [int] NOT NULL IDENTITY(1, 1),
[CaseNbr] [int] NOT NULL,
[ApptTime] [datetime] NOT NULL,
[DoctorCode] [int] NULL,
[LocationCode] [int] NULL,
[SpecialtyCode] [varchar] (50) NULL,
[ApptStatusID] [int] NOT NULL,
[DateAdded] [datetime] NULL,
[UserIDAdded] [varchar] (15) NULL,
[DateEdited] [datetime] NULL,
[UserIDEdited] [varchar] (15) NULL,
[CanceledByID] [int] NULL,
[Reason] [varchar] (300) NULL,
[LastStatusChg] [datetime] NULL
)
GO

ALTER TABLE [dbo].[tblCaseAppt] ADD CONSTRAINT [PK_tblCaseAppt] PRIMARY KEY CLUSTERED  ([CaseApptID])
GO

CREATE TABLE [dbo].[tblCaseApptPanel]
(
[CaseApptID] [int] NOT NULL,
[DoctorCode] [int] NOT NULL,
[SpecialtyCode] [varchar] (50) NULL
)
GO

ALTER TABLE [dbo].[tblCaseApptPanel] ADD CONSTRAINT [PK_tblCaseApptPanel] PRIMARY KEY CLUSTERED  ([CaseApptID], [DoctorCode])
GO

CREATE TABLE [dbo].[tblCanceledBy]
(
[CanceledByID] [int] NOT NULL,
[Name] [varchar] (25) NULL
)
GO

ALTER TABLE [dbo].[tblCanceledBy] ADD CONSTRAINT [PK_tblCanceledBy] PRIMARY KEY CLUSTERED  ([CanceledByID])
GO

ALTER TABLE [dbo].[tblCase] ADD
[ApptStatusID] [int] NULL,
[CaseApptID] [int] NULL
GO

ALTER TABLE [dbo].[tblIMEData] ADD
[QAfterLateCancel] [int] NULL
GO

ALTER TABLE tblAcctHeader
ADD CaseApptID INT NULL,
ApptStatusID INT NULL
GO

ALTER TABLE tblAcctingTrans ADD
CaseApptID INT NULL,
ApptStatusID INT NULL
GO

INSERT INTO [dbo].[tblApptStatus] ([ApptStatusID], [Name]) VALUES (0, '')
INSERT INTO [dbo].[tblApptStatus] ([ApptStatusID], [Name]) VALUES (10, 'Scheduled')
INSERT INTO [dbo].[tblApptStatus] ([ApptStatusID], [Name]) VALUES (50, 'Canceled')
INSERT INTO [dbo].[tblApptStatus] ([ApptStatusID], [Name]) VALUES (51, 'Late Canceled')
INSERT INTO [dbo].[tblApptStatus] ([ApptStatusID], [Name]) VALUES (100, 'Show')
INSERT INTO [dbo].[tblApptStatus] ([ApptStatusID], [Name]) VALUES (101, 'No Show')
INSERT INTO [dbo].[tblApptStatus] ([ApptStatusID], [Name]) VALUES (102, 'Unable to Examine')
GO
INSERT INTO [dbo].[tblCanceledBy] ([CanceledByID], [Name]) VALUES (1, 'Internal')
INSERT INTO [dbo].[tblCanceledBy] ([CanceledByID], [Name]) VALUES (2, 'Client')
INSERT INTO [dbo].[tblCanceledBy] ([CanceledByID], [Name]) VALUES (3, 'Examinee')
INSERT INTO [dbo].[tblCanceledBy] ([CanceledByID], [Name]) VALUES (4, 'Doctor')
INSERT INTO [dbo].[tblCanceledBy] ([CanceledByID], [Name]) VALUES (5, 'Opposing Attorney')
GO




UPDATE tblControl SET DBVersion='1.88'
GO
