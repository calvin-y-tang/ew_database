-- Issue 12027 - add Content Type to be used in tblDocument & tblBusinessRuleCondition for Sentry
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
-- Issue 12027 - update param4 desc for tblBusinessRule
UPDATE tblBusinessRule
   SET Param4Desc = 'MatchOnContentType'
  FROM tblBusinessRule
 WHERE BusinessRuleID in (109,110,111)
GO
-- Issue 12027 - delete existing entries for sentry from tblBusinessRuleCondition
DELETE FROM tblBusinessRuleCondition 
WHERE BusinessRuleID in (109,110,111) 
  AND EntityID = 46 
  AND EntityType = 'PC'
GO
-- Issue 12027 - add new entries for Sentry to tblBusinessRuleCondition
INSERT INTO 
     tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited,
                              OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
       -- generate doc
VALUES ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Referral Confirmation', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Appointment Confirmation', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Fee Quote Notice', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Fee Approval Notice', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Medical Records Request', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'IME Cite Letter', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Appointment Delay', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Reschedule Notice', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Attendance Confirmation', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'No Show Notice', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Cancellation Notice', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'IME Report Cover Sheet', NULL),
       ('PC', 46, 2, 1, 109, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'SentryMbrMgmt@sentry.com', '', 'Invoice Status Inquiries', NULL),
       -- distribute doc
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Referral Confirmation', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Appointment Confirmation', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Fee Quote Notice', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Fee Approval Notice', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Medical Records Request', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'IME Cite Letter', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Appointment Delay', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Reschedule Notice', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Attendance Confirmation', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'No Show Notice', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Cancellation Notice', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'IME Report Cover Sheet', NULL),
       ('PC', 46, 2, 1, 110, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'SentryMbrMgmt@sentry.com', '', 'Invoice Status Inquiries', NULL),
       -- distribute rpt
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Referral Confirmation', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Appointment Confirmation', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Fee Quote Notice', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Fee Approval Notice', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'WCClaimTechStPtEast@sentry.com', '', 'Medical Records Request', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'IME Cite Letter', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Appointment Delay', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Reschedule Notice', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Attendance Confirmation', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'No Show Notice', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'Cancellation Notice', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'ClaimsMail@sentry.com', '', 'IME Report Cover Sheet', NULL),
       ('PC', 46, 2, 1, 111, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 1, 'SentryMbrMgmt@sentry.com', '', 'Invoice Status Inquiries', NULL)

GO

-- Issue 12011 - storing appt letter content type here
insert into tblSetting (Name, Value)
Values ('ApptLetterContentType', 'Appointment Confirmation')


Go
  

