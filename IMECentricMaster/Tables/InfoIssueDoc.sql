CREATE TABLE [dbo].[InfoIssueDoc] (
    [InfoIssueDocID]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IssueID]          INT           NULL,
    [Description]      VARCHAR (70)  NULL,
    [Filename]         VARCHAR (128) NULL,
    [FileType]         INT           NULL,
    [DateAdded]        DATETIME      NULL,
    [DateEdited]       DATETIME      NULL,
    [UserAdded]        INT           NULL,
    [UserEdited]       INT           NULL,
    [CheckedOut]       BIT           NULL,
    [CheckedOutUserID] INT           NULL,
    [CheckedOutFolder] VARCHAR (256) NULL,
    CONSTRAINT [PK_InfoIssueDoc] PRIMARY KEY CLUSTERED ([InfoIssueDocID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_InfoIssueDoc_IssueID]
    ON [dbo].[InfoIssueDoc]([IssueID] ASC) WITH (FILLFACTOR = 90);

