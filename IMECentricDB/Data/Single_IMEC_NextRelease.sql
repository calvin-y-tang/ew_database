-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 130

-- IMEC-14045 - Create new business rules that apply when generating IN/VO line items for tblRecordHistory entries; 
--              the RecordsActionID that is specified in each rule is unique to each DB and will need to be customized
--              for each DB. To my knowledge this functionality is only needed for IMECentricEW.
USE [IMECentricEW]
GO
    -- Invoice Rules
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (132, 'InvMedRecPages', 'Accounting', 'Gen Inv Calculate Med Rec Page Count', 1, 1801, 0, 'RecordsActionID', 'IncludedPages', 'PerPageUnitAmt', NULL, NULL, 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
    VALUES (132, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, 1, 'CA', '67', '200', '3', NULL, NULL, 0, NULL), 
           (132, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, 8, 'CA', '68', '50', '3', NULL, NULL, 0, NULL)
    GO

     -- Voucher Rules
     INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
     VALUES (133, 'VouMedRecPages', 'Accounting', 'Gen Voucher Calculate Med Rec Page Count', 1, 1802, 0, 'RecordsActionID', 'IncludedPages', 'PerPageUnitAmt', NULL, NULL, 0, NULL)
     GO
     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
     VALUES (133, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, 1, 'CA', '67', '200', '3', NULL, NULL, 0, NULL), 
            (133, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, 8, 'CA', '68', '50', '3', NULL, NULL, 0, NULL)
     GO


