-- Sprint 118

-- IMEC-13658 - clean up old data from existing table for when the functionality gets turned on
DELETE FROM tblTask
GO

-- IMEC-13608 - Amtrust business rules related to documents/reports 
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 160 
  AND EntityType = 'PC' 
  AND EntityID = 9
GO
UPDATE tblBusinessRule
   SET Param5Desc = 'SelectedDistributeTo'
 WHERE BusinessRuleID = 160
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (160, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'AmTrustClaims@amtrustgroup.com', NULL, NULL, NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'AmTrustClaims@amtrustgroup.com', 'YES', 'IN', NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'John.Insco@amtrustgroup.com;AmTrustClaims@amtrustgroup.com', 'YES', 'OUT', NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, 'GSOperations@amtrustgroup.com;AmTrustClaims@amtrustgroup.com', 'YES', 'OUT', NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'AmTrustClaims@amtrustgroup.com', 'YES', 'OUT', NULL, ';Client;', 0, NULL)
GO
UPDATE tblBusinessRule
   SET Param3Desc = 'SelectedDistributeTo'
 WHERE BusinessRuleID = 10
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (10, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ' AmTrustClaims@amtrustgroup.com', NULL, ';Client;', NULL, NULL, 0, NULL)
GO
UPDATE tblBusinessRule
   SET Param3Desc = 'SelectedDistributeTo'
 WHERE BusinessRuleID = 11
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (11, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ' AmTrustClaims@amtrustgroup.com', NULL, ';Client;', NULL, NULL, 0, NULL)
GO
