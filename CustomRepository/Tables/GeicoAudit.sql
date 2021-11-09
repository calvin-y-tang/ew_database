CREATE TABLE [dbo].[GeicoAudit] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [LogDateTime]   DATETIME       NOT NULL,
    [UserId]        INT            NOT NULL,
    [Note]          VARCHAR (4096) NOT NULL,
    [ActionType]    TINYINT        NOT NULL,
    [TableName]     VARCHAR (64)   NULL,
    [TableRecordId] INT            NULL,
    CONSTRAINT [PK_GeicoAudit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_GeicoAudit_GeicoUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[GeicoUser] ([Id])
);

