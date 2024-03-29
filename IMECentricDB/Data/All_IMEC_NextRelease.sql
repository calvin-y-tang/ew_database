-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 132

-- IMEC-14109 - new security token to lock down Doctor Accounting fields
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('DoctorEditAcctngFields', 'Doctor - Edit Accounting Fields', GETDATE())
GO

-- IMEC-14110 - new security tokem to enable changes for Specialty Do Not Use setting
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('DoctorEditSpecialtyDoNotUse', 'Doctor - Update Specialty Do Not Use', GETDATE())
GO

-- IMEC-14076 - Business Rules to drive new "WCCaseTypeAddressee" bookmark 
-- **** DEV NOTE: This was undone in a rollback and needs to be re-applied
UPDATE tblBusinessRule
  SET EventID = 1201
WHERE Name = 'DynamicBookmarks'
GO