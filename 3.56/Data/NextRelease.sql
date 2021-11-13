

-- Issue 11119 - add new item to tblExceptioList for Generate Quote Document
INSERT INTO tblExceptionList (ExceptionID, Description, Status, DateAdded, UserIDAdded, DateEdited, UserIDEdited)
VALUES(31, 'Generate Quote Document', 'Active', '2019-06-21 09:28:00.000', 'Admin', '2019-06-21 09:28:00.000', 'Admin')
GO 


-- Issue 11142 - Network Fee Schedule Calculation Method (switch between "new" and "old" fee schedule tables)
INSERT INTO tblSetting(Name, Value)
VALUES('NetworkFeeSchedCalcMethod', '1')
GO

-- Issue 10243 - add new status queue form to list of forms available for choosing
  INSERT INTO [tblQueueForms] ([FormName], [Description])
  VALUES ('frmStatusMedRecsDue', 'Form with Medical Records Due Date')


--*****  Issue 11152 - add business rules for MI Auto Authorization - add rules to the tables when ready to turn on

----  *******  Setting BusinessRuleID to 12 – if changed, need to change below
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(12, 'ValidDrDocForSched', 'Appointment', 'Doctor must have the valid document on file when scheduling appointments', 1, 1101, 0, 'Document Type ID', NULL, NULL, NULL, NULL, 0)

















