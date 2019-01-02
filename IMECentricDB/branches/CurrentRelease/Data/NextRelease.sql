-- ISSUE 8047 & 7933 Allstte changes for Case and Client Forms
--	1. Update tblEvent 
UPDATE tblEvent SET Category = 'Client' WHERE EventID = 3001
GO
INSERT INTO tblEvent (EventID, Descrip, Category)
Values(3002, 'Client Loaded', 'Client'), 
      (1016, 'Case Data Modified', 'Case')
GO
-- 2. add new entries to BusinessRule tables
DECLARE @iPKeyValue INTEGER
INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES('DisplayClientCustomerData', 'Client', 'Display Customer Data Tab on frmClient', 1, '3002', 0, 'ParamPropertyGroupID', NULL, NULL, NULL, NULL, 0)
SET @iPKeyValue = @@IDENTITY
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 4, 1, 1, @iPKeyValue, '2018-12-10 13:54:00.000', 'Admin', '2018-12-10 13:54:00.000', 'Admin', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL)
GO

DECLARE @iPKeyValue INTEGER
INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES('ClientRequiredFields', 'Client', 'Define Required Fields on Client Form', 1, 3002, 0, 'FieldName1', 'FieldName2', 'FieldName3', 'FieldName4', NULL, 0)
SET @iPKeyValue = @@IDENTITY
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES ('PC', 4, 1, 1, @iPKeyValue, '2018-12-11 15:03:00.000', 'Admin', '2018-12-11 15:03:00.000', 'Admin', NULL, NULL, NULL, NULL, 'EmployeeNumber', NULL, NULL, NULL, NULL)
GO

DECLARE @iPKeyValue INTEGER
INSERT INTO tblBusinessRule(Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES('DisplayCaseCustomerData', 'Case', 'Display Customer Data Tabpage for frmCase', 1, 1016, 0, 'TabPageControlName', 'ParamPropertyGroupID', NULL, NULL, NULL, 0)
SET @iPKeyValue = @@IDENTITY
INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES 
	('PC', 31, 2, 1, @iPKeyValue, '2018-12-18 10:12:00.000', 'Admin', '2018-12-18 10:12:00.000', 'Admin', NULL, NULL, NULL, NULL, 'Liberty', NULL, NULL, NULL, NULL),
	('PC', 39, 2, 1, @iPKeyValue, '2018-12-18 10:12:00.000', 'Admin', '2018-12-18 10:12:00.000', 'Admin', NULL, NULL, NULL, NULL, 'Progressive', NULL, NULL, NULL, NULL),
	('PC', 4, 2, 1, @iPKeyValue, '2018-12-18 10:12:00.000', 'Admin', '2018-12-18 10:12:00.000', 'Admin', NULL, NULL, NULL, NULL, 'CustomerData', 2, NULL, NULL, NULL)
GO

-- 3. Populate new ParamProperty Tables
DECLARE @iPKeyValue INTEGER
INSERT INTO tblParamPropertyGroup(Description, LabelText, Version, DateAdded, UserIDAdded)
VALUES('Allstate Client Customer Data', 'Allstate', 1, '2018-12-10 00:00:00.000', 'JPais')
SET @iPKeyValue = @@IDENTITY
INSERT INTO tblParamProperty(ParamPropertyGroupID, LabelText, FieldName, Required, AllowedValues, DateAdded, UserIDAdded)
VALUES
	(@iPKeyValue, 'Department', 'Department', 0, NULL, '2018-12-10 00:00:00.000', 'JPais'), 
	(@iPKeyValue, 'MCO (Office Name)', 'MCO', 0, NULL, '2018-12-10 00:00:00.000', 'JPais'),
	(@iPKeyValue, 'CSA', 'CSA', 0, NULL, '2018-12-10 00:00:00.000', 'JPais')
GO

DECLARE @iPKeyValue INTEGER
INSERT INTO tblParamPropertyGroup(Description, LabelText, Version, DateAdded, UserIDAdded)
VALUES('Allstate Case Customer Data', 'Allstate', 1, '2018-12-10 00:00:00.000', 'JPais')
SET @iPKeyValue = @@IDENTITY
INSERT INTO tblParamProperty(ParamPropertyGroupID, LabelText, FieldName, Required, AllowedValues, DateAdded, UserIDAdded)
VALUES
	(@iPKeyValue, 'Involved ID', 'InvolvedID', 0, NULL, '2018-12-10 00:00:00.000', 'JPais')
GO
