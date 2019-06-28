

-- Issue 11119 - add new item to tblExceptioList for Generate Quote Document
INSERT INTO tblExceptionList (ExceptionID, Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES(31, 'Generate Quote Document', 'Active', '2019-06-21 09:28:00.000', 'Admin', '2019-06-21 09:28:00.000', 'Admin')
GO 


-- Issue 11142 - Network Fee Schedule Calculation Method (switch between "new" and "old" fee schedule tables)
INSERT INTO tblSetting(Name, Value)
VALUES('NetworkFeeSchedCalcMethod', '1')
GO



