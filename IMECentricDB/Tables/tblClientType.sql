CREATE TABLE [dbo].[tblClientType] (
    [TypeCode]     INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (20) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (20) NULL,
    CONSTRAINT [PK_tblClientType] PRIMARY KEY CLUSTERED ([TypeCode] ASC)
);

