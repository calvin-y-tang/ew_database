-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 142

-- IMEC-14445 - Changes to Implement Liberty QA Questions Feature for Finalize Report
-- Ensure that all tables are empty
	DELETE FROM tblQuestionSet
	GO 
	DELETE FROM tblQuestionSetDetail
	GO
-- New security token
	INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
		VALUES('CaseQAChecklistOverride', 'Case - QA Questions Override', GETDATE())
	GO

