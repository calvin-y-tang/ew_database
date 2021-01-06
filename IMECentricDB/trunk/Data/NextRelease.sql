INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc,
    DateAdded
)
VALUES
(   'SLAMonitor',
    'SLA Monitor',
    GETDATE()
    )

GO


-- Issue 11927 - parameters that will show on the custom data tab in IMECentric.  For Allstate
INSERT INTO tblParamProperty (ParamPropertyGroupID, LabelText, FieldName, Required, AllowedValues, DateAdded, UserIDAdded)
VALUES (2, 'Policy Company Name', 'PolicyCompanyName', 0, NULL, GETDATE(), 'Admin'),
       (2, 'Policy Company Code', 'PolicyCompanyCode', 0, NULL, GETDATE(), 'Admin'),
       (2, 'NAIC Company Code', 'NAICCompanyCode', 0, NULL, GETDATE(), 'Admin'),
       (2, 'Address', 'PolicyCompanyAddress', 0, NULL, GETDATE(), 'Admin')

GO

