CREATE TABLE [dbo].[ISBuild] (
    [BuildID]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SVNBranchID]  INT           NOT NULL,
    [RevisionFrom] INT           NOT NULL,
    [RevisionTo]   INT           NOT NULL,
    [Version]      VARCHAR (15)  NULL,
    [BuildNumber]  INT           NOT NULL,
    [ReleaseDate]  SMALLDATETIME NOT NULL,
    [Note]         VARCHAR (100) NULL,
    CONSTRAINT [PK_ISBuild] PRIMARY KEY CLUSTERED ([BuildID] ASC) WITH (FILLFACTOR = 90)
);

