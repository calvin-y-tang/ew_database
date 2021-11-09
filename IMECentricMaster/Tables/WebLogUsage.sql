CREATE TABLE [dbo].[WebLogUsage] (
    [WebLogUsageID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [DateAdded]     DATETIME      NULL,
    [ModuleName]    VARCHAR (100) NULL,
    [LogDetail]     VARCHAR (MAX) NULL,
    [Severity]      INT           NOT NULL,
    [DBID]          INT           NULL,
    [UserID]        VARCHAR (35)  NULL,
    CONSTRAINT [PK_WebLogUsage] PRIMARY KEY CLUSTERED ([WebLogUsageID] ASC)
);

