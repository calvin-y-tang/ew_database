--Add new language
INSERT INTO [tbllanguage] ([Description])
 select 'Serbian'
 where not exists (select description from tblLanguage where description='Serbian')
GO

ALTER TABLE tblDoctor
  ALTER COLUMN CredentialingSource VARCHAR(15)
GO


ALTER TABLE tblEWFacility
 ADD DateDR DATETIME
GO

CREATE TABLE [tblEWAccreditation] (
  [EWAccreditationID] INTEGER NOT NULL,
  [Name] VARCHAR(10),
  [Description] VARCHAR(50),
  [PublishOnWeb] BIT,
  [SeqNo] INTEGER,
  [CountryID] INTEGER,
  CONSTRAINT [PK_tblEWAccreditation] PRIMARY KEY ([EWAccreditationID])
)
GO

CREATE TABLE [tblDoctorAccreditation] (
  [DoctorCode] INTEGER,
  [EWAccreditationID] INTEGER,
  [DateAdded] DATETIME,
  [UserIDAdded] VARCHAR(15),
  [DateEdited] DATETIME,
  [UserIDEdited] VARCHAR(15),
  CONSTRAINT [PK_tblDoctorAccreditation] PRIMARY KEY ([DoctorCode],[EWAccreditationID])
)
GO

ALTER TABLE tblIMEData
 ADD CountryID INT
GO

UPDATE tblIMEData SET CountryID=2 WHERE Country='Canada'
UPDATE tblIMEData SET CountryID=1 WHERE CountryID IS NULL
GO

ALTER TABLE [tblCase]
  ADD [ReqEWAccreditationID] INTEGER
GO


UPDATE tblControl SET DBVersion='1.81'
GO
