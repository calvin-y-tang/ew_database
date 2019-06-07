
-- Issue 10046 - add tokens to table
INSERT INTO tblMessageToken (Name, Description)
VALUES (@ExamineeCertNbr@, NULL)
INSERT INTO tblMessageToken (Name, Description)
VALUES (@AttorneyCertNbr@, NULL)
GO


--
-- Issue 11086 - data patch for new IsNew column - set all values to 0
UPDATE tblCase SET IsNew = 0 WHERE 1=1

