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
VALUES (2, 'Policy Company Code', 'PolicyCompanyCode', 0, NULL, GETDATE(), 'Admin'),
       (2, 'Policy Company Name', 'PolicyCompanyName', 0, NULL, GETDATE(), 'Admin'),
       (2, 'NAIC Company Code', 'NAICCompanyCode', 0, NULL, GETDATE(), 'Admin'),
       (2, 'Address', 'PolicyCompanyAddress', 0, NULL, GETDATE(), 'Admin')

GO


-- Issue 11916 - need to add Actions to table tblSLAAction
DELETE FROM tblSLAAction

SET IDENTITY_INSERT [dbo].[tblSLAAction] ON
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (1, 'Contacted Client', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (2, 'Contacted Doctor', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (3, 'Contacted Examinee', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (4, 'Resolve SLA', 0, 1)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (5, 'Other', 1, 0)
SET IDENTITY_INSERT [dbo].[tblSLAAction] OFF

