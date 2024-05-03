CREATE TABLE [dbo].[InfoLauncher] (
    [LauncherID]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SeqNo]              INT          NULL,
    [AppName]            VARCHAR (40) NULL,
    [AppType]            VARCHAR (20) NULL,
    [NewVersionDir]      VARCHAR (256) NULL,
    [AppSubDir]          VARCHAR (40) NULL,
    [MasterServerName]   VARCHAR (40) NULL,
    [MasterInstanceName] VARCHAR (40) NULL,
    [DBID]               INT          NULL,
    CONSTRAINT [PK_InfoLauncher] PRIMARY KEY CLUSTERED ([LauncherID] ASC)
);

