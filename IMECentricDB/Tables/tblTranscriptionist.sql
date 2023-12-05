CREATE TABLE [dbo].[tblTranscriptionist] (
	[TranscriptionistID] INT          IDENTITY(1,1) NOT NULL,
	[FirstName]          VARCHAR (50) NULL,
	[LastName]           VARCHAR (50) NULL,
	[Email]              VARCHAR (70) NULL,
	[Status]             VARCHAR (10) CONSTRAINT [DF_tblTranscriptionist_Status] DEFAULT ('Active') NULL,
	[DateAdded]          DATETIME     NULL,
	[DateEdited]         DATETIME     NULL,
	[UserIDAdded]        VARCHAR (15) NULL,
	[UserIDEdited]       VARCHAR (15) NULL,
	[TransCode]          INT          NULL,
    CONSTRAINT [PK_tblTranscriptionist] PRIMARY KEY CLUSTERED ([TranscriptionistID] ASC) WITH (FILLFACTOR = 90),
	CONSTRAINT [FK_tblTranscriptionist_tblTranscription] FOREIGN KEY ([TransCode]) REFERENCES [dbo].[tblTranscription] ([TransCode])
);


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionist_Email]
    ON [dbo].[tblTranscriptionist]([Email] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionist_TranscriptionistID]
    ON [dbo].tblTranscriptionist(TranscriptionistID ASC);

GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionist_TransCode]
    ON [dbo].[tblTranscriptionist](TransCode ASC);

