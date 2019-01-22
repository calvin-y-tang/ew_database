/*
TRUNCATE TABLE tblDPSPriority
TRUNCATE TABLE tblDPSSortModel
TRUNCATE TABLE tblDPSStatus

SET IDENTITY_INSERT [dbo].[tblDPSPriority] ON
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours]) VALUES (1, 'Standard (24hr)', 'Standard (24hr)', 2, 24)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours]) VALUES (2, 'Rush (4hr)', 'Rush (4hr)', 1, 4)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours]) VALUES (3, 'Complex (48hr)', 'Complex (48hr)', 2, 48)
SET IDENTITY_INSERT [dbo].[tblDPSPriority] OFF
GO
SET IDENTITY_INSERT [dbo].[tblDPSSortModel] ON
INSERT INTO [dbo].[tblDPSSortModel] ([SortModelID], [Description], [ExtSortModelCode]) VALUES (11, 'Chronological Order', 'Chronological Order')
INSERT INTO [dbo].[tblDPSSortModel] ([SortModelID], [Description], [ExtSortModelCode]) VALUES (12, 'Chart Order', 'Chart Order')
INSERT INTO [dbo].[tblDPSSortModel] ([SortModelID], [Description], [ExtSortModelCode]) VALUES (13, 'Special Request', 'Special Request')
SET IDENTITY_INSERT [dbo].[tblDPSSortModel] OFF
GO
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (0, 'New')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (10, 'Submitted (Pending)')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (20, 'Submitted')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (30, 'Submitted (Preparing)')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (40, 'Reviewing')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (70, 'Combined')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (80, 'Complete')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (85, 'Canceled (Pending)')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (90, 'Canceled')||||||| .r14829
GO
*/
