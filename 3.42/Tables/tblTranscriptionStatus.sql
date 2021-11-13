CREATE TABLE [dbo].[tblTranscriptionStatus] (
    [TranscriptionStatusCode] INT          IDENTITY (1, 1) NOT NULL,
    [Descrip]                 VARCHAR (15) NULL,
    CONSTRAINT [PK_tblTranscriptionStatus] PRIMARY KEY CLUSTERED ([TranscriptionStatusCode] ASC)
);

