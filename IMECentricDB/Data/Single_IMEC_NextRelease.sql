-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against a single IMECentric database. 
--	You must specify which database to apply with a USE statement

--	Example
--	USE [IMECentricEW]
--	GO
--	{script to apply}
--	GO

-- --------------------------------------------------------------------------

-- Sprint 142

-- IMEC-14445 - Changes to Implement Liberty QA Questions Feature for Finalize Report
USE IMECentricEW
GO 
-- Populate Question tables
     SET IDENTITY_INSERT tblQuestion ON 
     GO
          INSERT INTO tblQuestion(QuestionID, QuestionText, DateAdded, UserIDAdded)
               VALUES (1, 'The date of injury is documented in the report and claim number is listed.', GETDATE(), 'System'),
                      (2, 'Doctor-patient relationship statement is contained in report or file contains a signed attestation. (attestation available in IMEC)', GETDATE(), 'System'),
                      (3, 'Report is void of spelling and grammatical errors.', GETDATE(), 'System'),
                      (4, 'Key issues/referral questions are addressed. All questions in the cover letter from Liberty are acknowledged and answered in the report.', GETDATE(), 'System'),
                      (5, 'IME provider has listed the records reviewed including treating provider/facility name by date of service or date of service range.', GETDATE(), 'System'),
                      (6, 'Report contains a comprehensive summary of past medical history and/or comorbidities.', GETDATE(), 'System'),
                      (7, 'IME provider documented and supported their impression. All abilities and restrictions have timeframes associated.', GETDATE(), 'System'),
                      (8, 'Claimant proof of identification is included in file or signed attestation present in case. (attestation available in IMEC)', GETDATE(), 'System'),
                      (9, 'The date of injury is documented in the report.', GETDATE(), 'System')
     GO
     SET IDENTITY_INSERT tblQuestion OFF
     GO
     --
     SET IDENTITY_INSERT tblQuestionSet ON 
     GO
          INSERT INTO tblQuestionSet(QuestionSetID, ProcessOrder, ParentCompanyID, CompanyCode, CaseType, Jurisdiction, EWServiceTYpeID, ServiceCode, OfficeCode, Active, DateAdded, UserIDAdded)
               VALUES(1, 1, 31, NULL, NULL, NULL, 2, NULL, NULL, 1, GETDATE(), 'System'),
                     (2, 2, 31, NULL, NULL, NULL, 1, NULL, NULL, 1, GETDATE(), 'System'),
                     (3, 3, 31, NULL, NULL, NULL, 3, NULL, NULL, 1, GETDATE(), 'System')
     GO
     SET IDENTITY_INSERT tblQuestionSet OFF
     GO
     --
     SET IDENTITY_INSERT tblQuestionSetDetail ON 
     GO
          INSERT INTO tblQuestionSetDetail(QuestionSetDetailID, QuestionSetID, DisplayOrder, QuestionID, DateAdded, UserIDAdded)
               VALUES(1, 1, 1, 1, GETDATE(), 'System'),
                     (2, 1, 2, 2, GETDATE(), 'System'),
                     (3, 1, 3, 3, GETDATE(), 'System'),
                     (4, 1, 4, 4, GETDATE(), 'System'),
                     (5, 1, 5, 5, GETDATE(), 'System'),
                     (6, 1, 6, 6, GETDATE(), 'System'),
                     (7, 1, 7, 7, GETDATE(), 'System'),
                     (8, 2, 1, 8, GETDATE(), 'System'),
                     (9, 2, 2, 9, GETDATE(), 'System'),
                     (10, 2, 3, 2, GETDATE(), 'System'),
                     (11, 2, 4, 3, GETDATE(), 'System'),
                     (12, 2, 5, 4, GETDATE(), 'System'),
                     (13, 2, 6, 5, GETDATE(), 'System'),
                     (14, 2, 7, 6, GETDATE(), 'System'),
                     (15, 2, 8, 7, GETDATE(), 'System'), 
                     (16, 3, 1, 1, GETDATE(), 'System'),
                     (17, 3, 2, 2, GETDATE(), 'System'),
                     (18, 3, 3, 3, GETDATE(), 'System'),
                     (19, 3, 4, 4, GETDATE(), 'System'),
                     (20, 3, 5, 5, GETDATE(), 'System'),
                     (21, 3, 6, 6, GETDATE(), 'System'),
                     (22, 3, 7, 7, GETDATE(), 'System')
     GO
     SET IDENTITY_INSERT tblQuestionSetDetail OFF
     GO

--IMEC-14442 - iCase Pop up Text messages for Liberty Mutual (PC)
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblSetting]
           ([Name],[Value]) VALUES
           ('LibertyICaseRefPopMsgStartDate', '2024/10/01')
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (183,'ScheduleAppointmentMsgs','Appointment','Liberty iCase Scheduled', 1, 1101, 0, 'HasPrevAppts', NULL, NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (190,'ApptStatusChangeMsgs','Appointment','When appointment Status is changed for Liberty Company cases when iCase referral is checked', 1, 1106, 0, 'ShowMsg', 'NoShowMsg', 'UTEMsg', 'UTEMsg1', NULL, 0, 'PopupTextMessage')
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (193,'CancelAppointmentMsgs','Appointment','When appointment is cancelled for Liberty Company cases when iCase referral is checked', 1, 1105, 0, NULL, NULL, NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (194,'InvoiceQuotetMsgs','Appointment','When invoice quote is created for Liberty Company cases when iCase referral is checked', 1, 1060, 0, 'QuoteApproval', 'DoctorTier', NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,183,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,'No',NULL,NULL,NULL,NULL,0,'We have scheduled the exam for @Examineename@, claim number: @claimnbr@, EW case #: @casenbr@. The exam will take place with @doctorname@, @doctorspecialty@ at @ExamLocation@ on @apptdate@ @appttime@. -@Username@, @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,183,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,'Yes',NULL,NULL,NULL,NULL,0,'We have rescheduled the exam for @Examineename@, claim number: @claimnbr@, EW case #: @casenbr@. The exam has been rescheduled because of @cancelreason@. The exam will now take place with @doctorname@, @doctorspecialty@ at @ExamLocation@ on @apptdate@ @appttime@. Please remember to notify the translation and/or transportation vendors, if applicable. -@Username@, @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,190,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,' attended ',' did not attend ',' attended but was unable to be examined at ','The claimant was unable to be examined because ',NULL,0,'@Examineename@. claim number: @claimnbr@, EW case #: @casenbr@ @apptmsg@ their appointment that was scheduled with @doctorname@, @doctorspecialty@ at @ExamLocation@ on @apptdate@ @appttime@. @utemsg@ @cancelreason@ -@Username@, @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,193,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'We have cancelled the exam for @Examineename@, claim number: @claimnbr@, EW case #: @casenbr@. The exam has been cancelled on @cancelapptdate@ because of @cancelreason@. Please remember to notify the translation and/or transportation vendors, if applicable. -@Username@, @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,2,NULL,1,NULL,NULL,NULL,NULL,0,'ExamWorks Fee Notice (Approval Required)  @Clientname@,   Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:       Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@      If you have any questions or concerns, please reply by return email or contact our office.        Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,2,NULL,1,NULL,NULL,NULL,NULL,0,'ExamWorks Fee Notice (Approval Required)  @Clientname@,   Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:       Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@      If you have any questions or concerns, please reply by return email or contact our office.        Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,2,NULL,1,NULL,NULL,NULL,NULL,0,'ExamWorks Fee Notice (Approval Required)  @Clientname@,   Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:       Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@      If you have any questions or concerns, please reply by return email or contact our office.        Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,3,NULL,1,NULL,NULL,NULL,NULL,0,'ExamWorks Fee Notice (Approval Required)  @Clientname@,   Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:       Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@      If you have any questions or concerns, please reply by return email or contact our office.        Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,3,NULL,1,NULL,NULL,NULL,NULL,0,'ExamWorks Fee Notice (Approval Required)  @Clientname@,   Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:       Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@      If you have any questions or concerns, please reply by return email or contact our office.        Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,3,NULL,1,NULL,NULL,NULL,NULL,0,'ExamWorks Fee Notice (Approval Required)  @Clientname@,   Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:       Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@      If you have any questions or concerns, please reply by return email or contact our office.        Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,2,NULL,2,NULL,NULL,NULL,NULL,0,' ExamWorks Fee Notice  @Clientname@,          Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@            If you have any questions or concerns, please reply by return email or contact our office.         Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,2,NULL,2,NULL,NULL,NULL,NULL,0,' ExamWorks Fee Notice  @Clientname@,          Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@            If you have any questions or concerns, please reply by return email or contact our office.         Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,2,NULL,2,NULL,NULL,NULL,NULL,0,' ExamWorks Fee Notice  @Clientname@,          Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@            If you have any questions or concerns, please reply by return email or contact our office.         Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,3,NULL,2,NULL,NULL,NULL,NULL,0,' ExamWorks Fee Notice  @Clientname@,          Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@            If you have any questions or concerns, please reply by return email or contact our office.         Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,3,NULL,2,NULL,NULL,NULL,NULL,0,' ExamWorks Fee Notice  @Clientname@,          Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@            If you have any questions or concerns, please reply by return email or contact our office.         Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,3,NULL,2,NULL,NULL,NULL,NULL,0,' ExamWorks Fee Notice  @Clientname@,          Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @ServiceDesc@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@            If you have any questions or concerns, please reply by return email or contact our office.         Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,1,'T1',NULL,NULL,NULL,0,' ExamWorks Fee Notice (Approval Required)  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:     Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@              Notify ExamWorks of Cancellation no later than [late cancellation days] (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                  If you have any questions or concerns, please reply by return email or contact our office.           Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,1,'T1',NULL,NULL,NULL,0,' ExamWorks Fee Notice (Approval Required)  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:     Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@              Notify ExamWorks of Cancellation no later than [late cancellation days] (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                  If you have any questions or concerns, please reply by return email or contact our office.           Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,1,'T1',NULL,NULL,NULL,0,' ExamWorks Fee Notice (Approval Required)  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:     Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@              Notify ExamWorks of Cancellation no later than [late cancellation days] (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                  If you have any questions or concerns, please reply by return email or contact our office.           Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,2,'T1',NULL,NULL,NULL,0,'ExamWorks Fee Notice  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                If you have any questions or concerns, please reply by return email or contact our office.             Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,2,'T1',NULL,NULL,NULL,0,'ExamWorks Fee Notice  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                If you have any questions or concerns, please reply by return email or contact our office.             Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,2,'T1',NULL,NULL,NULL,0,'ExamWorks Fee Notice  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                If you have any questions or concerns, please reply by return email or contact our office.             Thank you.       @Username@       @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,1,'T2;NORECORD;',NULL,NULL,NULL,0,' ExamWorks Fee Notice (Approval Required)  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.               If you have any questions or concerns, please reply by return email or contact our office.            Thank you.      Username@      @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,1,'T2;NORECORD;',NULL,NULL,NULL,0,' ExamWorks Fee Notice (Approval Required)  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.               If you have any questions or concerns, please reply by return email or contact our office.            Thank you.      Username@      @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,1,'T2;NORECORD;',NULL,NULL,NULL,0,' ExamWorks Fee Notice (Approval Required)  @Clientname@,            Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:         Physician Name: @doctorname@       Physician Specialty: @doctorspecialty@       Physician State: @DoctorAddr3@       @QuoteComment@      Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@       No Show Fee    @QuoteNoShowFee@       Late Cancel Fee    @QuoteLateCancelFee@       Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.               If you have any questions or concerns, please reply by return email or contact our office.            Thank you.      Username@      @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,2,'T2;NORECORD;',NULL,NULL,NULL,0,'ExamWorks Fee Notice  @Clientname@,        Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:        Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @QuoteComment@     Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@      No Show Fee    @QuoteNoShowFee@      Late Cancel Fee    @QuoteLateCancelFee@      Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.              If you have any questions or concerns, please reply by return email or contact our office.          Thank you.      @Username@      @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,2,'T2;NORECORD;',NULL,NULL,NULL,0,'ExamWorks Fee Notice  @Clientname@,        Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:        Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @QuoteComment@     Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@      No Show Fee    @QuoteNoShowFee@      Late Cancel Fee    @QuoteLateCancelFee@      Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.              If you have any questions or concerns, please reply by return email or contact our office.          Thank you.      @Username@      @UserPhone@',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,2,'T2;NORECORD;',NULL,NULL,NULL,0,'ExamWorks Fee Notice  @Clientname@,        Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:        Physician Name: @doctorname@      Physician Specialty: @doctorspecialty@      Physician State: @DoctorAddr3@      @QuoteComment@     Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@      No Show Fee    @QuoteNoShowFee@      Late Cancel Fee    @QuoteLateCancelFee@      Additional Applicable Fees:       Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@   Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@   Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@   Travel: @QuoteTravelFee@ @QuoteTravelUnit@   Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@   Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@   Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.    The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.    In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.              If you have any questions or concerns, please reply by return email or contact our office.          Thank you.      @Username@      @UserPhone@',0)
GO



