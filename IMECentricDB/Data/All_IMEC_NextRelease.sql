-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 144

-- IMEC-14733 - adding BR to give the option to choose the zip file import method
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
VALUES (207, ' DPSResultFileImportMethod', 'Case', ' DPS - Result File Import method: (1) info from tblDPSResultFileConfig or (2) info from JSON returned', 1, 1015, 0, ' RsltFileImportMthdID', 0)


