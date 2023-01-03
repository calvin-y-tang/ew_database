
PRINT N'Update complete.';


GO
-- Sprint 100

-- IMEC-31247 - Guard Rules for sending email to "Other" 
-- Update existing rule for Amtrust
UPDATE tblBusinessRule
   SET Param2Desc = 'ForQuoteDocument'
 WHERE BusinessRuleID = 160
GO
UPDATE tblBusinessRuleCondition
   SET Param2 = 'YES'
 WHERE BusinessRuleID = 160
GO
-- create new rules for Guard Insurance
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (10, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'guardclaimsteam@guard.com', NULL, NULL, NULL, NULL, 0, NULL),
       (11, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'guardclaimsteam@guard.com', NULL, NULL, NULL, NULL, 0, NULL),
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'guardclaimsteam@guard.com', NULL, NULL, NULL, NULL, 0, NULL)
GO
