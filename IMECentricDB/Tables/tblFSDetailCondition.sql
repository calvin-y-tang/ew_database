CREATE TABLE [dbo].[tblFSDetailCondition]
(
	[FSDetailConditionID] INT IDENTITY (1, 1) NOT NULL,
	[FSDetailID]          INT NOT NULL,
	[ConditionTable]      VARCHAR(30) NOT NULL,
	[ConditionKey]        INT         NULL,
	[ConditionValue]      VARCHAR(50) NULL, 
	CONSTRAINT [PK_tblFSDetailCondition] PRIMARY KEY CLUSTERED ([FSDetailConditionID] ASC)
)

-- TODOJP: Do we need to create the UNIQUE INDEX CONSTRAINT? (Noticed it was not present in IMECEW).
