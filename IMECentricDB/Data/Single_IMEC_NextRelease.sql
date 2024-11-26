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
---------------------------iCase Popup Msgs to be shown for the Cases Created on or after 10/01/2024----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblSetting]
           ([Name],[Value]) VALUES
           ('LibertyICaseRefPopMsgStartDate', '2024/10/01')
GO
---------------------------iCase - Schedule Re-Schedule----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (183,'ScheduleAppointmentMsgs','Appointment','Liberty iCase Scheduled', 1, 1101, 0, 'HasPrevAppts', NULL, NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

----------------------------iCase - Appointment Status Change ----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (190,'ApptStatusChangeMsgs','Appointment','When appointment Status is changed for Liberty Company cases when iCase referral is checked', 1, 1106, 0, 'ShowMsg', 'NoShowMsg', 'UTEMsg', 'UTEMsg1', NULL, 0, 'PopupTextMessage')
GO

----------------------------iCase - Appointment Cancel ----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (193,'CancelAppointmentMsgs','Appointment','When appointment is cancelled for Liberty Company cases when iCase referral is checked', 1, 1105, 0, NULL, NULL, NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

----------------------------iCase - Invoice  Quote----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (194,'InvoiceQuotetMsgs','Appointment','When invoice quote is created for Liberty Company cases when iCase referral is checked', 1, 1060, 0, 'QuoteApproval', 'DoctorTier', NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

----------------------------iCase - Panel Exam Schedule Re-Schedule----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (201,'ScheduleApptMsgsPanelExam','Appointment','Liberty iCase Scheduled Panel Exam', 1, 1101, 0, 'HasPrevAppts', NULL, NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

----------------------------iCase - Panel Exam Cancel Appointments ----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRule]
           ([BusinessRuleID],[Name],[Category],[Descrip],[IsActive],[EventID],[AllowOverride],[Param1Desc],[Param2Desc],[Param3Desc],[Param4Desc],[Param5Desc],[BrokenRuleAction],[Param6Desc])
		   VALUES (202,'CancelApptMsgsPanelExam','Appointment','Liberty iCase Appointment Cancel Msg in Panel Exam', 1, 1105, 0, NULL, NULL, NULL, NULL, NULL, 0, 'PopupTextMessage')
GO

---------------------------iCase Schedule----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,183,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,'No',NULL,NULL,NULL,NULL,0,'
We have scheduled the exam for @Examineename@,
claim number: @claimnbr@, 
EW case #: @casenbr@. 

The exam will take place with @doctorname@, @doctorspecialty@ at @ExamLocation@ on @apptdate@ @appttime@. 

-@Username@, 
@UserPhone@
',0)
GO

---------------------------iCase  Re-Schedule----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,183,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,'Yes',NULL,NULL,NULL,NULL,0,'
We have rescheduled the exam for @Examineename@, 
claim number: @claimnbr@, 
EW case #: @casenbr@. 

The exam has been rescheduled because of @cancelreason@. The exam will now take place with @doctorname@, @doctorspecialty@ at @ExamLocation@ on @apptdate@ @appttime@. 

Please remember to notify the translation and/or transportation vendors, if applicable. 

-@Username@, 
@UserPhone@
',0)
GO

---------------------------iCase  Appointment Change Status----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,190,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,' attended ',' did not attend ',' attended but was unable to be examined at ','The claimant was unable to be examined because ',NULL,0,'
@Examineename@. 
claim number: @claimnbr@, 
EW case #: @casenbr@ 

@apptmsg@ their appointment that was scheduled with @doctorname@, @doctorspecialty@ at @ExamLocation@ on @apptdate@ @appttime@. 

@utemsg@ @cancelreason@ 

-@Username@, 
@UserPhone@
',0)
GO

---------------------------iCase UnSchedule/Cancel Appointment----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,193,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'
We have cancelled the exam for @Examineename@, 
claim number: @claimnbr@, 
EW case #: @casenbr@. 

The exam has been cancelled on @cancelapptdate@ because of @cancelreason@. 

Please remember to notify the translation and/or transportation vendors, if applicable. 

-@Username@, 
@UserPhone@
',0)
GO

---------------------------iCase Option-1----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,2,NULL,2,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)    
@Clientname@,  
     
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:           

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          
  
If you have any questions or concerns, please reply by return email or contact our office.            

Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,2,NULL,2,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)    
@Clientname@,  
     
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:           

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          
  
If you have any questions or concerns, please reply by return email or contact our office.            

Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,2,NULL,2,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)    
@Clientname@,  
     
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:           

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          
  
If you have any questions or concerns, please reply by return email or contact our office.            

Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,3,NULL,2,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)    
@Clientname@,  
     
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:           

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          
  
If you have any questions or concerns, please reply by return email or contact our office.            

Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,3,NULL,2,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)    
@Clientname@,  
     
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:           

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          
  
If you have any questions or concerns, please reply by return email or contact our office.            

Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,3,NULL,2,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)    
@Clientname@,  
     
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:           

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@          
  
If you have any questions or concerns, please reply by return email or contact our office.            

Thank you.         
@Username@         
@UserPhone@
',0)
GO
---------------------------iCase Option-2----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,2,NULL,1,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice     
 @Clientname@,                
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@             
 Additional Applicable Fees:
	 Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	 Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	 Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	 Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	 Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	 Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	 Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                 
 
 If you have any questions or concerns, please reply by return email or contact our office.             
 
 Thank you.         
 @Username@         
 @UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,2,NULL,1,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice     
 @Clientname@,                
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@             
 Additional Applicable Fees:
	 Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	 Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	 Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	 Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	 Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	 Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	 Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                 
 
 If you have any questions or concerns, please reply by return email or contact our office.             
 
 Thank you.         
 @Username@         
 @UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,2,NULL,1,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice     
 @Clientname@,                
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@             
 Additional Applicable Fees:
	 Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	 Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	 Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	 Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	 Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	 Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	 Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                 
 
 If you have any questions or concerns, please reply by return email or contact our office.             
 
 Thank you.         
 @Username@         
 @UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,3,NULL,1,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice     
 @Clientname@,                
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@             
 Additional Applicable Fees:
	 Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	 Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	 Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	 Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	 Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	 Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	 Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                 
 
 If you have any questions or concerns, please reply by return email or contact our office.             
 
 Thank you.         
 @Username@         
 @UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,3,NULL,1,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice     
 @Clientname@,                
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@             
 Additional Applicable Fees:
	 Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	 Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	 Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	 Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	 Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	 Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	 Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                 
 
 If you have any questions or concerns, please reply by return email or contact our office.             
 
 Thank you.         
 @Username@         
 @UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,3,NULL,1,NULL,NULL,NULL,NULL,0,'
ExamWorks Fee Notice     
 @Clientname@,                
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following service:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @ServiceDesc@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@             
 Additional Applicable Fees:
	 Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	 Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	 Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	 Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	 Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	 Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	 Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                 
 
 If you have any questions or concerns, please reply by return email or contact our office.             
 
 Thank you.         
 @Username@         
 @UserPhone@
',0)
GO
---------------------------iCase Option-3----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,2,'T1',NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)     
 @Clientname@,                  
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@          
 No Show Fee    @QuoteNoShowFee@          
 Late Cancel Fee    @QuoteLateCancelFee@             
 
 Additional Applicable Fees:        
	Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                   
	
Notify ExamWorks of Cancellation no later than [late cancellation days] (business days) prior to appointment to avoid Late Cancel Fee. The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                      

If you have any questions or concerns, please reply by return email or contact our office.
               
Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,2,'T1',NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)     
 @Clientname@,                  
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@          
 No Show Fee    @QuoteNoShowFee@          
 Late Cancel Fee    @QuoteLateCancelFee@             
 
 Additional Applicable Fees:        
	Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                   
	
Notify ExamWorks of Cancellation no later than [late cancellation days] (business days) prior to appointment to avoid Late Cancel Fee. The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                      

If you have any questions or concerns, please reply by return email or contact our office.
               
Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,2,'T1',NULL,NULL,NULL,0,' 
ExamWorks Fee Notice (Approval Required)     
 @Clientname@,                  
 
 Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:               
 
 Physician Name: @doctorname@          
 Physician Specialty: @doctorspecialty@          
 Physician State: @DoctorAddr3@          
 @QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@          
 No Show Fee    @QuoteNoShowFee@          
 Late Cancel Fee    @QuoteLateCancelFee@             
 
 Additional Applicable Fees:        
	Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
	Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
	Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
	Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
	Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
	Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
	Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@                   
	
Notify ExamWorks of Cancellation no later than [late cancellation days] (business days) prior to appointment to avoid Late Cancel Fee. The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                      

If you have any questions or concerns, please reply by return email or contact our office.
               
Thank you.         
@Username@         
@UserPhone@
',0)
GO

---------------------------iCase Option-4----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,1,'T1',NULL,NULL,NULL,0,'
ExamWorks Fee Notice    
@Clientname@,                

Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:             

Physician Name: @doctorname@         
Physician Specialty: @doctorspecialty@         
Physician State: @DoctorAddr3@         
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         
No Show Fee    @QuoteNoShowFee@         
Late Cancel Fee    @QuoteLateCancelFee@           

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               
  
Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        

The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                    

If you have any questions or concerns, please reply by return email or contact our office.                 

Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,1,'T1',NULL,NULL,NULL,0,'
ExamWorks Fee Notice    
@Clientname@,                

Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:             

Physician Name: @doctorname@         
Physician Specialty: @doctorspecialty@         
Physician State: @DoctorAddr3@         
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         
No Show Fee    @QuoteNoShowFee@         
Late Cancel Fee    @QuoteLateCancelFee@           

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               
  
Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        

The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                    

If you have any questions or concerns, please reply by return email or contact our office.                 

Thank you.         
@Username@         
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,1,'T1',NULL,NULL,NULL,0,'
ExamWorks Fee Notice    
@Clientname@,                

Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:             

Physician Name: @doctorname@         
Physician Specialty: @doctorspecialty@         
Physician State: @DoctorAddr3@         
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@         
No Show Fee    @QuoteNoShowFee@         
Late Cancel Fee    @QuoteLateCancelFee@         
  
Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               
  
Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        

The fee for this service may exceed this quote for reasons including, but not limited to additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                    

If you have any questions or concerns, please reply by return email or contact our office.                 

Thank you.         
@Username@         
@UserPhone@
',0)
GO

---------------------------iCase Option-5----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,2,'T2;NORECORD;',NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)     
@Clientname@,                  
 
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:               
 
Physician Name: @doctorname@          
Physician Specialty: @doctorspecialty@          
Physician State: @DoctorAddr3@          
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@          
No Show Fee    @QuoteNoShowFee@          
Late Cancel Fee    @QuoteLateCancelFee@  
           
Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@     
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               

Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        

The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                   

If you have any questions or concerns, please reply by return email or contact our office.                

Thank you.        
@Username@        
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,2,'T2;NORECORD;',NULL,NULL,NULL,0,'
ExamWorks Fee Notice (Approval Required)     
@Clientname@,                  
 
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:               
 
Physician Name: @doctorname@          
Physician Specialty: @doctorspecialty@          
Physician State: @DoctorAddr3@          
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@          
No Show Fee    @QuoteNoShowFee@          
Late Cancel Fee    @QuoteLateCancelFee@  
           
Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@     
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               

Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        

The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                   

If you have any questions or concerns, please reply by return email or contact our office.                

Thank you.        
@Username@        
@UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,2,'T2;NORECORD;',NULL,NULL,NULL,0,' 
ExamWorks Fee Notice (Approval Required)     
@Clientname@,                  
 
Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:               
 
Physician Name: @doctorname@          
Physician Specialty: @doctorspecialty@          
Physician State: @DoctorAddr3@          
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@          
No Show Fee    @QuoteNoShowFee@          
Late Cancel Fee    @QuoteLateCancelFee@  
           
Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@      
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@      
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@     
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               

Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        

The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        

In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                   

If you have any questions or concerns, please reply by return email or contact our office.                

Thank you.        
@Username@        
@UserPhone@
',0)
GO

---------------------------iCase Option-6----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,1,NULL,NULL,1,'T2;NORECORD;',NULL,NULL,NULL,0,'
ExamWorks Fee Notice    
@Clientname@,            

Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:            

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@        
No Show Fee    @QuoteNoShowFee@        
Late Cancel Fee    @QuoteLateCancelFee@        

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@     
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@     
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               
  
 Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        
 
 The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        
 
 In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                  
 
 If you have any questions or concerns, please reply by return email or contact our office.              
 
 Thank you.        
 @Username@        
 @UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,3,NULL,NULL,1,'T2;NORECORD;',NULL,NULL,NULL,0,'
ExamWorks Fee Notice    
@Clientname@,            

Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:            

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@        
No Show Fee    @QuoteNoShowFee@        
Late Cancel Fee    @QuoteLateCancelFee@        

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@     
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@     
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               
  
 Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        
 
 The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        
 
 In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                  
 
 If you have any questions or concerns, please reply by return email or contact our office.              
 
 Thank you.        
 @Username@        
 @UserPhone@
',0)
GO

USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,2,194,GETDATE(),'admin',GETDATE(),'admin',NULL,5,NULL,NULL,1,'T2;NORECORD;',NULL,NULL,NULL,0,'
ExamWorks Fee Notice    
@Clientname@,            

Thank you for scheduling with ExamWorks. This letter serves as notification of the fees associated with the following appointment:            

Physician Name: @doctorname@        
Physician Specialty: @doctorspecialty@        
Physician State: @DoctorAddr3@        
@QuoteComment@ Base Rate  @FeeScheduleAmount@ @QuoteFeeUnit@        
No Show Fee    @QuoteNoShowFee@        
Late Cancel Fee    @QuoteLateCancelFee@        

Additional Applicable Fees:          
  Diagnostic Study: @QuoteDiagnosticStudyFee@  @QuoteDiagnosticStudyUnit@     
  Record Review: @QuoteRecordReviewFee@ @QuoteRecordReviewUnit@      
  Report Prep: @QuoteReportPrepFee@ @QuoteReportPrepUnit@     
  Travel: @QuoteTravelFee@ @QuoteTravelUnit@      
  Consultation: @QuoteConsultationFee@ @QuoteConsultationUnit@      
  Exam Room Rental: @QuoteExamRoomRentalFee@ @QuoteExamRoomRentalUnit@      
  Indexing Chart Prep: @QuoteIndexingChartPrepFee@ @QuoteIndexingChartPrepUnit@               
  
 Notify ExamWorks of Cancellation no later than @QuoteLateCancelDays@ (business days) prior to appointment to avoid Late Cancel Fee.        
 
 The fee for this service may exceed this quote for reasons including, but not limited to the complexity of the case, volume of the medical records, time required of the physician, additional required tests or geographical factors. Additional testing fees (i.e. X-Rays, diagnostics, diagnostic reviews, etc.) may apply and may be billed/reimbursed separately.        
 
 In order to provide our clients with the highest quality service we request that medical records, including CDs and films, are sent as soon as possible. Preferably at least 15 business days prior to the scheduled appointment date. Please send records, etc. to our ExamWorks office. If you are a web portal user, please upload the records to the portal as soon as possible.                  
 
 If you have any questions or concerns, please reply by return email or contact our office.              
 
 Thank you.        
 @Username@        
 @UserPhone@
',0)
GO

---------------------------iCase Panel Exam - Schedule----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,201,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,'No',NULL,NULL,NULL,NULL,0,'
We have scheduled the exam for @Examineename@,   
claim number: @claimnbr@,   
EW case #: @casenbr@.     

The exam will take place with a panel of medical experts at @ExamLocation@ on @apptdate@ @appttime@.     

-@Username@,   
@UserPhone@
',0)
GO

---------------------------iCase Panel Exam - Re-Schedule----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,201,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,'Yes',NULL,NULL,NULL,NULL,0,'
We have rescheduled the exam for @Examineename@,   
claim number: @claimnbr@,   
EW case #: @casenbr@.     

The exam has been rescheduled because of @cancelreason@. The exam will now take place with a panel of medical experts at @ExamLocation@ on @apptdate@ @appttime@.     

Please remember to notify the translation and/or transportation vendors, if applicable.     

-@Username@,   
@UserPhone@
',0)
GO

---------------------------iCase Panel Exam - Cancel Appointment----------------------------------------
USE [IMECentricEW]
GO
INSERT INTO [dbo].[tblBusinessRuleCondition]
           ([EntityType] ,[EntityID] ,[BillingEntity] ,[ProcessOrder] ,[BusinessRuleID] ,[DateAdded] ,[UserIDAdded] ,[DateEdited],[UserIDEdited],[OfficeCode],[EWBusLineID],[EWServiceTypeID],[Jurisdiction],[Param1],[Param2],[Param3],[Param4],[Param5],[Skip],[Param6],[ExcludeJurisdiction])  VALUES 
           ('PC',31,2,1,202,GETDATE(),'admin',GETDATE(),'admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'
We have cancelled the exam for @Examineename@,   
claim number: @claimnbr@,   
EW case #: @casenbr@.     

The exam has been cancelled on @cancelapptdate@ because of @cancelreason@.     

Please remember to notify the translation and/or transportation vendors, if applicable.     

-@Username@,   
@UserPhone@
',0)
GO




USE [IMECentricEW]
---------------- IMEC-14539 - Use Liberty Specific Forms When Generating Quotes   ------------------------------------
-- Business rule for document to use
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (196, 'LibertyQuoteDocument', 'Case', 'Determine which Liberty Quote document to use', 1, 1060, 0, 'QuoteType', 'QuoteHandlingID', 'DoctorTier', 'Document', 0)
GO

-- Invoice quote, peer review, fee approval, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 2, 'IN', '2', ';T1;T2;', 'LibQtPRAprReq')
GO

-- Invoice quote, record review, fee approval, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 3, 'IN', '2', ';T1;T2;', 'LibQtPRAprReq')
GO

-- Invoice quote, peer review, fee quote, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 2, 'IN', '1', ';T1;T2;', 'LibQtPeerRecRev')
GO

-- Invoice quote, record review, fee quote, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 3, 'IN', '1', ';T1;T2;', 'LibQtPeerRecRev')
GO

-- Invoice quote, anything but peer review and record review, fee approval, doctor tier 1
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 2, 196, GETDATE(), 'Admin', 'IN', '2', 'T1', 'LibQtT1AprReq')
GO

-- Invoice quote, anything but peer review and record review, fee quote, doctor tier 1
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 2, 196, GETDATE(), 'Admin', 'IN', '1', 'T1', 'LibQtT1NoAppr')

-- Invoice quote, anything but peer review and record review, fee approval, doctor tier 2
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 2, 196, GETDATE(), 'Admin', 'IN', '2', 'T2', 'LibQtT2AprReq')
GO

-- Invoice quote, anything but peer review and record review, fee quote, doctor tier 2
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('PC', 31, 2, 2, 196, GETDATE(), 'Admin', 'IN', '1', 'T2', 'LibQtT2NoAprReq')
GO

-- Invoice quote, anything but peer review and record review, fee approval, doctor tier not found
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 2, 196, GETDATE(), 'Admin', 'IN', '2', 'LibQtT2AprReq')
GO

-- Invoice quote, anything but peer review and record review, fee quote, doctor tier not found
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 2, 196, GETDATE(), 'Admin', 'IN', '1', 'LibQtT2NoAprReq')
GO

-- Invoice quote, peer review, fee approval, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 2, 'IN', '2', 'LibQtPRAprReq')
GO

-- Invoice quote, record review, fee approval, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 3, 'IN', '2', 'LibQtPRAprReq')
GO

-- Invoice quote, peer review, fee quote, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 2, 'IN', '1', 'LibQtPeerRecRev')
GO

-- Invoice quote, record review, fee quote, any tier
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWServiceTypeID, Param1, Param2, Param4)
VALUES ('PC', 31, 2, 1, 196, GETDATE(), 'Admin', 3, 'IN', '1', 'LibQtPeerRecRev')
GO


--------------------------- IMEC-14448 - Liberty Quote Guardrails  -----------------------------
USE [IMECentricEW]
-- insert 'Service Fee > 500 pgs' product into quote fee table
INSERT INTO tblQuoteFeeConfig (FeeValueName, DisplayOrder, DateAdded, UserIDAdded, ProdCode)
VALUES('Svc Fee > 500pgs', 65, GETDATE(), 'Admin', 3030)
GO

-- business rule to set choice of additional fees on quote form
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
VALUES (192, 'SetQuoteAdditionalFeeChoices', 'Accounting', 'Set list of available choices for quote additional fees', 1, 1061, 0, 'AllowedSelections', 0)
GO

-- show all fees for Liberty
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
VALUES ('PC', 31, 2, 1, 192, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8,9')
GO

-- limit additional fees for everyone - do not show "Service Fee > 500 pgs"
INSERT INTO tblBusinessRuleCondition (EntityType, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
VALUES ('SW', 2, 2, 192, GETDATE(), 'Admin', '1,2,3,4,5,6,7,8')
GO

-- User override security token for Liberty Quote Guardrails
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('LibertyQuoteOverride', 'Liberty - Override Guardrails to Generate Quote', GETDATE())
GO

-- enables the MedRecsPages textbox on the Quote params form
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
VALUES ('PC', 31, 2, 1, 152, GETDATE(), 'Admin', 'True')
GO

  -- business rule to set Liberty quote maximum amount
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc , BrokenRuleAction)
VALUES (200, 'LibertyGRSetQuoteMaxAmount', 'Case', 'Set quote maximum amount for Liberty Guardrails', 1, 1060, 0, 'QuoteFeeRangeUnit',  'AdditionalFeesUnit', 'TTlAmtLimit', 0)
GO

-- business rule condition to set Liberty quote maximum amount
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3)
VALUES ('PC', 31, 2, 1, 200, GETDATE(), 'Admin', ';fee;', ';fee;', '5000')
GO

-- Start Liberty Guardrails for cases added after date
INSERT INTO tblSetting (Name, Value) 
VALUES ('LibertyGuardrailsStartDate', '2024/10/01')
GO


-- Liberty quote guardrails - business rule for med rec page calculations
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (186, 'LibertyQuoteMedRecPgCalculations', 'Case', 'Liberty Qote GR - rules for calculating med rec page amounts', 1, 1060, 0, 'Doctor Tier', 'BlockIncrement', 'ProdCode', 'RateForBlock', 'BlockStrtPgCnt', 0)
GO

--   (1) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 1, 1, 'T1', '250', '385', '0.1', '250')
GO

--   (2) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 1, 2, 'T1', '250', '385', '0.2', '250')
GO

--   (3) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 5, 1, 'T1', '250', '385', '0.1', '250')
GO

--   (4) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Exclude Jurisdictions 'CA', 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', 5, 2, 'T1', '250', '385', '0.2', '250')
GO

--   (5) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 1, 'CA', 'T1', '385', '0.5', '250')
GO

--   (6) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = IME; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 1, 'WA', 'T1', '385', '0.5', '250')
GO

--   (7) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 2, 'CA', 'T1', '385', '0.35', '250')
GO

--   (8) Med rec Pages > 250 - ProdCode = 385; Liability; ServiceType = Peer review; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 1, 2, 'WA', 'T1', '385', '0.35', '250')
GO

--   (9) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 1, 'CA', 'T1', '385', '0.5', '250')
GO

--   (10) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = IME; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 1, 'WA', 'T1', '385', '0.5', '250')
GO

--   (11) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Jurisdiction 'CA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 2, 'CA', 'T1', '385', '0.35', '250')
GO

--   (12) Med rec Pages > 250 - ProdCode = 385; Third party; ServiceType = Peer review; Jurisdiction 'WA'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 5, 2, 'WA', 'T1', '385', '0.35', '250')
GO

--   (13) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = IME; Jurisdiction 'MI'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 2, 1, 'MI', 'T1', '250', '385', '0.1', '250')
GO

--   (14) Med rec Pages > 250 - ProdCode = 385; First party; ServiceType = Peer review; Jurisdiction 'MI'
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param3)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 2, 2, 'MI', 'T1', '385')
GO

--   (15) Service Fee > 500 - ProdCode = 3030; all cases
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param3, Param4, Param5)
VALUES ('PC', 31, 2, 2, 186, GETDATE(), 'Admin', '3030', '0.1', '500')
GO

  --   (16) Service Fee > 500 - ProdCode = 3030; exclude CA for workers comp - no service fee
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 3, 'CA', '3030')
GO

  --   (17) Service Fee > 500 - ProdCode = 3030; exclude TX for workers comp - no service fee
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, EWBusLineID, Jurisdiction, Param3)
VALUES ('PC', 31, 2, 1, 186, GETDATE(), 'Admin', 3, 'TX', '3030')
GO


--------------------------- IMEC-14444 - Liberty Invoice Guardrails  -----------------------------
USE [IMECentricEW]
-- User override security token for Liberty Invoice Guardrails
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES ('LibertyInvoiceOverride', 'Liberty - Override Guardrails to Finalize Invoice', GETDATE())
GO

-- Liberty invoice guardrail BR
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
VALUES (187, 'LibertyGuardRailsInvoice', 'Case', 'Check if guardrails need to be applied when generating an invoice.', 1, 1811, 0, 'InvoiceMaxAmount', 0)
GO
  
-- Liberty
INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1)
VALUES ('PC', 31, 2, 1, 187, GETDATE(), 'Admin', '5000')
GO



