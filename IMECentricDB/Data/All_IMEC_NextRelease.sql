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

