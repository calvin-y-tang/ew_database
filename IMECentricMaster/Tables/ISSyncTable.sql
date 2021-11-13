CREATE TABLE [dbo].[ISSyncTable] (
    [SyncID]   INT          NOT NULL,
    [TableID]  INT          NOT NULL,
    [TableMod] VARCHAR (50) NULL,
    CONSTRAINT [PK_ISSyncTable] PRIMARY KEY CLUSTERED ([SyncID] ASC, [TableID] ASC)
);

