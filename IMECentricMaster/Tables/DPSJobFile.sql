CREATE TABLE [dbo].[DPSJobFile] (
    [DPSJobFileID]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [JobID]              VARCHAR (50) NULL,
    [RequestedDate]      DATETIME     NULL,
    [CompletedDate]      DATETIME     NULL,
    [ResultSentDate]     DATETIME     NULL,
    [ResultReceivedDate] DATETIME     NULL,
    [InvoiceDate]        DATETIME     NULL,
    [InvoiceAmountAU]    MONEY        NULL,
    [SourceID]           INT          NULL,
    [DBID]               INT          NULL,
    [JobTrackingID]      BIGINT       NULL,
    [Command]            VARCHAR (10) NULL,
    [CancelDate]         DATETIME     NULL,
    [CancelledDate]      DATETIME     NULL,
    CONSTRAINT [PK_DPSJobFile] PRIMARY KEY CLUSTERED ([DPSJobFileID] ASC)
);

