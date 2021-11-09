CREATE TABLE [dbo].[EWNamePrefix] (
    [EWNamePrefixID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [sPrefix]        VARCHAR (10) NULL,
    CONSTRAINT [PK_EWNamePrefix] PRIMARY KEY CLUSTERED ([EWNamePrefixID] ASC)
);

