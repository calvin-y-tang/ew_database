-- Issue 10018 - business rule for create zip file with password
INSERT INTO tblSetting (Name, Value)
VALUES('AllowPWDZipFile', ';24;')
GO

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(103, 'DistAsZipToClient', 'Case', 'Distribute doc/rpt to client as a password protected zip file', 1, 1202, 0, 'Password', NULL, NULL, NULL, NULL, 0)
GO 
