CREATE TABLE [dbo].[InfoCollection] (
    [CollectionID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [Brand]        VARCHAR (5)  NULL,
    [OwnerID]      INT          NULL,
    CONSTRAINT [PK_InfoCollection] PRIMARY KEY CLUSTERED ([CollectionID] ASC)
);

