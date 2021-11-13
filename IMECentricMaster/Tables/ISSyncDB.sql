CREATE TABLE [dbo].[ISSyncDB] (
    [SyncDBID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SyncID]   INT           NOT NULL,
    [Type]     INT           NOT NULL,
    [DBType]   INT           NULL,
    [DBID]     INT           NULL,
    [ConnStr]  VARCHAR (150) NULL,
    [TableMod] VARCHAR (50)  NULL,
    CONSTRAINT [PK_ISSyncDB] PRIMARY KEY CLUSTERED ([SyncDBID] ASC)
);

