-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 146

-- IMEC-14832 Update emails sent for ERP errors.
UPDATE ISExtIntegration WHERE [Type] = 'ERP'
SET NotifyEmail = "doug.troy@examworks.com;william.cecil@examworks.com;EWISLogs@examworks.com";