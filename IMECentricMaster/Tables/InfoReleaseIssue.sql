CREATE TABLE [dbo].[InfoReleaseIssue] (
    [ReleaseIssueID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ReleaseID]      INT          NULL,
    [IssueID]        INT          NULL,
    [ReleaseStatus]  VARCHAR (10) NULL,
    CONSTRAINT [PK_InfoReleaseIssue] PRIMARY KEY CLUSTERED ([ReleaseIssueID] ASC)
);

