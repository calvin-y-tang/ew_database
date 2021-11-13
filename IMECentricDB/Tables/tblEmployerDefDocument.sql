CREATE TABLE [dbo].[tblEmployerDefDocument]
(
    [EmployerID]        INT          NOT NULL,
    [DocumentCode]      VARCHAR (15) NOT NULL,
    [DocumentQueue]     INT          NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (20) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (20) NULL,
    [DocumentToReplace] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblEmployerDefDocument] PRIMARY KEY CLUSTERED ([EmployerID] ASC, [DocumentCode] ASC, [Documentqueue] ASC)
);

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEmployerDefDocument_EmployerIDDocumentQueueDocumentToReplace]
    ON [dbo].[tblEmployerDefDocument]([EmployerID] ASC, [DocumentQueue] ASC, [DocumentToReplace] ASC) WHERE ([DocumentToReplace] IS NOT NULL);

