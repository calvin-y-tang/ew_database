CREATE TABLE [dbo].[tblHCAIInsurer] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [InsurerName] VARCHAR (50) NULL,
    [InsurerID]   VARCHAR (50) NULL,
    [BranchName]  VARCHAR (50) NULL,
    [BranchID]    VARCHAR (50) NULL,
    CONSTRAINT [PK_tblHCAIInsurer] PRIMARY KEY CLUSTERED ([ID] ASC)
);

