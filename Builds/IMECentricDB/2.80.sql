PRINT N'Dropping [dbo].[tblTranscriptionJob_AfterInsert_TRG]...';


GO
DROP TRIGGER [dbo].[tblTranscriptionJob_AfterInsert_TRG];


GO
PRINT N'Dropping [dbo].[tblAcctDetail].[IdxtblAcctDetail_BY_HeaderIDLineNbr]...';


GO
DROP INDEX [IdxtblAcctDetail_BY_HeaderIDLineNbr]
    ON [dbo].[tblAcctDetail];


GO
PRINT N'Dropping [dbo].[tblAcctHeader].[IdxtblAcctHeader_BY_CaseNbr]...';


GO
DROP INDEX [IdxtblAcctHeader_BY_CaseNbr]
    ON [dbo].[tblAcctHeader];


GO
PRINT N'Dropping [dbo].[tblAcctHeader].[IdxtblAcctHeader_BY_documentdatedocumentstatus]...';


GO
DROP INDEX [IdxtblAcctHeader_BY_documentdatedocumentstatus]
    ON [dbo].[tblAcctHeader];


GO
PRINT N'Dropping [dbo].[tblAcctHeader].[IdxtblAcctHeader_BY_DocumentNbrDocumentTypeEWFacilityID]...';


GO
DROP INDEX [IdxtblAcctHeader_BY_DocumentNbrDocumentTypeEWFacilityID]
    ON [dbo].[tblAcctHeader];


GO
PRINT N'Dropping [dbo].[tblAcctHeader].[IdxtblAcctHeader_BY_SeqNo]...';


GO
DROP INDEX [IdxtblAcctHeader_BY_SeqNo]
    ON [dbo].[tblAcctHeader];


GO
PRINT N'Dropping [dbo].[tblAcctHeader].[IX_tblacctheader_office]...';


GO
DROP INDEX [IX_tblacctheader_office]
    ON [dbo].[tblAcctHeader];


GO
PRINT N'Dropping [dbo].[tblAcctingTrans].[IdxtblAcctingTrans_BY_CaseNbrTypeStatusCodeDrOpCode]...';


GO
DROP INDEX [IdxtblAcctingTrans_BY_CaseNbrTypeStatusCodeDrOpCode]
    ON [dbo].[tblAcctingTrans];


GO
PRINT N'Dropping [dbo].[tblAcctingTrans].[IdxtblAcctingTrans_BY_StatusCode]...';


GO
DROP INDEX [IdxtblAcctingTrans_BY_StatusCode]
    ON [dbo].[tblAcctingTrans];


GO
PRINT N'Dropping [dbo].[tblAvailDoctor].[IX_tblavaildoctor]...';


GO
DROP INDEX [IX_tblavaildoctor]
    ON [dbo].[tblAvailDoctor];


GO
PRINT N'Dropping [dbo].[tblAvailDoctor].[IX_tblavaildoctor_1]...';


GO
DROP INDEX [IX_tblavaildoctor_1]
    ON [dbo].[tblAvailDoctor];


GO
PRINT N'Dropping [dbo].[tblAvailDoctor].[IX_tblavaildoctor_2]...';


GO
DROP INDEX [IX_tblavaildoctor_2]
    ON [dbo].[tblAvailDoctor];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_BillClientCode]...';


GO
DROP INDEX [IdxtblCase_BY_BillClientCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_ClientCode]...';


GO
DROP INDEX [IdxtblCase_BY_ClientCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_DateAddedOfficeCodeStatus]...';


GO
DROP INDEX [IdxtblCase_BY_DateAddedOfficeCodeStatus]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_DoctorCode]...';


GO
DROP INDEX [IdxtblCase_BY_DoctorCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation]...';


GO
DROP INDEX [IdxtblCase_BY_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_ExtCaseNbr]...';


GO
DROP INDEX [IdxtblCase_BY_ExtCaseNbr]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_ForecastDate]...';


GO
DROP INDEX [IdxtblCase_BY_ForecastDate]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_OfficeCodeChartNbrClaimNbr]...';


GO
DROP INDEX [IdxtblCase_BY_OfficeCodeChartNbrClaimNbr]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_OfficeCodeReExamReExamProcessedReExamDateClientCode]...';


GO
DROP INDEX [IdxtblCase_BY_OfficeCodeReExamReExamProcessedReExamDateClientCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_BY_PanelNbr]...';


GO
DROP INDEX [IdxtblCase_BY_PanelNbr]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IdxtblCase_For_MainForm]...';


GO
DROP INDEX [IdxtblCase_For_MainForm]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_1]...';


GO
DROP INDEX [IX_tblCase_1]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_2]...';


GO
DROP INDEX [IX_tblCase_2]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_3]...';


GO
DROP INDEX [IX_tblCase_3]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCaseMasterCaseNbr]...';


GO
DROP INDEX [IX_tblCaseMasterCaseNbr]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCaseAppt].[IdxtblCaseAppt_BY_CaseNbr]...';


GO
DROP INDEX [IdxtblCaseAppt_BY_CaseNbr]
    ON [dbo].[tblCaseAppt];


GO
PRINT N'Dropping [dbo].[tblCaseDocuments].[IX_tblCaseDocuments]...';


GO
DROP INDEX [IX_tblCaseDocuments]
    ON [dbo].[tblCaseDocuments];


GO
PRINT N'Dropping [dbo].[tblCaseHistory].[IdxtblCaseHistory_BY_FollowUpDate]...';


GO
DROP INDEX [IdxtblCaseHistory_BY_FollowUpDate]
    ON [dbo].[tblCaseHistory];


GO
PRINT N'Dropping [dbo].[tblCaseHistory].[ix_casehistorytype]...';


GO
DROP INDEX [ix_casehistorytype]
    ON [dbo].[tblCaseHistory];


GO
PRINT N'Dropping [dbo].[tblCaseHistory].[IX_tblCaseHistory]...';


GO
DROP INDEX [IX_tblCaseHistory]
    ON [dbo].[tblCaseHistory];


GO
PRINT N'Dropping [dbo].[tblCaseOtherParty].[IX_TblCaseOtherParty]...';


GO
DROP INDEX [IX_TblCaseOtherParty]
    ON [dbo].[tblCaseOtherParty];


GO
PRINT N'Dropping [dbo].[tblCasePanel].[IdxtblCasePanel_BY_DoctorCode]...';


GO
DROP INDEX [IdxtblCasePanel_BY_DoctorCode]
    ON [dbo].[tblCasePanel];


GO
PRINT N'Dropping [dbo].[tblCaseTrans].[IX_TblCaseTrans]...';


GO
DROP INDEX [IX_TblCaseTrans]
    ON [dbo].[tblCaseTrans];


GO
PRINT N'Dropping [dbo].[tblClient].[IdxtblClient_BY_ClientCodeCompanyCode]...';


GO
DROP INDEX [IdxtblClient_BY_ClientCodeCompanyCode]
    ON [dbo].[tblClient];


GO
PRINT N'Dropping [dbo].[tblClient].[IdxtblClient_BY_CompanyCode]...';


GO
DROP INDEX [IdxtblClient_BY_CompanyCode]
    ON [dbo].[tblClient];


GO
PRINT N'Dropping [dbo].[tblClient].[IX_tblClient]...';


GO
DROP INDEX [IX_tblClient]
    ON [dbo].[tblClient];


GO
PRINT N'Dropping [dbo].[tblCompany].[IdxtblCompany_BY_City]...';


GO
DROP INDEX [IdxtblCompany_BY_City]
    ON [dbo].[tblCompany];


GO
PRINT N'Dropping [dbo].[tblCompany].[IdxtblCompany_BY_IntName]...';


GO
DROP INDEX [IdxtblCompany_BY_IntName]
    ON [dbo].[tblCompany];


GO
PRINT N'Dropping [dbo].[tblCompanyCoverLetter].[IdxtblCompanyCoverLetter_UNIQUE_CompanyCodeEWCoverLetterID]...';


GO
DROP INDEX [IdxtblCompanyCoverLetter_UNIQUE_CompanyCodeEWCoverLetterID]
    ON [dbo].[tblCompanyCoverLetter];


GO
PRINT N'Dropping [dbo].[tblDegree].[IdxtblDegree_UNIQUE_DegreeCode]...';


GO
DROP INDEX [IdxtblDegree_UNIQUE_DegreeCode]
    ON [dbo].[tblDegree];


GO
PRINT N'Dropping [dbo].[tblDoctor].[IdxtblDoctor_BY_DictationAuthorID]...';


GO
DROP INDEX [IdxtblDoctor_BY_DictationAuthorID]
    ON [dbo].[tblDoctor];


GO
PRINT N'Dropping [dbo].[tblDoctor].[IdxtblDoctor_BY_LastNameFirstNameMiddleInitial]...';


GO
DROP INDEX [IdxtblDoctor_BY_LastNameFirstNameMiddleInitial]
    ON [dbo].[tblDoctor];


GO
PRINT N'Dropping [dbo].[tblDoctor].[IdxtblDoctor_BY_OPTypeLastNameFirstName]...';


GO
DROP INDEX [IdxtblDoctor_BY_OPTypeLastNameFirstName]
    ON [dbo].[tblDoctor];


GO
PRINT N'Dropping [dbo].[tblDoctor].[IdxtblDoctor_BY_OPTypeOPSubType]...';


GO
DROP INDEX [IdxtblDoctor_BY_OPTypeOPSubType]
    ON [dbo].[tblDoctor];


GO
PRINT N'Dropping [dbo].[tblDoctorCheckRequest].[IdxtblDoctorCheckRequest_UNIQUE_AcctingTransID]...';


GO
DROP INDEX [IdxtblDoctorCheckRequest_UNIQUE_AcctingTransID]
    ON [dbo].[tblDoctorCheckRequest];


GO
PRINT N'Dropping [dbo].[tblDoctorFeeSchedule].[IdxtblDoctorFeeSchedule_UNIQUE_DoctorCodeEWNetworkIDProdCodeEWBusLineIDEWSpecialtyIDLocationCodeEffDate]...';


GO
DROP INDEX [IdxtblDoctorFeeSchedule_UNIQUE_DoctorCodeEWNetworkIDProdCodeEWBusLineIDEWSpecialtyIDLocationCodeEffDate]
    ON [dbo].[tblDoctorFeeSchedule];


GO
PRINT N'Dropping [dbo].[tblDoctorSchedule].[IdxtblDoctorSchedule_BY_CaseNbr1]...';


GO
DROP INDEX [IdxtblDoctorSchedule_BY_CaseNbr1]
    ON [dbo].[tblDoctorSchedule];


GO
PRINT N'Dropping [dbo].[tblDoctorSchedule].[IdxtblDoctorSchedule_BY_CaseNbr2]...';


GO
DROP INDEX [IdxtblDoctorSchedule_BY_CaseNbr2]
    ON [dbo].[tblDoctorSchedule];


GO
PRINT N'Dropping [dbo].[tblDoctorSchedule].[IdxtblDoctorSchedule_BY_CaseNbr3]...';


GO
DROP INDEX [IdxtblDoctorSchedule_BY_CaseNbr3]
    ON [dbo].[tblDoctorSchedule];


GO
PRINT N'Dropping [dbo].[tblDoctorSchedule].[IdxtblDoctorSchedule_BY_StatusDoctorCodedateSchedCodeLocationCodeStartTimeDescriptionCaseNbr1desc]...';


GO
DROP INDEX [IdxtblDoctorSchedule_BY_StatusDoctorCodedateSchedCodeLocationCodeStartTimeDescriptionCaseNbr1desc]
    ON [dbo].[tblDoctorSchedule];


GO
PRINT N'Dropping [dbo].[tblDocument].[IX_tblDocument]...';


GO
DROP INDEX [IX_tblDocument]
    ON [dbo].[tblDocument];


GO
PRINT N'Dropping [dbo].[tblEWCoverLetterBusLine].[IdxtblEWCoverLetterBusLine_UNIQUE_EWCoverLetterIDEWBusLineID]...';


GO
DROP INDEX [IdxtblEWCoverLetterBusLine_UNIQUE_EWCoverLetterIDEWBusLineID]
    ON [dbo].[tblEWCoverLetterBusLine];


GO
PRINT N'Dropping [dbo].[tblEWCoverLetterState].[IdxtblEWCoverLetterState_UNIQUE_EWCoverLetterIDStateCode]...';


GO
DROP INDEX [IdxtblEWCoverLetterState_UNIQUE_EWCoverLetterIDStateCode]
    ON [dbo].[tblEWCoverLetterState];


GO
PRINT N'Dropping [dbo].[tblEWExchangeRate].[IdxtblEWExchangeRate_UNIQUE_MonetaryUnitExchangeRateDate]...';


GO
DROP INDEX [IdxtblEWExchangeRate_UNIQUE_MonetaryUnitExchangeRateDate]
    ON [dbo].[tblEWExchangeRate];


GO
PRINT N'Dropping [dbo].[tblEWParentCompany].[IdxEWParentCompany_UNIQUE_Name]...';


GO
DROP INDEX [IdxEWParentCompany_UNIQUE_Name]
    ON [dbo].[tblEWParentCompany];


GO
PRINT N'Dropping [dbo].[tblEWPostingPeriod].[IdxtblEWPostingPeriod_UNIQUE_OpenYearOpenMonth]...';


GO
DROP INDEX [IdxtblEWPostingPeriod_UNIQUE_OpenYearOpenMonth]
    ON [dbo].[tblEWPostingPeriod];


GO
PRINT N'Dropping [dbo].[tblEWWebUser].[IX_EWWebUser_UserID]...';


GO
DROP INDEX [IX_EWWebUser_UserID]
    ON [dbo].[tblEWWebUser];


GO
PRINT N'Dropping [dbo].[tblEWWebUser].[IX_EWWebUser_UserTypeEntityID]...';


GO
DROP INDEX [IX_EWWebUser_UserTypeEntityID]
    ON [dbo].[tblEWWebUser];


GO
PRINT N'Dropping [dbo].[tblExaminee].[IdxtblExaminee_BY_LastNameFirstNameMiddleInitialChartNbrCityStatePhone1DOB]...';


GO
DROP INDEX [IdxtblExaminee_BY_LastNameFirstNameMiddleInitialChartNbrCityStatePhone1DOB]
    ON [dbo].[tblExaminee];


GO
PRINT N'Dropping [dbo].[tblExaminee].[IdxtblExaminee_BY_SSN]...';


GO
DROP INDEX [IdxtblExaminee_BY_SSN]
    ON [dbo].[tblExaminee];


GO
PRINT N'Dropping [dbo].[tblExceptionDefinition].[IX_tblExceptionDefinition]...';


GO
DROP INDEX [IX_tblExceptionDefinition]
    ON [dbo].[tblExceptionDefinition];


GO
PRINT N'Dropping [dbo].[tblFacility].[IX_tblFacility]...';


GO
DROP INDEX [IX_tblFacility]
    ON [dbo].[tblFacility];


GO
PRINT N'Dropping [dbo].[tblFeeHeader].[IX_tblfeeheader]...';


GO
DROP INDEX [IX_tblfeeheader]
    ON [dbo].[tblFeeHeader];


GO
PRINT N'Dropping [dbo].[tblFeeHeader].[IX_tblfeeheader_1]...';


GO
DROP INDEX [IX_tblfeeheader_1]
    ON [dbo].[tblFeeHeader];


GO
PRINT N'Dropping [dbo].[tblFRCategorySetup].[IX_tblFRCategorySetup]...';


GO
DROP INDEX [IX_tblFRCategorySetup]
    ON [dbo].[tblFRCategorySetup];


GO
PRINT N'Dropping [dbo].[tblICDCode].[IX_tblICDCode]...';


GO
DROP INDEX [IX_tblICDCode]
    ON [dbo].[tblICDCode];


GO
PRINT N'Dropping [dbo].[tblKeyWord].[IX_tblKeyWord]...';


GO
DROP INDEX [IX_tblKeyWord]
    ON [dbo].[tblKeyWord];


GO
PRINT N'Dropping [dbo].[tblObtainmentTypeDetail].[IX_tblObtainmentTypeDetail]...';


GO
DROP INDEX [IX_tblObtainmentTypeDetail]
    ON [dbo].[tblObtainmentTypeDetail];


GO
PRINT N'Dropping [dbo].[tblProduct].[IX_tblproduct]...';


GO
DROP INDEX [IX_tblproduct]
    ON [dbo].[tblProduct];


GO
PRINT N'Dropping [dbo].[tblPublishOnWeb].[IdxtblPublishOnWeb_BY_TableTypeUserTypeUserCodePublishOnWebTableKey]...';


GO
DROP INDEX [IdxtblPublishOnWeb_BY_TableTypeUserTypeUserCodePublishOnWebTableKey]
    ON [dbo].[tblPublishOnWeb];


GO
PRINT N'Dropping [dbo].[tblPublishOnWeb].[IX_tblPublishOnWebTable]...';


GO
DROP INDEX [IX_tblPublishOnWebTable]
    ON [dbo].[tblPublishOnWeb];


GO
PRINT N'Dropping [dbo].[tblQueueDocuments].[IX_QueueDocuments]...';


GO
DROP INDEX [IX_QueueDocuments]
    ON [dbo].[tblQueueDocuments];


GO
PRINT N'Dropping [dbo].[tblRecordHistory].[IX_tblRecordHistory]...';


GO
DROP INDEX [IX_tblRecordHistory]
    ON [dbo].[tblRecordHistory];


GO
PRINT N'Dropping [dbo].[tblRecordsObtainment].[IX_tblRecordsObtainment]...';


GO
DROP INDEX [IX_tblRecordsObtainment]
    ON [dbo].[tblRecordsObtainment];


GO
PRINT N'Dropping [dbo].[tblRecordsObtainmentDetail].[IX_tblRecordsObtainmentDetail]...';


GO
DROP INDEX [IX_tblRecordsObtainmentDetail]
    ON [dbo].[tblRecordsObtainmentDetail];


GO
PRINT N'Dropping [dbo].[tblRptMEINotification].[IX_tblRptMEINotification]...';


GO
DROP INDEX [IX_tblRptMEINotification]
    ON [dbo].[tblRptMEINotification];


GO
PRINT N'Dropping [dbo].[tblScanSetting].[IX_tblScanSetting]...';


GO
DROP INDEX [IX_tblScanSetting]
    ON [dbo].[tblScanSetting];


GO
PRINT N'Dropping [dbo].[tblSetting].[IdxtblSetting_UNIQUE_Name]...';


GO
DROP INDEX [IdxtblSetting_UNIQUE_Name]
    ON [dbo].[tblSetting];


GO
PRINT N'Dropping [dbo].[tblSpecialty].[IdxtblSpecialty_UNIQUE_SpecialtyCode]...';


GO
DROP INDEX [IdxtblSpecialty_UNIQUE_SpecialtyCode]
    ON [dbo].[tblSpecialty];


GO
PRINT N'Dropping [dbo].[tblTranscription].[IX_tbltranscription]...';


GO
DROP INDEX [IX_tbltranscription]
    ON [dbo].[tblTranscription];


GO
PRINT N'Dropping [dbo].[tblTranscriptionJob].[IdxtblTranscriptionJob_BY_CaseNbr]...';


GO
DROP INDEX [IdxtblTranscriptionJob_BY_CaseNbr]
    ON [dbo].[tblTranscriptionJob];


GO
PRINT N'Dropping [dbo].[tblTranscriptionJob].[IdxtblTranscriptionJob_BY_TransCode]...';


GO
DROP INDEX [IdxtblTranscriptionJob_BY_TransCode]
    ON [dbo].[tblTranscriptionJob];


GO
PRINT N'Dropping [dbo].[tblTranscriptionJob].[IdxtblTranscriptionJob_BY_TranscriptionJobNbr]...';


GO
DROP INDEX [IdxtblTranscriptionJob_BY_TranscriptionJobNbr]
    ON [dbo].[tblTranscriptionJob];


GO
PRINT N'Dropping [dbo].[tblUser].[IX_tblUserWindowsUsername]...';


GO
DROP INDEX [IX_tblUserWindowsUsername]
    ON [dbo].[tblUser];


GO
PRINT N'Dropping [dbo].[tblVenue].[IX_tblVenue]...';


GO
DROP INDEX [IX_tblVenue]
    ON [dbo].[tblVenue];


GO
PRINT N'Dropping [dbo].[tblWebEventsOverride].[IX_tblWebEventsOverride]...';


GO
DROP INDEX [IX_tblWebEventsOverride]
    ON [dbo].[tblWebEventsOverride];


GO
PRINT N'Dropping [dbo].[tblWebUser].[IX_tblWebUser_UserID]...';


GO
DROP INDEX [IX_tblWebUser_UserID]
    ON [dbo].[tblWebUser];


GO
PRINT N'Dropping [dbo].[tblWebUserAccount].[IdxtblWebUserAccount_BY_UserCodeUserTypeIsActive]...';


GO
DROP INDEX [IdxtblWebUserAccount_BY_UserCodeUserTypeIsActive]
    ON [dbo].[tblWebUserAccount];


GO
PRINT N'Dropping [dbo].[tblZipCode].[IX_tblZipCode]...';


GO
DROP INDEX [IX_tblZipCode]
    ON [dbo].[tblZipCode];


GO
PRINT N'Creating [dbo].[tblAcctDetail].[IX_tblAcctDetail_HeaderIDLineNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctDetail_HeaderIDLineNbr]
    ON [dbo].[tblAcctDetail]([HeaderID] ASC, [LineNbr] ASC);


GO
PRINT N'Creating [dbo].[tblAcctHeader].[IX_tblAcctHeader_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_CaseNbr]
    ON [dbo].[tblAcctHeader]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblAcctHeader].[IX_tblAcctHeader_DocumentDateDocumentStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_DocumentDateDocumentStatus]
    ON [dbo].[tblAcctHeader]([DocumentDate] ASC, [DocumentStatus] ASC);


GO
PRINT N'Creating [dbo].[tblAcctHeader].[IX_tblAcctHeader_DocumentNbrDocumentTypeEWFacilityID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_DocumentNbrDocumentTypeEWFacilityID]
    ON [dbo].[tblAcctHeader]([DocumentNbr] ASC, [DocumentType] ASC, [EWFacilityID] ASC);


GO
PRINT N'Creating [dbo].[tblAcctHeader].[IX_tblAcctHeader_DocumentTypeDocumentDateDocumentStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_DocumentTypeDocumentDateDocumentStatus]
    ON [dbo].[tblAcctHeader]([DocumentType] ASC, [DocumentDate] ASC, [DocumentStatus] ASC);


GO
PRINT N'Creating [dbo].[tblAcctHeader].[IX_tblAcctHeader_SeqNo]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_SeqNo]
    ON [dbo].[tblAcctHeader]([SeqNo] ASC);


GO
PRINT N'Creating [dbo].[tblAcctingTrans].[IX_tblAcctingTrans_CaseNbrTypeStatusCodeDrOpCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctingTrans_CaseNbrTypeStatusCodeDrOpCode]
    ON [dbo].[tblAcctingTrans]([CaseNbr] ASC, [Type] ASC, [StatusCode] ASC, [DrOpCode] ASC);


GO
PRINT N'Creating [dbo].[tblAcctingTrans].[IX_tblAcctingTrans_StatusCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctingTrans_StatusCode]
    ON [dbo].[tblAcctingTrans]([StatusCode] ASC);


GO
PRINT N'Creating [dbo].[tblAvailDoctor].[IX_tblAvailDoctor_DoctorCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAvailDoctor_DoctorCode]
    ON [dbo].[tblAvailDoctor]([DoctorCode] ASC);


GO
PRINT N'Creating [dbo].[tblAvailDoctor].[IX_tblAvailDoctor_UserID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAvailDoctor_UserID]
    ON [dbo].[tblAvailDoctor]([UserID] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_ApptDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ApptDate]
    ON [dbo].[tblCase]([ApptDate] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_BillClientCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_BillClientCode]
    ON [dbo].[tblCase]([BillClientCode] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_ChartNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ChartNbr]
    ON [dbo].[tblCase]([ChartNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_ClaimNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ClaimNbr]
    ON [dbo].[tblCase]([ClaimNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_ClientCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ClientCode]
    ON [dbo].[tblCase]([ClientCode] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_DateAddedOfficeCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateAddedOfficeCode]
    ON [dbo].[tblCase]([DateAdded] ASC, [OfficeCode] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DoctorCodeCaseNbrChartNbrClientCodeStatusApptDateDoctorLocation]
    ON [dbo].[tblCase]([DoctorCode] ASC, [CaseNbr] ASC, [ChartNbr] ASC, [ClientCode] ASC, [Status] ASC, [ApptDate] ASC, [DoctorLocation] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_ExtCaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ExtCaseNbr]
    ON [dbo].[tblCase]([ExtCaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_ForecastDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ForecastDate]
    ON [dbo].[tblCase]([ForecastDate] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_MasterCaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_MasterCaseNbr]
    ON [dbo].[tblCase]([MasterCaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeChartNbrClaimNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeChartNbrClaimNbr]
    ON [dbo].[tblCase]([OfficeCode] ASC, [ChartNbr] ASC, [ClaimNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeReExamReExamProcessedReExamDateClientCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeReExamReExamProcessedReExamDateClientCode]
    ON [dbo].[tblCase]([OfficeCode] ASC, [ReExam] ASC, [ReExamProcessed] ASC, [ReExamDate] ASC, [ClientCode] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeStatusSchedulerCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatusSchedulerCode]
    ON [dbo].[tblCase]([OfficeCode] ASC, [Status] ASC, [SchedulerCode] ASC)
    INCLUDE([ClientCode], [Priority]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_PanelNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_PanelNbr]
    ON [dbo].[tblCase]([PanelNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCaseAppt].[IX_tblCaseAppt_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_CaseNbr]
    ON [dbo].[tblCaseAppt]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCaseDocuments].[IX_tblCaseDocuments_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseDocuments_CaseNbr]
    ON [dbo].[tblCaseDocuments]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblCaseHistory].[IX_tblCaseHistory_CaseNbrEventDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_CaseNbrEventDate]
    ON [dbo].[tblCaseHistory]([CaseNbr] ASC, [EventDate] ASC);


GO
PRINT N'Creating [dbo].[tblCaseHistory].[IX_tblCaseHistory_FollowUpDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_FollowUpDate]
    ON [dbo].[tblCaseHistory]([FollowUpDate] ASC);


GO
PRINT N'Creating [dbo].[tblCaseHistory].[IX_tblCaseHistory_Type]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_Type]
    ON [dbo].[tblCaseHistory]([Type] ASC);


GO
PRINT N'Creating [dbo].[tblCaseOtherParty].[IX_tblCaseOtherParty_DueDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseOtherParty_DueDate]
    ON [dbo].[tblCaseOtherParty]([DueDate] ASC);


GO
PRINT N'Creating [dbo].[tblCasePanel].[IX_tblCasePanel_DoctorCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCasePanel_DoctorCode]
    ON [dbo].[tblCasePanel]([DoctorCode] ASC);


GO
PRINT N'Creating [dbo].[tblCaseTrans].[IX_tblCaseTrans_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseTrans_CaseNbr]
    ON [dbo].[tblCaseTrans]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblClient].[IX_tblClient_ClientCodeCompanyCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblClient_ClientCodeCompanyCode]
    ON [dbo].[tblClient]([ClientCode] ASC, [CompanyCode] ASC);


GO
PRINT N'Creating [dbo].[tblClient].[IX_tblClient_CompanyCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblClient_CompanyCode]
    ON [dbo].[tblClient]([CompanyCode] ASC);


GO
PRINT N'Creating [dbo].[tblClient].[IX_tblClient_Email]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblClient_Email]
    ON [dbo].[tblClient]([Email] ASC);


GO
PRINT N'Creating [dbo].[tblCompany].[IX_tblCompany_City]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_City]
    ON [dbo].[tblCompany]([City] ASC);


GO
PRINT N'Creating [dbo].[tblCompany].[IX_tblCompany_IntName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_IntName]
    ON [dbo].[tblCompany]([IntName] ASC);


GO
PRINT N'Creating [dbo].[tblCompanyCoverLetter].[IX_U_tblCompanyCoverLetter_CompanyCodeEWCoverLetterID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblCompanyCoverLetter_CompanyCodeEWCoverLetterID]
    ON [dbo].[tblCompanyCoverLetter]([CompanyCode] ASC, [EWCoverLetterID] ASC);


GO
PRINT N'Creating [dbo].[tblDegree].[IX_U_tblDegree_DegreeCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDegree_DegreeCode]
    ON [dbo].[tblDegree]([DegreeCode] ASC);


GO
PRINT N'Creating [dbo].[tblDoctor].[IX_tblDoctor_DictationAuthorID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_DictationAuthorID]
    ON [dbo].[tblDoctor]([DictationAuthorID] ASC);


GO
PRINT N'Creating [dbo].[tblDoctor].[IX_tblDoctor_LastNameFirstNameMiddleInitial]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_LastNameFirstNameMiddleInitial]
    ON [dbo].[tblDoctor]([LastName] ASC, [FirstName] ASC, [MiddleInitial] ASC);


GO
PRINT N'Creating [dbo].[tblDoctor].[IX_tblDoctor_OPTypeLastNameFirstName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_OPTypeLastNameFirstName]
    ON [dbo].[tblDoctor]([OPType] ASC, [LastName] ASC, [FirstName] ASC);


GO
PRINT N'Creating [dbo].[tblDoctor].[IX_tblDoctor_OPTypeOPSubType]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctor_OPTypeOPSubType]
    ON [dbo].[tblDoctor]([OPType] ASC, [OPSubType] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorCheckRequest].[IX_U_tblDoctorCheckRequest_AcctingTransID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorCheckRequest_AcctingTransID]
    ON [dbo].[tblDoctorCheckRequest]([AcctingTransID] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorFeeSchedule].[IX_U_tblDoctorFeeSchedule_DoctorCodeEWNetworkIDProdCodeEWBusLineIDEWSpecialtyIDLocationCodeEffDate]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorFeeSchedule_DoctorCodeEWNetworkIDProdCodeEWBusLineIDEWSpecialtyIDLocationCodeEffDate]
    ON [dbo].[tblDoctorFeeSchedule]([DoctorCode] ASC, [EWNetworkID] ASC, [ProdCode] ASC, [EWBusLineID] ASC, [EWSpecialtyID] ASC, [LocationCode] ASC, [EffDate] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorSchedule].[IX_tblDoctorSchedule_CaseNbr1]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_CaseNbr1]
    ON [dbo].[tblDoctorSchedule]([CaseNbr1] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorSchedule].[IX_tblDoctorSchedule_dateLocationCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_dateLocationCode]
    ON [dbo].[tblDoctorSchedule]([date] ASC, [LocationCode] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorSchedule].[IX_tblDoctorSchedule_StatusDoctorCodedateSchedCodeLocationCodeStartTimeDescriptionCaseNbr1desc]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_StatusDoctorCodedateSchedCodeLocationCodeStartTimeDescriptionCaseNbr1desc]
    ON [dbo].[tblDoctorSchedule]([Status] ASC, [DoctorCode] ASC, [date] ASC, [SchedCode] ASC, [LocationCode] ASC, [StartTime] ASC, [Description] ASC, [CaseNbr1desc] ASC);


GO
PRINT N'Creating [dbo].[tblDocument].[IX_tblDocument_Document]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDocument_Document]
    ON [dbo].[tblDocument]([Document] ASC);


GO
PRINT N'Creating [dbo].[tblEWCoverLetterBusLine].[IX_U_tblEWCoverLetterBusLine_EWCoverLetterIDEWBusLineID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWCoverLetterBusLine_EWCoverLetterIDEWBusLineID]
    ON [dbo].[tblEWCoverLetterBusLine]([EWCoverLetterID] ASC, [EWBusLineID] ASC);


GO
PRINT N'Creating [dbo].[tblEWCoverLetterState].[IX_U_tblEWCoverLetterState_EWCoverLetterIDStateCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWCoverLetterState_EWCoverLetterIDStateCode]
    ON [dbo].[tblEWCoverLetterState]([EWCoverLetterID] ASC, [StateCode] ASC);


GO
PRINT N'Creating [dbo].[tblEWExchangeRate].[IX_U_tblEWExchangeRate_MonetaryUnitExchangeRateDate]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWExchangeRate_MonetaryUnitExchangeRateDate]
    ON [dbo].[tblEWExchangeRate]([MonetaryUnit] ASC, [ExchangeRateDate] ASC);


GO
PRINT N'Creating [dbo].[tblEWParentCompany].[IX_U_tblEWParentCompany_Name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWParentCompany_Name]
    ON [dbo].[tblEWParentCompany]([Name] ASC);


GO
PRINT N'Creating [dbo].[tblEWPostingPeriod].[IX_U_tblEWPostingPeriod_OpenYearOpenMonth]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWPostingPeriod_OpenYearOpenMonth]
    ON [dbo].[tblEWPostingPeriod]([OpenYear] ASC, [OpenMonth] ASC);


GO
PRINT N'Creating [dbo].[tblEWWebUser].[IX_tblEWWebUser_UserID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblEWWebUser_UserID]
    ON [dbo].[tblEWWebUser]([UserID] ASC);


GO
PRINT N'Creating [dbo].[tblEWWebUser].[IX_tblEWWebUser_UserTypeEWEntityID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblEWWebUser_UserTypeEWEntityID]
    ON [dbo].[tblEWWebUser]([UserType] ASC, [EWEntityID] ASC);


GO
PRINT N'Creating [dbo].[tblExaminee].[IX_tblExaminee_LastNameFirstNameMiddleInitialChartNbrCityStatePhone1DOB]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExaminee_LastNameFirstNameMiddleInitialChartNbrCityStatePhone1DOB]
    ON [dbo].[tblExaminee]([LastName] ASC, [FirstName] ASC, [MiddleInitial] ASC, [ChartNbr] ASC, [City] ASC, [State] ASC, [Phone1] ASC, [DOB] ASC);


GO
PRINT N'Creating [dbo].[tblExaminee].[IX_tblExaminee_SSN]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExaminee_SSN]
    ON [dbo].[tblExaminee]([SSN] ASC);


GO
PRINT N'Creating [dbo].[tblExceptionDefinition].[IX_tblExceptionDefinition_ExceptionID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExceptionDefinition_ExceptionID]
    ON [dbo].[tblExceptionDefinition]([ExceptionID] ASC);


GO
PRINT N'Creating [dbo].[tblFeeHeader].[IX_tblFeeHeader_Feedesc]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblFeeHeader_Feedesc]
    ON [dbo].[tblFeeHeader]([Feedesc] ASC);


GO
PRINT N'Creating [dbo].[tblFRCategorySetup].[IX_U_tblFRCategorySetup_ProductCodeCaseType]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblFRCategorySetup_ProductCodeCaseType]
    ON [dbo].[tblFRCategorySetup]([ProductCode] ASC, [CaseType] ASC);


GO
PRINT N'Creating [dbo].[tblICDCode].[IX_tblICDCode_Description]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblICDCode_Description]
    ON [dbo].[tblICDCode]([Description] ASC);


GO
PRINT N'Creating [dbo].[tblKeyWord].[IX_tblKeyWord_Keyword]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblKeyWord_Keyword]
    ON [dbo].[tblKeyWord]([Keyword] ASC);


GO
PRINT N'Creating [dbo].[tblObtainmentTypeDetail].[IX_tblObtainmentTypeDetail_Description]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblObtainmentTypeDetail_Description]
    ON [dbo].[tblObtainmentTypeDetail]([Description] ASC);


GO
PRINT N'Creating [dbo].[tblProduct].[IX_tblProduct_Description]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblProduct_Description]
    ON [dbo].[tblProduct]([Description] ASC);


GO
PRINT N'Creating [dbo].[tblPublishOnWeb].[IX_tblPublishOnWeb_TableTypeTableKey]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblPublishOnWeb_TableTypeTableKey]
    ON [dbo].[tblPublishOnWeb]([TableType] ASC, [TableKey] ASC);


GO
PRINT N'Creating [dbo].[tblPublishOnWeb].[IX_tblPublishOnWeb_TableTypeUserTypeUserCodePublishOnWebTableKey]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblPublishOnWeb_TableTypeUserTypeUserCodePublishOnWebTableKey]
    ON [dbo].[tblPublishOnWeb]([TableType] ASC, [UserType] ASC, [UserCode] ASC, [PublishOnWeb] ASC, [TableKey] ASC);


GO
PRINT N'Creating [dbo].[tblQueueDocuments].[IX_tblQueueDocuments_CaseTypeServiceCodeStatusDocumentOfficeCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblQueueDocuments_CaseTypeServiceCodeStatusDocumentOfficeCode]
    ON [dbo].[tblQueueDocuments]([CaseType] ASC, [ServiceCode] ASC, [Status] ASC, [Document] ASC, [OfficeCode] ASC);


GO
PRINT N'Creating [dbo].[tblRecordHistory].[IX_tblRecordHistory_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblRecordHistory_CaseNbr]
    ON [dbo].[tblRecordHistory]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblRecordsObtainment].[IX_tblRecordsObtainment_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblRecordsObtainment_CaseNbr]
    ON [dbo].[tblRecordsObtainment]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblRecordsObtainmentDetail].[IX_tblRecordsObtainmentDetail_RecordsID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblRecordsObtainmentDetail_RecordsID]
    ON [dbo].[tblRecordsObtainmentDetail]([RecordsID] ASC);


GO
PRINT N'Creating [dbo].[tblRptMEINotification].[IX_tblRptMEINotification_ProcessID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblRptMEINotification_ProcessID]
    ON [dbo].[tblRptMEINotification]([ProcessID] ASC);


GO
PRINT N'Creating [dbo].[tblScanSetting].[IX_U_tblScanSetting_SettingName]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblScanSetting_SettingName]
    ON [dbo].[tblScanSetting]([SettingName] ASC);


GO
PRINT N'Creating [dbo].[tblSetting].[IX_U_tblSetting_Name]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblSetting_Name]
    ON [dbo].[tblSetting]([Name] ASC);


GO
PRINT N'Creating [dbo].[tblSpecialty].[IX_U_tblSpecialty_SpecialtyCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblSpecialty_SpecialtyCode]
    ON [dbo].[tblSpecialty]([SpecialtyCode] ASC);


GO
PRINT N'Creating [dbo].[tblTranscription].[IX_tblTranscription_TransCompany]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscription_TransCompany]
    ON [dbo].[tblTranscription]([TransCompany] ASC);


GO
PRINT N'Creating [dbo].[tblTranscriptionJob].[IX_tblTranscriptionJob_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_CaseNbr]
    ON [dbo].[tblTranscriptionJob]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblTranscriptionJob].[IX_tblTranscriptionJob_TransCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTranscriptionJob_TransCode]
    ON [dbo].[tblTranscriptionJob]([TransCode] ASC);


GO
PRINT N'Creating [dbo].[tblUser].[IX_tblUser_WindowsUsername]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblUser_WindowsUsername]
    ON [dbo].[tblUser]([WindowsUsername] ASC);


GO
PRINT N'Creating [dbo].[tblVenue].[IX_tblVenue_StateCounty]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblVenue_StateCounty]
    ON [dbo].[tblVenue]([State] ASC, [County] ASC);


GO
PRINT N'Creating [dbo].[tblWebEventsOverride].[IX_tblWebEventsOverride_IMECentricCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblWebEventsOverride_IMECentricCode]
    ON [dbo].[tblWebEventsOverride]([IMECentricCode] ASC);


GO
PRINT N'Creating [dbo].[tblWebUser].[IX_U_tblWebUser_UserID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblWebUser_UserID]
    ON [dbo].[tblWebUser]([UserID] ASC);


GO
PRINT N'Creating [dbo].[tblWebUserAccount].[IX_tblWebUserAccount_UserCodeUserTypeIsActive]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblWebUserAccount_UserCodeUserTypeIsActive]
    ON [dbo].[tblWebUserAccount]([UserCode] ASC, [UserType] ASC, [IsActive] ASC);


GO
PRINT N'Creating [dbo].[tblZipCode].[IX_tblZipCode_sZip]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblZipCode_sZip]
    ON [dbo].[tblZipCode]([sZip] ASC);


GO



UPDATE tblControl SET DBVersion='2.80'
GO

