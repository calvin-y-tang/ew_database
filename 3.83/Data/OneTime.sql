--IMECentricEW only
DELETE FROM tblBusinessRuleCondition 
WHERE BusinessRuleID in (109,110,111) 
  AND EntityID = 46 
  AND EntityType = 'PC'
GO
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

