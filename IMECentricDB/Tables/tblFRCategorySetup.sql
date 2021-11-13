CREATE TABLE [dbo].[tblFRCategorySetup] (
    [FRCategorySetupID] INT IDENTITY (1, 1) NOT NULL,
    [ProductCode]       INT NOT NULL,
    [CaseType]          INT NULL,
    [EWFlashCategoryID] INT NULL,
    CONSTRAINT [PK_tblFRCategorySetup] PRIMARY KEY CLUSTERED ([FRCategorySetupID] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblFRCategorySetup_ProductCodeCaseType]
    ON [dbo].[tblFRCategorySetup]([ProductCode] ASC, [CaseType] ASC);

