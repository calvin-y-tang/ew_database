CREATE TABLE [dbo].[tblCaseRelatedParty] (
    [CaseRPID]    INT IDENTITY (1, 1) NOT NULL,
    [CaseNbr]     INT NULL,
    [RPCode]      INT NULL,
    [CompanyCode] INT NULL,
    CONSTRAINT [PK_tblCaseRelatedParty] PRIMARY KEY CLUSTERED ([CaseRPID] ASC)
);

