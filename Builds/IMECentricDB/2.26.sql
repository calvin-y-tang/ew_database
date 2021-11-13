DROP PROCEDURE [dbo].[proc_ICD9_GetDescByCode]
GO


DROP PROCEDURE [dbo].[proc_GetCaseICD9sByCase]
GO


DROP PROCEDURE [dbo].[proc_CaseICD9_LoadByPrimaryKey]
GO


DROP PROCEDURE [dbo].[proc_CaseICD9_LoadAll]
GO


DROP PROCEDURE [dbo].[proc_CaseICD9_Insert]
GO


DROP PROCEDURE [dbo].[proc_CaseICD9_Delete]
GO



/****** Object:  StoredVIEW [vw_WebCaseSummaryExt]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[vw_WebCaseSummaryExt]') AND OBJECTPROPERTY(id,N'IsView') = 1)
DROP VIEW [vw_WebCaseSummaryExt];
GO

CREATE VIEW vw_WebCaseSummaryExt

AS

SELECT     
	--case     
	tblCase.casenbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	REPLACE(REPLACE(REPLACE(CAST(tblCase.notes AS VARCHAR(2000)),CHAR(10),' '),CHAR(13),' '),CHAR(9),' ') notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.TransportationRequired,
	tblCase.InterpreterRequired,
	tblCase.LanguageID,
	
	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,
	tblExaminee.employer,
	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.TreatingPhysicianDiagnosis,
	tblExaminee.EmployerAddr1,
	tblExaminee.EmployerCity,
	tblExaminee.EmployerState,
	tblExaminee.EmployerZip,
	tblExaminee.EmployerPhone,
	tblExaminee.EmployerPhoneExt,
	tblExaminee.EmployerFax,
	tblExaminee.EmployerEmail,
	tblExaminee.Country,
	tblExaminee.policynumber,
	tblExaminee.EmployerContactFirstName,
	tblExaminee.EmployerContactLastName,
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,
	tblExaminee.note AS StateDirected,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,
	tblClient.phone1 AS ClientPhone,
	tblClient.email AS ClientEmail,
	tblClient.fax AS ClientFax,
	tblClient.notes AS ClientOffice,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix,

	--company
	tblCompany.extname AS InsCompanyName,
	tblCompany.addr1 AS InsCompanyAddress1,
	tblCompany.addr2 AS InsCompanyAddress2,
	tblCompany.city AS InsCompanyCity,
	tblCompany.state AS InsCompanyState,
	tblCompany.zip AS InsCompanyZip,

	--case manager
	tblRelatedParty.firstname AS CaseManagerFirstName,
	tblRelatedParty.lastname AS CaseManagerLastName,
	tblRelatedParty.address1 AS CaseManagerAddress1,
	tblRelatedParty.address2 AS CaseManagerAddress2,
	tblRelatedParty.city AS CaseManagerCity,
	tblRelatedParty.state AS CaseManagerState,
	tblRelatedParty.zip as CaseManagerZip,
	tblRelatedParty.companyname AS CaseManagerOffice,
	tblRelatedParty.phone as CaseManagerPhone,
	tblRelatedParty.fax as CaseManagerFax,
	tblRelatedParty.email as CaseManagerEmail,

	--language
	tblLanguage.Description as LanguageDescription

FROM tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
	LEFT OUTER  JOIN tblLanguage ON tblCase.LanguageID = tblLanguage.LanguageID
	LEFT OUTER JOIN tblCaseRelatedParty ON tblCase.casenbr = tblCaseRelatedParty.casenbr
	LEFT OUTER JOIN tblRelatedParty ON tblCaseRelatedParty.RPCode = tblRelatedParty.RPCode
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode


GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByTransCode]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByTransCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByTransCode];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByTransCode]
(
	@TransCode int,
	@TranscriptionStatusCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	(SELECT COUNT(TranscriptionJobID) FROM tblTranscriptionJob WHERE tblTranscriptionJob.TransCode = @TransCode AND TranscriptionStatusCode = @TranscriptionStatusCode) AS 'TransCount',
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.TransCode = @TransCode
		AND TranscriptionStatusCode = @TranscriptionStatusCode
	SET @Err = @@Error

	RETURN @Err
END
GO



/****** Object:  StoredProcedure [proc_ICD_GetDescByCode]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_ICD_GetDescByCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_ICD_GetDescByCode];
GO

CREATE PROCEDURE [proc_ICD_GetDescByCode]
(
	@ICDCode varchar(10)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT Description FROM tblICDCode WHERE Code = @ICDCode

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_IMECase_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_Update];
GO

CREATE PROCEDURE [proc_IMECase_Update]
(
	@casenbr int,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@allegation text = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@datemedsrecd datetime = NULL,
	@typemedsrecd varchar(50) = NULL,
	@transreceived datetime = NULL,
	@shownoshow int = NULL,
	@rptstatus varchar(50) = NULL,
	@reportverbal bit = NULL,
	@emailclient bit = NULL,
	@emaildoctor bit = NULL,
	@emailPattny bit = NULL,
	@faxclient bit = NULL,
	@faxdoctor bit = NULL,
	@faxPattny bit = NULL,
	@apptrptsselect bit = NULL,
	@chartprepselect bit = NULL,
	@apptselect bit = NULL,
	@awaittransselect bit = NULL,
	@intransselect bit = NULL,
	@inqaselect bit = NULL,
	@drchartselect bit = NULL,
	@datedrchart datetime = NULL,
	@billedselect bit = NULL,
	@miscselect bit = NULL,
	@invoicedate datetime = NULL,
	@invoiceamt money = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@bComplete bit = NULL,
	@bhanddelivery bit = NULL,
	@sinternalcasenbr varchar(70) = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@feecode int = NULL,
	@voucherselect bit = NULL,
	@voucheramt money = NULL,
	@voucherdate datetime = NULL,
	@icdFormat int = NULL,
	@icdcodeA varchar(70) = NULL,
	@icdcodeB varchar(70) = NULL,
	@icdcodeC varchar(70) = NULL,
	@icdcodeD varchar(70) = NULL,
	@icdcodeE varchar(10) = NULL,
	@icdcodeF varchar(10) = NULL,
	@icdcodeG varchar(10) = NULL,
	@icdcodeH varchar(10) = NULL,
	@icdcodeI varchar(10) = NULL,
	@icdcodeJ varchar(10) = NULL,
	@icdcodeK varchar(10) = NULL,
	@icdcodeL varchar(10) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@PanelNbr int = NULL,
	@DoctorName varchar(100) = NULL,
	@HearingDate smalldatetime = NULL,
	@CertMailNbr varchar(30) = NULL,
	@laststatuschg datetime = NULL,
	@Jurisdiction varchar(5) = NULL,
	@prevappt datetime = NULL,
	@mastersubcase varchar(1) = NULL,
	@mastercasenbr int = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@AssessmentToAddress varchar(50) = NULL,
	@OCF25Date smalldatetime = NULL,
	@DateForminDispute smalldatetime = NULL,
	@AssessingFacility varchar(100) = NULL,
	@referralmethod int = NULL,
	@referraltype int = NULL,
	@CSR1 varchar(15) = NULL,
	@CSR2 varchar(15) = NULL,
	@LegalEvent bit = NULL,
	@PILegalEvent bit = NULL,
	@Transcode int = NULL,
	@PublishDocuments bit = NULL,
	@DateReceived datetime = NULL,
	@usddate3 datetime = NULL,
	@usddate4 datetime = NULL,
	@usddate5 datetime = NULL,
	@UsdBit1 bit = NULL,
	@UsdBit2 bit = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@DefParaLegal int = NULL,
	@AttorneyNote text = NULL,
	@BillingNote text = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@RptInitialDraftDate datetime = NULL,
	@RptSentDate datetime = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL,
	@MMIReached bit = NULL,
	@MMITreatmentWeeks int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[chartnbr] = @chartnbr,
		[doctorlocation] = @doctorlocation,
		[clientcode] = @clientcode,
		[marketercode] = @marketercode,
		[schedulercode] = @schedulercode,
		[priority] = @priority,
		[status] = @status,
		[casetype] = @casetype,
		[dateadded] = @dateadded,
		[dateedited] = @dateedited,
		[useridadded] = @useridadded,
		[useridedited] = @useridedited,
		[schedcode] = @schedcode,
		[ApptDate] = @ApptDate,
		[Appttime] = @Appttime,
		[ApptMadeDate] = @ApptMadeDate,
		[claimnbr] = @claimnbr,
		[dateofinjury] = @dateofinjury,
		[allegation] = @allegation,
		[calledinby] = @calledinby,
		[notes] = @notes,
		[schedulenotes] = @schedulenotes,
		[requesteddoc] = @requesteddoc,
		[datemedsrecd] = @datemedsrecd,
		[typemedsrecd] = @typemedsrecd,
		[transreceived] = @transreceived,
		[shownoshow] = @shownoshow,
		[rptstatus] = @rptstatus,
		[reportverbal] = @reportverbal,
		[emailclient] = @emailclient,
		[emaildoctor] = @emaildoctor,
		[emailPattny] = @emailPattny,
		[faxclient] = @faxclient,
		[faxdoctor] = @faxdoctor,
		[faxPattny] = @faxPattny,
		[apptrptsselect] = @apptrptsselect,
		[chartprepselect] = @chartprepselect,
		[apptselect] = @apptselect,
		[awaittransselect] = @awaittransselect,
		[intransselect] = @intransselect,
		[inqaselect] = @inqaselect,
		[drchartselect] = @drchartselect,
		[datedrchart] = @datedrchart,
		[billedselect] = @billedselect,
		[miscselect] = @miscselect,
		[invoicedate] = @invoicedate,
		[invoiceamt] = @invoiceamt,
		[plaintiffattorneycode] = @plaintiffattorneycode,
		[defenseattorneycode] = @defenseattorneycode,
		[commitdate] = @commitdate,
		[servicecode] = @servicecode,
		[issuecode] = @issuecode,
		[doctorcode] = @doctorcode,
		[WCBNbr] = @WCBNbr,
		[specialinstructions] = @specialinstructions,
		[usdvarchar1] = @usdvarchar1,
		[usdvarchar2] = @usdvarchar2,
		[usddate1] = @usddate1,
		[usddate2] = @usddate2,
		[usdtext1] = @usdtext1,
		[usdtext2] = @usdtext2,
		[usdint1] = @usdint1,
		[usdint2] = @usdint2,
		[usdmoney1] = @usdmoney1,
		[usdmoney2] = @usdmoney2,
		[bComplete] = @bComplete,
		[bhanddelivery] = @bhanddelivery,
		[sinternalcasenbr] = @sinternalcasenbr,
		[sreqspecialty] = @sreqspecialty,
		[doctorspecialty] = @doctorspecialty,
		[feecode] = @feecode,
		[voucherselect] = @voucherselect,
		[voucheramt] = @voucheramt,
		[voucherdate] = @voucherdate,
		[icdformat] = @icdformat,
		[icdcodeA] = @icdcodeA,
		[icdcodeB] = @icdcodeB,
		[icdcodeC] = @icdcodeC,
		[icdcodeD] = @icdcodeD,
		[icdcodeE] = @icdcodeE,
		[icdcodeF] = @icdcodeF,
		[icdcodeG] = @icdcodeG,
		[icdcodeH] = @icdcodeH,
		[icdcodeI] = @icdcodeI,
		[icdcodeJ] = @icdcodeJ,
		[icdcodeK] = @icdcodeK,
		[icdcodeL] = @icdcodeL,
		[reccode] = @reccode,
		[billclientcode] = @billclientcode,
		[officecode] = @officecode,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[CertifiedMail] = @CertifiedMail,
		[PanelNbr] = @PanelNbr,
		[DoctorName] = @DoctorName,
		[HearingDate] = @HearingDate,
		[CertMailNbr] = @CertMailNbr,
		[laststatuschg] = @laststatuschg,
		[Jurisdiction] = @Jurisdiction,
		[prevappt] = @prevappt,
		[mastersubcase] = @mastersubcase,
		[mastercasenbr] = @mastercasenbr,
		[PublishOnWeb] = @PublishOnWeb,
		[WebNotifyEmail] = @WebNotifyEmail,
		[AssessmentToAddress] = @AssessmentToAddress,
		[OCF25Date] = @OCF25Date,
		[DateForminDispute] = @DateForminDispute,
		[AssessingFacility] = @AssessingFacility,
		[referralmethod] = @referralmethod,
		[referraltype] = @referraltype,
		[CSR1] = @CSR1,
		[CSR2] = @CSR2,
		[LegalEvent] = @LegalEvent,
		[PILegalEvent] = @PILegalEvent,
		[Transcode] = @Transcode,
		[PublishDocuments] = @PublishDocuments,
		[DateReceived] = @DateReceived,
		[usddate3] = @usddate3,
		[usddate4] = @usddate4,
		[usddate5] = @usddate5,
		[UsdBit1] = @UsdBit1,
		[UsdBit2] = @UsdBit2,
		[ClaimNbrExt] = @ClaimNbrExt,
		[DefParaLegal] = @DefParaLegal,
		[AttorneyNote] = @AttorneyNote,
		[BillingNote] = @BillingNote,
		[InterpreterRequired] = @InterpreterRequired,
		[TransportationRequired] = @TransportationRequired,
		[LanguageID] = @LanguageID,
		[InputSourceID] = @InputSourceID,
		[ReqEWAccreditationID] = @ReqEWAccreditationID,
		[RptInitialDraftDate] =	@RptInitialDraftDate,
		[RptSentDate] =	@RptSentDate,		
		[ApptStatusId] = @ApptStatusId,	
		[CaseApptId] = @CaseApptId,
		[MMIReached] = @MMIReached,
		[MMITreatmentWeeks] = @MMITreatmentWeeks
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_IMECase_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_Insert];
GO

CREATE PROCEDURE [proc_IMECase_Insert]
(
	@casenbr int = NULL output,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@allegation text = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@datemedsrecd datetime = NULL,
	@typemedsrecd varchar(50) = NULL,
	@transreceived datetime = NULL,
	@shownoshow int = NULL,
	@rptstatus varchar(50) = NULL,
	@reportverbal bit = NULL,
	@emailclient bit = NULL,
	@emaildoctor bit = NULL,
	@emailPattny bit = NULL,
	@faxclient bit = NULL,
	@faxdoctor bit = NULL,
	@faxPattny bit = NULL,
	@apptrptsselect bit = NULL,
	@chartprepselect bit = NULL,
	@apptselect bit = NULL,
	@awaittransselect bit = NULL,
	@intransselect bit = NULL,
	@inqaselect bit = NULL,
	@drchartselect bit = NULL,
	@datedrchart datetime = NULL,
	@billedselect bit = NULL,
	@miscselect bit = NULL,
	@invoicedate datetime = NULL,
	@invoiceamt money = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@bComplete bit = NULL,
	@bhanddelivery bit = NULL,
	@sinternalcasenbr varchar(70) = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@feecode int = NULL,
	@voucherselect bit = NULL,
	@voucheramt money = NULL,
	@voucherdate datetime = NULL,
	@icdFormat int = NULL,
	@icdcodeA varchar(70) = NULL,
	@icdcodeB varchar(70) = NULL,
	@icdcodeC varchar(70) = NULL,
	@icdcodeD varchar(70) = NULL,
	@icdcodeE varchar(10) = NULL,
	@icdcodeF varchar(10) = NULL,
	@icdcodeG varchar(10) = NULL,
	@icdcodeH varchar(10) = NULL,
	@icdcodeI varchar(10) = NULL,
	@icdcodeJ varchar(10) = NULL,
	@icdcodeK varchar(10) = NULL,
	@icdcodeL varchar(10) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@PanelNbr int = NULL,
	@DoctorName varchar(100) = NULL,
	@HearingDate smalldatetime = NULL,
	@CertMailNbr varchar(30) = NULL,
	@laststatuschg datetime = NULL,
	@Jurisdiction varchar(5) = NULL,
	@prevappt datetime = NULL,
	@mastersubcase varchar(1) = NULL,
	@mastercasenbr int = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@AssessmentToAddress varchar(50) = NULL,
	@OCF25Date smalldatetime = NULL,
	@DateForminDispute smalldatetime = NULL,
	@AssessingFacility varchar(100) = NULL,
	@referralmethod int = NULL,
	@referraltype int = NULL,
	@CSR1 varchar(15) = NULL,
	@CSR2 varchar(15) = NULL,
	@LegalEvent bit = NULL,
	@PILegalEvent bit = NULL,
	@Transcode int = NULL,
	@PublishDocuments bit = NULL,
	@DateReceived datetime = NULL,
	@usddate3 datetime = NULL,
	@usddate4 datetime = NULL,
	@usddate5 datetime = NULL,
	@UsdBit1 bit = NULL,
	@UsdBit2 bit = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@DefParaLegal int = NULL,
	@AttorneyNote text = NULL,
	@BillingNote text = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@RptInitialDraftDate datetime = NULL,
	@RptSentDate datetime = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL,
	@MMIReached bit = NULL,
	@MMITreatmentWeeks int = NULL
	)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCase]
	(
		[chartnbr],
		[doctorlocation],
		[clientcode],
		[marketercode],
		[schedulercode],
		[priority],
		[status],
		[casetype],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited],
		[schedcode],
		[ApptDate],
		[Appttime],
		[ApptMadeDate],
		[claimnbr],
		[dateofinjury],
		[allegation],
		[calledinby],
		[notes],
		[schedulenotes],
		[requesteddoc],
		[datemedsrecd],
		[typemedsrecd],
		[transreceived],
		[shownoshow],
		[rptstatus],
		[reportverbal],
		[emailclient],
		[emaildoctor],
		[emailPattny],
		[faxclient],
		[faxdoctor],
		[faxPattny],
		[apptrptsselect],
		[chartprepselect],
		[apptselect],
		[awaittransselect],
		[intransselect],
		[inqaselect],
		[drchartselect],
		[datedrchart],
		[billedselect],
		[miscselect],
		[invoicedate],
		[invoiceamt],
		[plaintiffattorneycode],
		[defenseattorneycode],
		[commitdate],
		[servicecode],
		[issuecode],
		[doctorcode],
		[WCBNbr],
		[specialinstructions],
		[usdvarchar1],
		[usdvarchar2],
		[usddate1],
		[usddate2],
		[usdtext1],
		[usdtext2],
		[usdint1],
		[usdint2],
		[usdmoney1],
		[usdmoney2],
		[bComplete],
		[bhanddelivery],
		[sinternalcasenbr],
		[sreqspecialty],
		[doctorspecialty],
		[feecode],
		[voucherselect],
		[voucheramt],
		[voucherdate],
		[icdformat],
		[icdcodeA],
		[icdcodeB],
		[icdcodeC],
		[icdcodeD],
		[icdcodeE],
		[icdcodeF],
		[icdcodeG],
		[icdcodeH],
		[icdcodeI],
		[icdcodeJ],
		[icdcodeK],
		[icdcodeL],
		[reccode],
		[billclientcode],
		[officecode],
		[QARep],
		[photoRqd],
		[CertifiedMail],
		[PanelNbr],
		[DoctorName],
		[HearingDate],
		[CertMailNbr],
		[laststatuschg],
		[Jurisdiction],
		[prevappt],
		[mastersubcase],
		[mastercasenbr],
		[PublishOnWeb],
		[WebNotifyEmail],
		[AssessmentToAddress],
		[OCF25Date],
		[DateForminDispute],
		[AssessingFacility],
		[referralmethod],
		[referraltype],
		[CSR1],
		[CSR2],
		[LegalEvent],
		[PILegalEvent],
		[Transcode],
		[PublishDocuments],
		[DateReceived],
		[usddate3],
		[usddate4],
		[usddate5],
		[UsdBit1],
		[UsdBit2],
		[ClaimNbrExt],
		[DefParaLegal],
		[AttorneyNote],
		[BillingNote],
		[InterpreterRequired],
		[TransportationRequired],
		[LanguageID],
		[InputSourceID],
		[ReqEWAccreditationID],
		[RptInitialDraftDate],
		[RptSentDate],
		[ApptStatusId],
		[CaseApptId],
		[MMIReached],
		[MMITreatmentWeeks]					
	)
	VALUES
	(
		@chartnbr,
		@doctorlocation,
		@clientcode,
		@marketercode,
		@schedulercode,
		@priority,
		@status,
		@casetype,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited,
		@schedcode,
		@ApptDate,
		@Appttime,
		@ApptMadeDate,
		@claimnbr,
		@dateofinjury,
		@allegation,
		@calledinby,
		@notes,
		@schedulenotes,
		@requesteddoc,
		@datemedsrecd,
		@typemedsrecd,
		@transreceived,
		@shownoshow,
		@rptstatus,
		@reportverbal,
		@emailclient,
		@emaildoctor,
		@emailPattny,
		@faxclient,
		@faxdoctor,
		@faxPattny,
		@apptrptsselect,
		@chartprepselect,
		@apptselect,
		@awaittransselect,
		@intransselect,
		@inqaselect,
		@drchartselect,
		@datedrchart,
		@billedselect,
		@miscselect,
		@invoicedate,
		@invoiceamt,
		@plaintiffattorneycode,
		@defenseattorneycode,
		@commitdate,
		@servicecode,
		@issuecode,
		@doctorcode,
		@WCBNbr,
		@specialinstructions,
		@usdvarchar1,
		@usdvarchar2,
		@usddate1,
		@usddate2,
		@usdtext1,
		@usdtext2,
		@usdint1,
		@usdint2,
		@usdmoney1,
		@usdmoney2,
		@bComplete,
		@bhanddelivery,
		@sinternalcasenbr,
		@sreqspecialty,
		@doctorspecialty,
		@feecode,
		@voucherselect,
		@voucheramt,
		@voucherdate,
		@icdFormat,
		@icdcodeA,
		@icdcodeB,
		@icdcodeC,
		@icdcodeD,
		@icdcodeE,
		@icdcodeF,
		@icdcodeG,
		@icdcodeH,
		@icdcodeI,
		@icdcodeJ,
		@icdcodeK,
		@icdcodeL,
		@reccode,
		@billclientcode,
		@officecode,
		@QARep,
		@photoRqd,
		@CertifiedMail,
		@PanelNbr,
		@DoctorName,
		@HearingDate,
		@CertMailNbr,
		@laststatuschg,
		@Jurisdiction,
		@prevappt,
		@mastersubcase,
		@mastercasenbr,
		@PublishOnWeb,
		@WebNotifyEmail,
		@AssessmentToAddress,
		@OCF25Date,
		@DateForminDispute,
		@AssessingFacility,
		@referralmethod,
		@referraltype,
		@CSR1,
		@CSR2,
		@LegalEvent,
		@PILegalEvent,
		@Transcode,
		@PublishDocuments,
		@DateReceived,
		@usddate3,
		@usddate4,
		@usddate5,
		@UsdBit1,
		@UsdBit2,
		@ClaimNbrExt,
		@DefParaLegal,
		@AttorneyNote,
		@BillingNote,
		@InterpreterRequired,
		@TransportationRequired,
		@LanguageID,
		@InputSourceID,		
		@ReqEWAccreditationID,
		@RptInitialDraftDate,
		@RptSentDate,
		@ApptStatusId,
		@CaseApptId,
		@MMIReached,
		@MMITreatmentWeeks				
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO



/****** Object:  StoredProcedure [proc_HCAIControl_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_HCAIControl_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_HCAIControl_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_HCAIControl_LoadByPrimaryKey]
(
	@DBID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblHCAIControl]
	WHERE
		([DBID] = @DBID)

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_GetCaseIssuesByCase]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetCaseIssuesByCase]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_GetCaseIssuesByCase];
GO

CREATE PROCEDURE [proc_GetCaseIssuesByCase]

@CaseNbr int

AS 

SELECT * FROM tblCaseIssue 
	INNER JOIN tblIssue ON tblCaseIssue.issuecode = tblIssue.issuecode 
	WHERE casenbr = @CaseNbr


GO

/****** Object:  StoredProcedure [proc_GetCaseICDRequestsByCase]    Script Date: 1/22/2007 1:30:43 PM ******/
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[proc_GetCaseICDRequestsByCase]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_GetCaseICDRequestsByCase];
GO

CREATE PROCEDURE [proc_GetCaseICDRequestsByCase]

@CaseNbr int

AS 

SELECT * FROM tblCaseICDRequest 

	WHERE casenbr = @CaseNbr

GO

/****** Object:  StoredProcedure [proc_Examinee_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_Examinee_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_Examinee_Update];
GO

CREATE PROCEDURE [proc_Examinee_Update]
(
	@chartnbr int,
	@oldchartnbr varchar(15) = NULL,
	@lastname varchar(50) = NULL,
	@firstname varchar(50) = NULL,
	@middleinitial varchar(5) = NULL,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@phone1 varchar(15) = NULL,
	@phone2 varchar(15) = NULL,
	@SSN varchar(15) = NULL,
	@sex varchar(10) = NULL,
	@DOB datetime = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@note text = NULL,
	@county varchar(50) = NULL,
	@prefix varchar(10) = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@fax varchar(15) = NULL,
	@email varchar(50) = NULL,
	@insured varchar(50) = NULL,
	@employer varchar(70) = NULL,
	@treatingphysician varchar(70) = NULL,
	@InsuredAddr1 varchar(70) = NULL,
	@InsuredCity varchar(70) = NULL,
	@InsuredState varchar(5) = NULL,
	@InsuredZip varchar(10) = NULL,
	@InsuredSex varchar(10) = NULL,
	@InsuredRelationship varchar(20) = NULL,
	@InsuredPhone varchar(15) = NULL,
	@InsuredPhoneExt varchar(10) = NULL,
	@InsuredFax varchar(15) = NULL,
	@InsuredEmail varchar(70) = NULL,
	@ExamineeStatus varchar(30) = NULL,
	@TreatingPhysicianAddr1 varchar(70) = NULL,
	@TreatingPhysicianCity varchar(70) = NULL,
	@TreatingPhysicianState varchar(5) = NULL,
	@TreatingPhysicianZip varchar(10) = NULL,
	@TreatingPhysicianPhone varchar(15) = NULL,
	@TreatingPhysicianPhoneExt varchar(10) = NULL,
	@TreatingPhysicianFax varchar(15) = NULL,
	@TreatingPhysicianEmail varchar(70) = NULL,
	@TreatingPhysicianDiagnosis varchar(70) = NULL,
	@EmployerAddr1 varchar(70) = NULL,
	@EmployerCity varchar(70) = NULL,
	@EmployerState varchar(5) = NULL,
	@EmployerZip varchar(10) = NULL,
	@EmployerPhone varchar(15) = NULL,
	@EmployerPhoneExt varchar(10) = NULL,
	@EmployerFax varchar(15) = NULL,
	@EmployerEmail varchar(70) = NULL,
	@Country varchar(50) = NULL,
	@policynumber varchar(70) = NULL,
	@EmployerContactFirstName varchar(50) = NULL,
	@EmployerContactLastName varchar(50) = NULL,
	@TreatingPhysicianLicenseNbr varchar(50) = NULL,
	@TreatingPhysicianTaxID varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblExaminee]
	SET
		[oldchartnbr] = @oldchartnbr,
		[lastname] = @lastname,
		[firstname] = @firstname,
		[middleinitial] = @middleinitial,
		[addr1] = @addr1,
		[addr2] = @addr2,
		[city] = @city,
		[state] = @state,
		[zip] = @zip,
		[phone1] = @phone1,
		[phone2] = @phone2,
		[SSN] = @SSN,
		[sex] = @sex,
		[DOB] = @DOB,
		[dateadded] = @dateadded,
		[dateedited] = @dateedited,
		[useridadded] = @useridadded,
		[useridedited] = @useridedited,
		[note] = @note,
		[county] = @county,
		[prefix] = @prefix,
		[usdvarchar1] = @usdvarchar1,
		[usdvarchar2] = @usdvarchar2,
		[usddate1] = @usddate1,
		[usddate2] = @usddate2,
		[usdtext1] = @usdtext1,
		[usdtext2] = @usdtext2,
		[usdint1] = @usdint1,
		[usdint2] = @usdint2,
		[usdmoney1] = @usdmoney1,
		[usdmoney2] = @usdmoney2,
		[fax] = @fax,
		[email] = @email,
		[insured] = @insured,
		[employer] = @employer,
		[treatingphysician] = @treatingphysician,
		[InsuredAddr1] = @InsuredAddr1,
		[InsuredCity] = @InsuredCity,
		[InsuredState] = @InsuredState,
		[InsuredZip] = @InsuredZip,
		[InsuredSex] = @InsuredSex,
		[InsuredRelationship] = @InsuredRelationship,
		[InsuredPhone] = @InsuredPhone,
		[InsuredPhoneExt] = @InsuredPhoneExt,
		[InsuredFax] = @InsuredFax,
		[InsuredEmail] = @InsuredEmail,
		[ExamineeStatus] = @ExamineeStatus,
		[TreatingPhysicianAddr1] = @TreatingPhysicianAddr1,
		[TreatingPhysicianCity] = @TreatingPhysicianCity,
		[TreatingPhysicianState] = @TreatingPhysicianState,
		[TreatingPhysicianZip] = @TreatingPhysicianZip,
		[TreatingPhysicianPhone] = @TreatingPhysicianPhone,
		[TreatingPhysicianPhoneExt] = @TreatingPhysicianPhoneExt,
		[TreatingPhysicianFax] = @TreatingPhysicianFax,
		[TreatingPhysicianEmail] = @TreatingPhysicianEmail,
		[TreatingPhysicianDiagnosis] = @TreatingPhysicianDiagnosis,
		[EmployerAddr1] = @EmployerAddr1,
		[EmployerCity] = @EmployerCity,
		[EmployerState] = @EmployerState,
		[EmployerZip] = @EmployerZip,
		[EmployerPhone] = @EmployerPhone,
		[EmployerPhoneExt] = @EmployerPhoneExt,
		[EmployerFax] = @EmployerFax,
		[EmployerEmail] = @EmployerEmail,
		[Country] = @Country,
		[policynumber] = @policynumber,
		[EmployerContactFirstName] = @EmployerContactFirstName,
		[EmployerContactLastName] = @EmployerContactLastName,
		[TreatingPhysicianLicenseNbr] = @TreatingPhysicianLicenseNbr,
		[TreatingPhysicianTaxID] = @TreatingPhysicianTaxID
	WHERE
		[chartnbr] = @chartnbr


	SET @Err = @@Error


	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_Examinee_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_Examinee_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_Examinee_Insert];
GO

CREATE PROCEDURE [proc_Examinee_Insert]
(
	@chartnbr int = NULL output,
	@oldchartnbr varchar(15) = NULL,
	@lastname varchar(50) = NULL,
	@firstname varchar(50) = NULL,
	@middleinitial varchar(5) = NULL,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@phone1 varchar(15) = NULL,
	@phone2 varchar(15) = NULL,
	@SSN varchar(15) = NULL,
	@sex varchar(10) = NULL,
	@DOB datetime = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@note text = NULL,
	@county varchar(50) = NULL,
	@prefix varchar(10) = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@fax varchar(15) = NULL,
	@email varchar(50) = NULL,
	@insured varchar(50) = NULL,
	@employer varchar(70) = NULL,
	@treatingphysician varchar(70) = NULL,
	@InsuredAddr1 varchar(70) = NULL,
	@InsuredCity varchar(70) = NULL,
	@InsuredState varchar(5) = NULL,
	@InsuredZip varchar(10) = NULL,
	@InsuredSex varchar(10) = NULL,
	@InsuredRelationship varchar(20) = NULL,
	@InsuredPhone varchar(15) = NULL,
	@InsuredPhoneExt varchar(10) = NULL,
	@InsuredFax varchar(15) = NULL,
	@InsuredEmail varchar(70) = NULL,
	@ExamineeStatus varchar(30) = NULL,
	@TreatingPhysicianAddr1 varchar(70) = NULL,
	@TreatingPhysicianCity varchar(70) = NULL,
	@TreatingPhysicianState varchar(5) = NULL,
	@TreatingPhysicianZip varchar(10) = NULL,
	@TreatingPhysicianPhone varchar(15) = NULL,
	@TreatingPhysicianPhoneExt varchar(10) = NULL,
	@TreatingPhysicianFax varchar(15) = NULL,
	@TreatingPhysicianEmail varchar(70) = NULL,
	@TreatingPhysicianDiagnosis varchar(70) = NULL,
	@EmployerAddr1 varchar(70) = NULL,
	@EmployerCity varchar(70) = NULL,
	@EmployerState varchar(5) = NULL,
	@EmployerZip varchar(10) = NULL,
	@EmployerPhone varchar(15) = NULL,
	@EmployerPhoneExt varchar(10) = NULL,
	@EmployerFax varchar(15) = NULL,
	@EmployerEmail varchar(70) = NULL,
	@Country varchar(50) = NULL,
	@policynumber varchar(70) = NULL,
	@EmployerContactFirstName varchar(50) = NULL,
	@EmployerContactLastName varchar(50) = NULL,
	@TreatingPhysicianLicenseNbr varchar(50) = NULL,
	@TreatingPhysicianTaxID varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblExaminee]
	(
		[oldchartnbr],
		[lastname],
		[firstname],
		[middleinitial],
		[addr1],
		[addr2],
		[city],
		[state],
		[zip],
		[phone1],
		[phone2],
		[SSN],
		[sex],
		[DOB],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited],
		[note],
		[county],
		[prefix],
		[usdvarchar1],
		[usdvarchar2],
		[usddate1],
		[usddate2],
		[usdtext1],
		[usdtext2],
		[usdint1],
		[usdint2],
		[usdmoney1],
		[usdmoney2],
		[fax],
		[email],
		[insured],
		[employer],
		[treatingphysician],
		[InsuredAddr1],
		[InsuredCity],
		[InsuredState],
		[InsuredZip],
		[InsuredSex],
		[InsuredRelationship],
		[InsuredPhone],
		[InsuredPhoneExt],
		[InsuredFax],
		[InsuredEmail],
		[ExamineeStatus],
		[TreatingPhysicianAddr1],
		[TreatingPhysicianCity],
		[TreatingPhysicianState],
		[TreatingPhysicianZip],
		[TreatingPhysicianPhone],
		[TreatingPhysicianPhoneExt],
		[TreatingPhysicianFax],
		[TreatingPhysicianEmail],
		[TreatingPhysicianDiagnosis],
		[EmployerAddr1],
		[EmployerCity],
		[EmployerState],
		[EmployerZip],
		[EmployerPhone],
		[EmployerPhoneExt],
		[EmployerFax],
		[EmployerEmail],
		[Country],
		[policynumber],
		[EmployerContactFirstName],
		[EmployerContactLastName],
		[TreatingPhysicianLicenseNbr],
		[TreatingPhysicianTaxID]
	)
	VALUES
	(
		@oldchartnbr,
		@lastname,
		@firstname,
		@middleinitial,
		@addr1,
		@addr2,
		@city,
		@state,
		@zip,
		@phone1,
		@phone2,
		@SSN,
		@sex,
		@DOB,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited,
		@note,
		@county,
		@prefix,
		@usdvarchar1,
		@usdvarchar2,
		@usddate1,
		@usddate2,
		@usdtext1,
		@usdtext2,
		@usdint1,
		@usdint2,
		@usdmoney1,
		@usdmoney2,
		@fax,
		@email,
		@insured,
		@employer,
		@treatingphysician,
		@InsuredAddr1,
		@InsuredCity,
		@InsuredState,
		@InsuredZip,
		@InsuredSex,
		@InsuredRelationship,
		@InsuredPhone,
		@InsuredPhoneExt,
		@InsuredFax,
		@InsuredEmail,
		@ExamineeStatus,
		@TreatingPhysicianAddr1,
		@TreatingPhysicianCity,
		@TreatingPhysicianState,
		@TreatingPhysicianZip,
		@TreatingPhysicianPhone,
		@TreatingPhysicianPhoneExt,
		@TreatingPhysicianFax,
		@TreatingPhysicianEmail,
		@TreatingPhysicianDiagnosis,
		@EmployerAddr1,
		@EmployerCity,
		@EmployerState,
		@EmployerZip,
		@EmployerPhone,
		@EmployerPhoneExt,
		@EmployerFax,
		@EmployerEmail,
		@Country,
		@policynumber,
		@EmployerContactFirstName,
		@EmployerContactLastName,
		@TreatingPhysicianLicenseNbr,
		@TreatingPhysicianTaxID
	)

	SET @Err = @@Error

	SELECT @chartnbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseICDRequest_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICDRequest_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseICDRequest_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_CaseICDRequest_LoadByPrimaryKey]
(
	@casenbr int,
	@ICDCode varchar(10)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCaseICDRequest]
	WHERE
		([casenbr] = @casenbr) AND
		([ICDCode] = @ICDCode)

	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_CaseICDRequest_LoadAll]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICDRequest_LoadAll]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseICDRequest_LoadAll];
GO

CREATE PROCEDURE [proc_CaseICDRequest_LoadAll]

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCaseICDRequest]


	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseICDRequest_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICDRequest_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseICDRequest_Insert];
GO

CREATE PROCEDURE [proc_CaseICDRequest_Insert]
(
	@seqno int = NULL output,
	@casenbr int,
	@ICDCode varchar(10) = NULL,
	@Status varchar(50) = NULL,
	@Description varchar(200) = NULL,
	@DateAdded datetime = NULL,
	@UserIDAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseICDRequest]
	(
		[casenbr],	
		[ICDCode],	
		[Status],
		[Description],	
		[DateAdded],	
		[UserIDAdded],	
		[DateEdited],	
		[UserIDEdited]
	)
	VALUES
	(
		@casenbr,	
		@ICDCode,	
		@Status,
		@Description,	
		@DateAdded,	
		@UserIDAdded,	
		@DateEdited,	
		@UserIDEdited
	)

	SET @Err = @@Error

	SELECT @seqno = SCOPE_IDENTITY()

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseICDRequest_Delete]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseICDRequest_Delete]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseICDRequest_Delete];
GO

CREATE PROCEDURE [proc_CaseICDRequest_Delete]
(
	@casenbr int,
	@ICDCode varchar(10)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	DELETE
	FROM [tblCaseICDRequest]
	WHERE
		[casenbr] = @casenbr AND
		[ICDCode] = @ICDCode
	SET @Err = @@Error

	RETURN @Err
END
GO


UPDATE tblControl SET DBVersion='2.26'
GO
