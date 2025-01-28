ALTER TABLE tblEWCompany
 ADD MMITracking BIT
GO

CREATE TABLE tblEWFolderType
(
FolderType int NOT NULL,
Descrip varchar (50) NULL,
SeqNo int NULL,
FileManager bit NULL,
DocumentStorage bit NULL,
FunctionCodePrefix varchar (10) NULL,
FunctionDescPrefix varchar (15)  NULL
) ON [PRIMARY]
GO
ALTER TABLE tblEWFolderType ADD CONSTRAINT PK_tblEWFolderType PRIMARY KEY CLUSTERED  (FolderType) ON [PRIMARY]
GO

UPDATE tblControl SET DBVersion='1.97'
GO
