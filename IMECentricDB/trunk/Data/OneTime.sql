-- Issue 11806 – increased the size of the client email fields in 2 DBs

ALTER TABLE EWDataRepository.dbo.Client ALTER COLUMN Email VARCHAR (150) NULL

ALTER TABLE IMECentricMaster.dbo.GPClient ALTER COLUMN Email VARCHAR (150) NULL

-- Issue 11857 - modify schema for EWParentCompany
ALTER TABLE IMECentricMaster.dbo.EWParentCompany DROP CONSTRAINT DF_EWParentCompany_RecordRetrievalMethod
ALTER TABLE IMECentricMaster.dbo.EWParentCompany  ALTER COLUMN RecordRetrievalMethod INT NULL


-- // add new token for Jurisdiction
-- // Issue 11828 - Modified Replace_Tokens method to support new @Jurisdiction@ token.
INSERT INTO tblMessageToken (Name) VALUES('@Jurisdiction@');


-- Issue 11792: for ATIC Export; PARAM value is temporary and subject to change when deployed to production
INSERT INTO tblConfiguration(ConfigurationID, Name, Active, ConfigurationType, DateEdited, UserIDEdited, Param)
VALUES(9, 'ATIC Case & Document Export', 1, 'ATICCaseExport', '2020-10-28', 'JPais', 'CompanyCode=32413;ExportFolder=\\dev4\ISIntegrations\ATIC;NextBatchNbr=1000;NF10Template2NoShows=NF-10 Ortho')
GO

