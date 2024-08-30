-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 140

-- IMEC-14303 - New Business Rule Conditions for EWCA for Industrial Alliance and Financial Services 
USE IMECentricEWCA 
GO 
     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
     VALUES (7, 'CO', 2, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'tbPgSynergy', NULL, NULL, NULL, NULL, 0, NULL, 0), 
            (7, 'CO', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'tbPgSynergy', NULL, NULL, NULL, NULL, 0, NULL, 0),
            (153, 'CO', 2, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Always', NULL, NULL, NULL, NULL, 0, NULL, 0), 
            (153, 'CO', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Always', NULL, NULL, NULL, NULL, 0, NULL, 0)
GO
