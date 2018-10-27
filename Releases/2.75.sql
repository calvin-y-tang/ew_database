UPDATE tblUserOffice SET DefaultOffice=ISNULL(DefaultOffice,0) WHERE DefaultOffice IS NULL
GO
PRINT N'Altering [dbo].[tblUserOffice]...';
GO
ALTER TABLE [dbo].[tblUserOffice] ALTER COLUMN [DefaultOffice] BIT NOT NULL;
GO
PRINT N'Creating [dbo].[DF_tblUserOffice_DefaultOffice]...';
GO
ALTER TABLE [dbo].[tblUserOffice]
    ADD CONSTRAINT [DF_tblUserOffice_DefaultOffice] DEFAULT ((0)) FOR [DefaultOffice];
GO



PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [ExtCaseNbr]    INT      CONSTRAINT [DF_tblCase_ExtCaseNbr] DEFAULT ((0)) NOT NULL,
        [DateOfInjury2] DATETIME NULL,
        [DateOfInjury3] DATETIME NULL,
        [DateOfInjury4] DATETIME NULL;


GO
PRINT N'Creating [dbo].[tblCase].[IdxtblCase_BY_ExtCaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IdxtblCase_BY_ExtCaseNbr]
    ON [dbo].[tblCase]([ExtCaseNbr] ASC);


GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [EmailCapability]          BIT          NULL,
        [FaxCapability]            BIT          NULL,
        [FaxServerType]            VARCHAR (10) NULL,
        [LabelCapability]          BIT          NULL,
        [TranscriptionCapability]  BIT          NULL,
        [CountryID]                INT          NULL,
        [BRqInternalCaseNbr]       BIT          CONSTRAINT [DF_tblControl_BRqInternalCaseNbr] DEFAULT ((0)) NULL,
        [CreateVouchers]           BIT          NULL,
        [CalcTaxOnVouchers]        BIT          NULL,
        [RequirePDF]               BIT          NULL,
        [AllowICD10]               BIT          NULL,
        [DefaultICDFormat]         INT          NULL,
        [UseHCAIInterface]         BIT          CONSTRAINT [DF_tblControl_UseHCAIInterface] DEFAULT ((0)) NOT NULL,
        [blnUseSubCases]           BIT          NULL,
        [NextInvoiceNbr]           INT          NULL,
        [NextVoucherNbr]           INT          NULL,
        [NextBatchNbr]             INT          NULL,
        [NextEDIBatchNbr]          INT          NULL,
        [ATSecurityProfileID]      INT          NULL,
        [CLSecurityProfileID]      INT          NULL,
        [DRSecurityProfileID]      INT          NULL,
        [OPSecurityProfileID]      INT          NULL,
        [TRSecurityProfileID]      INT          NULL,
        [ApptDuration]             INT          NULL,
        [MultiPortal]              BIT          NULL,
        [IncludeSubCaseOnMaster]   BIT          CONSTRAINT [DF_tblControl_IncludeSubCaseOnMaster] DEFAULT ((0)) NOT NULL,
        [WorkHourStart]            INT          NULL,
        [WorkHourEnd]              INT          NULL,
        [DrDocFolderID]            INT          NULL,
        [DirWebQuickReferralFiles] VARCHAR (70) NULL,
        [DirTemplate]              VARCHAR (70) NULL,
        [DirDirections]            VARCHAR (70) NULL,
        [SourceDirectory]          VARCHAR (70) NULL,
        [DirVoicePlayer]           VARCHAR (70) NULL,
        [DirIMECentricHelper]      VARCHAR (70) NULL;


GO
PRINT N'Altering [dbo].[tblIMEData]...';


GO
ALTER TABLE [dbo].[tblIMEData]
    ADD [FeeScheduleSetting] INT CONSTRAINT [DF_tblIMEData_FeeScheduleSetting] DEFAULT ((1)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblTranscriptionJob]...';


GO
ALTER TABLE [dbo].[tblTranscriptionJob]
    ADD [TranscriptionJobNbr] INT CONSTRAINT [DF_tblTranscriptionJob_TranscriptionJobNbr] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Creating [dbo].[tblTranscriptionJob].[IdxtblTranscriptionJob_BY_TranscriptionJobNbr]...';


GO
CREATE NONCLUSTERED INDEX [IdxtblTranscriptionJob_BY_TranscriptionJobNbr]
    ON [dbo].[tblTranscriptionJob]([TranscriptionJobNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCCAddressOffice]...';


GO
CREATE TABLE [dbo].[tblCCAddressOffice] (
    [CCCode]      INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCCAddressOffice] PRIMARY KEY CLUSTERED ([CCCode] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblClientOffice]...';


GO
CREATE TABLE [dbo].[tblClientOffice] (
    [ClientCode]  INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [IsDefault]   BIT          NOT NULL,
    CONSTRAINT [PK_tblClientOffice] PRIMARY KEY CLUSTERED ([ClientCode] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblCompanyOffice]...';


GO
CREATE TABLE [dbo].[tblCompanyOffice] (
    [CompanyCode] INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCompanyOffice] PRIMARY KEY CLUSTERED ([CompanyCode] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblDocumentOffice]...';


GO
CREATE TABLE [dbo].[tblDocumentOffice] (
    [DocumentID]  INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDocumentOffice] PRIMARY KEY CLUSTERED ([DocumentID] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblFacilityOffice]...';


GO
CREATE TABLE [dbo].[tblFacilityOffice] (
    [FacilityID]  INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFacilityOffice] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblLocationOffice]...';


GO
CREATE TABLE [dbo].[tblLocationOffice] (
    [LocationCode] INT          NOT NULL,
    [OfficeCode]   INT          NOT NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (15) NULL,
    CONSTRAINT [PK_tblLocationOffice] PRIMARY KEY CLUSTERED ([LocationCode] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Creating [dbo].[DF_tblClientOffice_IsDefault]...';


GO
ALTER TABLE [dbo].[tblClientOffice]
    ADD CONSTRAINT [DF_tblClientOffice_IsDefault] DEFAULT ((0)) FOR [IsDefault];


GO
PRINT N'Creating [dbo].[tblCase_AfterInsert_TRG]...';


GO
CREATE TRIGGER tblCase_AfterInsert_TRG 
  ON tblCase
AFTER INSERT
AS
  UPDATE tblCase
   SET tblCase.ExtCaseNbr = Inserted.CaseNbr
   FROM Inserted
   WHERE tblCase.CaseNbr = Inserted.CaseNbr
GO
PRINT N'Creating [dbo].[tblTranscriptionJob_AfterInsert_TRG]...';


GO
CREATE TRIGGER tblTranscriptionJob_AfterInsert_TRG 
  ON tblTranscriptionJob
AFTER INSERT
AS
  UPDATE tblTranscriptionJob
   SET tblTranscriptionJob.TranscriptionJobNbr = Inserted.TranscriptionJobID
   FROM Inserted
   WHERE tblTranscriptionJob.TranscriptionJobID = Inserted.TranscriptionJobID
GO

UPDATE tblControl SET DBVersion='2.75'
GO
