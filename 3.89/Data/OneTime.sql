
-- Issue 12222 - new setting for require out of network reason on quote form.
ALTER TABLE EWParentCompany ADD [RequireOutofNetworkReason] BIT CONSTRAINT [DF_tblEWParentCompany_RequireOutofNetworkReason] DEFAULT (0)
GO
UPDATE tblEWParentCompany SET RequireOutofNetworkReason = 0
GO
UPDATE tblEWParentCompany SET RequireOutofNetworkReason = 1 WHERE ParentCompanyID = 9
GO


-- Issue 12221 - change columns [EWSelected], [InNetwork] from Bit to Int
  ALTER TABLE tblQuoteRule DROP CONSTRAINT [DF_tblQuoteRule_EWSelected]
  ALTER TABLE tblQuoteRule DROP CONSTRAINT [DF_tblQuoteRule_InNetwork]
  GO

  ALTER TABLE tblQuoteRule ALTER COLUMN EWSelected INT
  ALTER TABLE tblQuoteRule ALTER COLUMN InNetwork INT
  GO

  ALTER TABLE tblQuoteRule ADD CONSTRAINT [DF_tblQuoteRule_EWSelected] DEFAULT ((2)) FOR [EWSelected]
  ALTER TABLE tblQuoteRule ADD CONSTRAINT [DF_tblQuoteRule_InNetwork] DEFAULT ((2)) FOR [InNetwork]
  GO

-- Issue 12222 - data patch items in tblCaseHistory from quote to correct type 
UPDATE tblCaseHistory SET Type = 'ACCT' WHERE Type = 'ACCT Quote'
GO

-- Issue 12216 - patch tblCaseAppt.DoctorReason for active cases
UPDATE tblCaseAppt 
   SET DoctorReason = C.DoctorReason 
FROM tblCaseAppt AS CA
          INNER JOIN tblCase AS C ON c.CaseApptID = ca.CaseApptID
WHERE C.Status NOT IN (8, 9)
GO
