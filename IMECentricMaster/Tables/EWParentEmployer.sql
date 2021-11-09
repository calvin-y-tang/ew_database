CREATE TABLE [dbo].[EWParentEmployer] (
    [EWParentEmployerID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ParentEmployer]     VARCHAR (70) NOT NULL,
    CONSTRAINT [PK_EWParentEmployer] PRIMARY KEY CLUSTERED ([EWParentEmployerID] ASC)
);

