ALTER TABLE tblEWFacility ALTER COLUMN [State] [varchar] (3) 
ALTER TABLE tblEWFacility ALTER COLUMN [RemitState] [varchar] (3)
GO


ALTER TABLE [tblTranscriptionJob]
  ADD [OriginalFileName] VARCHAR(100)
GO

UPDATE tblControl SET DBVersion='1.86'
GO
