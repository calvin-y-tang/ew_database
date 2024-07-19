-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 138

-- IMEC-14237 - add columns for parent company folderIDs for Case and Accting documents
-- DEV NOTES: we are not going to create these columns in master and have them only
--		be part of the IMEC BU DBs. This allows us to have separate folders for each
--		DB without having to worry about having the same case number present in 
--		multiple DBs.
--ALTER TABLE IMECentricMaster.dbo.EWParentCompany ADD CaseDocFolderID INT NULL
--GO
--ALTER TABLE IMECentricMaster.dbo.EWParentCompany ADD AcctDocFolderID INT NULL
--GO

