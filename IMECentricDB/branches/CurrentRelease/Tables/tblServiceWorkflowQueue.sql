CREATE TABLE [dbo].[tblServiceWorkflowQueue] (
    [ServiceWorkflowQueueID] INT          IDENTITY (1, 1) NOT NULL,
    [ServiceWorkflowID]      INT          NOT NULL,
    [DateAdded]              DATETIME     NULL,
    [DateEdited]             DATETIME     NULL,
    [UserIDAdded]            VARCHAR (20) NULL,
    [UserIDEdited]           VARCHAR (20) NULL,
    [QueueOrder]             INT          NOT NULL,
    [StatusCode]             INT          NOT NULL,
    [NextStatus]             INT          NOT NULL,
    [CreateVoucher]          BIT          CONSTRAINT [DF_tblServiceWorkflowQueue_CreateVoucher] DEFAULT ((0)) NOT NULL,
    [CreateInvoice]          BIT          CONSTRAINT [DF_tblServiceWorkflowQueue_CreateInvoice] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblServiceWorkflowQueue] PRIMARY KEY CLUSTERED ([ServiceWorkflowQueueID] ASC)
);


GO

CREATE INDEX [IX_tblServiceWorkflowQueue_ServiceWorkflowIDStatusCodeNextStatus] ON [dbo].[tblServiceWorkflowQueue] ([ServiceWorkflowID], [StatusCode], [NextStatus]) INCLUDE (QueueOrder, CreateInvoice, CreateVoucher);
