CREATE TABLE [dbo].[InfoIssueCollection] (
    [IssueID]      INT NOT NULL,
    [CollectionID] INT NOT NULL,
    CONSTRAINT [PK_InfoIssueCollection] PRIMARY KEY CLUSTERED ([IssueID] ASC, [CollectionID] ASC) WITH (FILLFACTOR = 90)
);

