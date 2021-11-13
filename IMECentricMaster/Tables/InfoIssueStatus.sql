CREATE TABLE [dbo].[InfoIssueStatus] (
    [Status] VARCHAR (20) NOT NULL,
    [SeqNo]  INT          NULL,
    CONSTRAINT [PK_InfoIssueStatus] PRIMARY KEY CLUSTERED ([Status] ASC)
);

