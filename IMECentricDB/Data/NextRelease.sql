-- Sprint 106

-- IMEC-13441 - creae new business rule condition for Claim Nbr requires Employer 
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (104, 'PC', 25, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, '015557', NULL, '55453,59557', 'First Transit or First Student', NULL, 0, NULL)
GO
