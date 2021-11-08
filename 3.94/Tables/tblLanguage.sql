CREATE TABLE [dbo].[tblLanguage] (
    [LanguageID]  INT          IDENTITY (1, 1) NOT NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblLanguage] PRIMARY KEY CLUSTERED ([LanguageID] ASC)
);

