CREATE TABLE [dbo].[tblUserActivity] (
    [UserActivityID]  INT          IDENTITY (1, 1) NOT NULL,
    [UserID]          VARCHAR (15) NULL,
    [ActivityType]    VARCHAR (15) NULL,
    [DateAdded]       DATETIME     NOT NULL,
    [WorkstationName] VARCHAR (20) NULL,
    [LogDetail]       TEXT         NULL,
    [AppVersion]      VARCHAR (15) NULL,
    [AutoLogin]       BIT          NULL,
    CONSTRAINT [PK_tblUserActivity] PRIMARY KEY CLUSTERED ([UserActivityID] ASC)
);

