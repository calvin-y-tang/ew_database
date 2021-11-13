CREATE TABLE [dbo].[EWParentCompanyNetwork] (
    [ParentCompanyID] INT NOT NULL,
    [NetworkID]       INT NOT NULL,
    CONSTRAINT [PK_EWParentCompanyNetwork] PRIMARY KEY CLUSTERED ([ParentCompanyID] ASC, [NetworkID] ASC)
);

