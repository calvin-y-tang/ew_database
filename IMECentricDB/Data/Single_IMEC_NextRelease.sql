-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 135


-- Applied to DB on 04/24 by DHT and WC
-- USE [EWDataRepository]
-- GO
-- // IMEC-14211 - Add ReleaseType field to Acctheader table in the data repository
-- // Dev: Sam Chiang
-- alter table EWDataRepository.dbo.AcctHeader
-- add ReleaseType varchar(100) null
-- go


--
-- START CHANGES FOR IMEC-14218
--

USE [IMECentricEW]
GO
-- update fax prefix
UPDATE tblControl Set XMediusFaxPrefix = '@xmedius-fax.com'

-- update Fax System Format (or add)
IF (SELECT COUNT(*) FROM tblSetting WHERE Name = 'FaxSysFormat') > 0
BEGIN 
	UPDATE tblSetting SET Value = 'XMediusDomain' WHERE Name = 'FaxSysFormat'
END
ELSE
BEGIN 
	INSERT INTO tblSetting (Name,Value) values ('FaxSysFormat', 'XMediusDomain')		
END
GO

USE [IMECentricFCE]
GO
-- update fax prefix
UPDATE tblControl Set XMediusFaxPrefix = '@xmedius-fax.com'

-- update Fax System Format (or add)
IF (SELECT COUNT(*) FROM tblSetting WHERE Name = 'FaxSysFormat') > 0
BEGIN 
	UPDATE tblSetting SET Value = 'XMediusDomain' WHERE Name = 'FaxSysFormat'
END
ELSE
BEGIN 
	INSERT INTO tblSetting (Name,Value) values ('FaxSysFormat', 'XMediusDomain')		
END
GO

USE [IMECentricMCMC]
GO
-- update fax prefix
UPDATE tblControl Set XMediusFaxPrefix = '@xmedius-fax.com'

-- update Fax System Format (or add)
IF (SELECT COUNT(*) FROM tblSetting WHERE Name = 'FaxSysFormat') > 0
BEGIN 
	UPDATE tblSetting SET Value = 'XMediusDomain' WHERE Name = 'FaxSysFormat'
END
ELSE
BEGIN 
	INSERT INTO tblSetting (Name,Value) values ('FaxSysFormat', 'XMediusDomain')		
END
GO

USE [IMECentricMIMedSource]
GO
-- update fax prefix
UPDATE tblControl Set XMediusFaxPrefix = '@xmedius-fax.com'

-- update Fax System Format (or add)
IF (SELECT COUNT(*) FROM tblSetting WHERE Name = 'FaxSysFormat') > 0
BEGIN 
	UPDATE tblSetting SET Value = 'XMediusDomain' WHERE Name = 'FaxSysFormat'
END
ELSE
BEGIN 
	INSERT INTO tblSetting (Name,Value) values ('FaxSysFormat', 'XMediusDomain')		
END

GO

USE [IMECentricJBA]
GO
-- update fax prefix
UPDATE tblControl Set XMediusFaxPrefix = '@xmedius-fax.com'

-- update Fax System Format (or add)
IF (SELECT COUNT(*) FROM tblSetting WHERE Name = 'FaxSysFormat') > 0
BEGIN 
	UPDATE tblSetting SET Value = 'XMediusDomain' WHERE Name = 'FaxSysFormat'
END
ELSE
BEGIN 
	INSERT INTO tblSetting (Name,Value) values ('FaxSysFormat', 'XMediusDomain')		
END

--
-- END CHANGES FOR IMEC-14218
--
