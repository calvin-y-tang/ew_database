-- Issue 12326 - to set TaxHandling to "non-default" value (enables processing for TX Sales Tax Lookup)
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (155, 'SetInvoiceTaxHandling', 'Accounting', 'Return Tax State to set desired taxHandling', 1, 1801, 0, 'TaxHandling', 'TaxState', NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(155, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'TX', NULL, NULL, NULL)
GO


