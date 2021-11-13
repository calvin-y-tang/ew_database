CREATE TABLE [dbo].[tblClientDefDocument] (
    [ClientCode]        INT          NOT NULL,
    [DocumentCode]      VARCHAR (15) NOT NULL,
    [DocumentQueue]     INT          NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (20) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (20) NULL,
    [DocumentToReplace] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblClientDefDocument] PRIMARY KEY CLUSTERED ([ClientCode] ASC, [DocumentCode] ASC, [DocumentQueue] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblClientDefDocument_ClientCodeDocumentqueueDocumentToReplace]
    ON [dbo].[tblClientDefDocument]([ClientCode] ASC, [DocumentQueue] ASC, [DocumentToReplace] ASC) WHERE ([DocumentToReplace] IS NOT NULL);

