insert into tblCodes (Category, SubCategory, Value)
Values ('DocumentContentType', 'Referral Confirmation', 1), 
       ('DocumentContentType', 'Appointment Confirmation', 2), 
       ('DocumentContentType', 'Fee Quote Notice', 3), 
       ('DocumentContentType', 'Fee Approval Notice', 4), 
       ('DocumentContentType', 'Medical Records Request', 5), 
       ('DocumentContentType', 'IME Cite Letter', 6), 
       ('DocumentContentType', 'Appointment Delay', 7), 
       ('DocumentContentType', 'Physician Selection', 8), 
       ('DocumentContentType', 'Cover Letter Request', 9), 
       ('DocumentContentType', 'Reschedule Notice', 10), 
       ('DocumentContentType', 'Attendance Confirmation', 11), 
       ('DocumentContentType', 'No Show Notice', 12), 
       ('DocumentContentType', 'IME Report Cover Sheet', 13), 
       ('DocumentContentType', 'Invoice', 14), 
       ('DocumentContentType', 'Voucher', 15), 
       ('DocumentContentType', 'Invoice Status Inquiries', 16), 
       ('DocumentContentType', 'Cancellation Notice', 17)

GO
UPDATE tblBusinessRule
   SET Param4Desc = 'MatchOnContentType'
  FROM tblBusinessRule
 WHERE BusinessRuleID in (109,110,111)
GO


insert into tblSetting (Name, Value)
Values ('ApptLetterContentType', 'Appointment Confirmation')


Go
  

