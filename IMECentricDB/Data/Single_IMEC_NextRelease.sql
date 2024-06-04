-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 136

-- IMEC-14227 (IMEC-14235) - requred fields for case form with security token override
USE IMECentricEW 
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
VALUES 
     (130, 'SW', -1, 0, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 32, NULL, NULL, NULL, 'cboEmployer', 'cboEmployerAddress', 'txtAddlclaimnbr', NULL, 'CaseSkipReqFieldCheck', 0, '1200', 0), 
     (130, 'SW', -1, 0, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 33, NULL, NULL, NULL, 'cboEmployer', 'cboEmployerAddress', 'txtAddlclaimnbr', NULL, 'CaseSkipReqFieldCheck', 0, '1200', 0), 
     (130, 'SW', -1, 0, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', 34, NULL, NULL, NULL, 'cboEmployer', 'cboEmployerAddress', 'txtAddlclaimnbr', NULL, 'CaseSkipReqFieldCheck', 0, '1200', 0)

GO
