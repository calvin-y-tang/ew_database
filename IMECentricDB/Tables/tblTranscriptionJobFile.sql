CREATE TABLE [dbo].[tblTranscriptionJobFile] (
    [TransJobFileID]     INT IDENTITY (1, 1) NOT NULL,
    [TranscriptionJobID] INT NOT NULL, 
    [CaseDocID]          INT NOT NULL,
    [FileType]           VARCHAR (50) NOT NULL,
    [TransFileName]      VARCHAR(200) NULL, 
    CONSTRAINT [PK_tblTranscriptionJobFile] PRIMARY KEY CLUSTERED ([TransJobFileID] ASC)
);
GO


CREATE INDEX [IX_tblTranscriptionJobFile_TranscriptionJobID] ON [dbo].[tblTranscriptionJobFile] ([TranscriptionJobID]);
