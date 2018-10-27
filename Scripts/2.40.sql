CREATE TABLE [tblCaseUnknownClient] (
  [CaseNbr] INTEGER NOT NULL,
  [ReferralEmail] VARCHAR(70),
  [Processed] BIT,
  CONSTRAINT [PK_tblCaseUnknownClient] PRIMARY KEY ([CaseNbr])
)
GO

ALTER TABLE [dbo].[tblHCAIControl] ADD [OCF21Version] [varchar] (15) NULL
GO

ALTER TABLE [dbo].[tblHCAIControl] DROP
	COLUMN [LogPath],
	COLUMN [InstallationPath],
	COLUMN [IsLoggingEnabled]
GO


UPDATE tblControl SET DBVersion='2.40'
GO
