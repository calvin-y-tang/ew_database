CREATE TABLE [dbo].[ISSVNBranch] (
    [SVNBranchID] INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]        VARCHAR (20)  NULL,
    [Path]        VARCHAR (200) NULL,
    [Major]       INT           NOT NULL,
    [Minor]       INT           NOT NULL,
    [Release]     INT           NOT NULL,
    CONSTRAINT [PK_ISSVNBranch] PRIMARY KEY CLUSTERED ([SVNBranchID] ASC)
);

