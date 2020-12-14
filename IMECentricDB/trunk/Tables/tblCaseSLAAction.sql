CREATE TABLE [dbo].[tblCaseSLAAction]
(
	[CaseSLAActionID] INT NOT NULL PRIMARY KEY IDENTITY, 
    [CaseSLARuleDetailID] INT NOT NULL, 
    [DateAdded] DATETIME NOT NULL, 
    [UserIDAdded] VARCHAR(15) NULL, 
    [SLAActionID] INT NOT NULL, 
    [Comment] VARCHAR(100) NULL, 
    [ForDSE] BIT NOT NULL DEFAULT (1)
)

GO

CREATE INDEX [IX_tblCaseSLAAction_CaseSLARuleDetailID] ON [dbo].[tblCaseSLAAction] ([CaseSLARuleDetailID])
GO

