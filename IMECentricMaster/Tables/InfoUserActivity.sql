CREATE TABLE [dbo].[InfoUserActivity] (
    [UserActivityID]  INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]          INT           NULL,
    [ActivityType]    VARCHAR (15)  NULL,
    [DateAdded]       DATETIME      CONSTRAINT [DF_InfoUserActivity_DateAdded] DEFAULT (getdate()) NULL,
    [WorkstationName] VARCHAR (20)  NULL,
    [LogDetail]       VARCHAR (MAX) NULL,
    [AppName]         VARCHAR (20)  NULL,
    [AppVersion]      VARCHAR (15)  NULL,
    CONSTRAINT [PK_InfoUserActivity] PRIMARY KEY CLUSTERED ([UserActivityID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_InfoUserActivity_UserID]
    ON [dbo].[InfoUserActivity]([UserID] ASC) WITH (FILLFACTOR = 90);

