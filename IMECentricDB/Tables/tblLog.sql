CREATE TABLE [dbo].[tblLog]
(
	[LogID]        INT           IDENTITY (1, 1) NOT NULL,
	[LogDateTime]  DATETIME      NOT NULL,
    [Severity]     INT           NOT NULL,
    [ModuleName]   VARCHAR(50)   NOT NULL,
    [Message]      VARCHAR(1024) NULL,
    [ErrorMessage] VARCHAR(2048) NULL,
    [StackTrace]   VARCHAR(MAX)  NULL,
    [UserID]       VARCHAR(20)   NULL, 
    [SessionID]    VARCHAR(50)   NULL,
    CONSTRAINT [PK_tblLog] PRIMARY KEY CLUSTERED ([LogID] ASC)
)
GO
CREATE INDEX [IX_tblLogID_LogDateTime] ON [dbo].[tblLog] ([LogDateTime])
GO
CREATE INDEX [IX_tblLogID_ModuleName] ON [dbo].[tblLog] ([ModuleName])
GO
