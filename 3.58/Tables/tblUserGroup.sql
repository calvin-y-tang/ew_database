CREATE TABLE [dbo].[tblUserGroup] (
    [GroupCode] VARCHAR (15) NOT NULL,
    [GroupDesc] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblUserGroup] PRIMARY KEY CLUSTERED ([GroupCode] ASC)
);

