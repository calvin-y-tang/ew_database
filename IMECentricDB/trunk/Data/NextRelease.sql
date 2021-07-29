-- Issue 12199 - Amtrust Parent Company stuff
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (150, 'ApplyAmtrustGuardRailsQuote', 'Case', 'Check if the Amtrust guardrails need to be applied when saving a quote.', 1, 1060, 0, NULL, NULL, NULL, NULL, NULL, 0), 
       (151, 'ApplyAmtrustGuardRailsInvoice', 'Case', 'Check if the Amtrust guardrails need to be applied when generating an invoice.', 1, 1811, 0, NULL, NULL, NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, 
                                     OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(150, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
      (151, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

-- Issue 12202/12203 - new product item for quote additional fees
INSERT INTO tblQuoteFeeConfig (FeeValueName, DisplayOrder, DateAdded, UserIDAdded, ProdCode)
VALUES('Med Recs Over 1"', 45, GETDATE(), 'Admin', 385)
GO

