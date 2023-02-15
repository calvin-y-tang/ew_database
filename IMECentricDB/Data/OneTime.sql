-- Sprint 104

-- IMEC-13365 - only allow CV Dr Document Type to be set for Publish to Web
USE IMECentricMaster 
GO
 UPDATE EWDrDocType
   SET AllowPublishOnWeb = 0
 WHERE EWDrDocTypeID <> 5
GO

-- IMEC-13363 - CRN - need to increase SpecialtyCode (and Description) to VARCHAR(500)
USE IMECentricMaster 
GO
ALTER TABLE EWDoctorDocument ALTER COLUMN SpecialtyCode VARCHAR (500) NULL
GO
ALTER TABLE EWSpecialty ALTER COLUMN SpecialtyCode VARCHAR (500) NULL
GO
ALTER TABLE EWSpecialty ALTER COLUMN  Description VARCHAR (500) NULL
GO
ALTER TABLE EWSpecialty ALTER COLUMN  PrimarySpecialty VARCHAR (500) NULL
GO
ALTER TABLE EWSpecialty ALTER COLUMN  SubSpecialty VARCHAR (500) NULL
GO
ALTER TABLE EWSpecialty ALTER COLUMN  Expertise VARCHAR (500) NULL
GO

ALTER TABLE NDBSpecialtyMapping ALTER COLUMN FromSpecialtyCode VARCHAR(500) NOT NULL
GO
ALTER TABLE NDBSpecialtyMapping ALTER COLUMN ToSpecialtyCode VARCHAR(500) NULL 
GO
ALTER TABLE EWDoctorExt ALTER COLUMN Specialties VARCHAR(3000) NULL
GO
