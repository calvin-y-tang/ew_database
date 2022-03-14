
-- IMEC-12558 - add new security token
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('CaseDocRptDelete', 'Case - Delete Doc/Rpt', GetDate())
GO

-- IMEC-IMEC-12545 - rework business rules for TX Sales Tax calculation
DELETE FROM tblBusinessRuleCondition WHERE BusinessRuleID = 155
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(155, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', 32, NULL, NULL, NULL, '2', 'TX', NULL, NULL, NULL),
      (155, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', 33, NULL, NULL, NULL, '2', 'TX', NULL, NULL, NULL),
      (155, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', 34, NULL, NULL, NULL, '2', 'TX', NULL, NULL, NULL)
GO


