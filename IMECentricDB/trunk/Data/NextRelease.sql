-- Issue 11469 - patch existing exception triggers to set "Type" value for "Case"
UPDATE tblExceptionList SET [Type] = 'Case' WHERE ExceptionID IN (1,2,3,5,6,10,11,12,13,14,15,16,17,18,19,20,22,25,26,27,28,29,30,31)
GO


-- Issue 11439 - add rows to tblCodes to add in office contact department types and values to be used in cboDepartment combo box for office Contacts
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Accounting', '1')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Bill Review', '7')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Customer Service', '2')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Medical Records', '3')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'QA', '4')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Scheduling', '5')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Other', '6')
GO 

-- Issue 11469 - create new security token
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('CSExcept','Case Exception - Add/Edit/Delete','2020-02-11')
GO

-- Issue 11156 - Making company inactive, add new user function for company status change
insert into tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
values ('CompanyStatusChange', 'Company - Status Change', getdate())

INSERT INTO tblSetting (Name, Value) VALUES ('UseNewFeeSchedulingMenuItems', 'True')
GO


DELETE FROM tblTATCalculationMethodEvent
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (5, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (6, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (7, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (8, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (9, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (12, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (13, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (14, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (15, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (16, 1320)
GO

-- Issue 11509 - set default invoicing and vouchering fee schedule versions
  update tblOffice set [FSInvoiceSetting] = 1 where [FSInvoiceSetting] is null
  update tblOffice set [FSVoucherSetting] = 1 where [FSVoucherSetting] is null


  -- Issue 11122 - add fee schedule security tokens
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('ViewFeeScheduleCompany','Fee Schedule (Company) - View','2020-03-20')

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('ViewFeeScheduleOffice','Fee Schedule (Office) - View','2020-03-20')

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('AddFeeSchedOffice','Fee Schedule (Office) - Add','2020-03-20')

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('AddFeeSchedCompany','Fee Schedule (Company) - Add','2020-03-20')

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('DeleteFeeSchedCompany','Fee Schedule (Company) - Delete','2020-03-20')

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('DeleteFeeSchedOffice','Fee Schedule (Office) - Delete','2020-03-20')

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('EditFeeSchedCompany','Fee Schedule (Company) - Edit','2020-03-20')

INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('EditFeeSchedOffice','Fee Schedule (Office) - Edit','2020-03-20')

Go


-- Issue 11547 - Add Secondary Email for V2 Client Portal Notifications
INSERT INTO tblNotifyAudience
(
    NotifyEventID,
    NotifyMethodID,
    UserType,
    ActionType,
    DateAdded,
    UserIDAdded,
    DateEdited,
    UserIDEdited,
    DefaultPreferenceValue,
    TableType
)
SELECT
NotifyEventID,
NotifyMethodID,
'SD',
ActionType,
DateAdded,
UserIDAdded,
DateEdited,
UserIDEdited,
0,
TableType
FROM tblNotifyAudience
WHERE UserType='CL'
GO

UPDATE NP SET NP.UserType = WU.UserType 
from tblNotifyPreference AS NP INNER JOIN tblWebUser AS WU ON NP.WebUserID = WU.WebUserID

INSERT INTO tblNotifyPreference
  (
      WebUserID,
      NotifyEventID,
      NotifyMethodID,
      DateEdited,
      UserIDEdited,
      PreferenceValue,
      UserType
  )
  SELECT DISTINCT
  NP.WebUserID,
  NA.NotifyEventID,
  NA.NotifyMethodID,
  GETDATE(),
  'System',
  NA.DefaultPreferenceValue,
  NA.UserType
  FROM tblNotifyPreference AS NP
  INNER JOIN tblNotifyAudience AS NA ON NA.UserType = 'SD'
  WHERE NP.UserType = 'CL'

GO





insert into tbluserfunction (functioncode, functiondesc)
 select 'EditApptCancelReason', 'Appointment - Edit Cancel Reason'
 where not exists (select functionCode from tblUserFunction where functionCode='EditApptCancelReason')
GO
