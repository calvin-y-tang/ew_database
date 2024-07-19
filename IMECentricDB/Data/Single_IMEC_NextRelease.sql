-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 138

-- IMEC - 14237 - config document folders for Chubb; IMECentricEW Only
-- DEV NOTE: *************** DO NOT APPLY TO TEST SYSTEM *********************
USE IMECentricEW
GO
UPDATE tblEWParentCompany 
   SET CaseDocFolderID = 363, 
       AcctDocFolderID = 364
  FROM tblEWParentCompany
 WHERE ParentCompanyID = 16
GO

