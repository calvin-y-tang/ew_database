-- Sprint 119

-- IMEC-13817 - Create business rules for Automated Referral Acknowledgement
DELETE 
  FROM tblExternalCommunications
GO
INSERT INTO tblEvent (EventID, Descrip, Category)
VALUES(1070, 'CaseHistoryAdded', 'Case')
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (116, 'CreateExtComm', 'Case', 'Create entry in tblExternalCommunications', 1, 1070, 0, 'ExtCommTypesAllowed', 'ExtCommEntity', NULL, NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (116, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'NewCase;', 'EntityType=PC;EntityID=9', NULL, NULL, NULL, 0, NULL)
GO

-- IMEC-13820 add new security token for edit doctor notes
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('DoctorEditNotes', 'Doctor - Edit Notes (Notes/QANotes/RecordReqNotes)', GETDATE())
GO
