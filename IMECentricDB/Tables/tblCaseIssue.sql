CREATE TABLE [dbo].[tblCaseIssue] (
    [CaseNbr]     INT          NOT NULL,
    [IssueCode]   INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblcaseissue] PRIMARY KEY CLUSTERED ([CaseNbr] ASC, [IssueCode] ASC)
);

