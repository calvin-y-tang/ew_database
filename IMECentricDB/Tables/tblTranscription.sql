CREATE TABLE [dbo].[tblTranscription] (
    [TransCompany]          VARCHAR (50) NULL,
    [Status]                VARCHAR (10) CONSTRAINT [DF_tblTranscription_Status] DEFAULT ('Active') NULL,
    [DateAdded]             DATETIME     NULL,
    [DateEdited]            DATETIME     NULL,
    [UserIDAdded]           VARCHAR (15) NULL,
    [UserIDEdited]          VARCHAR (15) NULL,
    [OfficeCode]            INT          NULL,
    [TransCode]             INT          IDENTITY (1, 1) NOT NULL,
    [WebUserID]             INT          NULL,
    [EMail]                 VARCHAR (70) NULL,
    [DirExport]             VARCHAR (70) NULL,
    [RequireReportTemplate] BIT          CONSTRAINT [DF_tblTranscription_RequireReportTemplate] DEFAULT ((0)) NOT NULL,
    [RequireCoverLetter]    BIT          CONSTRAINT [DF_tblTranscription_RequireCoverLetter] DEFAULT ((0)) NOT NULL,
    [AllowRequestNextJob]   BIT          NULL,
    [EmailAssignment]       BIT          NULL,
    [Workflow]              INT          NULL,
    [UploadRptWithoutJob]   BIT          NULL,
    [ExportFolderID]        INT          NULL,
    [IsSystem]              BIT          CONSTRAINT [DF_tblTranscription_IsSystem] DEFAULT ((0)) NOT NULL,
    [UseAdditionalDocuments] BIT NULL, 
    CONSTRAINT [PK_tbltranscription] PRIMARY KEY CLUSTERED ([TransCode] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblTranscription_TransCompany]
    ON [dbo].[tblTranscription]([TransCompany] ASC);

