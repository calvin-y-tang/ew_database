-- Sprint 128

-- IMEC-14003 - adding new conditions for existing Business Rule.
USE IMECentricEW 
INSERT INTO tblBusinessRuleCondition (BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), 'Admin', GETDATE(), 'Admin', OfficeCode, 2, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
     FROM tblBusinessRuleCondition
     WHERE BusinessRuleID = 130
     and ((EntityType = 'PC' and EntityID = 324) or EntityType = 'CO')
     and EWBusLineID = 1
GO
INSERT INTO tblBusinessRuleCondition (BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), 'Admin', GETDATE(), 'Admin', OfficeCode, 4, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
     FROM tblBusinessRuleCondition
     WHERE BusinessRuleID = 130
     and ((EntityType = 'PC' and EntityID = 324) or EntityType = 'CO')
     and EWBusLineID = 1
GO
INSERT INTO tblBusinessRuleCondition (BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), 'Admin', GETDATE(), 'Admin', OfficeCode, 5, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
     FROM tblBusinessRuleCondition
     WHERE BusinessRuleID = 130
     and ((EntityType = 'PC' and EntityID = 324) or EntityType = 'CO')
     and EWBusLineID = 1
GO
INSERT INTO tblBusinessRuleCondition (BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     SELECT BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, GETDATE(), 'Admin', GETDATE(), 'Admin', OfficeCode, 999, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6
     FROM tblBusinessRuleCondition
     WHERE BusinessRuleID = 130
     and ((EntityType = 'PC' and EntityID = 324) or EntityType = 'CO')
     and EWBusLineID = 1
GO
