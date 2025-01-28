
/****** Object:  StoredProcedure [proc_TranscriptionJob_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJob_Insert];
GO

CREATE PROCEDURE [proc_TranscriptionJob_Insert]
(
	@TranscriptionJobID int = NULL output,
	@TranscriptionStatusCode int,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(20) = NULL,
	@CaseNbr int = NULL,
	@ReportTemplate varchar(15) = NULL,
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL,
	@DateTranscribingStart datetime = NULL,
	@DateCanceled datetime = NULL,
	@InternalTransTat int = NULL,
	@ReportLines int = NULL,
	@ReportWords int = NULL,
	@EwTransDeptId int = NULL,
	@CoverLetterDownloaded bit = NULL,
	@ReportDownloaded bit = NULL,
	@Workflow int = NULL,
	@OriginalRptFileName varchar(100) = NULL,
	@Notes varchar(100) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblTranscriptionJob]
	(
		[TranscriptionStatusCode],
		[DateAdded],
		[DateEdited],
		[UserIDEdited],
		[CaseNbr],
		[ReportTemplate],
		[CoverLetterFile],
		[TransCode],
		[DateAssigned],
		[ReportFile],
		[DateRptReceived],
		[DateCompleted],
		[LastStatusChg],
		[DateTranscribingStart],
		[DateCanceled],
		[InternalTransTat],
		[ReportLines],
		[ReportWords],
		[EWTransDeptId],
		[CoverLetterDownloaded],
		[ReportDownloaded],
		[Workflow],
		[OriginalRptFileName],
		[Notes]
	)
	VALUES
	(
		@TranscriptionStatusCode,
		@DateAdded,
		@DateEdited,
		@UserIDEdited,
		@CaseNbr,
		@ReportTemplate,
		@CoverLetterFile,
		@TransCode, 
		@DateAssigned,
		@ReportFile,
		@DateRptReceived,
		@DateCompleted,
		@LastStatusChg,
		@DateTranscribingStart,
		@DateCanceled,
		@InternalTransTat,
		@ReportLines,
		@ReportWords,
		@EWTransDeptId,
		@CoverLetterDownloaded,
		@ReportDownloaded,
		@Workflow,
		@OriginalRptFileName,
		@Notes
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobID = SCOPE_IDENTITY()

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJob_Update];
GO

CREATE PROCEDURE [proc_TranscriptionJob_Update]
(
	@TranscriptionJobID int,
	@TranscriptionStatusCode int,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(20) = NULL,
	@CaseNbr int = NULL,
	@ReportTemplate varchar(15) = NULL,
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL,
	@DateTranscribingStart datetime = NULL,
	@DateCanceled datetime = NULL,
	@InternalTransTat int = NULL,
	@ReportLines int = NULL,
	@ReportWords int = NULL,
	@EwTransDeptId int = NULL,
	@CoverLetterDownloaded bit = NULL,
	@ReportDownloaded bit = NULL,
	@Workflow int = NULL,
	@OriginalRptFileName varchar(100) = NULL,
	@Notes varchar(100) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblTranscriptionJob]
	SET

	[TranscriptionStatusCode] = @TranscriptionStatusCode,
	[DateAdded] = @DateAdded,
	[DateEdited] = @DateEdited,
	[UserIDEdited] = @UserIDEdited,
	[CaseNbr] = @CaseNbr,
	[ReportTemplate] = @ReportTemplate,
	[CoverLetterFile] = @CoverLetterFile,
	[TransCode] = @TransCode,
	[DateAssigned] = @DateAssigned,
	[ReportFile] = @ReportFile,
	[DateRptReceived] = @DateRptReceived,
	[DateCompleted] = @DateCompleted,
	[LastStatusChg] = @LastStatusChg,
	[DateTranscribingStart] = @DateTranscribingStart,
	[DateCanceled] = @DateCanceled,
	[InternalTransTat] = @InternalTransTat,
	[ReportLines] = @ReportLines,
	[ReportWords] = @ReportWords,
	[EwTransDeptId] = @EwTransDeptId,
	[CoverLetterDownloaded] = @CoverLetterDownloaded,
	[ReportDownloaded] = @ReportDownloaded,
	[Workflow] = @Workflow,
	[OriginalRptFileName] = @OriginalRptFileName,
	[Notes] = @Notes

	WHERE
		[TranscriptionJobID] = @TranscriptionJobID


	SET @Err = @@Error


	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_TranscriptionJobDictation_Insert]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJobDictation_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJobDictation_Insert];
GO

CREATE PROCEDURE [proc_TranscriptionJobDictation_Insert]
(
	@TranscriptionJobDictationID int = NULL output,
	@TranscriptionJobID int = NULL,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDAdded varchar(20) = NULL,
	@UserIDEdited varchar(20) = NULL,
	@DictationFile varchar(100) = NULL,
	@OriginalFileName varchar(100) = NULL,
	@DictationDownloaded bit = NULL,
	@IntegrationId int = NULL,
	@SeqNo int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblTranscriptionJobDictation]
	(
		[TranscriptionJobID],
		[DateAdded],
		[DateEdited],
		[UserIDAdded],
		[UserIDEdited],
		[DictationFile],
		[OriginalFileName],
		[DictationDownloaded],
		[IntegrationId],
		[SeqNo]
	)
	VALUES
	(
		@TranscriptionJobID,
		@DateAdded,
		@DateEdited,
		@UserIDAdded,
		@UserIDEdited,
		@DictationFile,
		@OriginalFileName,
		@DictationDownloaded,
		@IntegrationId,
		@SeqNo
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobDictationID = SCOPE_IDENTITY()

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_TranscriptionJobDictation_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJobDictation_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJobDictation_Update];
GO

CREATE PROCEDURE [proc_TranscriptionJobDictation_Update]
(
	@TranscriptionJobDictationID int,
	@TranscriptionJobID int,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDAdded varchar(20) = NULL,
	@UserIDEdited varchar(20) = NULL,
	@DictationFile varchar(100) = NULL,
	@OriginalFileName varchar(100) = NULL,
	@DictationDownloaded bit = NULL,
	@IntegrationId int = NULL,
	@SeqNo int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblTranscriptionJobDictation]
	SET

	[TranscriptionJobID] = @TranscriptionJobID,
	[DateAdded] = @DateAdded,
	[DateEdited] = @DateEdited,
	[UserIDAdded] = @UserIDAdded,
	[UserIDEdited] = @UserIDEdited,
	[DictationFile] = @DictationFile,
	[OriginalFileName] = @OriginalFileName,
	[DictationDownloaded] = @DictationDownloaded,
	[IntegrationId] = @IntegrationId,
	[SeqNo] = @SeqNo

	WHERE
		[TranscriptionJobDictationID] = @TranscriptionJobDictationID


	SET @Err = @@Error


	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_TranscriptionJobDictation_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJobDictation_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJobDictation_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_TranscriptionJobDictation_LoadByPrimaryKey]
(
	@TranscriptionJobDictationID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblTranscriptionJobDictation]
	WHERE
		([TranscriptionJobDictationID] = @TranscriptionJobDictationID)
		
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
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usddate3 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@reportverbal bit = NULL,
	@TransCode int = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@DoctorName varchar(100) = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@reccode int = NULL,
	@Jurisdiction varchar(5) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@HearingDate smalldatetime = NULL,
	@laststatuschg datetime = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@DateReceived datetime = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL
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
		[usddate1],
		[usddate2],
		[usddate3],
		[calledinby],
		[notes],
		[schedulenotes],
		[requesteddoc],
		[reportverbal],
		[TransCode],
		[plaintiffattorneycode],
		[defenseattorneycode],
		[commitdate],
		[servicecode],
		[issuecode],
		[doctorcode],
		[DoctorName],
		[WCBNbr],
		[specialinstructions],
		[sreqspecialty],
		[doctorspecialty],
		[reccode],
		[Jurisdiction],
		[officecode],
		[QARep],
		[photoRqd],
		[CertifiedMail],
		[HearingDate],
		[laststatuschg],
		[PublishOnWeb],
		[WebNotifyEmail],
		[DateReceived],
		[ClaimNbrExt],
		[InterpreterRequired],
		[TransportationRequired],
		[LanguageID],
		[InputSourceID],
		[ReqEWAccreditationID],
		[ApptStatusId],
		[CaseApptId]			
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
		@usddate1,
		@usddate2,
		@usddate3,
		@calledinby,
		@notes,
		@schedulenotes,
		@requesteddoc,
		@reportverbal,
		@TransCode,
		@plaintiffattorneycode,
		@defenseattorneycode,
		@commitdate,
		@servicecode,
		@issuecode,
		@doctorcode,
		@DoctorName,
		@WCBNbr,
		@specialinstructions,
		@sreqspecialty,
		@doctorspecialty,
		@reccode,
		@Jurisdiction,
		@officecode,
		@QARep,
		@photoRqd,
		@CertifiedMail,
		@HearingDate,
		@laststatuschg,
		@PublishOnWeb,
		@WebNotifyEmail,
		@DateReceived,
		@ClaimNbrExt,
		@InterpreterRequired,
		@TransportationRequired,
		@LanguageID,
		@InputSourceID,		
		@ReqEWAccreditationID,
		@ApptStatusId,
		@CaseApptId		
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
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usddate3 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@reportverbal bit = NULL,
	@TransCode int = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@DoctorName varchar(100) = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@reccode int = NULL,
	@Jurisdiction varchar(5) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@HearingDate smalldatetime = NULL,
	@laststatuschg datetime = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@DateReceived datetime = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL
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
		[usddate1] = @usddate1,
		[usddate2] = @usddate2,
		[usddate3] = @usddate3,
		[calledinby] = @calledinby,
		[notes] = @notes,
		[schedulenotes] = @schedulenotes,
		[requesteddoc] = @requesteddoc,
		[reportverbal] = @reportverbal,
		[TransCode] = @TransCode,
		[plaintiffattorneycode] = @plaintiffattorneycode,
		[defenseattorneycode] = @defenseattorneycode,
		[commitdate] = @commitdate,
		[servicecode] = @servicecode,
		[issuecode] = @issuecode,
		[doctorcode] = @doctorcode,
		[DoctorName] = @DoctorName,
		[WCBNbr] = @WCBNbr,
		[specialinstructions] = @specialinstructions,
		[sreqspecialty] = @sreqspecialty,
		[doctorspecialty] = @doctorspecialty,
		[reccode] = @reccode,
		[Jurisdiction] = @Jurisdiction,
		[officecode] = @officecode,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[CertifiedMail] = @CertifiedMail,
		[HearingDate] = @HearingDate,
		[laststatuschg] = @laststatuschg,
		[PublishOnWeb] = @PublishOnWeb,
		[WebNotifyEmail] = @WebNotifyEmail,
		[DateReceived] = @DateReceived,
		[ClaimNbrExt] = @ClaimNbrExt,
		[InterpreterRequired] = @InterpreterRequired,
		[TransportationRequired] = @TransportationRequired,
		[LanguageID] = @LanguageID,
		[InputSourceID] = @InputSourceID,
		[ReqEWAccreditationID] = @ReqEWAccreditationID,
		[ApptStatusId] = @ApptStatusId,
		[CaseApptId] = @CaseApptId
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseHistory_LoadExprtGridByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseHistory_LoadExprtGridByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseHistory_LoadExprtGridByCaseNbr];
GO

CREATE PROCEDURE [proc_CaseHistory_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblCaseHistory.UserID as 'User', tblCaseHistory.DateAdded as 'Date Added', eventdesc as Description, otherinfo as Info 
		FROM tblCaseHistory 
			INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN 
				(SELECT UserCode 
					FROM tblWebUserAccount 
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
			AND (casenbr = @CaseNbr)
			AND (tblCaseHistory.PublishOnWeb = 1) 

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_CaseDocument_LoadExprtGridByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseDocument_LoadExprtGridByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_CaseDocument_LoadExprtGridByCaseNbr];
GO

CREATE PROCEDURE [proc_CaseDocument_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT tblCaseDocuments.UserIDAdded as 'User', tblCaseDocuments.DateAdded as 'Date Added', sfilename as 'File Name', Description 
		FROM tblCaseDocuments 
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments' 
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN 
				(SELECT UserCode 
					FROM tblWebUserAccount 
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
			AND (casenbr = @CaseNbr)
			AND (tblCaseDocuments.PublishOnWeb = 1) 

	SET @Err = @@Error

	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_IMECase_UpdateDateEdited]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_UpdateDateEdited]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_UpdateDateEdited];
GO

CREATE PROCEDURE [proc_IMECase_UpdateDateEdited]
(
	@casenbr int,
	@dateedited datetime
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[dateedited] = @dateedited
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_IMECase_UpdateTransCode]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_IMECase_UpdateTransCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_IMECase_UpdateTransCode];
GO

CREATE PROCEDURE [proc_IMECase_UpdateTransCode]
(
	@casenbr int,
	@TransCode int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[TransCode] = @TransCode
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO

/****** Object:  StoredProcedure [proc_TranscriptionJobDictation_LoadByTranscriptionJobID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJobDictation_LoadByTranscriptionJobID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJobDictation_LoadByTranscriptionJobID];
GO

CREATE PROCEDURE [proc_TranscriptionJobDictation_LoadByTranscriptionJobID]
(
	@TranscriptionJobID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblTranscriptionJob.*,
	tblTranscriptionJobDictation.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblExaminee.LastName + ', ' + tblExaminee.FirstName AS 'Examinee',
	tblTranscription.TransCompany,
	tblCase.ApptDate,
	'Dictation' AS 'FileType'
	
	FROM tblTranscriptionJobDictation
		INNER JOIN tblTranscriptionJob ON tblTranscriptionJobDictation.TranscriptionJobID = tblTranscriptionJob.TranscriptionJobID
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJobDictation.TranscriptionJobID = @TranscriptionJobID
		
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
	@prefix varchar(10) = NULL,
	@fax varchar(15) = NULL,
	@email varchar(50) = NULL,
	@insured varchar(50) = NULL,
	@employer varchar(70) = NULL,
	@treatingphysician varchar(70) = NULL,
	@InsuredAddr1 varchar(70) = NULL,
	@InsuredCity varchar(70) = NULL,
	@InsuredState varchar(5) = NULL,
	@InsuredZip varchar(10) = NULL,
	@InsuredPhone varchar(15) = NULL,
	@InsuredPhoneExt varchar(10) = NULL,
	@InsuredFax varchar(15) = NULL,
	@InsuredEmail varchar(70) = NULL,
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
	@policynumber varchar(70) = NULL,
	@EmployerContactFirstName varchar(50) = NULL,
	@EmployerContactLastName varchar(50) = NULL,
	@County varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblExaminee]
	(
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
		[prefix],
		[fax],
		[email],
		[insured],
		[employer],
		[treatingphysician],
		[InsuredAddr1],
		[InsuredCity],
		[InsuredState],
		[InsuredZip],
		[InsuredPhone],
		[InsuredPhoneExt],
		[InsuredFax],
		[InsuredEmail],
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
		[policynumber],
		[EmployerContactFirstName],
		[EmployerContactLastName],
		[County]
	)
	VALUES
	(
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
		@prefix,
		@fax,
		@email,
		@insured,
		@employer,
		@treatingphysician,
		@InsuredAddr1,
		@InsuredCity,
		@InsuredState,
		@InsuredZip,
		@InsuredPhone,
		@InsuredPhoneExt,
		@InsuredFax,
		@InsuredEmail,
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
		@policynumber,
		@EmployerContactFirstName,
		@EmployerContactLastName,
		@County
	)

	SET @Err = @@Error

	SELECT @chartnbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_Examinee_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_Examinee_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_Examinee_Update];
GO

CREATE PROCEDURE [proc_Examinee_Update]
(
	@chartnbr int,
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
	@prefix varchar(10) = NULL,
	@fax varchar(15) = NULL,
	@email varchar(50) = NULL,
	@insured varchar(50) = NULL,
	@employer varchar(70) = NULL,
	@treatingphysician varchar(70) = NULL,
	@InsuredAddr1 varchar(70) = NULL,
	@InsuredCity varchar(70) = NULL,
	@InsuredState varchar(5) = NULL,
	@InsuredZip varchar(10) = NULL,
	@InsuredPhone varchar(15) = NULL,
	@InsuredPhoneExt varchar(10) = NULL,
	@InsuredFax varchar(15) = NULL,
	@InsuredEmail varchar(70) = NULL,
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
	@policynumber varchar(70) = NULL,
	@EmployerContactFirstName varchar(50) = NULL,
	@EmployerContactLastName varchar(50) = NULL,
	@County varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblExaminee]
	SET
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
		[prefix] = @prefix,
		[fax] = @fax,
		[email] = @email,
		[insured] = @insured,
		[employer] = @employer,
		[treatingphysician] = @treatingphysician,
		[InsuredAddr1] = @InsuredAddr1,
		[InsuredCity] = @InsuredCity,
		[InsuredState] = @InsuredState,
		[InsuredZip] = @InsuredZip,
		[InsuredPhone] = @InsuredPhone,
		[InsuredPhoneExt] = @InsuredPhoneExt,
		[InsuredFax] = @InsuredFax,
		[InsuredEmail] = @InsuredEmail,
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
		[policynumber] = @policynumber,
		[EmployerContactFirstName] = @EmployerContactFirstName,
		[EmployerContactLastName] = @EmployerContactLastName,
		[County] = @County
	WHERE
		[chartnbr] = @chartnbr


	SET @Err = @@Error


	RETURN @Err
END
GO




UPDATE tblControl SET DBVersion='2.59'
GO
