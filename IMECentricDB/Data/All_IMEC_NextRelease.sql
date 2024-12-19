-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 143
IF NOT EXISTS (SELECT 1 FROM dbo.tblSetting WHERE [Name] = 'PreventDupInvoicesAndVouchers')
BEGIN
	INSERT INTO dbo.tblSetting ([Name], [Value]) VALUES ('PreventDupInvoicesAndVouchers', 'True')
END


-- IMEC-14600 - data patch for populating the new table used to keep track of case history notes for use overrides
INSERT INTO tblCaseHistoryOverrides (CasehistoryID)
SELECT ID FROM tblCaseHistory WHERE (Eventdesc LIKE '%guardrails override%' 
  OR Eventdesc LIKE '%QA Checklist completed with override%' 
  OR Eventdesc LIKE '%Doctor Scheduling Discipline Override%') AND EventDate > '2024-10-01 16:36:46.000'
ORDER BY EventDate
GO

