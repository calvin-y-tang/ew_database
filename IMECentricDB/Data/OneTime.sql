
-- Sprint 92

-- IMEC-12984
-- Adding new setting to tblSetting to handle database context CommandTimeout value
-- Dev: Sam Chiang
USE [IMECentricEW]
GO

INSERT INTO dbo.tblSetting (Name, Value)
VALUES (
'FeeSchedSyncTimeout', 
'1800' 
)
GO
