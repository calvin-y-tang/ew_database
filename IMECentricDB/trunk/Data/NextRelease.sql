--Issue 11389 - Changes to ext priority code for mi-Support

DELETE FROM tblDPSPriority

SET IDENTITY_INSERT [dbo].[tblDPSPriority] ON
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (1, 'Standard (24hr)', 'Medium', 2, 24, NULL)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (2, 'Rush (4hr)', 'Rush', 1, 4, 1)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (3, 'Complex (48hr)', 'Low', 2, 48, NULL)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (4, 'High (12hr)', 'High', 2, 12, NULL)
SET IDENTITY_INSERT [dbo].[tblDPSPriority] OFF

GO

-- Issue 11433
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(109, 'ClientGenDocsToAddtlEmail', 'Case', 'When sending docs to client cc/bcc additional email addresses', 1, 1201, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0),
      (110, 'ClientDistDocsToAddtlEmail', 'Case', 'When distribute docs to client cc/bcc additional email addresses', 1, 1202, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0),
	  (111, 'ClientDistRptToAddtlEmail', 'Case', 'When distribute rpts to client cc/bcc additional email addresses', 1, 1320, 0, 'AttachOption', 'CCEmailAddress', 'BccEmailAddress', NULL, NULL, 0)
GO


