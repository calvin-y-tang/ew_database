-- Issue 11469 - patch existing exception triggers to set "Type" value for "Case"
UPDATE tblExceptionList SET [Type] = 'Case' WHERE ExceptionID IN (1,2,3,5,6,10,11,12,13,14,15,16,17,18,19,20,22,25,26,27,28,29,30,31)
GO


-- Issue 11439 - add rows to tblCodes to add in office contact department types and values to be used in cboDepartment combo box for office Contacts
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Accounting', '1')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Customer Service', '2')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Medical Records', '3')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'QA', '4')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Scheduling', '5')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Other', '6')
INSERT INTO tblCodes (Category, SubCategory, Value) VALUES ('OfficeContactDeptCombo', 'Bill Review', '7')
