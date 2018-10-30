CREATE TABLE [dbo].[tblCaseIssueQuestion] (
    [CaseIssueQuestionID] INT          IDENTITY (1, 1) NOT NULL,
    [CaseNbr]             INT          NOT NULL,
    [IssueQuestionID]     INT          NOT NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCaseIssueQuestion] PRIMARY KEY CLUSTERED ([CaseIssueQuestionID] ASC)
);



