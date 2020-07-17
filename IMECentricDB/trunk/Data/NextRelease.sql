
-- Issue 11718 - Add business rule for Hartford quotes - BCC email
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('PC', 30, 2, 1, 109, GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 'HartfordQuotes@ExamWorks.com', NULL, NULL)


