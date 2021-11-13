CREATE TABLE [dbo].[tblEWGLAcctCategory] (
    [GLAcctCategoryID]     INT          NOT NULL,
    [Name]                 VARCHAR (50) NULL,
    [IncludeOnFlashReport] BIT          NULL,
    CONSTRAINT [PK_tblEWGLAcctCategory] PRIMARY KEY CLUSTERED ([GLAcctCategoryID] ASC)
);

