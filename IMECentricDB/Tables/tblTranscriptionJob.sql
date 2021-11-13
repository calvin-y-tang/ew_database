CREATE TABLE [dbo].[tblTranscriptionJob] (
    [TranscriptionJobID]      INT           IDENTITY (1, 1) NOT NULL,
    [TranscriptionStatusCode] INT           NOT NULL,
    [DateAdded]               DATETIME      NULL,
    [DateEdited]              DATETIME      NULL,
    [UserIDEdited]            VARCHAR (20)  NULL,
    [CaseNbr]                 INT           NULL,
    [ReportTemplate]          VARCHAR (15)  NULL,
    [CoverLetterFile]         VARCHAR (100) NULL,
    [TransCode]               INT           NULL,
    [DateAssigned]            DATETIME      NULL,
    [ReportFile]              VARCHAR (100) NULL,
    [DateRptReceived]         DATETIME      NULL,
    [DateCompleted]           DATETIME      NULL,
    [LastStatusChg]           DATETIME      NULL,
    [DateTranscribingStart]   DATETIME      NULL,
    [DateCanceled]            DATETIME      NULL,
    [InternalTransTAT]        INT           NULL,
    [ReportLines]             INT           NULL,
    [ReportWords]             INT           NULL,
    [EWTransDeptID]           INT           NULL,
    [CoverLetterDownloaded]   BIT           NULL,
    [ReportDownloaded]        BIT           NULL,
    [Workflow]                INT           NULL,
    [OriginalRptFileName]     VARCHAR (100) NULL,
    [Notes]                   VARCHAR (100) NULL,
    [TranscriptionJobNbr]     INT           CONSTRAINT [DF_tblTranscriptionJob_TranscriptionJobNbr] DEFAULT ((0)) NOT NULL,
    [FolderID]                INT           NULL,
    [SubFolder]               VARCHAR (32)  NULL,
    CONSTRAINT [PK_tblTranscriptionJob] PRIMARY KEY CLUSTERED ([TranscriptionJobID] ASC)
);






GO



GO



GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_TransCode]
    ON [dbo].[tblTranscriptionJob]([TransCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_CaseNbr]
    ON [dbo].[tblTranscriptionJob]([CaseNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_TranscriptionStatusCodeWorkflow]
    ON [dbo].[tblTranscriptionJob]([TranscriptionStatusCode] ASC, [Workflow] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_EWTransDeptID]
    ON [dbo].[tblTranscriptionJob]([EWTransDeptID] ASC);

