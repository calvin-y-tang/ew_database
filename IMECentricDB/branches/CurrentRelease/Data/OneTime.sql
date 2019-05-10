-- Issue 10018 - business rule for create zip file with password
INSERT INTO tblSetting (Name, Value)
VALUES('AllowPWDZipFile', ';24;')
GO