-- Sprint 114

-- IMEC-13617 - add Liberty business rule for Market Designation
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (131, 'FinalizeInvLibertyMarketDesignation', 'Accounting', 'Liberty only: Validate Market Designation value', 1, 1811, 1, 'AllowBlank', 'ValidValues', NULL, NULL, NULL, 0, NULL)
GO

INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
VALUES (131, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'False', ';GRM;GRS;', NULL, NULL, NULL, 0, NULL, NULL)
GO

-- IMEC-13696 - new business rule to validate additional fee amount for quote
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (159, 'QuoteAdditionalFeeVerify', 'Case', 'Check and Validate Quote Additional Fee (MedRecPages) Amt', 1, 1061, 0, 'ProdCode', 'MaxAllowedAmt', 'WarnUser', NULL, NULL, 0, NULL)
GO

INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
VALUES (159, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '385', '2250', 'False', NULL, NULL, 0, NULL, NULL)
GO
