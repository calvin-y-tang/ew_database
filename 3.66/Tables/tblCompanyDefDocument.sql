CREATE TABLE [dbo].[tblCompanyDefDocument] (
    [CompanyCode]       INT          NOT NULL,
    [DocumentCode]      VARCHAR (15) NOT NULL,
    [Documentqueue]     INT          NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (20) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (20) NULL,
    [DocumentToReplace] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCompanyDefDocument] PRIMARY KEY CLUSTERED ([CompanyCode] ASC, [DocumentCode] ASC, [Documentqueue] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblCompanyDefDocument_CompanyCodeDocumentqueueDocumentToReplace]
    ON [dbo].[tblCompanyDefDocument]([CompanyCode] ASC, [Documentqueue] ASC, [DocumentToReplace] ASC) WHERE ([DocumentToReplace] IS NOT NULL);

