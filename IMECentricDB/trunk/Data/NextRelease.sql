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
GO

-- Issue 11897 - new SLA Metrics
INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)
VALUES (216, 'tblCase', 'TATExamSchedToQuoteSent', null),
       (217, 'tblCase', 'TATExamSchedToApprovalSent', null),
       (218, 'tblCase', 'TATApprovalSentToResentApproval', null),
       (219, 'FeeQuote', 'DateClientInformed', 'Fee Quote Sent'), 
       (220, 'FeeApproval', 'DateClientInformed', 'Fee Approval Sent'),
       (221, 'FeeApproval', 'DateClientCommResent', 'Resent Fee Approval')
GO
INSERT INTO tblTATCalculationMethod(TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend)
VALUES(21, 207, 219, 'Day', 216, 0),
      (22, 207, 220, 'Day', 217, 0), 
      (23, 220, 221, 'Day', 218, 0)
GO
INSERT INTO tblEvent (EventID, Descrip, Category)
VALUES(1060, 'Fee Quote/Approval Saved', 'Case')
GO
INSERT INTO tblTATCalculationMethodEvent (TATCalculationMethodID, EventID)
VALUES (21,1060), 
	   (22,1060), 
	   (23,1060)
GO


