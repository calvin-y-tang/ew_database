-- Issue 11799 - new document tokens and Security tokens
INSERT INTO tblMessageToken(Name, Description)
VALUES ('@CurrentDate@', ''),
       ('@CurrentDateTime@', '')
GO
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('DocEditElecTransfer', 'Documents - Modify Electronic Transfer Settings', '2020-09-30')
GO

