CREATE TABLE [dbo].[tblIssue] (
    [IssueCode]    INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [Instruction]  TEXT         NULL,
    [Status]       VARCHAR (10) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (15) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (15) NULL,
    [PublishOnWeb] BIT          NULL,
    [WebSynchDate] DATETIME     NULL,
    [WebID]        INT          NULL,
    [Bookmark]     VARCHAR (30) NULL,
    CONSTRAINT [PK_tblIssue] PRIMARY KEY CLUSTERED ([IssueCode] ASC)
);

