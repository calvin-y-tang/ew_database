CREATE TABLE [dbo].[InfoRelease] (
    [ReleaseID]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Product]           VARCHAR (30)  NULL,
    [Name]              VARCHAR (30)  NULL,
    [Status]            VARCHAR (20)  NULL,
    [TargetDevDate]     DATETIME      NULL,
    [TargetReleaseDate] DATETIME      NULL,
    [Version]           VARCHAR (15)  NULL,
    [ActualReleaseDate] DATETIME      NULL,
    [ReleaseNotes]      VARCHAR (MAX) NULL,
    [DeployedByID]      INT           NULL,
    CONSTRAINT [PK_InfoRelease] PRIMARY KEY CLUSTERED ([ReleaseID] ASC)
);

