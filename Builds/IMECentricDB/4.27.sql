

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
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCode]...';


GO
DROP INDEX [IX_tblCase_OfficeCode]
    ON [dbo].[tblCase];


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
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_WCBNbrOfficeCode]...';


GO
DROP INDEX [IX_tblCase_WCBNbrOfficeCode]
    ON [dbo].[tblCase];


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
PRINT N'Dropping [dbo].[tblSpecialty].[IX_U_tblSpecialty_SpecialtyCode]...';


GO
DROP INDEX [IX_U_tblSpecialty_SpecialtyCode]
    ON [dbo].[tblSpecialty];


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
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase] ALTER COLUMN [DoctorSpecialty] VARCHAR (500) NULL;

ALTER TABLE [dbo].[tblCase] ALTER COLUMN [SReqSpecialty] VARCHAR (500) NULL;


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
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCode]
    ON [dbo].[tblCase]([OfficeCode] ASC)
    INCLUDE([ChartNbr], [DoctorLocation], [ClientCode], [SchedulerCode], [Status], [CaseType], [ApptDate], [ClaimNbr], [PlaintiffAttorneyCode], [DefenseAttorneyCode], [ServiceCode], [DoctorCode], [DoctorSpecialty], [RecCode], [DoctorName], [CertMailNbr], [Jurisdiction], [TransCode], [DefParaLegal], [VenueID], [LanguageID], [ApptStatusID], [CaseApptID], [CertMailNbr2], [ExtCaseNbr], [EmployerID], [EmployerAddressID]);


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
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_WCBNbrOfficeCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_WCBNbrOfficeCode]
    ON [dbo].[tblCase]([WCBNbr] ASC, [OfficeCode] ASC)
    INCLUDE([ChartNbr], [DoctorLocation], [ClientCode], [SchedulerCode], [Status], [CaseType], [ApptDate], [ClaimNbr], [PlaintiffAttorneyCode], [DefenseAttorneyCode], [ServiceCode], [DoctorCode], [DoctorSpecialty], [RecCode], [DoctorName], [Jurisdiction], [TransCode], [DefParaLegal], [VenueID], [LanguageID], [ApptStatusID], [CaseApptID], [ExtCaseNbr], [EmployerID], [EmployerAddressID]);


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
PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt] ALTER COLUMN [SpecialtyCode] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblCaseApptPanel]...';


GO
ALTER TABLE [dbo].[tblCaseApptPanel] ALTER COLUMN [SpecialtyCode] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblCasePanel]...';


GO
ALTER TABLE [dbo].[tblCasePanel] ALTER COLUMN [SpecialtyCode] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblCasePeerBill]...';


GO
ALTER TABLE [dbo].[tblCasePeerBill] ALTER COLUMN [ProviderSpecialtyCode] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblCaseSpecialty]...';


GO
ALTER TABLE [dbo].[tblCaseSpecialty] ALTER COLUMN [SpecialtyCode] VARCHAR (500) NOT NULL;


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
PRINT N'Altering [dbo].[tblDoctorDocuments]...';


GO
ALTER TABLE [dbo].[tblDoctorDocuments] ALTER COLUMN [SpecialtyCode] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblDoctorMargin]...';


GO
ALTER TABLE [dbo].[tblDoctorMargin] ALTER COLUMN [SpecialtyCode] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblDoctorRecommend]...';


GO
ALTER TABLE [dbo].[tblDoctorRecommend] ALTER COLUMN [Specialty] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblDoctorSearchResult]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult] ALTER COLUMN [SpecialtyCodes] VARCHAR (3000) NULL;


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
PRINT N'Starting rebuilding table [dbo].[tblDoctorSpecialty]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblDoctorSpecialty] (
    [SpecialtyCode]             VARCHAR (500) NOT NULL,
    [DateAdded]                 DATETIME      NULL,
    [UserIDAdded]               VARCHAR (50)  NULL,
    [DateEdited]                DATETIME      NULL,
    [UserIDEdited]              VARCHAR (50)  NULL,
    [DoctorCode]                INT           NOT NULL,
    [MasterReviewerSpecialtyID] INT           NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblDoctorSpecialty1] PRIMARY KEY CLUSTERED ([SpecialtyCode] ASC, [DoctorCode] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblDoctorSpecialty])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_tblDoctorSpecialty] ([SpecialtyCode], [DoctorCode], [DateAdded], [UserIDAdded], [DateEdited], [UserIDEdited], [MasterReviewerSpecialtyID])
        SELECT   [SpecialtyCode],
                 [DoctorCode],
                 [DateAdded],
                 [UserIDAdded],
                 [DateEdited],
                 [UserIDEdited],
                 [MasterReviewerSpecialtyID]
        FROM     [dbo].[tblDoctorSpecialty]
        ORDER BY [SpecialtyCode] ASC, [DoctorCode] ASC;
    END

DROP TABLE [dbo].[tblDoctorSpecialty];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblDoctorSpecialty]', N'tblDoctorSpecialty';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblDoctorSpecialty1]', N'PK_tblDoctorSpecialty', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


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
PRINT N'Creating [dbo].[tblDoctorSpecialty].[IX_tblDoctorSpecialty_DoctorCodeSpecialtyCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSpecialty_DoctorCodeSpecialtyCode]
    ON [dbo].[tblDoctorSpecialty]([DoctorCode] ASC, [SpecialtyCode] ASC);


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
PRINT N'Altering [dbo].[tblExternalCommunications]...';


GO
ALTER TABLE [dbo].[tblExternalCommunications] ALTER COLUMN [DoctorSpecialty] VARCHAR (500) NULL;


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
PRINT N'Altering [dbo].[tblSpecialty]...';


GO
ALTER TABLE [dbo].[tblSpecialty] ALTER COLUMN [Description] VARCHAR (500) NULL;

ALTER TABLE [dbo].[tblSpecialty] ALTER COLUMN [PrimarySpecialty] VARCHAR (500) NULL;

ALTER TABLE [dbo].[tblSpecialty] ALTER COLUMN [SpecialtyCode] VARCHAR (500) NOT NULL;

ALTER TABLE [dbo].[tblSpecialty] ALTER COLUMN [SubSpecialty] VARCHAR (500) NULL;


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
PRINT N'Creating [dbo].[tblSpecialty].[IX_U_tblSpecialty_SpecialtyCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblSpecialty_SpecialtyCode]
    ON [dbo].[tblSpecialty]([SpecialtyCode] ASC);


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
PRINT N'Altering [dbo].[tblWebReferral]...';


GO
ALTER TABLE [dbo].[tblWebReferral] ALTER COLUMN [Specialty] VARCHAR (3000) NULL;


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
PRINT N'Altering [dbo].[proc_IMECase_CheckForDupe]...';


GO
ALTER PROCEDURE [proc_IMECase_CheckForDupe]
(
	@CaseType int,
	@ServiceCode int,
	@Jurisdiction varchar(5),
	@ClaimNbr varchar(50),
	@DateOfInjury datetime,
	@CheckDate datetime,
	@FirstName varchar(50),
	@LastName varchar(50),
	@ClientCode int,
	@SReqSpecialty varchar(500)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 CaseNbr
	FROM tblCase
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
			WHERE caseType = @CaseType
			AND ServiceCode =  @ServiceCode
			AND Jurisdiction = @Jurisdiction
			AND ClaimNbr = @ClaimNbr
			AND tblCase.SReqSpecialty = @SReqSpecialty
			AND DateOfInjury = @DateofInjury
			AND tblCase.ClientCode = @ClientCode
			AND tblCase.DateAdded >= @CheckDate
			AND tblExaminee.FirstName = @Firstname
			AND tblExaminee.LastName = @Lastname

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
	@WCBNbr varchar(110) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(500) = NULL,
	@doctorspecialty varchar(500) = NULL,
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
	@WCBNbr varchar(110) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(500) = NULL,
	@doctorspecialty varchar(500) = NULL,
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
PRINT N'Altering [dbo].[proc_Info_Medaca_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt_PatchData]
	@startDate Date,
	@endDate Date	
AS

UPDATE T 
	set T.[EHQ-Rcvd] = [dbo].[fnGetParamValue](CD.Param, 'EHQReceived=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[EHQ-Sent] = [dbo].[fnGetParamValue](CD.Param, 'EHQSent=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARecommend] = [dbo].[fnGetParamValue](CD.Param, 'TMHARecommend=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARequestSent] = [dbo].[fnGetParamValue](CD.Param, 'TMHARequestSent=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[GPContactDate] = [dbo].[fnGetParamValue](CD.Param, 'GPContactDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[RTWDate] = [dbo].[fnGetParamValue](CD.Param, 'RTWDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[Diagnosis] = (SELECT  STUFF((SELECT  ',' + icd.description from tblcase c with (nolock)
										left join tblICDCode icd with (nolock) on icd.Code in (icdcodea, icdcodeb, icdcodec,icdcoded,ICDCodeE,icdcodeF,icdcodeg,ICDCodeH,ICDCodeI, icdcodej,icdcodek,icdcodel)
										where c.casenbr = t.casenbr
										FOR XML PATH('')), 1, 1, ''))
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[RTWExplained] = [dbo].[fnGetParamValue](CD.Param, 'Comments=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHARescheduled] = (select count(ca.caseapptid) from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr)
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[TMHACancelled] = (select count(ca.caseapptid) from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr and ca.apptstatusid in (50,51)) --Cancelled or Late Cancelled
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

	
UPDATE T 
	set T.[TMHARescheduledDate] = (select top 1 ca.dateadded from tblcaseappt ca with (nolock) where ca.casenbr = t.casenbr  order by ca.dateadded desc)
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[Claims Received Date] = [dbo].[fnGetParamValue](CD.Param, 'ClaimReceivedDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'

UPDATE T 
	set T.[GP Comm Fax Received] = [dbo].[fnGetParamValue](CD.Param, 'FaxReceivedDate=')
	FROM ##Temp_MedacaCases as T
	INNER JOIN tblCustomerData as CD on T.casenbr = CD.TableKey AND CD.TableType = 'tblCase' and CustomerName = 'Medaca'
Select
	Casenbr,
	[Service File Type],
	[Referral Date],
	CM,
	Surname,
	[First Name],
	Client,
	[Client Location],
	[Group Number],
	[Claim Number],
	isnull([Group or Employer],'') as [Group or Employer],
	[Case Manager 1],
	[Disability Date],
	isnull(convert(varchar,[Claims Received Date],101),'') as [Claims Received Date],
	isnull([EHQ-Rcvd],'') as [EHQ-Rcvd],
	isnull([EHQ-Sent],'') as [EHQ-Sent],
	isnull([TMHARecommend],'') as [TMHARecommend],
	isnull([TMHARequestSent],'') as [TMHARequestSent],	
	isnull(convert(varchar, [TMHAService],101),'') as [TMHAService],
	case when [TMHARescheduled] > 1 then 'Yes' else 'No' end as [TMHARescheduled],
	Case when [TMHACancelled] > 1 then 'Yes' else 'No' end as [TMHACancelled],
	case when [TMHARescheduled] > 1 then isnull(convert(varchar,[TMHARescheduledDate],101),'') else '' end  as [TMHARescheduledDate],
	isnull(convert(varchar,[Final Sent],101),'') as 'Final Sent',
	isnull(Diagnosis,'') as Diagnosis,
	isnull([GP Contact],'') as [GP Contact],
	isnull([GPContactDate],'') as [GPContactDate],
	isnull(Psychiatrist,'') as Psychiatrist,
	isnull(convert(varchar,[GP Comm Fax Received],101),'') as [GP Comm Fax Received],
	isnull([RTWDate],'') as RTWDate,
	isnull(RTWExplained,'') as RTWExplained,
	convert(varchar,ServiceFileModified,101) as ServiceFileModified
from ##Temp_MedacaCases
order by [Referral Date]

IF OBJECT_ID('tempdb..##Temp_MedacaCases') IS NOT NULL DROP TABLE ##Temp_MedacaCases
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
PRINT N'Altering [dbo].[proc_Info_Medaca_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@dateFilter INT
AS
SET NOCOUNT ON
IF OBJECT_ID('tempdb..##Temp_MedacaCases') IS NOT NULL DROP TABLE ##Temp_MedacaCases

SELECT
	c.casenbr,
	s.description as 'Service File Type',
	convert(varchar, c.dateadded, 101) as 'Referral Date',
	sh.lastname + ', ' + sh.firstname as 'CM',
	e.lastname as Surname,
	e.firstname as 'First Name',
	co.ExtName as 'Client',
	co.city as 'Client Location',
	c.AddlClaimNbrs as 'Group Number',
	c.claimnbr as 'Claim Number',
	emp.Name as 'Group or Employer',
	cl.firstname + ' ' + cl.LastName as 'Case Manager 1',
	isnull(convert(varchar,c.dateofinjury,101),'') as 'Disability Date',
	convert(varchar, null) as 'EHQ-Rcvd',
	convert(varchar, null) as 'EHQ-Sent',
	convert(varchar, null) as 'Claims Received Date',
	convert(varchar, null) as 'TMHARecommend',
	convert(varchar, null) as 'TMHARequestSent',
	c.ApptDate as 'TMHAService',
	convert(int, null) as 'TMHARescheduled' ,
	convert(bit, null) as 'TMHACancelled' ,
	convert(datetime, null) as 'TMHARescheduledDate' ,
	c.RptSentDate as 'Final Sent',
	convert(varchar(1000), null) as Diagnosis,
	e.treatingphysician as 'GP Contact',
	convert(varchar, null) as 'GPContactDate',
	c.doctorname as 'Psychiatrist',
	convert(datetime, null) as 'GP Comm Fax Received' ,
	convert(varchar, null) as 'RTWDate',
	convert(varchar(2000), null) as 'RTWExplained',
	c.dateedited as 'ServiceFileModified'
into ##Temp_MedacaCases
from tblcase c with (nolock) 
	inner join tbloffice o with (nolock) on c.officecode = o.officecode
	inner join tblexaminee e with (nolock) on e.chartnbr = c.chartnbr
	inner join tblclient cl with (nolock) on cl.clientcode = c.clientcode
	inner join tblcompany co with (nolock) on co.companycode = cl.companycode
	inner join tblservices s with (nolock) on s.ServiceCode = c.ServiceCode
	left join tblemployer emp with (nolock) on emp.EmployerID = c.EmployerID
	left join tbluser sh with (nolock) on sh.userid = c.schedulercode
where 	
	CONVERT(DATE, IIF(@dateFilter = 2, c.dateedited, c.DateReceived)) >= @startDate
		and CONVERT(DATE, IIF(@dateFilter = 2, c.dateedited, c.DateReceived)) <= @endDate

SET NOCOUNT OFF
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
PRINT N'Altering [dbo].[proc_CaseAppt_Insert]...';


GO
ALTER PROCEDURE [proc_CaseAppt_Insert]
(
	@CaseApptId int = NULL output,
	@CaseNbr int,
	@ApptTime datetime,
	@DoctorCode int = NULL,
	@LocationCode int = NULL,
	@SpecialtyCode varchar(500) = NULL,
	@ApptStatusId int,
	@DateAdded datetime = NULL,
	@DateReceived datetime = NULL,
	@UserIdAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIdEdited varchar(15) = NULL,
	@CanceledById int = NULL,
	@Reason varchar(300) = NULL,
	@LastStatusChg datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseAppt]
	(
		[CaseNbr],
		[ApptTime],
		[DoctorCode],
		[LocationCode],
		[SpecialtyCode],
		[ApptStatusId],
		[DateAdded],
		[DateReceived],
		[UserIdAdded],
		[DateEdited],
		[UserIdEdited],
		[CanceledById],
		[Reason],
		[LastStatusChg]
	)
	VALUES
	(
		@CaseNbr,
		@ApptTime,
		@DoctorCode,
		@LocationCode,
		@SpecialtyCode,
		@ApptStatusId,
		@DateAdded,
		@DateReceived,
		@UserIdAdded,
		@DateEdited,
		@UserIdEdited,
		@CanceledById,
		@Reason,
		@LastStatusChg
	)

	SET @Err = @@Error

	SELECT @CaseApptId = SCOPE_IDENTITY()

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
PRINT N'Altering [dbo].[proc_CasePeerBill_Insert]...';


GO
ALTER PROCEDURE [proc_CasePeerBill_Insert]
(
	@PeerBillId int = NULL output,
	@CaseNbr int,
	@DateBillReceived datetime = NULL,
	@ServiceDate datetime = NULL,
	@BillNumber varchar(50) = NULL,
	@BillAmount money = NULL,
	@ReferringProviderName varchar(50) = NULL,
	@ReferringProviderTIN varchar(11) = NULL,
	@ProviderName varchar(50) = NULL,
	@ProviderTIN varchar(11) = NULL,
	@ProviderSpecialtyCode varchar(500) = NULL,
	@ServiceRendered varchar(250) = NULL,
	@CPTCode varchar(50) = NULL,
	@BillAmountApproved money = NULL,
	@BillAmountDenied money = NULL,
	@DateAdded datetime = NULL,
	@UserIDAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(15) = NULL,
	@ProviderZip varchar(10) = NULL,
	@ServiceEndDate datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCasePeerBill]
 (
	[CaseNbr],
	[DateBillReceived],
	[ServiceDate],
	[BillNumber],
	[BillAmount],
	[ReferringProviderName],
	[ReferringProviderTIN],
	[ProviderName],
	[ProviderTIN],
	[ProviderSpecialtyCode],
	[ServiceRendered],
	[CPTCode],
	[BillAmountApproved],
	[BillAmountDenied],
	[DateAdded],
	[UserIDAdded],
	[DateEdited],
	[UserIDEdited],
	[ProviderZip],
	[ServiceEndDate]
 )
 VALUES
 (
	@CaseNbr,
	@DateBillReceived,
	@ServiceDate,
	@BillNumber,
	@BillAmount,
	@ReferringProviderName,
	@ReferringProviderTIN,
	@ProviderName,
	@ProviderTIN,
	@ProviderSpecialtyCode,
	@ServiceRendered,
	@CPTCode,
	@BillAmountApproved,
	@BillAmountDenied,
	@DateAdded,
	@UserIDAdded,
	@DateEdited,
	@UserIDEdited,
	@ProviderZip,
	@ServiceEndDate
 )

 SET @Err = @@Error

 SELECT @PeerBillId = SCOPE_IDENTITY()

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
PRINT N'Altering [dbo].[proc_CaseSpecialty_Insert]...';


GO

ALTER PROCEDURE [dbo].[proc_CaseSpecialty_Insert]
(
	@casenbr int,
	@Specialtycode varchar(500),
	@dateadded datetime = NULL,
	@useridadded varchar(30) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseSpecialty]
	(
		[casenbr],
		[Specialtycode],
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@casenbr,
		@Specialtycode,
		@dateadded,
		@useridadded
	)

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
PRINT N'Altering [dbo].[spDoctorSearch]...';


GO
ALTER PROCEDURE [dbo].[spDoctorSearch]
(
	@SessionID AS VARCHAR(50) = NULL,

    @StartDate AS DATETIME,
    @PanelExam AS BIT = NULL,

    @DoctorCode AS INT = NULL,
    @ProvTypeCode AS INT = NULL,
	@IncludeInactiveDoctor AS BIT = NULL,
    @Degree AS VARCHAR(50) = NULL,
    @RequirePracticingDoctors AS BIT = NULL,
    @RequireLicencedInExamState AS BIT = NULL,
    @RequireBoardCertified AS BIT = NULL,

    @LocationCode AS INT = NULL,
    @City AS VARCHAR(50) = NULL,
    @State AS VARCHAR(2) = NULL,
    @Vicinity AS VARCHAR(50) = NULL,
    @County AS VARCHAR(50) = NULL,

	@Proximity AS INT = NULL,
	@ProximityZip AS VARCHAR(10) = NULL,

    @KeyWordIDs AS VARCHAR(100) = NULL,
    @Specialties AS VARCHAR(3000) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL,
	
	@FirstName AS VARCHAR(50) = NULL,
	@LastName AS VARCHAR(50) = NULL,
	@UserID AS VARCHAR(15) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(200)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT
	DECLARE @AvgMargin AS DECIMAL(8, 2)
	DECLARE @MaxCaseCount AS DECIMAL(8, 2)

	--Defalt Values
	SET @tmpSessionID = ISNULL(@SessionID, NEWID())

	IF @ParentCompanyID IS NOT NULL
	BEGIN
		IF @RequirePracticingDoctors IS NULL
			(SELECT @RequirePracticingDoctors = RequirePracticingDoctor FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
		IF @RequireBoardCertified IS NULL
			(SELECT @RequireBoardCertified = RequireCertification FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
	END

	--Format delimited list
	SET @lstSpecialties = ';;' + @Specialties
	SET @lstKeywordIDs = ';;' + REPLACE(@KeyWordIDs, ' ', '')
	
	
	--Calculate parameter geography data
	IF (@ProximityZip IS NOT NULL)
	BEGIN
		SET @geoEE = geography::STGeomFromText((SELECT TOP 1 'POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')' FROM tblZipCode AS Z WHERE Z.sZip=@ProximityZip ORDER BY Z.kIndex) ,4326)
		IF (SELECT TOP 1 DistanceUofM FROM tblIMEData)='Miles'
			SET @distanceConv = 1609.344
		ELSE
			SET @distanceConv = 1000
	END

	--Clear data from last search
	DELETE FROM tblDoctorSearchResult WHERE SessionID=@tmpSessionID


	--Set Differrent SQL String for Panel Search
	IF ISNULL(@PanelExam,0) = 1
	BEGIN
		SET @strDrSchCol = ' DS.SchedCode,'
		SET @strDrSchFrom = ' INNER JOIN tblDoctorSchedule AS DS ON DS.DoctorCode = DL.DoctorCode AND DS.LocationCode = DL.LocationCode AND DS.Status=''Open'' AND DS.StartTime>=@_StartDate '
	END
	ELSE

		SET @strDrSchCol = '(SELECT TOP 1 SchedCode FROM tblDoctorSchedule AS DS WHERE DS.DoctorCode=DL.DoctorCode AND DS.LocationCode=DL.LocationCode AND DS.date >= dbo.fnDateValue(@_StartDate) AND DS.Status = ''Open'' ORDER BY DS.date) AS SchedCode,'

--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
    Proximity
)
SELECT
	@_tmpSessionID AS SessionID,
	DR.DoctorCode,
    L.LocationCode,
	' + @strDrSchCol + '
	ISNULL(L.GeoData.STDistance(@_geoEE)/@_distanceConv,9999) AS Proximity

FROM 
    tblDoctor AS DR
    INNER JOIN tblDoctorLocation AS DL
        ON DL.DoctorCode = DR.DoctorCode
	INNER JOIN tblLocation AS L
        ON L.LocationCode = DL.LocationCode
' + @strDrSchFrom


--Set WHERE clause string
	SET @strWhere ='WHERE DR.OPType = ''DR'''

	IF ISNULL(@IncludeInactiveDoctor,0)=0
		SET @strWhere = @strWhere + ' AND (DR.Status = ''Active'' AND DL.Status = ''Active'')'
	IF @OfficeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorOffice WHERE OfficeCode=@_OfficeCode)'

	IF @DoctorCode IS NOT NULL
		 SET @strWhere = @strWhere + ' AND @_DoctorCode = DR.DoctorCode'
	IF @ProvTypeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_ProvTypeCode = DR.ProvTypeCode'
	IF ISNULL(@Degree,'')<>''
		SET @strWhere = @strWhere + ' AND @_Degree = DR.Credentials'

	IF ISNULL(@FirstName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.FirstName LIKE @_FirstName'
	IF ISNULL(@LastName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.LastName LIKE @_LastName'

	IF ISNULL(@RequirePracticingDoctors,0)=1
		SET @strWhere = @strWhere + ' AND DR.PracticingDoctor = 1'
	IF ISNULL(@RequireLicencedInExamState,0)=1
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 11 AND State = @_State)'
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2 AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'
	IF @Specialties IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorSpecialty WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID)'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode)'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode)'

	IF @LocationCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_LocationCode = L.LocationCode'
	IF ISNULL(@City,'')<>''
		SET @strWhere = @strWhere + ' AND @_City = L.City'
	IF ISNULL(@State,'')<>''
		SET @strWhere = @strWhere + ' AND @_State = L.State'
	IF ISNULL(@County,'')<>''
		SET @strWhere = @strWhere + ' AND @_County = L.County'
	IF ISNULL(@Vicinity,'')<>''
		SET @strWhere = @strWhere + ' AND @_Vicinity = L.Vicinity'

	IF @Proximity IS NOT NULL
		SET @strWhere = @strWhere + ' AND L.GeoData.STDistance(@_geoEE)/@_distanceConv<=@_Proximity'

	SET @strSQL = @strSQL + @strWhere
	PRINT @strSQL
	EXEC sp_executesql @strSQL,
		  N'@_tmpSessionID VARCHAR(50),
			@_geoEE GEOGRAPHY,
			@_distanceConv FLOAT,
			@_StartDate DATETIME ,
			@_DoctorCode INT ,
			@_LocationCode INT ,
			@_City VARCHAR(50) ,
			@_State VARCHAR(2) ,
			@_Vicinity VARCHAR(50) ,
			@_County VARCHAR(50) ,
			@_Degree VARCHAR(50) ,
			@_lstKeyWordIDs VARCHAR(100) ,
			@_lstSpecialties VARCHAR(200) ,
			@_PanelExam BIT ,
			@_ProvTypeCode INT ,		
			@_EWAccreditationID INT,	
			@_IncludeInactiveDoctor BIT,	
			@_RequirePracticingDoctors BIT,
			@_RequireLicencedInExamState BIT,
			@_RequireBoardCertified BIT,	
			@_OfficeCode INT,			
			@_ParentCompanyID INT,	
			@_CompanyCode INT,		
			@_ClientCode INT,			
			@_Proximity INT,
			@_FirstName VARCHAR(50),
			@_LastName VARCHAR(50)
			',
			@_tmpSessionID = @tmpSessionID,
			@_geoEE = @geoEE,
			@_distanceConv = @distanceConv,
			@_StartDate = @StartDate,
			@_DoctorCode = @DoctorCode,
			@_LocationCode = @LocationCode,
			@_City = @City,
			@_State = @State,
			@_Vicinity = @Vicinity,
			@_County = @County,
			@_Degree = @Degree,
			@_lstKeyWordIDs = @lstKeywordIDs ,
			@_lstSpecialties = @lstSpecialties,
			@_PanelExam = @PanelExam,
			@_ProvTypeCode = @ProvTypeCode,		
			@_EWAccreditationID = @EWAccreditationID,	
			@_IncludeInactiveDoctor = @IncludeInactiveDoctor,
			@_RequirePracticingDoctors = @RequirePracticingDoctors,
			@_RequireLicencedInExamState = @RequireLicencedInExamState,
			@_RequireBoardCertified = @RequireBoardCertified,
			@_OfficeCode = @OfficeCode,
			@_ParentCompanyID = @ParentCompanyID,
			@_CompanyCode = @CompanyCode,
			@_ClientCode = @ClientCode,
			@_Proximity = @Proximity,
			@_FirstName = @FirstName,
			@_LastName = @LastName
	SET @returnValue = @@ROWCOUNT

	--Remove results for access restrictions
	IF (SELECT RestrictToFavorites FROM tblUser WHERE UserID = ISNULL(@UserID,'')) = 1
        DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND LocationCode NOT IN 
            (SELECT DISTINCT L.LocationCode
                FROM tblUser AS U
                INNER JOIN tblUserOffice AS UO ON UO.UserID = U.UserID
                INNER JOIN tblOfficeState AS OS ON OS.OfficeCode = UO.OfficeCode
                INNER JOIN tblLocation AS L ON L.State = OS.State
                WHERE U.UserID = ISNULL(@UserID,''))


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,2,'')),'')
		 FROM tblDoctorSearchResult AS DSR
		 WHERE DSR.SessionID=@tmpSessionID
		SET QUOTED_IDENTIFIER ON
	END

	--Get Doctor Margin
	UPDATE DSR SET DSR.CaseCount=stats.CaseCount, DSR.AvgMargin=stats.AvgMargin
	 FROM tblDoctorSearchResult AS DSR
	 INNER JOIN
		(
		 SELECT DM.DoctorCode, AVG(DM.Margin) AS AvgMargin, SUM(DM.CaseCount) AS CaseCount
		 FROM tblDoctorMargin AS DM
		 WHERE (@ParentCompanyID IS NULL OR DM.ParentCompanyID=@ParentCompanyID)
		  AND (@EWBusLineID IS NULL OR DM.EWBusLineID=@EWBusLineID)
		  AND (@EWServiceTypeID IS NULL OR DM.EWServiceTypeID=@EWServiceTypeID)
		  AND (@Specialties IS NULL OR PATINDEX('%;;' + DM.SpecialtyCode + ';;%', @lstSpecialties)>0)
		 GROUP BY DM.DoctorCode
		) AS stats ON stats.DoctorCode = DSR.DoctorCode
	 WHERE DSR.SessionID=@tmpSessionID

	 -- Calculate DisplayScore
	SELECT 
		@AvgMargin = MAX(AvgMargin), 
		@MaxCaseCount = CAST(MAX(CaseCount) AS DECIMAL(8, 2)) 
	FROM tblDoctorSearchResult 
	WHERE SessionID = @tmpSessionID
	GROUP BY SessionID

	UPDATE DSR SET DSR.DisplayScore =
	   IIF(L.InsideDr=1, W.BlockTime, 0) +
	   IIF(@AvgMargin=0, 0, DSR.AvgMargin/@AvgMargin * W.AverageMargin) +
	   IIF(@MaxCaseCount=0, 0, DSR.CaseCount/@MaxCaseCount * W.CaseCount) +
	   (6-ISNULL(DR.SchedulePriority,5))/5.0 * W.SchedulePriority +
	   IIF(DR.ReceiveMedRecsElectronically=1, W.ReceiveMedRecsElectronically, 0)
	FROM tblDoctorSearchResult AS DSR
		INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
		INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
		INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
		WHERE DSR.SessionID = @tmpSessionID

	 -- Calculate DoctorRank 
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DoctorRank1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DisplayScore DESC, DoctorCode) AS DoctorRank1
		                 FROM tblDoctorSearchResult
					  WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey
		WHERE DSR.SessionID=@tmpSessionID


	-- Recalculate doctor ranking so that the same doctor has the same ranking
     UPDATE DSR 
           SET DSR.DoctorRank = T1.DoctorRankMin
           FROM tblDoctorSearchResult AS DSR
                     INNER JOIN (SELECT PrimaryKey, DoctorCode, MIN(DoctorRank)OVER(PARTITION BY DoctorCode) AS DoctorRankMin 
                                    FROM tblDoctorSearchResult
                                    WHERE SessionID = @tmpSessionID) AS T1 ON t1.PrimaryKey = DSR.PrimaryKey
           WHERE DSR.SessionID = @tmpSessionID


	-- The ranking created above has gaps in numbering - take gaps out.
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DRk1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DoctorRank) AS DRk1 FROM tblDoctorSearchResult
		WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey


	--If SessionID is given, return the number of rows instead of the actual data
	IF @SessionID IS NOT NULL
		RETURN @returnValue
	ELSE
		SELECT * FROM tblDoctorSearchResult WHERE SessionID=@SessionID
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
PRINT N'Altering [dbo].[spDoctorSearchNew]...';


GO
ALTER PROCEDURE [dbo].[spDoctorSearchNew]
(
	@SessionID AS VARCHAR(50) = NULL,

    @StartDate AS DATETIME,
    @PanelExam AS BIT = NULL,

    @DoctorCode AS INT = NULL,
    @ProvTypeCode AS INT = NULL,
	@IncludeInactiveDoctor AS BIT = NULL,
    @Degree AS VARCHAR(50) = NULL,
    @RequirePracticingDoctors AS BIT = NULL,
    @RequireLicencedInExamState AS BIT = NULL,
    @RequireBoardCertified AS BIT = NULL,

    @LocationCode AS INT = NULL,
    @City AS VARCHAR(50) = NULL,
    @State AS VARCHAR(2) = NULL,
    @Vicinity AS VARCHAR(50) = NULL,
    @County AS VARCHAR(50) = NULL,

	@Proximity AS INT = NULL,
	@ProximityZip AS VARCHAR(10) = NULL,

    @KeyWordIDs AS VARCHAR(100) = NULL,
    @Specialties AS VARCHAR(3000) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@ThirdPartyParentCompanyID AS INT = NULL, 
	@BillClientCompanyCode AS INT = NULL,
	@BillClientCode AS INT = NULL, 
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL,
	
	@FirstName AS VARCHAR(50) = NULL,
	@LastName AS VARCHAR(50) = NULL,
	@UserID AS VARCHAR(15) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(200)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT
	DECLARE @AvgMargin AS DECIMAL(8, 2)
	DECLARE @MaxCaseCount AS DECIMAL(8, 2)

	--Defalt Values
	SET @tmpSessionID = ISNULL(@SessionID, NEWID())

	IF @ParentCompanyID IS NOT NULL
	BEGIN
		IF @RequirePracticingDoctors IS NULL
			(SELECT @RequirePracticingDoctors = RequirePracticingDoctor FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
		IF @RequireBoardCertified IS NULL
			(SELECT @RequireBoardCertified = RequireCertification FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
	END

	--Format delimited list
	SET @lstSpecialties = ';;' + @Specialties
	SET @lstKeywordIDs = ';;' + REPLACE(@KeyWordIDs, ' ', '')


	--Calculate parameter geography data
	IF (@ProximityZip IS NOT NULL)
	BEGIN
		SET @geoEE = geography::STGeomFromText((SELECT TOP 1 'POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')' FROM tblZipCode AS Z WHERE Z.sZip=@ProximityZip ORDER BY Z.kIndex) ,4326)
		IF (SELECT TOP 1 DistanceUofM FROM tblIMEData)='Miles'
			SET @distanceConv = 1609.344
		ELSE
			SET @distanceConv = 1000
	END

	--Clear data from last search
	DELETE FROM tblDoctorSearchResult WHERE SessionID=@tmpSessionID


	--Set Differrent SQL String for Panel Search
	IF ISNULL(@PanelExam,0) = 1
		BEGIN
			SET @strDrSchCol = ' BTS.DoctorBlockTimeSlotID AS SchedCode,' +
							   ' ROW_NUMBER() OVER (PARTITION BY BTS.DoctorBlockTimeDayID, BTS.StartTime ORDER BY BTS.DoctorBlockTimeSlotID) AS DisplayScore,'
			SET @strDrSchFrom = ' INNER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTD.ScheduleDate>=@_StartDate ' +
								' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID AND BTS.DoctorBlockTimeSlotStatusID=10'
		END
	ELSE
		SET @strDrSchCol = '(SELECT TOP 1 BTS.DoctorBlockTimeSlotID AS SchedCode FROM tblDoctorBlockTimeDay AS BTD ' +
						   ' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID' +
						   ' WHERE BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTS.DoctorBlockTimeSlotStatusID=10' +
						   ' AND BTD.ScheduleDate >= dbo.fnDateValue(@_StartDate) ORDER BY BTD.ScheduleDate) AS SchedCode,' +
						   ' 1 AS DisplayScore,'


--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
	DisplayScore,
    Proximity
)
SELECT
	@_tmpSessionID AS SessionID,
	DR.DoctorCode,
    L.LocationCode,
	' + @strDrSchCol + '
	ISNULL(L.GeoData.STDistance(@_geoEE)/@_distanceConv,9999) AS Proximity

FROM 
    tblDoctor AS DR
    INNER JOIN tblDoctorLocation AS DL
        ON DL.DoctorCode = DR.DoctorCode
	INNER JOIN tblLocation AS L
        ON L.LocationCode = DL.LocationCode
' + @strDrSchFrom


--Set WHERE clause string
	SET @strWhere ='WHERE DR.OPType = ''DR'''

	IF ISNULL(@IncludeInactiveDoctor,0)=0
		SET @strWhere = @strWhere + ' AND (DR.Status = ''Active'' AND DL.Status = ''Active'')'
	IF @OfficeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorOffice WHERE OfficeCode=@_OfficeCode)'

	IF @DoctorCode IS NOT NULL
		 SET @strWhere = @strWhere + ' AND @_DoctorCode = DR.DoctorCode'
	IF @ProvTypeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_ProvTypeCode = DR.ProvTypeCode'
	IF ISNULL(@Degree,'')<>''
		SET @strWhere = @strWhere + ' AND @_Degree = DR.Credentials'

	IF ISNULL(@FirstName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.FirstName LIKE @_FirstName'
	IF ISNULL(@LastName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.LastName LIKE @_LastName'

	IF ISNULL(@RequirePracticingDoctors,0)=1
		SET @strWhere = @strWhere + ' AND DR.PracticingDoctor = 1'
	IF ISNULL(@RequireLicencedInExamState,0)=1
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 11 AND State = @_State)'
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2 AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'
	IF @Specialties IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorSpecialty WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID)'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode)'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode)'

	IF @ThirdPartyParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ThirdPartyParentCompanyID)'
	IF @BillClientCompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_BillClientCompanyCode)'
	IF @BillClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_BillClientCode)'

	IF @LocationCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_LocationCode = L.LocationCode'
	IF ISNULL(@City,'')<>''
		SET @strWhere = @strWhere + ' AND @_City = L.City'
	IF ISNULL(@State,'')<>''
		SET @strWhere = @strWhere + ' AND @_State = L.State'
	IF ISNULL(@County,'')<>''
		SET @strWhere = @strWhere + ' AND @_County = L.County'
	IF ISNULL(@Vicinity,'')<>''
		SET @strWhere = @strWhere + ' AND @_Vicinity = L.Vicinity'

	IF @Proximity IS NOT NULL
		SET @strWhere = @strWhere + ' AND L.GeoData.STDistance(@_geoEE)/@_distanceConv<=@_Proximity'

	SET @strSQL = @strSQL + @strWhere
	PRINT @strSQL
	EXEC sp_executesql @strSQL,
		  N'@_tmpSessionID VARCHAR(50),
			@_geoEE GEOGRAPHY,
			@_distanceConv FLOAT,
			@_StartDate DATETIME ,
			@_DoctorCode INT ,
			@_LocationCode INT ,
			@_City VARCHAR(50) ,
			@_State VARCHAR(2) ,
			@_Vicinity VARCHAR(50) ,
			@_County VARCHAR(50) ,
			@_Degree VARCHAR(50) ,
			@_lstKeyWordIDs VARCHAR(100) ,
			@_lstSpecialties VARCHAR(200) ,
			@_PanelExam BIT ,
			@_ProvTypeCode INT ,		
			@_EWAccreditationID INT,	
			@_IncludeInactiveDoctor BIT,	
			@_RequirePracticingDoctors BIT,
			@_RequireLicencedInExamState BIT,
			@_RequireBoardCertified BIT,	
			@_OfficeCode INT,			
			@_ParentCompanyID INT,	
			@_CompanyCode INT,		
			@_ClientCode INT,			
			@_ThirdPartyParentCompanyID INT,	
			@_BillClientCompanyCode INT,		
			@_BillClientCode INT,			
			@_Proximity INT,
			@_FirstName VARCHAR(50),
			@_LastName VARCHAR(50)
			',
			@_tmpSessionID = @tmpSessionID,
			@_geoEE = @geoEE,
			@_distanceConv = @distanceConv,
			@_StartDate = @StartDate,
			@_DoctorCode = @DoctorCode,
			@_LocationCode = @LocationCode,
			@_City = @City,
			@_State = @State,
			@_Vicinity = @Vicinity,
			@_County = @County,
			@_Degree = @Degree,
			@_lstKeyWordIDs = @lstKeywordIDs ,
			@_lstSpecialties = @lstSpecialties,
			@_PanelExam = @PanelExam,
			@_ProvTypeCode = @ProvTypeCode,		
			@_EWAccreditationID = @EWAccreditationID,	
			@_IncludeInactiveDoctor = @IncludeInactiveDoctor,
			@_RequirePracticingDoctors = @RequirePracticingDoctors,
			@_RequireLicencedInExamState = @RequireLicencedInExamState,
			@_RequireBoardCertified = @RequireBoardCertified,
			@_OfficeCode = @OfficeCode,
			@_ParentCompanyID = @ParentCompanyID,
			@_CompanyCode = @CompanyCode,
			@_ClientCode = @ClientCode,
			@_ThirdPartyParentCompanyID = @ThirdPartyParentCompanyID,
			@_BillClientCompanyCode = @BillClientCompanyCode,
			@_BillClientCode = @BillClientCode,
			@_Proximity = @Proximity,
			@_FirstName = @FirstName,
			@_LastName = @LastName
	SET @returnValue = @@ROWCOUNT
	
	--Use only the first row of the same start time (DisplayScore was set to 1 during INSERT)
	DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND ISNULL(DisplayScore,0)<>1

	--Remove results for access restrictions
	IF (SELECT RestrictToFavorites FROM tblUser WHERE UserID = ISNULL(@UserID,'')) = 1
		DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND LocationCode NOT IN 
			(SELECT DISTINCT L.LocationCode
				FROM tblUser AS U
				INNER JOIN tblUserOffice AS UO ON UO.UserID = U.UserID
				INNER JOIN tblOfficeState AS OS ON OS.OfficeCode = UO.OfficeCode
				INNER JOIN tblLocation AS L ON L.State = OS.State
				WHERE U.UserID = ISNULL(@UserID,''))


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,2,'')),'')
		 FROM tblDoctorSearchResult AS DSR
		 WHERE DSR.SessionID=@tmpSessionID
		SET QUOTED_IDENTIFIER ON
	END

	--Get Doctor Margin
	UPDATE DSR SET DSR.CaseCount=stats.CaseCount, DSR.AvgMargin=stats.AvgMargin
	 FROM tblDoctorSearchResult AS DSR
	 INNER JOIN
		(
		 SELECT DM.DoctorCode, AVG(DM.Margin) AS AvgMargin, SUM(DM.CaseCount) AS CaseCount
		 FROM tblDoctorMargin AS DM
		 WHERE (@ParentCompanyID IS NULL OR DM.ParentCompanyID=@ParentCompanyID)
		  AND (@EWBusLineID IS NULL OR DM.EWBusLineID=@EWBusLineID)
		  AND (@EWServiceTypeID IS NULL OR DM.EWServiceTypeID=@EWServiceTypeID)
		  AND (@Specialties IS NULL OR PATINDEX('%;;' + DM.SpecialtyCode + ';;%', @lstSpecialties)>0)
		 GROUP BY DM.DoctorCode
		) AS stats ON stats.DoctorCode = DSR.DoctorCode
	 WHERE DSR.SessionID=@tmpSessionID

	 -- Calculate DisplayScore
	UPDATE tblDoctorSearchResult SET DisplayScore = NULL
		WHERE SessionID = @tmpSessionID

	SELECT 
		@AvgMargin = MAX(AvgMargin), 
		@MaxCaseCount = CAST(MAX(CaseCount) AS DECIMAL(8, 2)) 
	FROM tblDoctorSearchResult 
	WHERE SessionID = @tmpSessionID
	GROUP BY SessionID

	UPDATE DSR SET DSR.DisplayScore =
	   IIF(L.InsideDr=1, W.BlockTime, 0) +
	   IIF(@AvgMargin=0, 0, DSR.AvgMargin/@AvgMargin * W.AverageMargin) +
	   IIF(@MaxCaseCount=0, 0, DSR.CaseCount/@MaxCaseCount * W.CaseCount) +
	   (6-ISNULL(DR.SchedulePriority,5))/5.0 * W.SchedulePriority +
	   IIF(DR.ReceiveMedRecsElectronically=1, W.ReceiveMedRecsElectronically, 0)
	FROM tblDoctorSearchResult AS DSR
		INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
		INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
		INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
		WHERE DSR.SessionID = @tmpSessionID

	 -- Calculate DoctorRank 
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DoctorRank1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DisplayScore DESC, DoctorCode) AS DoctorRank1
		                 FROM tblDoctorSearchResult
					  WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey
		WHERE DSR.SessionID=@tmpSessionID


	-- Recalculate doctor ranking so that the same doctor has the same ranking
     UPDATE DSR 
           SET DSR.DoctorRank = T1.DoctorRankMin
           FROM tblDoctorSearchResult AS DSR
                     INNER JOIN (SELECT PrimaryKey, DoctorCode, MIN(DoctorRank)OVER(PARTITION BY DoctorCode) AS DoctorRankMin 
                                    FROM tblDoctorSearchResult
                                    WHERE SessionID = @tmpSessionID) AS T1 ON t1.PrimaryKey = DSR.PrimaryKey
           WHERE DSR.SessionID = @tmpSessionID


	-- The ranking created above has gaps in numbering - take gaps out.
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DRk1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DoctorRank) AS DRk1 FROM tblDoctorSearchResult
		WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey


	--If SessionID is given, return the number of rows instead of the actual data
	IF @SessionID IS NOT NULL
		RETURN @returnValue
	ELSE
		SELECT * FROM tblDoctorSearchResult WHERE SessionID=@SessionID
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
PRINT N'Update complete.';


GO
-- Sprint 104

-- IMEC-13365 - only allow CV Dr Document Type to be set for Publish to Web
 UPDATE tblEWDrDocType
   SET AllowPublishOnWeb = 1
 WHERE EWDrDocTypeID = 5
GO
UPDATE tblEWDrDocType
   SET AllowPublishOnWeb = 0
 WHERE EWDrDocTypeID <> 5
GO
