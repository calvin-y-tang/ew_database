CREATE TABLE [dbo].[tblTerms] (
    [TermsCode]    INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (50) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblTerms] PRIMARY KEY CLUSTERED ([TermsCode] ASC)
);

