CREATE TABLE [dbo].[SedgwickServiceRequestQueue] (
    [Id]                   INT            IDENTITY (1, 1) NOT NULL,
    [ServiceType]          VARCHAR (16)   NOT NULL,
    [UniqueRecordId]       VARCHAR (64)   NOT NULL,
    [ServiceParams]        VARCHAR (1024) NULL,
    [Status]               VARCHAR (32)   NULL,
    [LastErrorMessage]     VARCHAR (MAX)  NULL,
    [LastRequestDateTime]  DATETIME       NULL,
    [AddedDateTime]        DATETIME       NOT NULL,
    [TotalRequestAttempts] INT            NULL,
    CONSTRAINT [PK_SedgwickServiceRequestQueue] PRIMARY KEY CLUSTERED ([Id] ASC)
);










GO
CREATE NONCLUSTERED INDEX [IX_SedgwickServiceRequestQueue_UniqueRecordId]
    ON [dbo].[SedgwickServiceRequestQueue]([UniqueRecordId] ASC) WITH (FILLFACTOR = 100);


GO
CREATE NONCLUSTERED INDEX [IX_SedgwickServiceRequestQueue_TotalRequestAttempts]
    ON [dbo].[SedgwickServiceRequestQueue]([TotalRequestAttempts] ASC);

