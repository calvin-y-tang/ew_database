-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 144

-- IMEC-14208 - data patch to turn on External communication tasks
USE [IMECentricMaster]
UPDATE ISExtIntegration SET Active = 1, LastBatchDate = GETDATE() WHERE Type = 'EXTCOM'

GO
