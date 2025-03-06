
----------------------------------------------------------------------------
--Add Identity column to tblUser for easier locating record
----------------------------------------------------------------------------

ALTER TABLE [tblUser]
  ADD [SeqNo] INTEGER IDENTITY(1,1) NOT NULL
GO



update tblControl set DBVersion='1.33'
GO