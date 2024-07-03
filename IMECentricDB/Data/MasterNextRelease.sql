-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 138

-- IMEC-14237 - add columns for parent company folderIDs for Case and Accting documents
ALTER TABLE IMECentricMaster.dbo.EWParentCompany ADD CaseDocFolderID INT NULL
GO
ALTER TABLE IMECentricMaster.dbo.EWParentCompany ADD AcctDocFolderID INT NULL
GO

