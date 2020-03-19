INSERT INTO tblSetting (Name, Value) VALUES ('UseNewFeeSchedulingMenuItems', 'True')
GO


DELETE FROM tblTATCalculationMethodEvent
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (5, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (6, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (7, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (8, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (9, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (12, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (13, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (14, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (15, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (16, 1320)
GO

-- Issue 11509 - set default invoicing and vouchering fee schedule versions
  update tblOffice set [FSInvoiceSetting] = 1 where [FSInvoiceSetting] is null
  update tblOffice set [FSVoucherSetting] = 1 where [FSVoucherSetting] is null

