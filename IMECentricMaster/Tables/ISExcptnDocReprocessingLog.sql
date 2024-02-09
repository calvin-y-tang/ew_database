
CREATE TABLE [dbo].[ISExcptnDocReprocessingLog](
	[ReprocessingLogID] INT             IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
	[MaxTimesRetry]     INT             NULL,
	[AttemptNumber]     INT             NULL,
	[AttemptTime]       SMALLDATETIME   NULL,
	[FileName]          VARCHAR (200)   NULL,
	[ExceptionFolder]   VARCHAR (300)   NULL,
	[InboxFolder]       VARCHAR (300)   NULL,
	[InboxFolderID]     INT             NULL,
    CONSTRAINT [PK_ISExcptnDocReprocessingLog] PRIMARY KEY CLUSTERED ([ReprocessingLogID] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE INDEX [IX_ISExcptnDocReprocessingLog_FileName_InboxFolderID] ON [dbo].[ISExcptnDocReprocessingLog] ([FileName], [InboxFolderID])
