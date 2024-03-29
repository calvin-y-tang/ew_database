-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 132

-- IMEC-14139 - new security token to be used to override not processing South Dakota Cases
USE [IMECentricEW]
GO
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('SDOverrideCase', 'Case - South Dakota Override', GETDATE())
GO

USE [IMECentricFCE]
GO
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('SDOverrideCase', 'Case - South Dakota Override', GETDATE())
GO

USE [IMECentricMIMedSource]
GO
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('SDOverrideCase', 'Case - South Dakota Override', GETDATE())
GO

USE [IMECentricJBA]
GO
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('SDOverrideCase', 'Case - South Dakota Override', GETDATE())
GO

