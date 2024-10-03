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


--********************  Changes after sprint 140 was closed  *********************
-- moving from All IMEC to Single IMEC

USE IMECentricEW

-- IMEC-14382 - Guardrail for med Rec Pages when Finalizing Invoices - business rules and conditions for the security token and service types
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, BrokenRuleAction)
VALUES (178, 'GuardRailForMedRecPagesFinInvoice', 'Case', 'Check that number of medical record pages has been recorded by checking that documents were sent to doctor before finalizing invoice', 1, 1811, 1, 'NumDocsMedsToDr', 'Override Sec Token', 0)
GO


INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 1, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 2, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 3, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 4, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 5, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 6, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 8, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 9, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 10, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 11, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 12, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 4, 1, 178, GETDATE(), 'Admin', 999, '1', 'MedRecPgsFinInvoiceOverride')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 1, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 2, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 3, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 4, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 5, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 6, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 8, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 9, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 10, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 11, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 12, '1', 'MedRecPgsFinInvoiceOverride')
GO
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2)
VALUES ('PC', 31, 1, 178, GETDATE(), 'Admin', 999, '1', 'MedRecPgsFinInvoiceOverride')
GO


-- ********************* moving from All IMEC to Single IMEC  **************


-- IMEC-14382 - Guardrail for med Rec Pages when Finalizing Invoices - Security token to override guardrail
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('MedRecPgsFinInvoiceOverride', 'MedRecPgs - Override Guardrail to Finalize Invoice', GETDATE())
GO

-- IMEC-14382 - Guardrail for med Rec Pages when Finalizing Invoices - Reasons users can override guardrail stored in tblCodes
INSERT INTO tblCodes (Category, SubCategory, Value)
VALUES ('frmAuthorizeOverrideReason', 'cboOverrideReason', 'Service does not require page counts')
GO

INSERT INTO tblCodes (Category, SubCategory, Value)
VALUES ('frmAuthorizeOverrideReason', 'cboOverrideReason', 'Records sent to doctor by client')
GO

