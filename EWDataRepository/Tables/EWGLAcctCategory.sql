CREATE TABLE [dbo].[EWGLAcctCategory] (
    [GLAcctCategoryID]     INT          NOT NULL,
    [Name]                 VARCHAR (50) NULL,
    [IncludeOnFlashReport] BIT          NULL,
    CONSTRAINT [PK_EWGLAcctCategory] PRIMARY KEY CLUSTERED ([GLAcctCategoryID] ASC)
);

