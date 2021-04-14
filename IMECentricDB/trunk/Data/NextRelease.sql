-- Issue 12079 - add med status options to combo
INSERT INTO tblRecordStatus  (Description, DateAdded, UserIDAdded, PublishOnWeb)
VALUES ('Awaiting Declaration', GETDATE(), 'TLyde', 1),
       ('Declaration Received', GETDATE(), 'TLyde', 1)

GO

-- Issue 12026 - add new security token and items to tblSetting for CCMSI
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('CaseOverview', 'Case - CCMSI Overview', GETDATE())
GO
INSERT INTO tblSetting(Name, Value)
VALUES('CCMSIBaseAPIURL', 'https://api.terraclaim.com/connect/vendors/test/'),
      ('CCMSIAPISecurityToken', '31031783bcb8466abfc45521a2fdcfe9')
GO

