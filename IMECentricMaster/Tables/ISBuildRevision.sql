CREATE TABLE [dbo].[ISBuildRevision] (
    [BuildRevisionID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BuildID]         INT           NOT NULL,
    [Revision]        INT           NOT NULL,
    [IssueID]         INT           NULL,
    [Details]         VARCHAR (MAX) NULL,
    CONSTRAINT [PK_ISBuildRevision] PRIMARY KEY CLUSTERED ([BuildRevisionID] ASC)
);

