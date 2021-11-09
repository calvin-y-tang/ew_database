CREATE TABLE [dbo].[GeicoCancelExpert] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [UniqueRecordsIDs]   VARCHAR (2048) NULL,
    [CancellationReason] VARCHAR (100)  NULL,
    [InvoiceNumber]      VARCHAR (30)   NULL,
    [UserId]             INT            NULL,
    [Notes]              VARCHAR (2048) NULL,
    [DateAssigned]       DATETIME       NULL,
    [DateReceived]       DATETIME       NULL,
    [Status]             TINYINT        NULL,
    [DateCompleted]      DATETIME       NULL,
    [RequestContextId]   INT            NOT NULL,
    CONSTRAINT [PK_GeicoCancelExpert] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_GeicoCancelExpert_GeicoRequestContext] FOREIGN KEY ([RequestContextId]) REFERENCES [dbo].[GeicoRequestContext] ([Id]),
    CONSTRAINT [FK_GeicoCancelExpert_GeicoUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[GeicoUser] ([Id])
);

