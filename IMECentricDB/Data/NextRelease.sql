-- Sprint 93


-- IMEC-13014 add new "Date Meds Sent to Dr" field and TAT/SLA calculation
INSERT INTO tblDataField (DataFieldID, TableName, FieldName, Descrip)
VALUES (225, 'tblCase','DateMedsSentToDr', 'Date Meds Sent to Doctor'),
       (226, 'tblCase','TATDateMedsSentToDrToRptSentDate',NULL)
GO
INSERT INTO tblTATCalculationMethod(TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend)
VALUES (25, 225, 205, 'Day', 226, 0)
GO
INSERT INTO tblTATCalculationGroupDetail(TATCalculationGroupID, TATCalculationMethodID, DisplayOrder)
VALUES(2, 25, 18)
GO
-- IMEC-13014 add new business rule to require "Date Meds Sent to Dr" to be completed
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (144, 'InvRequireDateMedsSentToDr', 'Accounting', 'Gen Inv requires DateMedsSentToDr', 1, 1801, 0, 'SvcTypeMapping1', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (144, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
       (144, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
       (144, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
       (144, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 5, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
       (144, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, 6, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL)
GO

-- IMEC-13009 update some Sentry document gen/dist business rules.
UPDATE tblBusinessRuleCondition 
   SET ewbuslineid = 3, 
       EWServiceTypeID = 1
 WHERE BusinessRuleID IN (109,110) 
   AND EntityType = 'PC' 
   AND EntityID = 46
   AND Param2 = 'WCClaimTechStPtEast@sentry.com'
GO

