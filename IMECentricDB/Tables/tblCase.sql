CREATE TABLE [dbo].[tblCase] (
    [CaseNbr]                          INT              IDENTITY (1000, 1) NOT NULL,
    [ChartNbr]                         INT              NULL,
    [DoctorLocation]                   VARCHAR (10)     NULL,
    [ClientCode]                       INT              NULL,
    [MarketerCode]                     VARCHAR (15)     NULL,
    [SchedulerCode]                    VARCHAR (15)     NULL,
    [Priority]                         VARCHAR (15)     NULL,
    [Status]                           INT              NULL,
    [CaseType]                         INT              NULL,
    [DateAdded]                        DATETIME         NULL,
    [DateEdited]                       DATETIME         NULL,
    [UserIDAdded]                      VARCHAR (15)     NULL,
    [UserIDEdited]                     VARCHAR (15)     NULL,
    [SchedCode]                        INT              NULL,
    [ApptDate]                         DATETIME         NULL,
    [ApptTime]                         DATETIME         NULL,
    [ClaimNbr]                         VARCHAR (50)     NULL,
    [DateOfInjury]                     DATETIME         NULL,
    [Allegation]                       TEXT             NULL,
    [CalledInBy]                       VARCHAR (50)     NULL,
    [Notes]                            TEXT             NULL,
    [ScheduleNotes]                    TEXT             NULL,
    [RequestedDoc]                     VARCHAR (100)    NULL,
    [DateMedsRecd]                     DATETIME         NULL,
    [TypeMedsRecd]                     VARCHAR (50)     NULL,
    [TransReceived]                    DATETIME         NULL,
    [ShowNoShow]                       INT              CONSTRAINT [DF_tblCase_ShowNoShow] DEFAULT (null) NULL,
    [RptStatus]                        VARCHAR (50)     NULL,
    [ReportVerbal]                     BIT              NULL,
    [EmailClient]                      BIT              NULL,
    [EmailDoctor]                      BIT              NULL,
    [EmailPAttny]                      BIT              NULL,
    [FaxClient]                        BIT              NULL,
    [FaxDoctor]                        BIT              NULL,
    [FaxPAttny]                        BIT              NULL,
    [ApptRptsSelect]                   BIT              CONSTRAINT [DF_tblCase_ApptRptsSelect] DEFAULT (0) NULL,
    [ChartPrepSelect]                  BIT              CONSTRAINT [DF_tblCase_ChartPrepSelect] DEFAULT (0) NULL,
    [ApptSelect]                       BIT              CONSTRAINT [DF_tblCase_ApptSelect] DEFAULT (0) NULL,
    [AwaitTransSelect]                 BIT              CONSTRAINT [DF_tblCase_AwaitTransSelect] DEFAULT (0) NULL,
    [InTransSelect]                    BIT              CONSTRAINT [DF_tblCase_InTransSelect] DEFAULT (0) NULL,
    [InQASelect]                       BIT              CONSTRAINT [DF_tblCase_InQASelect] DEFAULT (0) NULL,
    [DrChartSelect]                    BIT              CONSTRAINT [DF_tblCase_DrChartSelect] DEFAULT (0) NULL,
    [DateDrChart]                      DATETIME         NULL,
    [BilledSelect]                     BIT              CONSTRAINT [DF_tblCase_BilledSelect] DEFAULT (0) NULL,
    [MiscSelect]                       BIT              NULL,
    [InvoiceDate]                      DATETIME         NULL,
    [InvoiceAmt]                       MONEY            CONSTRAINT [DF_tblCase_invoiceamt] DEFAULT (0) NULL,
    [PlaintiffAttorneyCode]            INT              NULL,
    [DefenseAttorneyCode]              INT              NULL,
    [CommitDate]                       DATETIME         NULL,
    [ServiceCode]                      INT              NULL,
    [IssueCode]                        INT              NULL,
    [DoctorCode]                       INT              NULL,
    [WCBNbr]                           VARCHAR (110)    NULL,
    [SpecialInstructions]              TEXT             NULL,
    [USDVarChar1]                      VARCHAR (50)     NULL,
    [USDVarChar2]                      VARCHAR (50)     NULL,
    [USDDate1]                         DATETIME         NULL,
    [USDDate2]                         DATETIME         NULL,
    [USDText1]                         TEXT             NULL,
    [USDText2]                         TEXT             NULL,
    [USDInt1]                          INT              NULL,
    [USDInt2]                          INT              NULL,
    [USDMoney1]                        MONEY            NULL,
    [USDMoney2]                        MONEY            NULL,
    [BComplete]                        BIT              NULL,
    [BHandDelivery]                    BIT              CONSTRAINT [DF_tblCase_bhanddelivery] DEFAULT (0) NULL,
    [SInternalCaseNbr]                 VARCHAR (70)     NULL,
    [SReqSpecialty]                    VARCHAR (500)    NULL,
    [DoctorSpecialty]                  VARCHAR (500)    NULL,
    [FeeCode]                          INT              NULL,
    [VoucherSelect]                    BIT              NULL,
    [VoucherAmt]                       MONEY            CONSTRAINT [DF_tblCase_voucheramt] DEFAULT (0) NULL,
    [VoucherDate]                      DATETIME         NULL,
    [ICDCodeA]                         VARCHAR (70)     NULL,
    [RecCode]                          INT              NULL,
    [BillClientCode]                   INT              NULL,
    [OfficeCode]                       INT              NULL,
    [QARep]                            VARCHAR (15)     NULL,
    [PhotoRqd]                         BIT              NULL,
    [CertifiedMail]                    BIT              NULL,
    [ICDCodeB]                         VARCHAR (70)     NULL,
    [ICDCodeC]                         VARCHAR (70)     NULL,
    [ICDCodeD]                         VARCHAR (70)     NULL,
    [PanelNbr]                         INT              NULL,
    [DoctorName]                       VARCHAR (100)    NULL,
    [HearingDate]                      SMALLDATETIME    NULL,
    [CertMailNbr]                      VARCHAR (30)     NULL,
    [LastStatusChg]                    DATETIME         NULL,
    [Jurisdiction]                     VARCHAR (5)      NULL,
    [PrevAppt]                         DATETIME         NULL,
    [MasterSubCase]                    VARCHAR (1)      NULL,
    [MasterCaseNbr]                    INT              NULL,
    [PublishOnWeb]                     BIT              CONSTRAINT [DF_tblcase_publishonweb] DEFAULT (0) NULL,
    [WebGUID]                          UNIQUEIDENTIFIER NULL,
    [WebLastSynchDate]                 DATETIME         NULL,
    [WebNotifyEmail]                   VARCHAR (200)    NULL,
    [AssessmentToAddress]              VARCHAR (50)     NULL,
    [OCF25Date]                        SMALLDATETIME    NULL,
    [DateForminDispute]                SMALLDATETIME    NULL,
    [AssessingFacility]                VARCHAR (100)    NULL,
    [ReferralMethod]                   INT              NULL,
    [ReferralType]                     INT              NULL,
    [CSR1]                             VARCHAR (15)     NULL,
    [CSR2]                             VARCHAR (15)     NULL,
    [LegalEvent]                       BIT              NULL,
    [PILegalEvent]                     BIT              NULL,
    [TransCode]                        INT              NULL,
    [PublishDocuments]                 BIT              CONSTRAINT [DF_tblCase_PublishDocuments] DEFAULT (0) NULL,
    [DateReceived]                     DATETIME         NULL,
    [USDDate3]                         DATETIME         NULL,
    [USDDate4]                         DATETIME         NULL,
    [USDDate5]                         DATETIME         NULL,
    [USDBit1]                          BIT              CONSTRAINT [DF_tblCase_USDBit1] DEFAULT (0) NULL,
    [USDBit2]                          BIT              CONSTRAINT [DF_tblCase_USDBit2] DEFAULT (0) NULL,
    [ClaimNbrExt]                      VARCHAR (50)     NULL,
    [DefParaLegal]                     INT              NULL,
    [AttorneyNote]                     TEXT             NULL,
    [BillingNote]                      TEXT             NULL,
    [ExternalDueDate]                  DATETIME         NULL,
    [InternalDueDate]                  DATETIME         NULL,
    [TrialWeek1]                       DATETIME         NULL,
    [AvailableWeek1]                   BIT              NULL,
    [Week1Mon]                         BIT              CONSTRAINT [DF_tblCase_Week1Mon] DEFAULT ((0)) NULL,
    [Week1Tue]                         BIT              CONSTRAINT [DF_tblCase_Week1Tue] DEFAULT ((0)) NULL,
    [Week1Wed]                         BIT              CONSTRAINT [DF_tblCase_Week1Wed] DEFAULT ((0)) NULL,
    [Week1Thu]                         BIT              CONSTRAINT [DF_tblCase_Week1Thu] DEFAULT ((0)) NULL,
    [Week1Fri]                         BIT              CONSTRAINT [DF_tblCase_Week1Fri] DEFAULT ((0)) NULL,
    [TrialWeek2]                       DATETIME         NULL,
    [AvailableWeek2]                   BIT              NULL,
    [Week2Mon]                         BIT              CONSTRAINT [DF_tblCase_Week2Mon] DEFAULT ((0)) NULL,
    [Week2Tue]                         BIT              CONSTRAINT [DF_tblCase_Week2Tue] DEFAULT ((0)) NULL,
    [Week2Wed]                         BIT              CONSTRAINT [DF_tblCase_Week2Wed] DEFAULT ((0)) NULL,
    [Week2Thu]                         BIT              CONSTRAINT [DF_tblCase_Week2Thu] DEFAULT ((0)) NULL,
    [Week2Fri]                         BIT              CONSTRAINT [DF_tblCase_Week2Fri] DEFAULT ((0)) NULL,
    [CourtHouse]                       INT              NULL,
    [Judge]                            VARCHAR (50)     NULL,
    [RoomNbr]                          VARCHAR (10)     NULL,
    [HoursNeeded]                      VARCHAR (10)     NULL,
    [PreTrialConference]               VARCHAR (30)     NULL,
    [AvailabilityComments]             TEXT             NULL,
    [ExpertComments]                   TEXT             NULL,
    [ProposedServiceDateTime]          DATETIME         NULL,
    [PlaintiffDefense]                 VARCHAR (20)     NULL,
    [VenueID]                          INT              NULL,
    [ForecastDate]                     DATETIME         NULL,
    [TransportationRequired]           BIT              CONSTRAINT [DF_tblCase_TransportationRequired] DEFAULT ((0)) NULL,
    [InterpreterRequired]              BIT              CONSTRAINT [DF_tblCase_InterpreterRequired] DEFAULT ((0)) NULL,
    [LanguageID]                       INT              NULL,
    [bln3DayNotifClaimant]             BIT              CONSTRAINT [DF_tblCase_bln3DayNotifClaimant] DEFAULT ((0)) NULL,
    [bln3DayNotifAttorney]             BIT              CONSTRAINT [DF_tblCase_bln3DayNotifAttorney] DEFAULT ((0)) NULL,
    [bln14DayNotifClaimant]            BIT              CONSTRAINT [DF_tblCase_bln14DayNotifClaimant] DEFAULT ((0)) NULL,
    [bln14DayNotifAttorney]            BIT              CONSTRAINT [DF_tblCase_bln14DayNotifAttorney] DEFAULT ((0)) NULL,
    [blnImedNotifClaimant]             BIT              CONSTRAINT [DF_tblCase_blnImedNotifClaimant] DEFAULT ((0)) NULL,
    [blnImedNotifAttorney]             BIT              CONSTRAINT [DF_tblCase_blnImedNotifAttorney] DEFAULT ((0)) NULL,
    [EWReferralType]                   INT              CONSTRAINT [DF_tblCase_EWReferralType] DEFAULT ((0)) NOT NULL,
    [EWReferralEWFacilityID]           INT              NULL,
    [InputSourceID]                    INT              NULL,
    [ReminderNotifyDays]               INT              NULL,
    [OrigApptTime]                     DATETIME         NULL,
    [RptFinalizedDate]                 DATETIME         NULL,
    [ApptMadeDate]                     DATETIME         NULL,
    [DateCompleted]                    DATETIME         NULL,
    [DateCanceled]                     DATETIME         NULL,
    [GenerateDocumentsClient]          BIT              NULL,
    [GenerateDocumentsDoctor]          BIT              NULL,
    [GenerateDocumentsExaminee]        BIT              NULL,
    [DeliverFinalReportClient]         BIT              NULL,
    [DeliverFinalInvoiceClient]        BIT              NULL,
    [RptInitialDraftDate]              DATETIME         NULL,
    [RptSentDate]                      DATETIME         NULL,
    [ReqEWAccreditationID]             INT              NULL,
    [ApptStatusID]                     INT              NULL,
    [CaseApptID]                       INT              NULL,
    [MMIReached]                       BIT              NULL,
    [MMITreatmentWeeks]                INT              NULL,
    [EWNetworkID]                      INT              NULL,
    [DoctorReason]                     VARCHAR (25)     NULL,
    [ICDFormat]                        INT              NULL,
    [ICDCodeE]                         VARCHAR (10)     NULL,
    [ICDCodeF]                         VARCHAR (10)     NULL,
    [ICDCodeG]                         VARCHAR (10)     NULL,
    [ICDCodeH]                         VARCHAR (10)     NULL,
    [ICDCodeI]                         VARCHAR (10)     NULL,
    [ICDCodeJ]                         VARCHAR (10)     NULL,
    [ICDCodeK]                         VARCHAR (10)     NULL,
    [ICDCodeL]                         VARCHAR (10)     NULL,
    [Recommendation]                   TEXT             NULL,
    [NeedFurtherTreatment]             BIT              CONSTRAINT [DF_tblCase_NeedFurtherTreatment] DEFAULT ((0)) NOT NULL,
    [TreatmentLength]                  INT              NULL,
    [TreatmentLengthUnit]              VARCHAR (1)      NULL,
    [ReExam]                           BIT              CONSTRAINT [DF_tblCase_ReExam] DEFAULT ((0)) NOT NULL,
    [ReExamDate]                       DATETIME         NULL,
    [ReExamProcessed]                  BIT              CONSTRAINT [DF_tblCase_ReExamProcessed] DEFAULT ((0)) NOT NULL,
    [ReExamNoticePrinted]              BIT              CONSTRAINT [DF_tblCase_ReExamNoticePrinted] DEFAULT ((0)) NOT NULL,
    [IsReExam]                         BIT              CONSTRAINT [DF_tblCase_IsReExam] DEFAULT ((0)) NOT NULL,
    [CourtIndexNbr]                    VARCHAR (50)     NULL,
    [EWFeeZoneID]                      INT              NULL,
    [PhotoRcvd]                        BIT              CONSTRAINT [DF_tblCase_PhotoRcvd] DEFAULT ((0)) NOT NULL,
    [CertMailNbr2]                     VARCHAR (30)     NULL,
    [CreateCvrLtr]                     BIT              CONSTRAINT [DF_tblCase_CreateCvrLtr] DEFAULT ((0)) NOT NULL,
    [ExtCaseNbr]                       INT              CONSTRAINT [DF_tblCase_ExtCaseNbr] DEFAULT ((0)) NOT NULL,
    [DateOfInjury2]                    DATETIME         NULL,
    [DateOfInjury3]                    DATETIME         NULL,
    [DateOfInjury4]                    DATETIME         NULL,
    [ReferralAssignmentRuleID]         INT              NULL,
    [AllowMigratingClaim]              BIT              NULL,
    [CompanyCode]                      INT              NULL,
    [TATEnteredToScheduled]            INT              NULL,
    [TATEnteredToMRRReceived]          INT              NULL,
    [TATScheduledToExam]               INT              NULL,
    [TATReport]                        INT              NULL,
    [TATServiceLifeCycle]              INT              NULL,
    [ConfirmExamineePhone]             BIT              CONSTRAINT [DF_tblCase_ConfirmExamineePhone] DEFAULT ((1)) NOT NULL,
    [ConfirmExamineeText]              BIT              CONSTRAINT [DF_tblCase_ConfirmExamineeText] DEFAULT ((1)) NOT NULL,
    [ConfirmAttorneyPhone]             BIT              CONSTRAINT [DF_tblCase_ConfirmAttorneyPhone] DEFAULT ((1)) NOT NULL,
    [EmployerID]                       INT              NULL,
    [InsuringCompany]                  VARCHAR (100)    NULL,
    [EmployerAddressID]                INT              NULL,
    [TATExamToClientNotified]          INT              NULL,
    [TATExamToRptReceived]             INT              NULL,
    [TATRptReceivedToQAComplete]       INT              NULL,
    [TATQACompleteToRptSent]           INT              NULL,
    [TATRptSentToInvoiced]             INT              NULL,
    [TATCalculationGroupID]            INT              NULL,
    [SLARuleID]                        INT              NULL,
    [AwaitingScheduling]               DATETIME         NULL,
    [TATAwaitingScheduling]            INT              NULL,
    [DateAcknowledged]                 DATETIME         NULL,
    [TATEnteredToAcknowledged]         INT              NULL,
    [MMIReachedStatus]                 VARCHAR (3)      NULL,
    [TATEnteredToExam]                 INT              NULL,
    [TATAwaitingSchedulingToRptSent]   INT              NULL,
    [TATAwaitingSchedulingToExam]      INT              NULL,
    [IssueVersion]                     INT              NULL,
    [CanceledByID]                     INT              NULL,
    [CanceledReason]                   VARCHAR (300)    NULL,
    [CanceledByUserID]                 VARCHAR (15)     NULL,
    [CancelReasonDetailID]             INT              NULL,
    [IsAutoReExam]                     BIT              NULL,
    [ContactClientForReExam]           BIT              NULL,
    [RequestedDoctorCode]              INT              NULL,
    [RequestedLocationCode]            INT              NULL,
    [CaseCaption]                      VARCHAR (200)    NULL,
    [LitigationNotes]                  VARCHAR (MAX)    NULL,
    [DoctorRptDueDate]                 DATETIME         NULL,
    [NotaryRequired]                   BIT              CONSTRAINT [DF_tblCase_NotaryRequired] DEFAULT ((0)) NOT NULL,
    [NotaryRequiredCheckedDate]        SMALLDATETIME    NULL,
    [ReExamNoticePrintedDate]          DATETIME         NULL,
    [PreviousCaseNbr]                  INT              NULL,
    [DoctorScheduledRank]              INT              NULL,
    [ScheduleMethod]                   INT              NULL,
    [AddlClaimNbrs]                    VARCHAR (50)     NULL,
    [NotarySent]                       BIT              CONSTRAINT [DF_tblCase_NotarySent] DEFAULT ((0)) NOT NULL,
    [PreAuthorization]                 VARCHAR (30)     NULL,
    [WorkCompCaseType]                 VARCHAR (30)     NULL,
    [IsNew]                            BIT              CONSTRAINT [DF_tblCase_IsNew] DEFAULT ((1)) NOT NULL,
    [DrMedRecsDueDate]                 DATETIME         NULL,
    [TATDateLossToApptDate]            INT              NULL,
    [TATInitialApptDateToApptDate]     INT              NULL,
    [TATDateReceivedToInitialApptDate] INT              NULL,
    [RptQADraftDate]                   DATETIME         NULL,
    [TATQADraftToQAComplete]           INT              NULL,
    [DoctorBlockTimeSlotID]            INT              NULL,
    [OrigApptMadeDate]                 DATETIME         NULL,
    [RecordRetrievalMethod]            INT              CONSTRAINT [DF_tblCase_RecordRetrievalMethod] DEFAULT ((0)) NOT NULL,
    [CustomerSystemID]                 VARCHAR (50)     NULL,
    [RetrieveMedRecords]               BIT              CONSTRAINT [DF_tblCase_RetrieveMedRecords] DEFAULT ((0)) NULL,
    [RetrieveFilms]                    BIT              CONSTRAINT [DF_tblCase_RetrieveFilms] DEFAULT ((0)) NULL,
    [RetrieveStudies]                  VARCHAR (200)    NULL,
    [AcctQuoteIDQuoteTATCalc]          INT              NULL,
    [AcctQuoteIDApprovalTATCalc]       INT              NULL,
    [TATExamSchedToQuoteSent]          INT              NULL,
    [TATExamSchedToApprovalSent]       INT              NULL,
    [TATApprovalSentToResentApproval]  INT              NULL,
    [InvFeeQuoteTotalAmt]              MONEY            NULL,
    [InvFeeApprovalTotalAmt]           MONEY            NULL,
    [LegalCourtVenue]                  VARCHAR (70)     NULL,
    [LegalCourtCounty]                 VARCHAR (50)     NULL,
    [LegalCity]                        VARCHAR (50)     NULL,
    [LegalInsuranceCompany]            VARCHAR (70)     NULL,
    [ExamStartTime]                    DATETIME         NULL,
    [ExamEndTime]                      DATETIME         NULL,
    [TimeReviewingRecords]             VARCHAR (20)     NULL,
    [Tags]                             VARCHAR (1000)   NULL,
    [TATExamDateToNotifyShowNoShow]    INT              NULL,
    [DateMedsSentToDr]                 DATETIME         NULL,
    [TATDateMedsSentToDrToRptSentDate] INT              NULL,
    [RPAMedRecRequestDate]             DATETIME         NULL, 
    [RPAMedRecUploadAckDate]           DATETIME         NULL, 
    [RPAMedRecUploadAckUserID]         VARCHAR(20)      NULL, 
    [RPAMedRecUploadStatus]            VARCHAR(15)      NULL, 
    [RPAMedRecCompleteDate]            DATETIME         NULL, 
    CONSTRAINT [PK_tblCase] PRIMARY KEY CLUSTERED ([CaseNbr] ASC),
    CONSTRAINT [FK_tblCase_tblClient] FOREIGN KEY ([ClientCode]) REFERENCES [dbo].[tblClient] ([ClientCode]),
    CONSTRAINT [FK_tblCase_tblExaminee] FOREIGN KEY ([ChartNbr]) REFERENCES [dbo].[tblExaminee] ([ChartNbr])
);











GO
CREATE TRIGGER tblCase_AfterInsert_TRG 
  ON tblCase
AFTER INSERT
AS
  UPDATE tblCase
   SET tblCase.ExtCaseNbr = Inserted.CaseNbr, tblCase.CompanyCode = tblClient.CompanyCode
   FROM Inserted
   LEFT OUTER JOIN tblClient ON tblClient.ClientCode = Inserted.ClientCode
   WHERE tblCase.CaseNbr = Inserted.CaseNbr

GO
CREATE TRIGGER tblCase_AfterUpdate_TRG 
  ON tblCase
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
CREATE NONCLUSTERED INDEX [IX_tblCase_ExtCaseNbr]
    ON [dbo].[tblCase]([ExtCaseNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_MasterCaseNbr]
    ON [dbo].[tblCase]([MasterCaseNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_PanelNbr]
    ON [dbo].[tblCase]([PanelNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_CompanyCode]
    ON [dbo].[tblCase]([CompanyCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ClientCode]
    ON [dbo].[tblCase]([ClientCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_BillClientCode]
    ON [dbo].[tblCase]([BillClientCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ClaimNbr]
    ON [dbo].[tblCase]([ClaimNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ChartNbr]
    ON [dbo].[tblCase]([ChartNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ForecastDate]
    ON [dbo].[tblCase]([ForecastDate] ASC);


GO


CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatus]
    ON [dbo].[tblCase]([OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation],
			[MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode],
			[CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ApptDateOfficeCodeStatus]
    ON [dbo].[tblCase]([ApptDate] ASC, [OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation],
			[MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode],
			[CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateAddedOfficeCodeStatus]
    ON [dbo].[tblCase]([DateAdded] ASC, [OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation],
			[MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode],
			[CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateReceivedOfficeCodeStatus]
    ON [dbo].[tblCase]([DateReceived] ASC, [OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation],
			[MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode],
			[CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeReExamReExamProcessedReExamDate]
    ON [dbo].[tblCase]([OfficeCode] ASC, [ReExam] ASC, [ReExamProcessed] ASC, [ReExamDate] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation],
			[MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode],
			[CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeChartNbrClaimNbr]
    ON [dbo].[tblCase]([OfficeCode] ASC, [ChartNbr] ASC, [ClaimNbr] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation]
    ON [dbo].[tblCase]([DoctorCode] ASC, [CaseNbr] ASC, [ChartNbr] ASC, [ClientCode] ASC, [Status] ASC, [ApptDate] ASC, [DoctorLocation] ASC);



GO
CREATE NONCLUSTERED INDEX [IX_tblCase_SchedCode]
    ON [dbo].[tblCase]([SchedCode] ASC)
    INCLUDE([PanelNbr], [ExtCaseNbr], [ChartNbr], [OfficeCode], [ClientCode], [CaseType], [ServiceCode], [ClaimNbr], [DoctorName], [PhotoRqd], [InterpreterRequired]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeSchedulerCode]
    ON [dbo].[tblCase]([OfficeCode] ASC, [SchedulerCode] ASC)
    INCLUDE([CaseNbr], [ClientCode], [ServiceCode], [Status]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeNotaryRequired]
    ON [dbo].[tblCase]([OfficeCode] ASC, [NotaryRequired] ASC)
    INCLUDE([ChartNbr], [ClientCode], [ServiceCode]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_WCBNbrOfficeCode]
    ON [dbo].[tblCase]([WCBNbr] ASC, [OfficeCode] ASC)
    INCLUDE([ChartNbr], [DoctorLocation], [ClientCode], [SchedulerCode], [Status], [CaseType], [ApptDate], [ClaimNbr], [PlaintiffAttorneyCode], [DefenseAttorneyCode], [ServiceCode], [DoctorCode], [DoctorSpecialty], [RecCode], [DoctorName], [Jurisdiction], [TransCode], [DefParaLegal], [VenueID], [LanguageID], [ApptStatusID], [CaseApptID], [ExtCaseNbr], [EmployerID], [EmployerAddressID]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_TransCode]
    ON [dbo].[tblCase]([TransCode] ASC)
    INCLUDE([OfficeCode]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_PlaintiffAttorneyCode]
    ON [dbo].[tblCase]([PlaintiffAttorneyCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCode]
    ON [dbo].[tblCase]([OfficeCode] ASC)
    INCLUDE([ChartNbr], [DoctorLocation], [ClientCode], [SchedulerCode], [Status], [CaseType], [ApptDate], [ClaimNbr], [PlaintiffAttorneyCode], [DefenseAttorneyCode], [ServiceCode], [DoctorCode], [DoctorSpecialty], [RecCode], [DoctorName], [CertMailNbr], [Jurisdiction], [TransCode], [DefParaLegal], [VenueID], [LanguageID], [ApptStatusID], [CaseApptID], [CertMailNbr2], [ExtCaseNbr], [EmployerID], [EmployerAddressID]);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DefParaLegal]
    ON [dbo].[tblCase]([DefParaLegal] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DefenseAttorneyCode]
    ON [dbo].[tblCase]([DefenseAttorneyCode] ASC);

