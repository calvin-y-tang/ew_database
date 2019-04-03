
-- -Issue 10022 - add new Exception trigger
INSERT INTO tblExceptionList (Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES('SLA Violation', 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin')
GO

