CREATE TABLE [dbo].[tblDebugLog] (
    [SessionID]      VARCHAR (50)  NOT NULL,
    [ModuleName]     VARCHAR (50)  NULL,
    [DateAdded]      DATETIME      NULL,
    [UserID]         VARCHAR (50)  NULL,
    [DebugMessage]   VARCHAR (200) NULL,
    [PrimaryKey]     INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblDebugLog] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);
