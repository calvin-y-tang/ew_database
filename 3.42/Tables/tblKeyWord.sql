CREATE TABLE [dbo].[tblKeyWord] (
    [KeywordID]    INT          IDENTITY (1, 1) NOT NULL,
    [Keyword]      VARCHAR (70) NULL,
    [Status]       VARCHAR (10) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
    [PublishOnWeb] BIT          NULL,
    CONSTRAINT [PK_tblKeyWord] PRIMARY KEY CLUSTERED ([KeywordID] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblKeyWord_Keyword]
    ON [dbo].[tblKeyWord]([Keyword] ASC);

