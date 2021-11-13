
ALTER TABLE tblDoctorDocuments
 ALTER COLUMN OriginalFilePath VARCHAR(250)
GO

ALTER TABLE tblWebActivation
 ALTER COLUMN UserIDAdded VARCHAR(50)
GO


ALTER TABLE tblUser
 ADD AdminFinance BIT NOT NULL DEFAULT (0)
GO



UPDATE tblControl SET DBVersion='1.89'
GO
