DELETE FROM tblSLAAction

SET IDENTITY_INSERT [dbo].[tblSLAAction] ON
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (1, 'Contacted Client', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (2, 'Contacted Doctor', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (3, 'Contacted Examinee', 0, 0)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (4, 'Resolve SLA', 0, 1)
INSERT INTO [dbo].[tblSLAAction] ([SLAActionID], [Name], [RequireComment], [IsResolution]) VALUES (5, 'Other', 1, 0)
SET IDENTITY_INSERT [dbo].[tblSLAAction] OFF

