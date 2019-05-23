
-- Issue 11085 - new columns to add to IMECentricMaster for EWParentCompany 
ALTER TABLE EWParentCompany ADD 
	[DateAdded] DATETIME NULL, 
	[UserIDAdded] VARCHAR(15) NULL, 
	[DateEdited] DATETIME NULL, 
	[UserIDEdited] VARCHAR(15) NULL
GO

-- Issue 11085 - set initial value for parent company add columns
UPDATE EWParentCompany 
   SET DateAdded = ISNULL(DateAdded, '2019-01-01'), 
       UserIDAdded = ISNULL(UserIDAdded, 'Admin')
GO 

-- Issue 11093 - new columns to add to IMECentricMaster for EWParentCompany 
ALTER TABLE EWParentCompany ADD 
	[DICOMHandlingPreference] INT NULL
GO

