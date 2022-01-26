
-- IMEC-12318 - parent company patch existing data
UPDATE IMECentricMaster.dbo.EWParentCompany
SET RequireInOutNetworkInvoice = ISNULL(RequireInOutNetworkInvoice, 0), 
    RequireOutofNetworkReason = ISNULL(RequireOutofNetworkReason, 0)
GO

UPDATE tblEWParentCompany
SET RequireInOutNetworkInvoice = ISNULL(RequireInOutNetworkInvoice, 0), 
    RequireOutofNetworkReason = ISNULL(RequireOutofNetworkReason, 0)
GO

-- IMEC-12320 - Add new business rule for capture date appt conf/show/no show letters are generated
--      remove old tblSetting for appt conf letter
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (141, 'SaveApptLetterDateToCaseAppt', 'Case', 'Save Date Doc Created to tblCaseAppt', 1, 1201, 0, 'ApptStatusID', 'DocContentType', 'CaseApptColumnName', NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES(141, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '10', 'Appointment Confirmation', 'DateApptLetterSent', NULL, NULL, 0),
      (141, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '101', 'No Show Notice', 'DateShowNoShowLetterSent', NULL, NULL, 0), 
      (141, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '100', 'Attendance Confirmation', 'DateShowNoShowLetterSent', NULL, NULL, 0)
GO
DELETE 
  FROM tblSetting 
 WHERE Name = 'ApptLetterContentType'
GO 

-- IMEC-12321 - new SLA Metric Exam Date to Client Notified Show/No Show
INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)
VALUES(222, 'tblCaseAppt', 'DateShowNoShowLetterSent', 'Client Notified Show/No Show'), 
      (223, 'tblCase', 'TATExamDateToNotifyShowNoShow', NULL) , 
      (224, 'tblCase', 'ApptTime', 'Appt Time')
GO
INSERT INTO tblTATCalculationMethod(TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend)
VALUES(24, 224, 222, 'Hour', 223, 0)
GO
INSERT INTO tblTATCalculationGroupDetail
VALUES(1, 24, 17),
      (2, 24, 17),
      (3, 24, 17),
      (4, 24, 17)
GO
