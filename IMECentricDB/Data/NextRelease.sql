-- Sprint 98

-- IMEC-13207 - new biz rules for Sentry WC Peer Reviews and WC Record Reviews
-- Wokers Comp Peer Review
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), UserIDAdded, GETDATE(), UserIDEdited, OfficeCode, EWBusLineID, 2, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
       FROM tblBusinessRuleCondition 
       WHERE BusinessRuleID IN (109,110) 
         AND EntityType = 'PC' 
         AND EntityID = 46
         AND EWBusLineID = 3 
         AND EWServiceTypeID = 1
         AND Param2 = 'WCClaimTechStPtEast@sentry.com'
GO
-- Workers Comp Record Review
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), UserIDAdded, GETDATE(), UserIDEdited, OfficeCode, EWBusLineID, 3, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
       FROM tblBusinessRuleCondition 
       WHERE BusinessRuleID IN (109,110) 
         AND EntityType = 'PC' 
         AND EntityID = 46
         AND EWBusLineID = 3 
         AND EWServiceTypeID = 1
         AND Param2 = 'WCClaimTechStPtEast@sentry.com'
GO

-- IMEC-13184 business rules for allstate client validation prior to scheduling
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (145, 'VerifyClientType', 'Appointment', 'Verify client type value of client', 1, 1101, 0, 'CaseClientType', 'Required', 'ClientTypeString', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (145, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';1;3;4;13;', 'YES', 'Adjuster, Attorney, Attorney-Defense or Paralegal', NULL, NULL, 0, NULL),
       (145, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';1;3;4;13;', 'YES', 'Adjuster, Attorney, Attorney-Defense or Paralegal', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (146, 'ClientTypeRequirements', 'Appointment', 'Client and Attorney requirements based on client type', 1, 1101, 0, 'ClientType', 'ReqDefAtty', 'ReqBillToClient', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';1;', 'YES', 'NO', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';3;4;', 'NO', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';13;', 'YES', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';1;', 'YES', 'NO', NULL ,NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';3;4;', 'NO', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';13;', 'YES', 'YES', NULL, NULL, 0, NULL)
GO
-- IMEC-13184 - new security settings for Client Type Override
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('ClientTypeVerifyOverride','Case - Skip Client Type Validation', GETDATE())
GO
