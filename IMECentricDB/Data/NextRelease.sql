-- Sprint 98

-- IMEC-13207 - new biz rules for Sentry WC Peer Reviews and WC Record Reviews
-- Generate Documents
DELETE 
  FROM tblBusinessRuleCondition 
 WHERE BusinessRuleID = 109
   AND EntityType = 'PC' 
   AND EntityID = 46
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES(109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL)
GO
-- Distribute Documents
DELETE 
  FROM tblBusinessRuleCondition 
 WHERE BusinessRuleID = 110
   AND EntityType = 'PC' 
   AND EntityID = 46
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES(110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL)
GO
-- Distribute Reports
DELETE 
  FROM tblBusinessRuleCondition 
 WHERE BusinessRuleID = 111
   AND EntityType = 'PC' 
   AND EntityID = 46
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES(111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL)
GO

-- IMEC-13184 business rules for allstate client validation prior to scheduling
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (145, 'VerifyClientType', 'Appointment', 'Verify client type value of client', 1, 1101, 0, 'CaseClientType', 'Required', 'ClientTypeString', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (145, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';1;3;4;13;', 'YES', 'Adjuster, Attorney, Attorney-Defense or Paralegal', NULL, NULL, 0, NULL),
       (145, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';1;3;4;13;', 'YES', 'Adjuster, Attorney, Attorney-Defense or Paralegal', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (146, 'ClientTypeRequirements', 'Appointment', 'Client and Attorney requirements based on client type', 1, 1101, 0, 'ClientType', 'ReqDefAtty', 'ReqBillToClient', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';1;', 'YES', 'NO', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';3;4;', 'NO', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';13;', 'YES', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';1;', 'YES', 'NO', NULL ,NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';3;4;', 'NO', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';13;', 'YES', 'YES', NULL, NULL, 0, NULL)
GO
-- IMEC-13184 - new security settings for Client Type Override
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('ClientTypeVerifyOverride','Case - Skip Client Type Validation', GETDATE())
GO
