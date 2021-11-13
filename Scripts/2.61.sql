ALTER TABLE [tblEWWebUser]
  ADD [ShowThirdPartyBilling] BIT DEFAULT 0 NOT NULL
GO

ALTER TABLE [tblWebUser]
  ADD [ShowThirdPartyBilling] BIT DEFAULT 0 NOT NULL
GO

--------------------------BEGIN PROC 1--------------------------

/****** Object:  StoredProcedure [proc_EWWebUser_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_EWWebUser_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_EWWebUser_Update];
GO

CREATE PROCEDURE [proc_EWWebUser_Update]
(
	@EWWebUserID int,
	@UserID varchar(100) = NULL,
	@Password varchar(200) = NULL,
	@UserType varchar(2),
	@EWEntityID int,
	@ProviderSearch bit,
	@AutoPublishNewCases bit,
	@DisplayClient bit,
	@StatusID int = NULL,
	@LastLoginDate datetime = NULL,
	@FailedLoginAttempts int = NULL,
	@LockoutDate datetime = NULL,
	@LastPasswordChangeDate datetime = NULL,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL,
	@ShowThirdPartyBilling bit
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [EWWebUser]
	SET
		[UserID] = @UserID,
		[Password] = @Password,
		[UserType] = @UserType,
		[EWEntityID] = @EWEntityID,
		[ProviderSearch] = @ProviderSearch,
		[AutoPublishNewCases] = @AutoPublishNewCases,
		[DisplayClient] = @DisplayClient,
		[StatusID] = @StatusID,
		[LastLoginDate] = @LastLoginDate,
		[FailedLoginAttempts] = @FailedLoginAttempts,
		[LockoutDate] = @LockoutDate,
		[LastPasswordChangeDate] = @LastPasswordChangeDate,
		[DateAdded] = @DateAdded,
		[UseridAdded] = @UseridAdded,
		[DateEdited] = @DateEdited,
		[UseridEdited] =@UseridEdited,
		[ShowThirdPartyBilling] = @ShowThirdPartyBilling	
	WHERE
		[EWWebUserID] = @EWWebUserID


	SET @Err = @@Error


	RETURN @Err
END
GO

--------------------------END PROC 1----------------------------

GO

--------------------------BEGIN PROC 2--------------------------

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
	@CaseApptId int = NULL,
	@BillingNote text = NULL
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
		[CaseApptId],
		[BillingNote]			
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
		@CaseApptId,
		@BillingNote		
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO


--------------------------END PROC 2----------------------------

GO

--------------------------BEGIN PROC 3--------------------------

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
	@CaseApptId int = NULL,
	@BillingNote text = NULL
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
		[CaseApptId] = @CaseApptId,
		[BillingNote] = @BillingNote
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO

--------------------------END PROC 3----------------------------

GO

--------------------------BEGIN PROC 4--------------------------

/****** Object:  StoredProcedure [proc_WebUser_Update]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_WebUser_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_WebUser_Update];
GO

CREATE PROCEDURE [proc_WebUser_Update]
(
	@WebUserID int,
	@UserID varchar(100) = NULL,
	@Password varchar(200) = NULL,
	@LastLoginDate datetime = NULL,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@UseridEdited varchar(50) = NULL,
	@DisplayClient bit,
	@ProviderSearch bit,
	@IMECentricCode int,
	@UserType varchar(2),
	@AutoPublishNewCases bit,
	@IsClientAdmin bit,
	@UpdateFlag bit,
	@LastPasswordChangeDate datetime = NULL,
	@StatusID int = NULL,
	@FailedLoginAttempts int = NULL,
	@LockoutDate datetime = NULL,
	@ShowThirdPartyBilling bit
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblWebUser]
	SET
		[UserID] = @UserID,
		[Password] = @Password,
		[LastLoginDate] = @LastLoginDate,
		[DateAdded] = @DateAdded,
		[DateEdited] = @DateEdited,
		[UseridAdded] = @UseridAdded,
		[UseridEdited] = @UseridEdited,
		[DisplayClient] = @DisplayClient,
		[ProviderSearch] = @ProviderSearch,
		[IMECentricCode] = @IMECentricCode,
		[UserType] = @UserType,
		[AutoPublishNewCases] = @AutoPublishNewCases,
		[IsClientAdmin] = @IsClientAdmin,
		[UpdateFlag] = @UpdateFlag,
		[LastPasswordChangeDate] = @LastPasswordChangeDate,
		[StatusID] = @StatusID,
		[FailedLoginAttempts] = @FailedLoginAttempts,
		[LockoutDate] = @LockoutDate,
		[ShowThirdPartyBilling] = @ShowThirdPartyBilling
	WHERE
		[WebUserID] = @WebUserID


	SET @Err = @@Error


	RETURN @Err
END
GO


UPDATE tblControl SET DBVersion='2.61'
GO
