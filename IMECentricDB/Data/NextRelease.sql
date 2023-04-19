-- Sprint 109

-- IMEC-13504 - create new business rules for Liberty to force value for Case Priorty
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (156, 'SetCasePriorityOnSave', 'Case', 'Check/Set the case Priority value when case is saved', 1, 1016, 0, 'SetPriorityTo', NULL, NULL, NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (156, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, 'OR', 'RushReport', NULL, NULL, NULL, NULL, 0, NULL), 
        (156, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, 'WA', 'RushReport', NULL, NULL, NULL, NULL, 0, NULL)
GO


