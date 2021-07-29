
-- Issue 12222 - new setting for require out of network reason on quote form.
ALTER TABLE EWParentCompany ADD [RequireOutofNetworkReason] BIT CONSTRAINT [DF_tblEWParentCompany_RequireOutofNetworkReason] DEFAULT (0)
GO
UPDATE tblEWParentCompany SET RequireOutofNetworkReason = 0
GO
UPDATE tblEWParentCompany SET RequireOutofNetworkReason = 1 WHERE ParentCompanyID = 9
GO
