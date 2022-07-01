CREATE TABLE [dbo].[tblFSDetailCondition]
(
	[FSDetailConditionID] INT IDENTITY (1, 1) NOT NULL,
	[FSDetailID]          INT NOT NULL,
	[ConditionTable]      VARCHAR(30) NOT NULL,
	[ConditionKey]        INT         NULL,
	[ConditionValue]      VARCHAR(50) NULL, 
	CONSTRAINT [PK_tblFSDetailCondition] PRIMARY KEY CLUSTERED ([FSDetailConditionID] ASC)
)

GO
CREATE INDEX [IX_tblFSDetailCondition_Includes] ON [tblFSDetailCondition] ([FSDetailID], [ConditionTable])  INCLUDE ([ConditionKey]) WITH (FILLFACTOR=100);
GO
