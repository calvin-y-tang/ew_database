
-- Issue 12281 - AmTrust SLA Reminder Email for Appt
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (158, 'AutoSendSLAApptCreated', 'Case', 'Determine the Send Date for SLA Appt Not Set Email.', 1, 1001, 0, 'NbrHrsAddToOrigDate', 'ServiceCode', NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(158, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '0', '700', NULL, NULL, NULL), 
	  (158, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '0', '3120', NULL, NULL, NULL), 
	  (158, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '0', '1200', NULL, NULL, NULL), 
	  (158, 'PC', 9, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 1, NULL, '15', NULL, NULL, NULL, NULL) 
GO 

