-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 136

-- IMEC-14227 (IMEC-14235) - add token and update bizRule details on all DBs to keep them in sync
UPDATE tblBusinessRule
   SET Param5Desc = 'SecurityToken', 
       Param6Desc = 'ServiceCode', 
       AllowOverride = 1
WHERE BusinessRuleID = 130
GO

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('CaseSkipReqFieldCheck','Case -Override Required Field Validation (BusRule)', GETDATE())
GO
