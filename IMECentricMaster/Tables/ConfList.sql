CREATE TABLE [dbo].[ConfList] (
    [PrimaryKey]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ExtConfirmationID]    VARCHAR (64)   NULL,
    [DBID]                 INT            NOT NULL,
    [ConfirmatonListID]    INT            NOT NULL,
    [CallerPhone]          VARCHAR (15)   NULL,
    [TransferPhone]        VARCHAR (15)   NULL,
    [DateSent]             DATETIME       NULL,
    [InitialMessageKey]    VARCHAR (30)   NULL,
    [LastMessageKeyPlayed] VARCHAR (30)   NULL,
    [DateLastResponded]    DATETIME       NULL,
    [DateResult]           DATETIME       NULL,
    [ResultParam]          VARCHAR (1024) NULL,
    [ReturnValue]          VARCHAR (30)   NULL,
    [DateImported]         DATETIME       NULL,
    [LastCallStatus]       VARCHAR (32)   NULL,
    [Brand]                CHAR (4)       NULL,
    [CallToPhone]          VARCHAR (15)   NULL,
    CONSTRAINT [PK_ConfList] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_ConfList_ExtConfirmationID]
    ON [dbo].[ConfList]([ExtConfirmationID] ASC) WHERE ([ExtConfirmationID] IS NOT NULL) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_ConfList_DBIDDateResultDateImportedConfirmatonListID]
    ON [dbo].[ConfList]([DBID] ASC, [DateResult] ASC, [DateImported] ASC, [ConfirmatonListID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ConfList_DBIDConfirmatonListID]
    ON [dbo].[ConfList]([DBID] ASC, [ConfirmatonListID] ASC) WITH (FILLFACTOR = 90);

