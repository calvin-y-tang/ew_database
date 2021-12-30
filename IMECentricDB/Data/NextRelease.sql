-- Issue 12326 - to set TaxHandling to "non-default" value (enables processing for TX Sales Tax Lookup)
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (155, 'SetInvoiceTaxHandling', 'Accounting', 'Return Tax State to set desired taxHandling', 1, 1801, 0, 'TaxHandling', 'TaxState', NULL, NULL, NULL, 0)
GO



-- Issue 12417 - Business rules for Hartford Quote Guardrails
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
  VALUES(161, 'ApplyHartfordGuardrailsQuote', 'Case', 'Check if Hartford Guardrails should be applied when saving a quote', 1, 1060, 0, Null, Null, Null, Null, Null, 0)
GO

