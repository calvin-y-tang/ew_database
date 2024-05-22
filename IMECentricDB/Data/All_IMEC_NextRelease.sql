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


-- IMEC-14234 - Adding in entry to tblCodes for ToDate box on invoice sub form to be enabled if EWFacility combo box is set to one of the values
INSERT INTO tblCodes (Category, SubCategory, Value)
VALUES ('TexasFacilityCombo', 'ToDateEnabled', ';5;')
GO
