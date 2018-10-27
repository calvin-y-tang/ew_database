IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [AddlClaimNbrs] VARCHAR (50) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeNotaryRequired]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeNotaryRequired]
    ON [dbo].[tblCase]([OfficeCode] ASC, [NotaryRequired] ASC)
    INCLUDE([ChartNbr], [ClientCode], [ServiceCode]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeSchedulerCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeSchedulerCode]
    ON [dbo].[tblCase]([OfficeCode] ASC, [SchedulerCode] ASC)
    INCLUDE([CaseNbr], [ClientCode], [ServiceCode], [Status]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblCaseHistory].[IX_tblCaseHistory_CaseNbrFollowUpDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseHistory_CaseNbrFollowUpDate]
    ON [dbo].[tblCaseHistory]([CaseNbr] ASC, [FollowUpDate] ASC)
    INCLUDE([EventDate], [Eventdesc], [UserID], [OtherInfo], [ID]);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_GetCaseDetailsProgressive]...';


GO
ALTER PROCEDURE [proc_GetCaseDetailsProgressive] 
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblExaminee.*, 
		tblCase.*,
		CC1.ccCode DefenseAttorneyCode,
		CC1.LastName DefenseAttorneyLastName,
		CC1.FirstName DefenseAttorneyFirstName,
		CC1.Company DefenseAttorneyCompany,
		CC1.Address1 DefenseAttorneyAddress1,
		CC1.Address2 DefenseAttorneyAddress2,
		CC1.City DefenseAttorneyCity,
		CC1.[State] DefenseAttorneyState,
		CC1.Zip DefenseAttorneyZip,
		CC1.Phone DefenseAttorneyPhone,
		CC1.PhoneExtension DefenseAttorneyPhoneExt,
		CC1.Fax DefenseAttorneyFax,
		CC1.Email DefenseAttorneyEmail,
		CC2.ccCode PlaintiffAttorneyCode,
		CC2.LastName PlaintiffAttorneyLastName,
		CC2.FirstName PlaintiffAttorneyFirstName,
		CC2.Company PlaintiffAttorneyCompany,
		CC2.Address1 PlaintiffAttorneyAddress1,
		CC2.Address2 PlaintiffAttorneyAddress2,
		CC2.City PlaintiffAttorneyCity,
		CC2.[State] PlaintiffAttorneyState,
		CC2.Zip PlaintiffAttorneyZip,
		CC2.Phone PlaintiffAttorneyPhone,
		CC2.PhoneExtension PlaintiffAttorneyPhoneExt,
		CC2.Fax PlaintiffAttorneyFax,
		CC2.Email PlaintiffAttorneyEmail
		FROM tblCase
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr 
		LEFT JOIN tblCCAddress CC1 on tblCase.DefenseAttorneyCode = CC1.CCCode
		LEFT JOIN tblCCAddress CC2 on tblCase.PlaintiffAttorneyCode = CC2.CCCode
		WHERE tblCase.CaseNbr = @CaseNbr

	SET @Err = @@Error

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_GetReferralSearchProgressive]...';


GO
ALTER PROCEDURE [proc_GetReferralSearchProgressive]

@CompanyCode int

AS

SET NOCOUNT OFF
DECLARE @Err int

	SELECT DISTINCT
		tblWebQueues.statuscode,
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.ClaimNbrExt,
		tblCase.ClientCode,
		tblCase.DoctorName AS provider,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		(SELECT COUNT(*) FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1) AS ApptCount,
		tblCase.chartnbr,
		tblCase.doctorspecialty as Specialty,
		tblServices.shortdesc AS service,
		tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
		tblExaminee.lastname,
		tblExaminee.firstname,
		tblWebQueues.description AS WebStatus,
		tblQueues.WebStatusCode,
		tblWebQueues.statuscode,
		tblCase.claimnbr,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblclient on tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
			AND tblPublishOnWeb.UserType = 'CL'

	WHERE tblCase.ClientCode IN (SELECT ClientCode FROM tblClient WHERE tblClient.CompanyCode = @CompanyCode)

SET @Err = @@Error
RETURN @Err
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_IMECase_Insert]...';


GO
ALTER PROCEDURE [proc_IMECase_Insert]
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
	@dateofinjury2 datetime = NULL,
	@dateofinjury3 datetime = NULL,
	@dateofinjury4 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@AttorneyNote text = NULL,
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
	@BillingNote text = NULL,
	@AllowMigratingClaim bit = NULL,
	@InsuringCompany varchar(100) = NULL,
	@AwaitingScheduling datetime = NULL,
	@DateAcknowledged datetime = NULL,
	@VenueID int = NULL,
	@MasterCaseNbr int = NULL,
	@MasterSubCase varchar(1) = NULL
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
		[dateofinjury2],
		[dateofinjury3],
		[dateofinjury4],
		[calledinby],
		[notes],
		[AttorneyNote],
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
		[BillingNote],
		[AllowMigratingClaim],
		[InsuringCompany],
		[AwaitingScheduling],
		[DateAcknowledged],
		[VenueID],
		[MasterCaseNbr],
		[MasterSubCase]
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
		@dateofinjury2,
		@dateofinjury3,
		@dateofinjury4,
		@calledinby,
		@notes,
		@AttorneyNote,
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
		@BillingNote,
		@AllowMigratingClaim,
		@InsuringCompany,
		@AwaitingScheduling,
		@DateAcknowledged,
		@VenueID,
		@MasterCaseNbr,
		@MasterSubCase
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_IMECase_Update]...';


GO
ALTER PROCEDURE [proc_IMECase_Update]
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
	@dateofinjury2 datetime = NULL,
	@dateofinjury3 datetime = NULL,
	@dateofinjury4 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@AttorneyNote text = NULL,
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
	@BillingNote text = NULL,
	@InsuringCompany varchar(100) = NULL,
	@AwaitingScheduling datetime,
	@DateAcknowledged datetime = NULL,
	@VenueID int = NULL,
	@MasterCaseNbr int = NULL,
	@MasterSubCase varchar(1) = NULL
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
		[dateofinjury2] = @dateofinjury2,
		[dateofinjury3] = @dateofinjury3,
		[dateofinjury4] = @dateofinjury4,
		[calledinby] = @calledinby,
		[notes] = @notes,
		[AttorneyNote] = @AttorneyNote,
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
		[BillingNote] = @BillingNote,
		[InsuringCompany] = @InsuringCompany,
		[AwaitingScheduling] = @AwaitingScheduling,
		[DateAcknowledged] = @DateAcknowledged,
		[VenueID] = @VenueID,
		[MasterCaseNbr] = @MasterCaseNbr,
		[MasterSubCase] = @MasterSubCase
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[proc_Client_LoadByParentCompany]...';


GO
CREATE PROCEDURE [proc_Client_LoadByParentCompany]
(
	@ParentCompanyId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ClientCode, LastName + ', ' + FirstName Name

	FROM tblClient
		WHERE CompanyCode in (SELECT CompanyCode FROM tblCompany WHERE ParentCompanyID = @ParentCompanyId)
		AND Status = 'Active' ORDER BY LastName

	SET @Err = @@Error

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[proc_ExamineeAddress_Insert]...';


GO
CREATE PROCEDURE [proc_ExamineeAddress_Insert]
(
	@ExamineeAddressID int = NULL output,
	@chartnbr int,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@County varchar(50) = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblExamineeAddresses]
	(
		[chartnbr],
		[addr1],
		[addr2],
		[city],
		[state],
		[zip],
		[County],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited]
	)
	VALUES
	(
		@chartnbr,
		@addr1,
		@addr2,
		@city,
		@state,
		@zip,
		@County,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited
	)

	SET @Err = @@Error

	SELECT @ExamineeAddressID = SCOPE_IDENTITY()

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[proc_GetExamineeAddressesByChartNbr]...';


GO
CREATE PROCEDURE [proc_GetExamineeAddressesByChartNbr]
(
	@chartnbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT Addr1, Addr2, City, State, Zip, County

	FROM [tblExaminee]
	WHERE
		([chartnbr] = @chartnbr)

	UNION

	SELECT Addr1, Addr2, City, State, Zip, County

	FROM [tblExamineeAddresses]
	WHERE
		([chartnbr] = @chartnbr)

	SET @Err = @@Error

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[proc_GetProgressiveClients]...';


GO
CREATE PROCEDURE [proc_GetProgressiveClients]

@CompanyCode int

AS

SELECT DISTINCT lastname + ', ' + firstname + ' ' + tblCompany.intname name, clientcode FROM tblclient
	INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
	INNER JOIN tblWebUser ON tblClient.ClientCode = tblWebUser.IMECentricCode and tblWebUser.UserType = 'CL'
	WHERE tblClient.CompanyCode = @CompanyCode
		AND tblClient.Status = 'Active'
	ORDER BY name
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[proc_ProblemArea_LoadByProblemCode]...';


GO
CREATE PROCEDURE [proc_ProblemArea_LoadByProblemCode]
(
	@ProblemCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblProblemArea.ProblemAreaCode, tblProblemArea.Description FROM tblProblem 
	INNER JOIN tblProblemDetail on tblProblem.ProblemCode = tblProblemDetail.ProblemCode
	INNER JOIN tblProblemArea on tblProblemDetail.ProblemAreaCode = tblProblemArea.ProblemAreaCode
	WHERE tblProblem.PublishOnWeb = 1
	AND tblProblem.Status = 'Active'
	AND tblProblem.ProblemCode = @ProblemCode

	SET @Err = @@Error

	RETURN @Err
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

UPDATE tblControl SET DBVersion='3.40'
GO



IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO

