CREATE TABLE [dbo].[tblMessageToken] (
    [MessageTokenID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]           VARCHAR (30) NULL,
    [Description]    VARCHAR (50) NULL,
    CONSTRAINT [PK_tblMessageToken] PRIMARY KEY CLUSTERED ([MessageTokenID] ASC)
);

