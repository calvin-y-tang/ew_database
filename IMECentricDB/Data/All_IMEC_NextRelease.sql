-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 143
IF NOT EXISTS (SELECT 1 FROM dbo.tblSetting WHERE [Name] = 'PreventDupInvoicesAndVouchers')
BEGIN
	INSERT INTO dbo.tblSetting ([Name], [Value]) VALUES ('PreventDupInvoicesAndVouchers', 'True')
END

-- Sprint 143
-- IMEC- 14686 Checking CaseDate to Appointment Date
UPDATE tblBusinessRule SET Param3Desc='DaysbetwnApptC&ApptT' WHERE BusinessRuleID=188;

-- Sprint 143
-- IMEC- 14678 Pop-up message styling updated
UPDATE tblBusinessRuleCondition SET Param6='ExamWorks now owes Allstate the following:-
• A $2500 penalty fee
• A refund of the testimony/deposition fee (if prepaid)
• A refund of the original IME/MMR service fee
                                     Thank you.' WHERE BusinessRuleConditionID=2001;

-- Sprint 143
-- IMEC- 14680 Email language updated
 UPDATE tblBusinessRuleCondition SET Param6='Examworks users were notified that we owe Allstate a $2500 penalty for Case Number @casenbr@.' WHERE BusinessRuleConditionID=2002;