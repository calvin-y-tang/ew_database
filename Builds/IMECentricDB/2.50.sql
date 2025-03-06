ALTER TABLE [tblTranscription]
  ADD [ExportFolderID] INTEGER
GO

ALTER TABLE [tblTranscription]
  ADD [IsSystem] BIT DEFAULT 0 NOT NULL
GO

UPDATE tblControl SET DBVersion='2.50'
GO
