PRINT N'Altering [dbo].[tblCaseDocuments]...';


GO
ALTER TABLE [dbo].[tblCaseDocuments]
    ADD [ReportApproved] BIT NULL;


GO
PRINT N'Starting rebuilding table [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWParentCompany] (
    [ParentCompanyID]         INT           NOT NULL,
    [Name]                    VARCHAR (40)  NOT NULL,
    [GPParentCustomerID]      VARCHAR (15)  NULL,
    [CompanyFilter]           VARCHAR (80)  NULL,
    [NationalAccount]         BIT           NOT NULL,
    [SeqNo]                   INT           NULL,
    [DataHandling]            INT           NULL,
    [FolderID]                INT           NULL,
    [SLADocumentFileName]     VARCHAR (80)  NULL,
    [BulkBillingID]           INT           NULL,
    [RequireInOutNetwork]     INT           NULL,
    [ServiceIncludeExclude]   BIT           NULL,
    [CaseAcknowledgment]      BIT           NULL,
    [ParentCompanyURL]        VARCHAR (MAX) NULL,
    [RequirePracticingDoctor] BIT           NULL,
    [RequireStateLicence]     BIT           NULL,
    [RequireCertification]    BIT           NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWParentCompany1] PRIMARY KEY CLUSTERED ([ParentCompanyID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWParentCompany])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_tblEWParentCompany] ([ParentCompanyID], [Name], [GPParentCustomerID], [CompanyFilter], [NationalAccount], [SeqNo], [DataHandling], [FolderID], [SLADocumentFileName], [BulkBillingID], [RequireInOutNetwork], [ServiceIncludeExclude], [CaseAcknowledgment], [ParentCompanyURL], [RequirePracticingDoctor], [RequireStateLicence], [RequireCertification])
        SELECT   [ParentCompanyID],
                 [Name],
                 [GPParentCustomerID],
                 [CompanyFilter],
                 [NationalAccount],
                 [SeqNo],
                 [DataHandling],
                 [FolderID],
                 [SLADocumentFileName],
                 [BulkBillingID],
                 [RequireInOutNetwork],
                 [ServiceIncludeExclude],
                 [CaseAcknowledgment],
                 [ParentCompanyURL],
                 [RequirePracticingDoctor],
                 [RequireStateLicence],
                 [RequireCertification]
        FROM     [dbo].[tblEWParentCompany]
        ORDER BY [ParentCompanyID] ASC;
    END

DROP TABLE [dbo].[tblEWParentCompany];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWParentCompany]', N'tblEWParentCompany';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWParentCompany1]', N'PK_tblEWParentCompany', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[tblEWParentCompany].[IX_U_tblEWParentCompany_Name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWParentCompany_Name]
    ON [dbo].[tblEWParentCompany]([Name] ASC);


GO
PRINT N'Starting rebuilding table [dbo].[tblEWParentCompanyDocuments]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWParentCompanyDocuments] (
    [ParentCompanyDocumentID] INT           NOT NULL,
    [ParentCompanyID]         INT           NOT NULL,
    [FolderID]                INT           NOT NULL,
    [DocumentType]            INT           NOT NULL,
    [DocumentFilename]        VARCHAR (256) NOT NULL,
    [Description]             VARCHAR (128) NULL,
    [DateAdded]               DATETIME      NOT NULL,
    [UserIDAdded]             VARCHAR (15)  NOT NULL,
    [DateEdited]              DATETIME      NOT NULL,
    [UserIDEdited]            VARCHAR (15)  NOT NULL,
    [Active]                  BIT           NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWParentCompanyDocuments1] PRIMARY KEY CLUSTERED ([ParentCompanyDocumentID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWParentCompanyDocuments])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_tblEWParentCompanyDocuments] ([ParentCompanyDocumentID], [ParentCompanyID], [FolderID], [DocumentType], [DocumentFilename], [Description], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [Active])
        SELECT   [ParentCompanyDocumentID],
                 [ParentCompanyID],
                 [FolderID],
                 [DocumentType],
                 [DocumentFilename],
                 [Description],
                 [DateAdded],
                 [UserIDAdded],
                 [DateEdited],
                 [UserIDEdited],
                 [Active]
        FROM     [dbo].[tblEWParentCompanyDocuments]
        ORDER BY [ParentCompanyDocumentID] ASC;
    END

DROP TABLE [dbo].[tblEWParentCompanyDocuments];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWParentCompanyDocuments]', N'tblEWParentCompanyDocuments';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWParentCompanyDocuments1]', N'PK_tblEWParentCompanyDocuments', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Altering [dbo].[tblPublishOnWeb]...';


GO
ALTER TABLE [dbo].[tblPublishOnWeb]
    ADD [Viewed] BIT NULL;


GO
PRINT N'Creating [dbo].[tblCaseContactRequest]...';


GO
CREATE TABLE [dbo].[tblCaseContactRequest] (
    [CaseContactReqID] INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]          INT           NULL,
    [Department]       VARCHAR (100) NULL,
    [EWEmailAddress]   VARCHAR (255) NULL,
    [UserEmailAddress] VARCHAR (255) NULL,
    [Phone]            VARCHAR (50)  NULL,
    [Message]          VARCHAR (MAX) NULL,
    [IMECentricCode]   INT           NULL,
    [UserType]         CHAR (2)      NULL,
    [NotificationSent] BIT           NULL,
    CONSTRAINT [PK_tblCaseContactRequest] PRIMARY KEY CLUSTERED ([CaseContactReqID] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


GO







UPDATE tblControl SET DBVersion='3.21'
GO