-- Issue 11799 - new document tokens and Security tokens
INSERT INTO tblMessageToken(Name, Description)
VALUES ('@CurrentDate@', ''),
       ('@CurrentDateTime@', '')
GO
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('DocEditElecTransfer', 'Documents - Modify Electronic Transfer Settings', '2020-09-30')
GO


-- Issue 11806 – increased the size of the client email fields in 2 DBs

ALTER TABLE EWDataRepository.dbo.Client ALTER COLUMN Email VARCHAR (150) NULL

ALTER TABLE IMECentricMaster.dbo.GPClient ALTER COLUMN Email VARCHAR (150) NULL


