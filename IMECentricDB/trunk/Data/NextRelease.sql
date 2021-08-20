-- Issue 12229 - Parent company bookmark request - add token also
  INSERT INTO tblMessageToken (Name, Description)
  VALUES ('@ParentCompany@', '')
GO 

-- Issue  12215 - add business rules for additional refinement of "Customer Data" option for duplicate/new sub case
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (153, 'CustomerDataForDupCase', 'Case', 'Data Handling setting for tblCustomerData when duplicate/new sub case', 1, 1001, 0, 'DataHandlingValue', 'InputSourceID', NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(153, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Never', NULL, NULL, NULL, NULL), 
      (153, 'PC', 44, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Always', '7', NULL, NULL, NULL)
GO
