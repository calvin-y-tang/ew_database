-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 134

-- DB Change applied on 04/24 by DHT and WC
-- // IMEC-14211 - Add ReleaseType field to Acctheader table in the data repository
-- // Dev: Sam Chiang
--alter table IMECentricMaster.dbo.GPInvoice
--add ReleaseType varchar(100) null
--go

