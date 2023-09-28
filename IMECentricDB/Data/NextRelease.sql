-- Sprint 120

-- IMEC-13860 - configure CustomerData page of case form and create BizRule to show it
DECLARE @newID INT
INSERT INTO tblParamPropertyGroup(Description, LabelText, Version, DateAdded, UserIDAdded)
VALUES('American Family Customer Data', 'American Family', 1, GetDate(), 'JPais')
SET @newID = (SELECT @@IDENTITY)
INSERT INTO tblParamProperty(ParamPropertyGroupID, LabelText, FieldName, Required, DateAdded, UserIDAdded, Visible)
VALUES(@newID, 'Coordinator First Name', 'CoordinatorFirstName', 0, GETDATE(), 'JPais', 1), 
      (@newID, 'Coordinator Last Name', 'CoordinatorLastName', 0, GETDATE(), 'JPais', 1), 
      (@newID, 'Coordinator Email', 'CoordinatorEmail', 0, GETDATE(), 'JPais', 1)
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (7, 'PC', 5, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'CustomerData', @newID, NULL, NULL, NULL, 0, NULL)
GO

-- IMEC-13860 - set Insuring Company as required field
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (130, 'PC', 5, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'txtInsuringCompany', NULL, NULL, NULL, NULL, 0, NULL)
GO

-- IMEC-13860 - Generate Documents check Other Email and set Other Email Address
UPDATE tblBusinessRule 
   SET Param6Desc = 'CustDataCustomerName'
 WHERE BusinessRuleID = 160
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (160, 'PC', 5, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '%tblCustomerData_CoordinatorEmail%', NULL, NULL, NULL, ';Client;', 0, 'American Family')
GO

-- IMEC-13860 - distribute documents check other email and set other email address
UPDATE tblBusinessRule 
   SET Param4Desc = 'CustDataCustomerName'
 WHERE BusinessRuleID = 10
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (10, 'PC', 5, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '%tblCustomerData_CoordinatorEmail%', NULL, ';Client;', 'American Family', NULL, 0, NULL)
GO

-- IMEC-13860 - Duplicate/Create sub case allow use of Customer Data option
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (153, 'PC', 5, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Always', NULL, NULL, NULL, NULL, 0, NULL)
GO
