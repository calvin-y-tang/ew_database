
PRINT N'Update complete.';


GO
-- Sprint 111

-- IMEC-12786 - BR and BR conditions for Liberty invoice limits for quote approval needed - excludes WC cases in CA and TX
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES(165, 'QuoteApprovalNeededForInvoice', 'Accounting', 'Determine if a quote approval is needed to finalize an invoice', 1, 1811, 1, 'InvoiceTotal', 'Override Sec Token', NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES('PC', 31, 2, 1, 165, GetDate(), 'Admin', NULL, NULL, NULL, 3, NULL, 'CA', '0', NULL, NULL, NULL, NULL, 1, NULL)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES('PC', 31, 2, 1, 165, GetDate(), 'Admin', NULL, NULL, NULL, 3, NULL, 'TX', '0', NULL, NULL, NULL, NULL, 1, NULL)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES('PC', 31, 2, 2, 165, GetDate(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, '5000', 'LimitInvoiceAmountOverride', NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded) VALUES ('LimitInvoiceAmountOverride', 'Accounting - Override Quote Approval on Invoice', GETDATE())
GO
