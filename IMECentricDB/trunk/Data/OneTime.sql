
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
