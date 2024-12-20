-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 143
IF NOT EXISTS (SELECT 1 FROM dbo.tblSetting WHERE [Name] = 'PreventDupInvoicesAndVouchers')
BEGIN
	INSERT INTO dbo.tblSetting ([Name], [Value]) VALUES ('PreventDupInvoicesAndVouchers', 'True')
END
GO

-- Sprint 143
-- IMEC- 14686 Checking CaseDate to Appointment Date
UPDATE tblBusinessRule SET Param3Desc='DaysbetwnApptC&ApptT' WHERE BusinessRuleID=188;
GO

-- Sprint 143
-- IMEC- 14678 Pop-up message styling updated
UPDATE tblBusinessRuleCondition SET Param6='ExamWorks now owes Allstate the following:-
• A $2500 penalty fee
• A refund of the testimony/deposition fee (if prepaid)
• A refund of the original IME/MMR service fee
                                     Thank you.' WHERE BusinessRuleConditionID=2001;
GO

-- Sprint 143
-- IMEC- 14680 Email language updated
 UPDATE tblBusinessRuleCondition SET Param6='Examworks users were notified that we owe Allstate a $2500 penalty for Case Number @casenbr@.' WHERE BusinessRuleConditionID=2002;
GO

-- IMEC-14600 - data patch for populating the new table used to keep track of case history notes for use overrides
INSERT INTO tblCaseHistoryOverrides (CasehistoryID)
SELECT ID FROM tblCaseHistory WHERE (Eventdesc LIKE '%guardrails override%' 
  OR Eventdesc LIKE '%QA Checklist completed with override%' 
  OR Eventdesc LIKE '%Doctor Scheduling Discipline Override%') AND EventDate > '2024-10-01 16:36:46.000'
ORDER BY EventDate
GO

-- IMEC-14657 - additional additional product for additonal Liberty fee = "Med Recs"
SET IDENTITY_INSERT tblProduct ON
INSERT INTO tblProduct (ProdCode, Description, LongDesc, Status, Taxable, INGLAcct,
      VOGLAcct, DateAdded, UserIDAdded, XferToVoucher, UnitOfMeasureCode, AllowVoNegativeAmount, AllowInvoice, AllowVoucher, IsStandard)
  Values(3060, 'Med Recs', 'Medical Records', 'Active', 1, '400??',
         '500??', GETDATE(), 'Admin', 0, 'PG', 0, 1, 0, 1)
SET IDENTITY_INSERT tblProduct OFF
GO

