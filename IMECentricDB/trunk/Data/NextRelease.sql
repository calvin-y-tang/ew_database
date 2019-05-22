
-- Issue 10046 - add tokens to table
INSERT INTO tblMessageToken (Name, Description)
VALUES (@ExamineeCertNbr@, NULL)
INSERT INTO tblMessageToken (Name, Description)
VALUES (@AttorneyCertNbr@, NULL)
GO


--