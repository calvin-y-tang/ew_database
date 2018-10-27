CREATE TABLE [tblEWFeeZone] (
  [EWFeeZoneID] INTEGER NOT NULL,
  [Name] VARCHAR(30),
  [Status] VARCHAR(10),
  [StateCode] VARCHAR(2),
  [CountryCode] VARCHAR(2),
  CONSTRAINT [PK_tblEWFeeZone] PRIMARY KEY ([EWFeeZoneID])
)
GO

ALTER TABLE tblCase
 ADD EWFeeZoneID INT
GO

ALTER TABLE tblCaseAppt
 ADD EWFeeZoneID INT
GO



ALTER TABLE [tblControl]
  ADD [MaintenanceMode] BIT DEFAULT 0 NOT NULL
GO


ALTER TABLE [tblEWFolderDef]
  ADD [AutoCreate] BIT
GO

ALTER TABLE [tblEWFolderDef]
  ADD [AddFilesEnabled] BIT
GO

ALTER TABLE [tblEWFolderDef]
  ADD [AddFilesAcceptFolder] BIT
GO

ALTER TABLE [tblEWFolderDef]
  ADD [AddFilesCopyOperation] INTEGER
GO


UPDATE tblControl SET DBVersion='2.55'
GO
