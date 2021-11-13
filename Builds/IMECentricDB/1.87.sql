

--Changes by Gary for Web Portal

/****** Object:  StoredProcedure [proc_CaseDocuments_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseDocuments_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseDocuments_Update];
GO

CREATE PROCEDURE [proc_CaseDocuments_Update]
(
	@casenbr int,
	@document varchar(20),
	@type varchar(20) = NULL,
	@reporttype varchar(20) = NULL,
	@description varchar(200) = NULL,
	@sfilename varchar(200) = NULL,
	@dateadded datetime,
	@useridadded varchar(20) = NULL,
	@PublishOnWeb bit = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@seqno int,
	@PublishedTo varchar(50) = NULL,
	@Viewed bit,
	@FileMoved bit,
	@FileSize int,
	@Source varchar(15)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCaseDocuments]
	SET
		[casenbr] = @casenbr,
		[document] = @document,
		[type] = @type,
		[reporttype] = @reporttype,
		[description] = @description,
		[sfilename] = @sfilename,
		[dateadded] = @dateadded,
		[useridadded] = @useridadded,
		[PublishOnWeb] = @PublishOnWeb,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[PublishedTo] = @PublishedTo,
		[Viewed] = @Viewed,
		[FileMoved] = @FileMoved,
		[FileSize] = @FileSize,
		[Source] = @Source
	WHERE
		[seqno] = @seqno


	SET @Err = @@Error


	RETURN @Err
END
GO



/****** Object:  StoredProcedure [proc_CaseDocuments_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseDocuments_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseDocuments_Insert];
GO

CREATE PROCEDURE [proc_CaseDocuments_Insert]
(
	@casenbr int,
	@document varchar(20),
	@type varchar(20) = NULL,
	@reporttype varchar(20) = NULL,
	@description varchar(200) = NULL,
	@sfilename varchar(200) = NULL,
	@dateadded datetime,
	@useridadded varchar(20) = NULL,
	@PublishOnWeb bit = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@seqno int = NULL output,
	@PublishedTo varchar(50) = NULL,
	@Viewed bit,
	@FileMoved bit,
	@FileSize int,
	@Source varchar(15)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseDocuments]
	(
		[casenbr],
		[document],
		[type],
		[reporttype],
		[description],
		[sfilename],
		[dateadded],
		[useridadded],
		[PublishOnWeb],
		[dateedited],
		[useridedited],
		[PublishedTo],
		[Viewed],
		[FileMoved],
		[FileSize],
		[Source]
	)
	VALUES
	(
		@casenbr,
		@document,
		@type,
		@reporttype,
		@description,
		@sfilename,
		@dateadded,
		@useridadded,
		@PublishOnWeb,
		@dateedited,
		@useridedited,
		@PublishedTo,
		@Viewed,
		@FileMoved,
		@FileSize,
		@Source
	)

	SET @Err = @@Error

	SELECT @seqno = SCOPE_IDENTITY()

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_Examinee_LoadByName]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_Examinee_LoadByName]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_Examinee_LoadByName];
GO

CREATE PROCEDURE [proc_Examinee_LoadByName]
(
	@firstName varchar(50),
	@lastName varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblExaminee]
	WHERE
		([firstname] = @firstName)
	AND
		([lastname] = @lastName)

	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_CCAddress_LoadByName]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CCAddress_LoadByName]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CCAddress_LoadByName];
GO

CREATE PROCEDURE [proc_CCAddress_LoadByName]
(
	@FirstName varchar(50),
	@LastName varchar(50),
	@Company varchar(70)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCCAddress]
	WHERE
		([FirstName] = @FirstName)
	AND
		([LastName] = @LastName)
	AND
		([Company] = @Company)

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
	@icd9code varchar(70) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@billcompany varchar(100) = NULL,
	@billcontact varchar(70) = NULL,
	@billaddr1 varchar(70) = NULL,
	@billaddr2 varchar(70) = NULL,
	@billcity varchar(70) = NULL,
	@billstate varchar(2) = NULL,
	@billzip varchar(10) = NULL,
	@billARKey varchar(100) = NULL,
	@billfax varchar(15) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@ICD9Code2 varchar(70) = NULL,
	@ICD9Code3 varchar(70) = NULL,
	@ICD9Code4 varchar(70) = NULL,
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
	@RptSentDate datetime = NULL
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
		[icd9code],
		[reccode],
		[billclientcode],
		[billcompany],
		[billcontact],
		[billaddr1],
		[billaddr2],
		[billcity],
		[billstate],
		[billzip],
		[billARKey],
		[billfax],
		[officecode],
		[QARep],
		[photoRqd],
		[CertifiedMail],
		[ICD9Code2],
		[ICD9Code3],
		[ICD9Code4],
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
		[RptSentDate]				
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
		@icd9code,
		@reccode,
		@billclientcode,
		@billcompany,
		@billcontact,
		@billaddr1,
		@billaddr2,
		@billcity,
		@billstate,
		@billzip,
		@billARKey,
		@billfax,
		@officecode,
		@QARep,
		@photoRqd,
		@CertifiedMail,
		@ICD9Code2,
		@ICD9Code3,
		@ICD9Code4,
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
		@RptSentDate
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

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
	@icd9code varchar(70) = NULL,
	@reccode int = NULL,
	@billclientcode int = NULL,
	@billcompany varchar(100) = NULL,
	@billcontact varchar(70) = NULL,
	@billaddr1 varchar(70) = NULL,
	@billaddr2 varchar(70) = NULL,
	@billcity varchar(70) = NULL,
	@billstate varchar(2) = NULL,
	@billzip varchar(10) = NULL,
	@billARKey varchar(100) = NULL,
	@billfax varchar(15) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@ICD9Code2 varchar(70) = NULL,
	@ICD9Code3 varchar(70) = NULL,
	@ICD9Code4 varchar(70) = NULL,
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
	@RptSentDate datetime = NULL
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
		[icd9code] = @icd9code,
		[reccode] = @reccode,
		[billclientcode] = @billclientcode,
		[billcompany] = @billcompany,
		[billcontact] = @billcontact,
		[billaddr1] = @billaddr1,
		[billaddr2] = @billaddr2,
		[billcity] = @billcity,
		[billstate] = @billstate,
		[billzip] = @billzip,
		[billARKey] = @billARKey,
		[billfax] = @billfax,
		[officecode] = @officecode,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[CertifiedMail] = @CertifiedMail,
		[ICD9Code2] = @ICD9Code2,
		[ICD9Code3] = @ICD9Code3,
		[ICD9Code4] = @ICD9Code4,
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
		[RptSentDate] =	@RptSentDate					
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO


--Add a field to store the VoicePlayer deploy folder for auto install
ALTER TABLE [tblIMEData]
  ADD [DirVoicePlayer] VARCHAR(70)
GO

--Set the default VoicePlayer deploy folder
UPDATE tblIMEData SET DirVoicePlayer='\\SQLSERVER2\IMECentricDocs\Deploy\VoicePlayer\'
GO


UPDATE tblControl SET DBVersion='1.87'
GO
