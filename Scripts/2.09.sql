DROP TABLE tblFaxCover
GO

CREATE TABLE [tblEWFaxCoverPage] (
  [FaxCoverPageID] INTEGER NOT NULL,
  [FaxType] INTEGER,
  [DeviceName] VARCHAR(20),
  [DisplayName] VARCHAR(50),
  CONSTRAINT [PK_tblEWFaxCoverPage] PRIMARY KEY ([FaxCoverPageID])
)
GO

CREATE TABLE [tblEWFaxCoverPageDB] (
  [FaxCoverPageID] INTEGER NOT NULL,
  [DBID] INTEGER NOT NULL,
  CONSTRAINT [PK_tblEWFaxCoverPageDB] PRIMARY KEY ([FaxCoverPageID],[DBID])
)
GO
ALTER TABLE tblDocument
 ADD FaxCoverPageID INT
GO
ALTER TABLE tblDocument
 DROP COLUMN FaxCoverID
GO




UPDATE tblControl SET DBVersion='2.09'
GO
