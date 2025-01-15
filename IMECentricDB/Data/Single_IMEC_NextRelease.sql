-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 144



-- IMEC-14723 - Update Med rec page calculations for certain scenarios
USE [IMECentricEW]

DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'LibertyQuoteMedRecPgCalculations')

IF @BusinessRuleID IS NOT NULL
BEGIN
	DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID = @BusinessRuleID

	--   (1) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 1, 1, 'T1', '250', '385', '0.1', '250')

	--   (2) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 1, 2, 'T1', '250', '385', '0.2', '250')

	--   (3) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 5, 1, 'T1', '250', '385', '0.1', '250')

	--   (4) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 5, 2, 'T1', '250', '385', '0.2', '250')

	--   (13) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = IME; Jurisdiction 'MI'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 2, 1, 'MI', 'T1', '250', '385', '0.1', '250')

	--   (14) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = Peer review; Jurisdiction 'MI'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 2, 2, 'MI', 'T1', '385')

	--   (15) Service Fee > 500 - ProdCode = 3030; all cases
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', '3030', '0.1', '500')

	  --   (16) Service Fee > 500 - ProdCode = 3030; exclude CA for workers comp - no service fee
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'CA', '3030')

	  --   (17) Service Fee > 500 - ProdCode = 3030; exclude TX for workers comp - no service fee
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'TX', '3030')

	  --   (18) Service Fee > 500 - ProdCode = 3030; exclude WA for workers comp - no service fee
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 3, 'WA', '3030')

	--   (19) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 1, 3, 'T1', '250', '385', '0.2', '250')

	--   (20) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', 5, 3, 'T1', '250', '385', '0.2', '250')

	--   (25) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = Record review; Jurisdiction 'MI'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 2, 3, 'MI', 'T1', '385')

	--   (5) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 1, 'CA', 'T1', '250', '385', '0.5', '250')

	--   (6) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 1, 'WA', 'T1', '250', '385', '0.5', '250')

	--   (7) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 2, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (8) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 2, 'WA', 'T1', '250', '385', '0.35', '250')

	--   (9) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 1, 'CA', 'T1', '250', '385', '0.5', '250')

	--   (10) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 1, 'WA', 'T1', '250', '385', '0.5', '250')

	--   (11) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 2, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (12) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 2, 'WA', 'T1', '250', '385', '0.35', '250')

	--   (21) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 3, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (22) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 1, 3, 'WA', 'T1', '250', '385', '0.35', '250')

	--   (23) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'CA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 3, 'CA', 'T1', '250', '385', '0.35', '250')

	--   (24) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'WA'
	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', 5, 3, 'WA', 'T1', '250', '385', '0.35', '250')

END

GO

-- IMEC-14728 - Need an additional serviceCode for FL office
--		**** This was applied to production  on 01/10/2025 but there is no harm in letting it run again.
USE [IMECentricEW]

DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'AutoAckDPSBundle')

IF @BusinessRuleID IS NOT NULL
BEGIN
	UPDATE tblBusinessRuleCondition 
	   SET param6 = ';2070;3290;4121;2100;' , 
		   DateEdited = GETDATE(),
		   UserIDEdited = 'JPais'
	WHERE  BusinessRuleID = @BusinessRuleID
	   AND EWServiceTypeID = 1  
	   AND OfficeCode = 17
END

GO


-- IMEC-14730 - Liberty updates - add BRC for when no doctor and no reason - a.k.a panel exam
USE [IMECentricEW]
GO

DECLARE @BusinessRuleID INT = (SELECT BusinessRuleID FROM tblBusinessRule WHERE Name = 'SetQuoteAdditionalFeeChoices')

IF @BusinessRuleID IS NOT NULL
BEGIN
	DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID = @BusinessRuleID

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', ';T1;', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', 'EW Selected', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
	VALUES ('SW', 2, 4, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
	VALUES ('PC', 31, 2, 1, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,9,10', ';T2;', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param3, Param4)
	VALUES ('PC', 31, 2, 2, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,9,10', 'Client Selected', 'LibertyGuardrailsStartDate')

	INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param4)
	VALUES ('PC', 31, 2, 3, @BusinessRuleID, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9', 'LibertyGuardrailsStartDate')

END
GO

