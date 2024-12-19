CREATE TABLE [dbo].[tblCaseHistoryOverrides] (
    [ID]            INT      IDENTITY (1, 1) NOT NULL,
    [CaseHistoryID] INT      NOT NULL,
    CONSTRAINT [PK_tblCaseHistoryOverrides] PRIMARY KEY ([ID])
);

