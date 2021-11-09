CREATE TABLE [dbo].[ISServiceLog] (
    [ServiceLogID]     INT           IDENTITY (1, 1) NOT NULL,
    [LogDate]          DATETIME      NULL,
    [Severity]         INT           NULL,
    [ModuleName]       VARCHAR (50)  NULL,
    [ProcessName]      VARCHAR (50)  NULL,
    [ProcessID]        VARCHAR (50)  NULL,
    [Message]          VARCHAR (200) NULL,
    [ErrorMessage]     VARCHAR (200) NULL,
    [StackTrace]       VARCHAR (MAX) NULL,
    [WCFInstanceCount] INT           NULL,
    [WCFThreadCount]   INT           NULL,
    [Username]         VARCHAR (50)  NULL,
    [WorkstationName]  VARCHAR (25)  NULL,
    [IP]               VARCHAR (15)  NULL,
    CONSTRAINT [PK_ISServiceLog] PRIMARY KEY CLUSTERED ([ServiceLogID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_ISServiceLog_LogDateModuleNameProcessName]
    ON [dbo].[ISServiceLog]([LogDate] ASC, [ModuleName] ASC, [ProcessName] ASC);

