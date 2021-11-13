CREATE TABLE [dbo].[tblICDCode] (
    [Code]        VARCHAR (50)  NOT NULL,
    [Description] VARCHAR (300) NULL,
    [DateAdded]   DATETIME      NULL,
    [UserIDAdded] VARCHAR (30)  NULL,
    [ICDFormat]   INT           NOT NULL,
    [CountryID]   INT           NULL,
    CONSTRAINT [PK_tblICDCode] PRIMARY KEY CLUSTERED ([ICDFormat] ASC, [Code] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblICDCode_Description]
    ON [dbo].[tblICDCode]([Description] ASC);

