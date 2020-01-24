
-- new business rule condition to match employer (Waste Management) to claim number.
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('CO', 77443, 2, 1, 108, '2020-01-08', 'Admin', '2020-01-08', 'Admin', NULL, NULL, NULL, NULL, '003000', NULL, '142', NULL, 'ClaimEmployerOverride')


