-- Issue 11806 – increased the size of the client email fields in 2 DBs

ALTER TABLE EWDataRepository.dbo.Client ALTER COLUMN Email VARCHAR (150) NULL

ALTER TABLE IMECentricMaster.dbo.GPClient ALTER COLUMN Email VARCHAR (150) NULL

-- Issue 11857 - modify schema for EWParentCompany
ALTER TABLE IMECentricMaster.dbo.EWParentCompany DROP CONSTRAINT DF_EWParentCompany_RecordRetrievalMethod
ALTER TABLE IMECentricMaster.dbo.EWParentCompany  ALTER COLUMN RecordRetrievalMethod INT NULL

