CREATE TABLE [dbo].[InfoLogUsage] (
    [LogUsageID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]     INT          NULL,
    [DateAdded]  DATETIME     NULL,
    [ModuleName] VARCHAR (50) NULL,
    [LogDetail]  TEXT         NULL,
    [Simulated]  BIT          NULL,
    [RealUserID] INT          NULL,
    CONSTRAINT [PK_InfoLogUsage] PRIMARY KEY CLUSTERED ([LogUsageID] ASC)
);

