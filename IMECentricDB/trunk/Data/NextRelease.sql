-- Issue 8200 - New Business Rules for Require Coversheet 
DECLARE @iBusRuleID INTEGER
INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, BrokenRuleAction)
VALUES('DistDocReqCoverSheet', 'Case', 'Coversheet Required when distributing document', 1, 1202, 0, 0)
SELECT @iBusRuleID = @@IDENTITY
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('CO', 76626, 2, 1, @iBusRuleID, GetDate(), 'Admin', GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, BrokenRuleAction)
VALUES('DistRepReqCoverSheet', 'Report', 'Coversheet Required when distributing report', 1, 1320, 0, 0)
SELECT @iBusRuleID = @@IDENTITY
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('CO', 76626, 2, 1, @iBusRuleID, GetDate(), 'Admin', GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)


