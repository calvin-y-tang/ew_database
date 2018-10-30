CREATE TABLE [dbo].[tblTranscriptionJobDictation] (
    [TranscriptionJobDictationID] INT           IDENTITY (1, 1) NOT NULL,
    [TranscriptionJobID]          INT           NOT NULL,
    [DateAdded]                   DATETIME      NULL,
    [DateEdited]                  DATETIME      NULL,
    [UserIDAdded]                 VARCHAR (20)  NULL,
    [UserIDEdited]                VARCHAR (20)  NULL,
    [DictationFile]               VARCHAR (100) NULL,
    [OriginalFileName]            VARCHAR (100) NULL,
    [DictationDownloaded]         BIT           NOT NULL,
    [IntegrationID]               INT           NULL,
    [SeqNo]                       INT           NOT NULL,
    CONSTRAINT [PK_tblTranscriptionJobDictation] PRIMARY KEY CLUSTERED ([TranscriptionJobDictationID] ASC)
);

