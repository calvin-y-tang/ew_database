-- Sprint 117

-- IMEC-13683 - need a data conversion/update for exisitng entries in tblFSDetailCondition tied to ExamLocation City
UPDATE tblFSDetailCondition
   SET ConditionTable = 'tblLocationCity'
 WHERE ConditionTable = 'tblLocation' 
   AND ConditionValue IS NOT NULL
GO

-- IMEC-13607 Guard Business Rules
-- Distribute Document
DELETE FROM tblBusinessRuleCondition where BusinessRuleID = 10
GO
UPDATE tblBusinessRule
   SET Param2Desc = 'ClaimNbrStartsWith'
 WHERE BusinessRuleID = 10
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (10, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', 'N9', NULL, NULL, NULL, 0, NULL),
       (10, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, NULL, NULL, NULL, 0, NULL)
GO
-- Distribute Report
DELETE FROM tblBusinessRuleCondition where BusinessRuleID = 11
GO
UPDATE tblBusinessRule
   SET Param2Desc = 'ClaimNbrStartsWith'
 WHERE BusinessRuleID = 11
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (11, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', 'N9', NULL, NULL, NULL, 0, NULL),
       (11, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, NULL, NULL, NULL, 0, NULL)
GO
-- Generate Documents (and Quote Documents)
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 160 
  AND EntityType = 'PC' 
  AND EntityID = 91
GO
UPDATE tblBusinessRule
   SET Param3Desc = 'QuoteInOutNetwork', 
       Param4Desc = 'ClaimNbrStartsWith'
 WHERE BusinessRuleID = 160
GO
UPDATE tblBusinessRuleCondition 
   SET Param3 = 'OUT'
 WHERE BusinessRuleID = 160 
   AND EntityType = 'PC' 
   AND EntityID = 9
GO 
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', NULL, NULL, 'N9', NULL, 0, NULL), 
       (160, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, NULL, NULL, NULL, 0, NULL),
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', 'YES', 'IN', 'N9', NULL, 0, NULL),
       (160, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', 'YES', 'IN', NULL, NULL, 0, NULL), 
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'lauren.langan@biberk.com', 'YES', 'OUT', 'N9', NULL, 0, NULL), 
       (160, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Brandon.Styczen@guard.com', 'YES', 'OUT', NULL, NULL, 0, NULL)

-- Distribute Invoice
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (114, 'DistRptInvDefaultOtherEmail', 'Case', 'When Dist Rpt if Inv is an attached Doc default Other Email Address', 1, 1320, 0, 'OtherEmail', 'ClaimNbrStartsWith', 'DocNameStartsWith', NULL, NULL, 0, NULL),
       (115, 'DistDocInvDefaultOtherEmail', 'Case', 'When Dist Doc if Inv is part of dist  then default Other Email Address', 1, 1202, 0, 'OtherEmail', 'ClaimNbrStartsWith', 'DocNameStartsWith', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (114, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'mbr@guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (114, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@Biberk.com', 'N9', 'CMS', NULL, NULL, 0, NULL),
       (114, 'PC', 91, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'mbr@guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@Biberk.com', 'N9', 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 91, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, 'CMS', NULL, NULL, 0, NULL)
GO
