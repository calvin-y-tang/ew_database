-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 136

-- IMEC-14227 (IMEC-14235) - add token and update bizRule details on all DBs to keep them in sync
UPDATE tblBusinessRule
   SET Param5Desc = 'SecurityToken', 
       Param6Desc = 'ServiceCode', 
       AllowOverride = 1
WHERE BusinessRuleID = 130
GO

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('CaseSkipReqFieldCheck','Case -Override Required Field Validation (BusRule)', GETDATE())
GO

-- IMEC-14234 - Adding in entry to tblCodes for ToDate box on invoice sub form to be enabled if EWFacility combo box is set to one of the values
INSERT INTO tblCodes (Category, SubCategory, Value)
VALUES ('TexasFacilityCombo', 'ToDateEnabled', ';5;')
GO

-- *************************************************************************************
-- ****** DO NOT EXECUTE AGAINST TEST SYSTEM DATABASES. **********
-- IMEC-14230 - create new BizRules for Guard & Berkshire to handle GenDocs and Dist Doc/Rpt
-- Distribute Documents
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 10 
  AND EntityType = 'PC' 
  AND EntityID in (91, 295)
GO 
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES 
       (10, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@guard.com', NULL, NULL, NULL, NULL, 0, NULL),
       (10, 'PC', 295, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@biberk.com', NULL, NULL, NULL, NULL, 0, NULL)
GO

-- Distribute Reports 
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 11 
  AND EntityType = 'PC' 
  AND EntityID in (91, 295)
GO 
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES 
       (11, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@guard.com', NULL, NULL, NULL, NULL, 0, NULL),
       (11, 'PC', 295, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@biberk.com', NULL, NULL, NULL, NULL, 0, NULL)
GO

-- Generate Documents & Quote Documents
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 160 
  AND EntityType = 'PC' 
  AND EntityID in (91, 295)
GO
-- The following replaces rules for Generate Document.
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES 
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@guard.com', NULL, NULL, NULL, NULL, 0, NULL),
       (160, 'PC', 295, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@biberk.com', NULL, NULL, NULL, NULL, 0, NULL),
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@guard.com', 'YES', 'IN', NULL, NULL, 0, NULL),
       (160, 'PC', 295, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@biberk.com', 'YES', 'IN', NULL, NULL, 0, NULL),
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Brandon.Styczen@guard.com', 'YES', 'OUT', NULL, NULL, 0, NULL),
       (160, 'PC', 295, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'lauren.langan@biberk.com', 'YES', 'OUT', NULL, NULL, 0, NULL)
GO

-- DistRptInvDefaultOtherEmail
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 114 
  AND EntityType = 'PC' 
  AND EntityID in (91, 295)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES 
       (114, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'mbr@guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (114, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (114, 'PC', 295, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'claims@Biberk.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (114, 'PC', 295, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@Biberk.com', NULL, 'CMS', NULL, NULL, 0, NULL)
GO

-- DistDocInvDefaultOtherEmail
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 115 
  AND EntityType = 'PC' 
  AND EntityID in (91, 295)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES 
       (115, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'mbr@guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 295, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'claims@Biberk.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 295, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@Biberk.com', NULL, 'CMS', NULL, NULL, 0, NULL)
GO
-- *************************************************************************************

