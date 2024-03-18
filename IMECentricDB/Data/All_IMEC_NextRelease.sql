-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 132

-- IMEC-14109 - new security token to lock down Doctor Accounting fields
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('DoctorEditAcctngFields', 'Doctor - Edit Accounting Fields', GETDATE())
GO

-- IMEC-13679 - data patch to set new tblCaseDocuments field DocumentSelect to 0 for checkbox to delete
UPDATE tblCaseDocuments SET DocumentSelect = 0
GO
