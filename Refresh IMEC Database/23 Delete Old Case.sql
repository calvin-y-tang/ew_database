--Delete Case before 2020
--SELECT TOP 1 CaseNbr FROM tblCase WHERE DateAdded>='2020-01-01' ORDER BY CaseNbr
SELECT * INTO tmpCase FROM tblCase WHERE CaseNbr>=20994290
DROP TABLE tblCase
EXEC sp_rename 'tmpCase', 'tblCase'
GO


SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON
GO
PRINT N'Creating trigger [dbo].[tblCase_AfterInsert_TRG] on [dbo].[tblCase]'
GO
CREATE TRIGGER [dbo].[tblCase_AfterInsert_TRG] 
  ON [dbo].[tblCase]
AFTER INSERT
AS
  UPDATE tblCase
   SET tblCase.ExtCaseNbr = Inserted.CaseNbr, tblCase.CompanyCode = tblClient.CompanyCode
   FROM Inserted
   LEFT OUTER JOIN tblClient ON tblClient.ClientCode = Inserted.ClientCode
   WHERE tblCase.CaseNbr = Inserted.CaseNbr
GO
PRINT N'Creating trigger [dbo].[tblCase_AfterUpdate_TRG] on [dbo].[tblCase]'
GO
CREATE TRIGGER [dbo].[tblCase_AfterUpdate_TRG] 
  ON [dbo].[tblCase]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT OFF
	DECLARE @caseNbr INT
	SELECT @caseNbr=Inserted.CaseNbr FROM Inserted

	IF UPDATE(ClientCode)
	BEGIN
		UPDATE tblCase SET CompanyCode=tblClient.CompanyCode
		FROM tblCase INNER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
		WHERE CaseNbr=@caseNbr
	END
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
PRINT N'Creating primary key [PK_tblCase] on [dbo].[tblCase]'
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [PK_tblCase] PRIMARY KEY CLUSTERED  ([CaseNbr])
GO
PRINT N'Creating index [IX_tblCase_ApptDateOfficeCodeStatus] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ApptDateOfficeCodeStatus] ON [dbo].[tblCase] ([ApptDate], [OfficeCode], [Status]) INCLUDE ([ApptTime], [CaseNbr], [CaseType], [ChartNbr], [ClientCode], [CompanyCode], [DoctorCode], [DoctorLocation], [EWReferralType], [ExtCaseNbr], [ForecastDate], [InputSourceID], [Jurisdiction], [MarketerCode], [Priority], [QARep], [SchedulerCode], [ServiceCode])
GO
PRINT N'Creating index [IX_tblCase_BillClientCode] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_BillClientCode] ON [dbo].[tblCase] ([BillClientCode])
GO
PRINT N'Creating index [IX_tblCase_ChartNbr] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ChartNbr] ON [dbo].[tblCase] ([ChartNbr])
GO
PRINT N'Creating index [IX_tblCase_ClaimNbr] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ClaimNbr] ON [dbo].[tblCase] ([ClaimNbr])
GO
PRINT N'Creating index [IX_tblCase_ClientCode] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ClientCode] ON [dbo].[tblCase] ([ClientCode])
GO
PRINT N'Creating index [IX_tblCase_CompanyCode] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_CompanyCode] ON [dbo].[tblCase] ([CompanyCode])
GO
PRINT N'Creating index [IX_tblCase_DateAddedOfficeCodeStatus] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateAddedOfficeCodeStatus] ON [dbo].[tblCase] ([DateAdded], [OfficeCode], [Status]) INCLUDE ([ApptTime], [CaseNbr], [CaseType], [ChartNbr], [ClientCode], [CompanyCode], [DoctorCode], [DoctorLocation], [EWReferralType], [ExtCaseNbr], [ForecastDate], [InputSourceID], [Jurisdiction], [MarketerCode], [Priority], [QARep], [SchedulerCode], [ServiceCode])
GO
PRINT N'Creating index [IX_tblCase_DateReceivedOfficeCodeStatus] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateReceivedOfficeCodeStatus] ON [dbo].[tblCase] ([DateReceived], [OfficeCode], [Status]) INCLUDE ([ApptTime], [CaseNbr], [CaseType], [ChartNbr], [ClientCode], [CompanyCode], [DoctorCode], [DoctorLocation], [EWReferralType], [ExtCaseNbr], [ForecastDate], [InputSourceID], [Jurisdiction], [MarketerCode], [Priority], [QARep], [SchedulerCode], [ServiceCode])
GO
PRINT N'Creating index [IX_tblCase_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation] ON [dbo].[tblCase] ([DoctorCode], [CaseNbr], [ChartNbr], [ClientCode], [Status], [ApptDate], [DoctorLocation])
GO
PRINT N'Creating index [IX_tblCase_ExtCaseNbr] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ExtCaseNbr] ON [dbo].[tblCase] ([ExtCaseNbr])
GO
PRINT N'Creating index [IX_tblCase_ForecastDate] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ForecastDate] ON [dbo].[tblCase] ([ForecastDate])
GO
PRINT N'Creating index [IX_tblCase_MasterCaseNbr] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_MasterCaseNbr] ON [dbo].[tblCase] ([MasterCaseNbr])
GO
PRINT N'Creating index [IX_tblCase_OfficeCodeChartNbrClaimNbr] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeChartNbrClaimNbr] ON [dbo].[tblCase] ([OfficeCode], [ChartNbr], [ClaimNbr])
GO
PRINT N'Creating index [IX_tblCase_OfficeCodeNotaryRequired] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeNotaryRequired] ON [dbo].[tblCase] ([OfficeCode], [NotaryRequired]) INCLUDE ([ChartNbr], [ClientCode], [ServiceCode])
GO
PRINT N'Creating index [IX_tblCase_OfficeCodeReExamReExamProcessedReExamDate] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeReExamReExamProcessedReExamDate] ON [dbo].[tblCase] ([OfficeCode], [ReExam], [ReExamProcessed], [ReExamDate]) INCLUDE ([ApptTime], [CaseNbr], [CaseType], [ChartNbr], [ClientCode], [CompanyCode], [DoctorCode], [DoctorLocation], [EWReferralType], [ExtCaseNbr], [ForecastDate], [InputSourceID], [Jurisdiction], [MarketerCode], [Priority], [QARep], [SchedulerCode], [ServiceCode])
GO
PRINT N'Creating index [IX_tblCase_OfficeCodeSchedulerCode] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeSchedulerCode] ON [dbo].[tblCase] ([OfficeCode], [SchedulerCode]) INCLUDE ([CaseNbr], [ClientCode], [ServiceCode], [Status])
GO
PRINT N'Creating index [IX_tblCase_OfficeCodeStatus] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatus] ON [dbo].[tblCase] ([OfficeCode], [Status]) INCLUDE ([ApptTime], [CaseNbr], [CaseType], [ChartNbr], [ClientCode], [CompanyCode], [DoctorCode], [DoctorLocation], [EWReferralType], [ExtCaseNbr], [ForecastDate], [InputSourceID], [Jurisdiction], [MarketerCode], [Priority], [QARep], [SchedulerCode], [ServiceCode])
GO
PRINT N'Creating index [IX_tblCase_PanelNbr] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_PanelNbr] ON [dbo].[tblCase] ([PanelNbr])
GO
PRINT N'Creating index [IX_tblCase_SchedCode] on [dbo].[tblCase]'
GO
CREATE NONCLUSTERED INDEX [IX_tblCase_SchedCode] ON [dbo].[tblCase] ([SchedCode]) INCLUDE ([CaseType], [ChartNbr], [ClaimNbr], [ClientCode], [DoctorName], [ExtCaseNbr], [InterpreterRequired], [OfficeCode], [PanelNbr], [PhotoRqd], [ServiceCode])
GO
PRINT N'Adding foreign keys to [dbo].[tblCase]'
GO
ALTER TABLE [dbo].[tblCase] WITH NOCHECK  ADD CONSTRAINT [FK_tblCase_tblClient] FOREIGN KEY ([ClientCode]) REFERENCES [dbo].[tblClient] ([ClientCode])
GO
ALTER TABLE [dbo].[tblCase] WITH NOCHECK  ADD CONSTRAINT [FK_tblCase_tblExaminee] FOREIGN KEY ([ChartNbr]) REFERENCES [dbo].[tblExaminee] ([ChartNbr])
GO
PRINT N'Adding constraints to [dbo].[tblCase]'
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ShowNoShow] DEFAULT (null) FOR [ShowNoShow]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ApptRptsSelect] DEFAULT (0) FOR [ApptRptsSelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ChartPrepSelect] DEFAULT (0) FOR [ChartPrepSelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ApptSelect] DEFAULT (0) FOR [ApptSelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_AwaitTransSelect] DEFAULT (0) FOR [AwaitTransSelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_InTransSelect] DEFAULT (0) FOR [InTransSelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_InQASelect] DEFAULT (0) FOR [InQASelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_DrChartSelect] DEFAULT (0) FOR [DrChartSelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_BilledSelect] DEFAULT (0) FOR [BilledSelect]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_invoiceamt] DEFAULT (0) FOR [InvoiceAmt]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_bhanddelivery] DEFAULT (0) FOR [BHandDelivery]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_voucheramt] DEFAULT (0) FOR [VoucherAmt]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblcase_publishonweb] DEFAULT (0) FOR [PublishOnWeb]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_PublishDocuments] DEFAULT (0) FOR [PublishDocuments]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_USDBit1] DEFAULT (0) FOR [USDBit1]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_USDBit2] DEFAULT (0) FOR [USDBit2]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week1Mon] DEFAULT ((0)) FOR [Week1Mon]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week1Tue] DEFAULT ((0)) FOR [Week1Tue]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week1Wed] DEFAULT ((0)) FOR [Week1Wed]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week1Thu] DEFAULT ((0)) FOR [Week1Thu]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week1Fri] DEFAULT ((0)) FOR [Week1Fri]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week2Mon] DEFAULT ((0)) FOR [Week2Mon]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week2Tue] DEFAULT ((0)) FOR [Week2Tue]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week2Wed] DEFAULT ((0)) FOR [Week2Wed]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week2Thu] DEFAULT ((0)) FOR [Week2Thu]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_Week2Fri] DEFAULT ((0)) FOR [Week2Fri]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_TransportationRequired] DEFAULT ((0)) FOR [TransportationRequired]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_InterpreterRequired] DEFAULT ((0)) FOR [InterpreterRequired]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_bln3DayNotifClaimant] DEFAULT ((0)) FOR [bln3DayNotifClaimant]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_bln3DayNotifAttorney] DEFAULT ((0)) FOR [bln3DayNotifAttorney]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_bln14DayNotifClaimant] DEFAULT ((0)) FOR [bln14DayNotifClaimant]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_bln14DayNotifAttorney] DEFAULT ((0)) FOR [bln14DayNotifAttorney]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_blnImedNotifClaimant] DEFAULT ((0)) FOR [blnImedNotifClaimant]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_blnImedNotifAttorney] DEFAULT ((0)) FOR [blnImedNotifAttorney]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_EWReferralType] DEFAULT ((0)) FOR [EWReferralType]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_NeedFurtherTreatment] DEFAULT ((0)) FOR [NeedFurtherTreatment]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ReExam] DEFAULT ((0)) FOR [ReExam]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ReExamProcessed] DEFAULT ((0)) FOR [ReExamProcessed]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ReExamNoticePrinted] DEFAULT ((0)) FOR [ReExamNoticePrinted]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_IsReExam] DEFAULT ((0)) FOR [IsReExam]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_PhotoRcvd] DEFAULT ((0)) FOR [PhotoRcvd]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_CreateCvrLtr] DEFAULT ((0)) FOR [CreateCvrLtr]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ExtCaseNbr] DEFAULT ((0)) FOR [ExtCaseNbr]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ConfirmExamineePhone] DEFAULT ((1)) FOR [ConfirmExamineePhone]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ConfirmExamineeText] DEFAULT ((1)) FOR [ConfirmExamineeText]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_ConfirmAttorneyPhone] DEFAULT ((1)) FOR [ConfirmAttorneyPhone]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_NotaryRequired] DEFAULT ((0)) FOR [NotaryRequired]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_NotarySent] DEFAULT ((0)) FOR [NotarySent]
GO
ALTER TABLE [dbo].[tblCase] ADD CONSTRAINT [DF_tblCase_IsNew] DEFAULT ((1)) FOR [IsNew]
GO

