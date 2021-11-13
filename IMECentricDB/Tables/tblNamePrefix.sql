CREATE TABLE [dbo].[tblNamePrefix] (
    [sPrefix]        VARCHAR (10) NOT NULL,
    [EWNamePrefixID] INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_tblNamePrefix] PRIMARY KEY CLUSTERED ([EWNamePrefixID] ASC)
);

