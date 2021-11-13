INSERT INTO tblDataField VALUES (111, 'tblCase', 'TATAwaitingScheduling', '')
GO

INSERT INTO tblDataField VALUES (210, 'tblCase', 'AwaitingScheduling', 'Available for Scheduling')
GO

INSERT INTO tblTATCalculationMethod VALUES (12, 210, 207, 'Hour', 111, 0)
GO

UPDATE tblTATCalculationGroupDetail set DisplayOrder = DisplayOrder + 1 where TATCalculationGroupID = 1 and DisplayOrder > 1
GO

INSERT INTO tblTATCalculationGroupDetail VALUES (1, 12, 2)
GO

UPDATE c SET AwaitingScheduling = maxdate FROM tblCase AS c 
INNER JOIN
(SELECT CaseNbr, MAX(EventDate) AS maxdate FROM tblCaseHistory WHERE STATUS = 3 OR STATUS = 10 GROUP BY CaseNbr) AS ch ON c.CaseNbr = ch.CaseNbr
 INNER JOIN tblServices AS s ON
        c.ServiceCode = s.ServiceCode
WHERE c.[Status] NOT IN (8, 9) AND c.TATCalculationGroupID = 1 AND S.ApptBased = 1
GO

UPDATE c SET c.AwaitingScheduling = c.LastStatusChg
FROM tblCase AS c
INNER JOIN tblServices AS S ON c.ServiceCode = S.ServiceCode
WHERE c.TATCalculationGroupID = 1 AND S.ApptBased = 1 AND c.AwaitingScheduling IS NULL AND c.[STATUS] = 10
GO

UPDATE c SET c.AwaitingScheduling = c.DateAdded
FROM tblCase AS c
INNER JOIN tblServices AS S ON c.ServiceCode = S.ServiceCode
WHERE c.TATCalculationGroupID = 1 AND S.ApptBased = 1 AND c.AwaitingScheduling IS NULL AND c.[STATUS] not in (8,9)
GO

INSERT INTO tbluserfunction VALUES ('SLAExceptionAddEdit', 'SLA Exception List - Add/Edit')
GO

insert into tblUserFunction 
values ('SuppressWeb', 'Suppress Web Doc Print and Download')
GO





INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1001, 'Case Added', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1010, 'Case Status Change', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1011, 'Case Marked as Rush', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1012, 'Change External Due Date', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1013, 'Change Internal Due Date', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1014, 'Case Change Service', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1015, 'Medical Records Received', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1101, 'Case Scheduled', 'Appointment')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1105, 'Appointment Cancellation', 'Appointment')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1106, 'Show', 'Appointment')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1107, 'No Show', 'Appointment')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1108, 'Unable to Examine', 'Appointment')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1109, 'Late Cancellation', 'Appointment')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1201, 'Generate Document', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1202, 'Distribute Document', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1305, 'Attach Report', 'Report')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1310, 'Report Finalized', 'Report')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1320, 'Distribute Report', 'Report')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1801, 'Generate Invoice', 'Accounting')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1802, 'Generate Voucher', 'Accounting')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1900, 'Case Cancellation', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1901, 'Case Cancellation with a Pre-Invoice Client', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (1902, 'Case Cancellation with a Pre-Pay Doctor', 'Case')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (2001, 'Company Added', 'Company')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (3001, 'Client Added', 'Clinet')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (4001, 'Doctor Added', 'Doctor')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (4011, 'Doctor Added to ExamWorks Panel', 'Doctor')
INSERT INTO [dbo].[tblEvent] ([EventID], [Descrip], [Category]) VALUES (4012, 'Doctor Removed from ExamWorks Panel', 'Doctor')
GO

INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (5, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (6, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (7, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (8, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (9, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (12, 1101)
GO



PRINT(N'Add 58 rows to [dbo].[tblSLAException]')
SET IDENTITY_INSERT [dbo].[tblSLAException] ON
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (1, 1, 'Attorney Intervention', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (2, 1, 'Cancellation Request', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (3, 1, 'Clarification Needed', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (4, 1, 'Client Selected Physician', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (5, 1, 'Fee Approval Needed', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (6, 1, 'Jurisdictional Requirement', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (7, 1, 'No Show', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (8, 1, 'Other (Explanation Required)', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 1)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (9, 1, 'Rare Specialty Request', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (10, 1, 'Remote/Rural Location', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (11, 1, 'Reschedule', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
INSERT INTO [dbo].[tblSLAException] ([SLAExceptionID], [SLAExceptionGroupID], [Descrip], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ExternalCode], [RequireExplanation]) VALUES (12, 1, 'Specific Date and/or Time Request', 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', '', 0)
SET IDENTITY_INSERT [dbo].[tblSLAException] OFF

PRINT(N'Add 5 rows to [dbo].[tblSLAExceptionGroup]')
SET IDENTITY_INSERT [dbo].[tblSLAExceptionGroup] ON
INSERT INTO [dbo].[tblSLAExceptionGroup] ([SLAExceptionGroupID], [ProcessOrder], [Active], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [ParentCompanyID]) VALUES (1, 99, 1, '2017-03-17 00:00:00.000', 'System', '2017-03-17 00:00:00.000', 'System', NULL)
SET IDENTITY_INSERT [dbo].[tblSLAExceptionGroup] OFF
GO
