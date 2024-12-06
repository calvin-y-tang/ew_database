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
