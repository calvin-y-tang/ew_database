CREATE TABLE [dbo].[TransReportFile] (
    [TransReportFileID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [JobID]             VARCHAR (20) NULL,
    [DictationSentDate] DATETIME     NULL,
    [CompletedDate]     DATETIME     NULL,
    [RptSentDate]       DATETIME     NULL,
    [RptReceivedDate]   DATETIME     NULL,
    [InvoiceDate]       DATETIME     NULL,
    [InvoiceAmountAU]   MONEY        NULL,
    [SourceID]          INT          NULL,
    [DBID]              INT          NULL,
    CONSTRAINT [PK_TransReportFile] PRIMARY KEY CLUSTERED ([TransReportFileID] ASC)
);

