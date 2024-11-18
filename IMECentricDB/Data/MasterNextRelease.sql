-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 142

-- IMEC-14553
DECLARE
	@Zone1 INT = 1251,
	@Zone2 INT = 1252;
DECLARE @NewFloridaZones table (EWFeeZoneID INT NOT NULL, [Name] VARCHAR(30), [Status] VARCHAR(10), StateCode VARCHAR(2), CountryCode VARCHAR(2));

insert into @NewFloridaZones
	(EWFeeZoneID, [Name], [Status], StateCode, CountryCode) 
values
	(@Zone1, 'Florida (Zone 1)', 'Active', 'FL', 'US'),
	(@Zone2, 'Florida (Zone 2)', 'Active', 'FL', 'US');

INSERT INTO dbo.EWFeeZone ([EWFeeZoneID], [Name] , [Status], StateCode, CountryCode)
SELECT EWFeeZoneID, [Name], [Status], StateCode, CountryCode FROM @NewFloridaZones nfl
WHERE NOT EXISTS (SELECT 1 FROM dbo.EWFeeZone fz WHERE fz.EWFeeZoneID = nfl.EWFeeZoneID);

GO
