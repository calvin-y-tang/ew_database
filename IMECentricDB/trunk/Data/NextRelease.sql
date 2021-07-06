
-- Issue 12152 Zurich Default Invoice Formats for Paykind Codes
--   Changing Business rule and adding business rule conditions

UPDATE tblBusinessRule SET Param2Desc = 'PayKind Code' WHERE BusinessRuleID = 120

  
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 60, 2, 1, 120, GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, 'Invoice', '37IME', NULL, NULL, NULL)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 60, 2, 1, 120, GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, 'Invoice', '37PCS', NULL, NULL, NULL)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 60, 2, 1, 120, GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, 'CMSZurich', '30IME', NULL, NULL, NULL)

