-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 143
-- IMEC-14485 - email documents for Chubb
USE [IMECentricEW]
GO

INSERT INTO tblBusinessRuleCondition (
    EntityType,         -- Type of entity (e.g., 'CO', 'PC', 'SW')
    EntityID,           -- The unique ID of the entity; Foreign Key to tblCompany
    BillingEntity,      -- Case Client or Company Client and we are looking for both
    ProcessOrder,       -- The priority
    BusinessRuleID,     -- Business Rule ID (foreign key to the tblBusinessRule)
    DateAdded,          -- Date and time when the record was added (using GETDATE())
    UserIDAdded,        -- User who added the record ('Admin' in this case)
    DateEdited,         -- Date and time when the record was last edited (using GETDATE())
    UserIDEdited,       -- User who last edited the record ('Admin' in this case)
    Param1,             -- SET to 2 for all kinds of emal with or without attachments
    Param2,             -- An additional parameter (email in this case)
    Param4,              -- Indicating documentype in this case
    Skip                -- A flag (0 means no skip)
)
VALUES   
    ('CO',4121,2,1,109,GETDATE(),'Admin',GETDATE(),'Admin',2,'WCClaimse3@Chubb.com','ALL',0),
	('CO',4121,2,1,110,GETDATE(),'Admin',GETDATE(),'Admin',2,'WCClaimse3@Chubb.com','ALL',0),
	('CO',4121,2,1,111,GETDATE(),'Admin',GETDATE(),'Admin',2,'WCClaimse3@Chubb.com','ALL',0)
GO

-- IMEC-14578 - security token and Biz Rules for Doctor Discipline Status validation when scheduling case
-- need new security token
USE [IMECentricEW]
GO
    INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
    VALUES('LibertySchedulingOverride', 'Appointments - Liberty Schedule Doctor Override', GETDATE())
    GO

-- need new bizRules
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (139, 'ApplyDoctorDiscipline', 'Appointment', 'Apply Doctor Discipline Status Criteria when scheduling', 1, 1101, 0, 'tblSettingStartDate', 'CriteriaNotMetMsg', NULL, NULL, 'SecOverrideToken', 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
    VALUES (139, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'LibertyGuardrailsStartDate', 'The selected doctor doesn''t meet Liberty''s credentialing requirements for discipline.', NULL, NULL, 'LibertySchedulingOverride', 0, NULL, 0)
    GO

    -- just create the rule; we will deploy with no doctors being exempt and them as the need arises
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (123, 'ExemptDoctorDiscipline', 'Appointment', 'Exempt from Doctor Discipline Status Criteria when scheduling', 1, 1101, 0, 'DoctorCode', NULL, NULL, NULL, NULL, 0, NULL)
    GO

USE [IMECentricEW]
GO

-- IMEC-14645 - Liberty quote guardrails - business rule for med rec page calculations - Exclude WA workers comp
  --   (18) Service Fee > 500 - ProdCode = 3030; exclude WA for workers comp - no service fee
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 3, 'WA', '3030')
GO

-- IMEC-14646 - Liberty quote guardrails - business rule for med rec page calculations - add Record review
--   (19) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 1, 3, 'T1', '250', '385', '0.2', '250')
GO

--   (20) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 5, 3, 'T1', '250', '385', '0.2', '250')
GO

--   (21) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 3, 'CA', 'T1', '385', '0.35', '250')
GO

--   (22) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Record review; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 3, 'WA', 'T1', '385', '0.35', '250')
GO

--   (23) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 3, 'CA', 'T1', '385', '0.35', '250')
GO

--   (24) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Record review; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 3, 'WA', 'T1', '385', '0.35', '250')
GO

--   (25) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = Record review; Jurisdiction 'MI'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 2, 3, 'MI', 'T1', '385')
GO

