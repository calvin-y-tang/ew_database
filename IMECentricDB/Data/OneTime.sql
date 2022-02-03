-- ISSUE 12293 - Allstate VAT ERP Import Senior Manager Field From JSON
  -- Making Policy Company Code field visible
INSERT INTO tblParamProperty (ParamPropertyGroupID, LabelText, FieldName, Required, AllowedValues, DateAdded, UserIDAdded, Visible)
VALUES (2, 'Senior Manager', 'SeniorManager', 0, NULL, GETDATE(), 'TLyde', 1)
GO

INSERT INTO tblParamProperty (ParamPropertyGroupID, LabelText, FieldName, Required, AllowedValues, DateAdded, UserIDAdded, Visible)
VALUES (2, 'Policy Company Code', 'PolicyCompanyCode', 0, NULL, GETDATE(), 'TLyde', 1)
GO

