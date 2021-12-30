--IMECentricEW only
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(155, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'TX', NULL, NULL, NULL)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 161, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'CA', Null, NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 161, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'TX', Null, NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 2, 161, GetDate(), 'Admin', NULL, NULL,    NULL, NULL, NULL, NULL, Null, NULL, NULL, NULL, NULL, 0)
GO


