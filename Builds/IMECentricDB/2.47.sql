ALTER TABLE tblSpecialty
 ADD PrimarySpecialty VARCHAR(50)
GO
ALTER TABLE tblSpecialty
 ADD SubSpecialty VARCHAR(50)
GO


ALTER TABLE tblEWBusLine
 ADD Mapping1 VARCHAR(10)
GO

ALTER TABLE tblEWBusLine
 ADD Mapping2 VARCHAR(10)
GO

ALTER TABLE tblEWBusLine
 ADD Mapping3 VARCHAR(10)
GO



UPDATE tblControl SET DBVersion='2.47'
GO
