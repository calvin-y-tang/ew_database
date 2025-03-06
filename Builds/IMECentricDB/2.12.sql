
ALTER TABLE [tblEWFolderDef]
  ADD [InfoSecurityTokenID] INTEGER
GO

ALTER TABLE [tblEWFolderDef]
  ADD [MoveSource] BIT
GO

ALTER TABLE [tblEWFolderDef]
  ADD [MoveTarget] BIT
GO

ALTER TABLE [tblEWFolderDef]
  ADD [FolderGroup] VARCHAR(15)
GO

ALTER TABLE [tblEWFolderType]
  ADD [FileManagerNational] BIT
GO

UPDATE tblControl SET DBVersion='2.12'
GO
