

-- Issue 12346 - Allow for an Allstate customer data tab on the case form that requires data to be completed.
DECLARE @iPKeyID AS INTEGER
-- Create new ParamPropertyGroup & Items for Required Allstate
INSERT INTO tblParamPropertyGroup(Description, LabelText, Version, DateAdded, UserIDAdded)
VALUES('Allstate Case Customer Data - Required', 'Allstate', 1, GetDate(), 'JPais')
SELECT @iPKeyID = @@IDENTITY
INSERT INTO tblParamProperty(ParamPropertyGroupID, LabelText, FieldName, Required, DateAdded, UserIDAdded)
     (SELECT @iPKeyID, LabelText, FieldName, 1, GETDATE(), 'JPais' 
        FROM tblParamProperty 
       WHERE ParamPropertyGroupID = 2)

-- Changes to Business rules
--   1. delete existing Allstate rule
DELETE FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 7 
  AND EntityType = 'PC' 
  AND EntityID = 4

--   2. new allstate customer tab with required properties
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(7, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, 1, NULL, 'CustomerData', @iPKeyID, NULL, NULL, NULL),
     -- 3. recreate original allstate rule with properties not required
      (7, 'PC', 4, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'CustomerData', '2', NULL, NULL, NULL)
GO


