

 -- Issue 12418 - Hartford resend quote approvals a 2nd time then approve - adding business rules to add resend date
 INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 154, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'CA', '16', NULL, NULL, NULL, NULL, 1)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 154, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'TX', '16', NULL, NULL, NULL, NULL, 1)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 2, 154, GetDate(), 'Admin', NULL, NULL,    NULL, NULL, NULL, NULL, '16', NULL, NULL, NULL, NULL, 0)

GO
