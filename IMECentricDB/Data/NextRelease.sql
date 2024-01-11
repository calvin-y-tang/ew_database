-- Sprint 127

-- IMEC-13994 - Add email address for when RPA document intake errors occur with referral numbers
INSERT INTO tblSetting (Name, Value)
VALUES ('EmailForRefrlErr_RPA_Liberty', 'william.cecil@examworks.com')
GO

-- IMEC-13980 - Add email address for when RPA document intake errors occur with case numbers for Progressive
INSERT INTO tblSetting (Name, Value)
VALUES ('EmailForCaseNbrErr_RPA_Prog', 'william.cecil@examworks.com;liabilitydocuments@examworks.com')
GO

-- IMEC-12979 - Add setting for the number of times the code tries to copy the documents before failing
INSERT INTO tblSetting (Name, Value)
VALUES ('EnvelopRecopyAttemptCount', '3')
GO

-- IMEC-13610 - data patch for Liberty referrals missing NotiCaseReferral data in tblCustomerData.Param
USE IMECentricEW
UPDATE tblCustomerData SET Param = Param + ';NotiCaseReferral="0"'
WHERE TableType = 'tblCase' AND CustomerName = 'Liberty Mutual' AND Param NOT LIKE '%NotiCase%'
GO

