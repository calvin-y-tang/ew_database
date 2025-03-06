
---------------------------------------------------
--Adding a new field in tblDoctor to determine if the doctor record is actually another EW Facility
---------------------------------------------------

ALTER TABLE [tblDoctor]
  ADD [EWFacility] BIT
GO

---------------------------------------------------
--Adding new Exception when changing ExamWorks Doctor Panel
---------------------------------------------------

SET IDENTITY_INSERT [dbo].[tblExceptionList] ON
INSERT INTO [dbo].[tblExceptionList] ([ExceptionID], [Description], [Status], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited]) VALUES (23, 'Doctor Added to ExamWorks Panel', 'Active', '2010-11-12 00:00:00.000', 'Admin', '2010-11-12 00:00:00.000', 'Admin')
INSERT INTO [dbo].[tblExceptionList] ([ExceptionID], [Description], [Status], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited]) VALUES (24, 'Doctor Removed from ExamWorks Panel', 'Active', '2010-11-12 00:00:00.000', 'Admin', '2010-11-12 00:00:00.000', 'Admin')
SET IDENTITY_INSERT [dbo].[tblExceptionList] OFF

GO
update tblControl set DBVersion='1.30'
GO