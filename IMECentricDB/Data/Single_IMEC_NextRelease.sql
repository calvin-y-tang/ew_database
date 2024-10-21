-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 141


USE [IMECentricEW]
---- Business Rule and conditions for AllState Guardrails to send quote to billing client
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, BrokenRuleAction)
VALUES (182, 'GenDocsSendQuoteToBillClient', 'Case', 'When generating documents for quotes, send email to billing client if there is one instead of case client', 1, 1201, 0, 'QuoteType', 'Quotehandling', 0)
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Param1, Param2)
VALUES ('PC', 4, 2, 1, 182, GETDATE(), 'Admin', 2, 'IN', '2')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Param1, Param2)
VALUES ('PC', 4, 2, 1, 182, GETDATE(), 'Admin', 5, 'IN', '2')
GO


-- IMEC-14446 - only show 2 FL fee zones for Liberty - remove FL-Central if the case network is Liberty
USE [IMECentricEW]

INSERT INTO tblSetting (Name, Value)
VALUES ('LibertyStartDateFLFeeZones', '2024/10/01')
GO

-- IMEC-14422 - Allstate quote guardrails
USE [IMECentricEW]
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (181, 'ApplyAllStateGuardRailsQuote', 'Case', 'Check if the AllState guardrails need to be applied when generating a quote.', 1, 1060, 0, 'Max late cancel fee', 'Med recs max amount', 'Med recs rate', 'Max late cancel days', 0)

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Param1, Param2, Param3, Param4)
VALUES ('PC', 4, 2, 1, 181, GETDATE(), 'Admin', 2, '2500', '2000', '1.00', '3')

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Param1, Param2, Param3, Param4)
VALUES ('PC', 4, 2, 1, 181, GETDATE(), 'Admin', 5, '2500', '2000', '1.00', '3')


-- enables the MedRecsPages textbox on the Quote params form
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Param1)
VALUES ('PC', 4, 2, 1, 152, GETDATE(), 'Admin', 2, 'True')

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Param1)
VALUES ('PC', 4, 2, 1, 152, GETDATE(), 'Admin', 5, 'True')


-- quote override
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES (' AllStateQuoteGuardrailOverride ', 'AllState - Override Guardrails when creating quote', GETDATE())



