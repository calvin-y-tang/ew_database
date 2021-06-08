-- Issue 12097 - add new business rules and BR conditions to check the Exam Time fields before finalizing a report
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(140, 'FinalizeRptCaptureExamTimes', 'Case', 'Exam times required when finalizing report', 1, 1320, 0, NULL, NULL, NULL, NULL, NULL, 0)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('SW', NULL, 0, 1, 140, GetDate(), 'Admin', NULL, NULL, NULL, 3, 1, 'NY', NULL, NULL, NULL, NULL, NULL)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES('SW', NULL, 0, 1, 140, GetDate(), 'Admin', NULL, NULL, NULL, 3, 3, 'NY', NULL, NULL, NULL, NULL, NULL)

