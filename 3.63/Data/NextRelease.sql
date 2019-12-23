--Issue 11389 - Changes to ext priority code for mi-Support

DELETE FROM tblDPSPriority

SET IDENTITY_INSERT [dbo].[tblDPSPriority] ON
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (1, 'Standard (24hr)', 'Medium', 2, 24, NULL)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (2, 'Rush (4hr)', 'Rush', 1, 4, 1)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (3, 'Complex (48hr)', 'Low', 2, 48, NULL)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (4, 'High (12hr)', 'High', 2, 12, NULL)
SET IDENTITY_INSERT [dbo].[tblDPSPriority] OFF

GO

