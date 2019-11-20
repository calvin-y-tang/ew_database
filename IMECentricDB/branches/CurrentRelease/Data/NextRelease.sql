ALTER TABLE tblCase ADD RptQADraftDate DATETIME NULL
ALTER TABLE tblCase ADD TATQADraftToQAComplete INT NULL
GO

  INSERT INTO tblDataField (DataFieldID, TableName, FieldName, Descrip) VALUES
  (214, 'tblCase', 'RptQADraftDate', 'Report QA Draft Date'),
  (120, 'tblCase', 'TATQADraftToQAComplete', '')

  INSERT INTO tblTATCalculationMethod (TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend) VALUES
(20, 214, 204, 'Day', 120, 0)


  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 7 WHERE TATCalculationMethodID = 2 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 9 WHERE TATCalculationMethodID = 3 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 10 WHERE TATCalculationMethodID = 4 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 11 WHERE TATCalculationMethodID = 16 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 12 WHERE TATCalculationMethodID = 9 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 13 WHERE TATCalculationMethodID = 5 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 14 WHERE TATCalculationMethodID = 17 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 15 WHERE TATCalculationMethodID = 18 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 16 WHERE TATCalculationMethodID = 19 AND TATCalculationGroupID = 1

  INSERT INTO tblTATCalculationGroupDetail (TATCalculationGroupID, TATCalculationMethodID, DisplayOrder) VALUES
  (1, 20, 8)


INSERT INTO tblQueueForms VALUES ('frmStatusWbRsvdAppts', 'Form for Web Rerserved Appointments')

SET IDENTITY_INSERT tblQueues ON
GO
INSERT INTO tblQueues (StatusCode, StatusDesc, Type, ShortDesc, DisplayOrder, 
	FormToOpen, DateAdded, DateEdited, UserIDAdded, UserIDEdited, 
	Status, SubType, FunctionCode, WebStatusCode, NotifyScheduler, 
	NotifyQARep, NotifyIMECompany, WebGUID, AllowToAwaitingScheduling, IsConfirmation, 
	WebStatusCodeV2, AwaitingReptDictation, AwaitingReptApproval, DoNotAllowManualChange)
VALUES(34, 'Web Reserved Appointment', 'System', 'WbRsvdAppt', 50, 
		'frmStatusWbRsvdAppts', GETDATE(), NULL, 'TLyde', NULL,
		'Active', 'Case', 'None', NULL, 0,
		0, 1, NULL, NULL, 0, 
		NULL, Null, NULL, 1)
GO
SET IDENTITY_INSERT tblQueues OFF


GO


UPDATE tblControl SET ApptRequestStatusCode = 34, ApptRequestDoctorReasonID = 4 WHERE InstallID = 1

UPDATE tblWebUser SET AllowScheduling = 0 
GO

UPDATE CA SET CA.Duration=DS.Duration
 FROM tblCaseAppt AS CA
 INNER JOIN tblCase AS C ON C.CaseApptID = CA.CaseApptID
 INNER JOIN tblDoctorSchedule AS DS ON DS.SchedCode = C.SchedCode

UPDATE tblCaseAppt SET Duration=1 WHERE Duration IS NULL


GO

