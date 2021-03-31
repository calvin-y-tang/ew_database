-- Issue 11897 - new SLA Metrics
INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)
VALUES (216, 'tblCase', 'TATExamSchedToQuoteSent', null),
       (217, 'tblCase', 'TATExamSchedToApprovalSent', null),
       (218, 'tblCase', 'TATApprovalSentToResentApproval', null),
       (219, 'FeeQuote', 'DateClientInformed', 'Fee Quote Sent'), 
       (220, 'FeeApproval', 'DateClientInformed', 'Fee Approval Sent'),
       (221, 'FeeApproval', 'DateClientCommResent', 'Resent Fee Approval')
GO
INSERT INTO tblTATCalculationMethod(TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend)
VALUES(21, 207, 219, 'Day', 216, 0),
      (22, 207, 220, 'Day', 217, 0), 
      (23, 220, 221, 'Day', 218, 0)
GO
INSERT INTO tblEvent (EventID, Descrip, Category)
VALUES(1060, 'Fee Quote/Approval Saved', 'Case')
GO
INSERT INTO tblTATCalculationMethodEvent (TATCalculationMethodID, EventID)
VALUES (21,1060), 
	   (22,1060), 
	   (23,1060)
GO


-- Issue 12079 - add med status options to combo
INSERT INTO tblRecordStatus  (Description, DateAdded, UserIDAdded, PublishOnWeb)
VALUES ('Awaiting Declaration', GETDATE(), 'TLyde', 1),
       ('Declaration Received', GETDATE(), 'TLyde', 1)

GO


