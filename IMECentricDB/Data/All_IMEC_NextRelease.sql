-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 141
-- IMEC-14483 - Update tblSetting for CaseDocTypeMedsIncoming_True to include only CaseDocType 'Med Records' (7) and do not include 'San Med Records' (21)
UPDATE tblSetting Set Value = ';7;' where Name = 'CaseDocTypeMedsIncoming_True'
GO 

-- IMEC-14423 - Changes for Allstate SLA Metric (No Show to Exam Scheduled)
UPDATE tblTATCalculationMethod
   SET ApptEnabled = ISNULL(ApptEnabled, 0)
GO 
INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)           
VALUES(227, 'OrigAppt', 'ApptTime', 'No Show'), 
      (228, 'NextAppt', 'DateAdded', 'Exam Scheduled'),
      (229, 'OrigAppt', 'TATNoShowToScheduled', NULL)
GO
INSERT INTO tblTATCalculationMethod(TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend, ApptEnabled)
VALUES(26, 227, 228, 'Day', 229, 0, 1)
GO
INSERT INTO tblTATCalculationMethodEvent(TATCalculationMethodID, EventID)
VALUES(26, 1101)
GO

-- IMEC-14424 - add new SLA Exception Reason columns for tracking historical case appts SLA Exception reasons
--  table is managed by dev team and will be the same across all databases.
    INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)           
    VALUES(231, 'tblCaseAppt', 'SLAExScheduledToExam', NULL), 
        (232, 'tblCaseAppt', 'SLAExExamToClientNotified', NULL), 
        (233, 'tblCaseAppt', 'SLAExAwaitingScheduling', NULL), 
        (234, 'tblCaseAppt', 'SLAExAwaitingSchedulingToExam', NULL), 
        (235, 'tblCaseAppt', 'SALExEnteredToExam', NULL), 
        (236, 'tblCaseAppt', 'SLAExDateLossToApptDate', NULL), 
        (237, 'tblCaseAppt', 'SLAExExamSchedToQuoteSent', NULL), 
        (238, 'tblCaseAppt', 'SLAExExamSchedToApprovalSent', NULL), 
        (239, 'tblCaseAppt', 'SLAExExamDateToNotifyShowNoShow', NULL) 
GO

-- IMEC-14424 - patch TATCalcMethod to include Appt SLA Exception Reason tabel/field where appropriate
--   table is managed by dev team and will the same across all IMEC databases.
     -- Exam Scheduled to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 231
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 8
     GO
     -- Date of Exam to Client Notified
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 232
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 11
     GO
     -- Available for Scheduling to Exam Scheduled
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 233
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 12
     GO
     -- Available for Scheduling to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 234
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 14
     GO
     -- Referral Entered into IMEC to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 235
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 15
     GO
     -- Date of Loss to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 236
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 17
     GO
     -- Exam Scheduled to Fee Quote Sent
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 237
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 21
     GO
     -- Exam Scheduled to Fee Approval Sent
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 238
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 22
     GO
     -- Appt Time to Client Notified Show/No Show
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 239
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 24
     GO
