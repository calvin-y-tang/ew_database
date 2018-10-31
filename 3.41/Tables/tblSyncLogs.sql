CREATE TABLE [dbo].[tblSyncLogs] (
    [SyncLogID]          INT          IDENTITY (1000, 1) NOT NULL,
    [Log_DateAdded]      DATETIME     CONSTRAINT [DF_tblSyncLogs_Log_DateAdded] DEFAULT (getdate()) NOT NULL,
    [Log_Severity]       INT          NOT NULL,
    [Log_RelatedID]      INT          NULL,
    [Log_Message]        TEXT         NOT NULL,
    [Log_Resolved]       BIT          CONSTRAINT [DF_tblSyncLogs_Log_Resolved] DEFAULT ((0)) NOT NULL,
    [Log_ResolvedUserID] VARCHAR (50) NULL,
    [Log_ResolvedDate]   DATETIME     NULL,
    CONSTRAINT [PK_tblSyncLogs] PRIMARY KEY CLUSTERED ([SyncLogID] ASC)
);

