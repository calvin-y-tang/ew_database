-- Sprint 127

-- IMEC-13994 - Add email address for when RPA document intake errors occur with referral numbers
INSERT INTO tblSetting (Name, Value)
VALUES ('EmailForRefrlErr_RPA_Liberty', 'william.cecil@examworks.com')
GO

-- IMEC-13980 - Add email address for when RPA document intake errors occur with case numbers for Progressive
INSERT INTO tblSetting (Name, Value)
VALUES ('EmailForCaseNbrErr_RPA_Prog', 'william.cecil@examworks.com;liabilitydocuments@examworks.com')
GO

