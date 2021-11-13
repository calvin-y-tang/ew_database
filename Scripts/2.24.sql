EXEC sp_rename N'dbo.tblClaimInfo.PriorAuthNbr', N'CMSBox23', 'COLUMN'
EXEC sp_rename N'dbo.tblClaimInfo.DoctorNameWithDegree', N'CMSBox31Line1', 'COLUMN'
EXEC sp_rename N'dbo.tblClaimInfo.DoctorSpecialty', N'CMSBox31Line2', 'COLUMN'
EXEC sp_rename N'dbo.tblClaimInfo.DoctorNonNPINbr', N'CMSBox32b', 'COLUMN'
EXEC sp_rename N'dbo.tblClaimInfo.BillingProviderNonNPINbr', N'CMSBox33b', 'COLUMN'
GO

EXEC sp_rename 'tblDocument.blnWarnIfNoICD9CodesEntered', 'blnWarnIfNoICDCodesEntered', 'Column'
GO
EXEC sp_rename N'dbo.tblCase.ICD9Code', N'ICDCodeA', 'COLUMN'
EXEC sp_rename N'dbo.tblCase.ICD9Code2', N'ICDCodeB', 'COLUMN'
EXEC sp_rename N'dbo.tblCase.ICD9Code3', N'ICDCodeC', 'COLUMN'
EXEC sp_rename N'dbo.tblCase.ICD9Code4', N'ICDCodeD', 'COLUMN'
GO

EXEC sp_rename N'dbo.tblCaseICD9.ICD9Code', N'ICDCode', 'COLUMN'
EXEC sp_rename N'dbo.tblCaseICD9', N'tblCaseICDRequest'
GO
ALTER TABLE tblCaseICDRequest
  DROP CONSTRAINT PK_tblCaseICD9
GO
ALTER TABLE tblCaseICDRequest
  ADD CONSTRAINT PK_tblCaseICDRequest PRIMARY KEY (SeqNo)
GO

UPDATE tblCase SET ICDFormat = 9 WHERE ICDFormat IS NULL
GO
UPDATE tblICDCode SET ICDFormat = 9
GO
UPDATE tblIMEData SET DefaultICDFormat=9
GO

UPDATE tblControl SET DBVersion='2.24'
GO
