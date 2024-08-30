-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 140

-- IMEC 14380 - Data patch - sets bits to 0 so checkboxes are blank and then patch the data
UPDATE tblCaseDocuments SET MedsIncoming = 0, MedsToDoctor = 0
UPDATE tblCaseDocuments SET MedsIncoming = 1 WHERE CaseDocTypeID = 7 AND UserIDAdded LIKE '%@%'
GO

