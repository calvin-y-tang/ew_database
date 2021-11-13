CREATE TABLE [dbo].[tblEWGLAcct] (
    [GLNaturalAcct]    VARCHAR (5) NOT NULL,
    [GLAcctCategoryID] INT         NULL,
    CONSTRAINT [PK_tblEWGLAcct] PRIMARY KEY CLUSTERED ([GLNaturalAcct] ASC)
);

