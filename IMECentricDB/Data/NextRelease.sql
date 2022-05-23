
-- Sprint 85

-- IMEC-12760 - set the PDFMerge method to use
--	***** this does not need to be executed on the DBs that we want to use IMECentricHelper to do the Merge
INSERT INTO tblSetting(Name, Value)
VALUES('MergePDFMethod', 'QuickPDF')
GO

-- IMEC-12752 - new business rule for calculating quote total
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (143, 'ComputeQuoteAmounts', 'Case', 'Calculate the Amount for a Quote', 1, 1060, 0, 'QuoteFeeRangeUnit', 'AdditionalFeesUnit', 'TTlAmtLimit', NULL, NULL, 0, NULL)
GO

INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (143, 'PC', 30, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ';Fee;Hourly;Inch;Each;', ';fee;', NULL, NULL, NULL, 0, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 32, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 33, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 34, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 13, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 14, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 15, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 16, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 38, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 40, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL),
       (143, 'PC', 31, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ';fee;', ';fee;', '5000.00', NULL, NULL, 0, NULL)
GO



