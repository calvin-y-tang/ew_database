-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------
-- sprint 146


-- **** Canadian DB change ***************
-- IMEC-14824 - Add case priority values for DirectIME
USE [IMECentricDirectIME]
INSERT INTO tblPriority (PriorityCode, Description, DateAdded, UserIDAdded, Rank)
VALUES ('24Hr', '24 Hour Rush', GETDATE(), 'Admin', 30),
       ('5Day', '5 Day Rush', GETDATE(), 'Admin', 60),
       ('10Day', '10 Day Rush', GETDATE(), 'Admin', 70),
       ('RushVerbal', 'Rush Verbal', GETDATE(), 'Admin', 90)



