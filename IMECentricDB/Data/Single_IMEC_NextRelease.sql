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

