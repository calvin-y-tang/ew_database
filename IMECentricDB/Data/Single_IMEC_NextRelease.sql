-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 140

-- IMEC-14303 - New Business Rule Conditions for EWCA for Industrial Alliance and Financial Services 
USE IMECentricEWCA 
GO 
     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
     VALUES (7, 'CO', 2, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'tbPgSynergy', NULL, NULL, NULL, NULL, 0, NULL, 0), 
            (7, 'CO', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'tbPgSynergy', NULL, NULL, NULL, NULL, 0, NULL, 0),
            (153, 'CO', 2, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Always', NULL, NULL, NULL, NULL, 0, NULL, 0), 
            (153, 'CO', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Always', NULL, NULL, NULL, NULL, 0, NULL, 0)
GO

-- IMEC-14296 - set CaseDocTypeID values for DBs based on current contents of local tblCaseDocType table
USE IMECentricLandmark
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO 

USE IMECentricMedicolegal
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

Use IMECentricFCE
GO
UPDATE tblSetting 
   SET Value = ';7;22;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;22;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricSOMA
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricDirectIME
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricMatrix
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricCVS
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricMakos
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricNYRC
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricKRA
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricIMAS
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricMedylex
GO
UPDATE tblSetting 
   SET Value = ';7;28;30;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;28;30;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricMedaca
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO

USE IMECentricEWCA
GO
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsIncoming_True'
GO 
UPDATE tblSetting 
   SET Value = ';7;'
  FROM tblSetting 
 WHERE Name = 'CaseDocTypeMedsToDoctor_True'
GO
