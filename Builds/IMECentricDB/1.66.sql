
ALTER TABLE [tblEWWebUser]
  ADD [DisplayClient] BIT DEFAULT 1 NOT NULL
GO


UPDATE tblControl SET DBVersion='1.66'
GO
