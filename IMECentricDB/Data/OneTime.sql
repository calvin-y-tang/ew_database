--IMECentricEW only
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(155, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '2', 'TX', NULL, NULL, NULL)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 161, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'CA', Null, NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 161, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'TX', Null, NULL, NULL, NULL, NULL, 1)
GO

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 2, 161, GetDate(), 'Admin', NULL, NULL,    NULL, NULL, NULL, NULL, Null, NULL, NULL, NULL, NULL, 0)
GO



-- ISSUE 12300 - Add langugage Preference to web user maintenance - set language choices per DBID; set default langugage choice for users to english
  -- Apply to DB NYRC  - DBID = 18
INSERT INTO tblSetting (Name, Value) VALUES ('WebUserLanguageChoices', ';110;1;')
GO

-- Apply to all other DB’s
INSERT INTO tblSetting (Name, Value) VALUES ('WebUserLanguageChoices', ';110;')
GO

-- Apply to all DB’s
UPDATE tblWebUser SET LanguageIDPreference = 110
GO



-- ISSUE 12293 - Allstate VAT ERP Import Senior Manager Field From JSON
  -- Making Policy Company Code field visible
INSERT INTO tblParamProperty (ParamPropertyGroupID, LabelText, FieldName, Required, AllowedValues, DateAdded, UserIDAdded, Visible)
VALUES (2, 'Senior Manager', 'SeniorManager', 0, NULL, GETDATE(), 'TLyde', 1)
GO

INSERT INTO tblParamProperty (ParamPropertyGroupID, LabelText, FieldName, Required, AllowedValues, DateAdded, UserIDAdded, Visible)
VALUES (2, 'Policy Company Code', 'PolicyCompanyCode', 0, NULL, GETDATE(), 'TLyde', 1)
GO

