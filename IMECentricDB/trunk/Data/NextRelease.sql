
-- -Issue 10022 - add new Exception trigger
INSERT INTO tblExceptionList (Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES('SLA Violation', 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin')
GO

-- Issue 10048 - no longer using field ExceptionAlert.  Replacing with AlertType.  Set the values
UPDATE tblCaseHistory SET AlertType = 1 WHERE ExceptionAlert = 1 OR FollowUpDate IS NOT NULL
