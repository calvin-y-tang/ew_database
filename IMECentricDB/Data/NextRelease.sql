-- Sprint 123


-- IMEC-13930 - O365 Changes for Xmedius Faxing feature.
INSERT INTO tblSetting(Name, Value)
VALUES('FaxSysFormat', 'Default'),
      ('FaxPhonePrefix','91')
GO


-- IMEC-13942 - set default values for column [InvTaxCalcMethod] in tblAcctHeader
UPDATE tblAcctHeader SET InvTaxCalcMethod = 0
GO


