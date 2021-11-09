CREATE TABLE [dbo].[InfoBurndown] (
    [CollectionID] INT          NOT NULL,
    [IssueID]      INT          NOT NULL,
    [DateAdded]    DATETIME     NOT NULL,
    [Status]       VARCHAR (20) NULL,
    [Est]          REAL         NOT NULL,
    [Remaining]    REAL         NOT NULL,
    [AssignedTo]   VARCHAR (50) NULL,
    CONSTRAINT [PK_InfoBurndown] PRIMARY KEY CLUSTERED ([CollectionID] ASC, [IssueID] ASC, [DateAdded] ASC)
);

