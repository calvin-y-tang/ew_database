CREATE TABLE [dbo].[tblFRCategory] (
    [CaseType]          INT          NOT NULL,
    [ProductCode]       INT          NOT NULL,
    [FRCategory]        VARCHAR (25) NULL,
    [EWFlashCategoryID] INT          NULL,
    [FRCategorySetupID] INT          NULL,
    CONSTRAINT [PK_tblFRCategory] PRIMARY KEY CLUSTERED ([CaseType] ASC, [ProductCode] ASC)
);

