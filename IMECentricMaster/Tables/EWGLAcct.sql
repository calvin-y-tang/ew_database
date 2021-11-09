CREATE TABLE [dbo].[EWGLAcct] (
    [GLNaturalAcct]    VARCHAR (5) NOT NULL,
    [GLAcctCategoryID] INT         NULL,
    CONSTRAINT [PK_EWGLAcct] PRIMARY KEY CLUSTERED ([GLNaturalAcct] ASC)
);

