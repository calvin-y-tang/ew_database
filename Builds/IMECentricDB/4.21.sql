

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
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase] ALTER COLUMN [WCBNbr] VARCHAR (110) NULL;


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
	@WCBNbr varchar(110) = NULL,
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
-- Sprint 98

-- IMEC-13207 - new biz rules for Sentry WC Peer Reviews and WC Record Reviews
-- Generate Documents
DELETE 
  FROM tblBusinessRuleCondition 
 WHERE BusinessRuleID = 109
   AND EntityType = 'PC' 
   AND EntityID = 46
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES(109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (109,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL)
GO
-- Distribute Documents
DELETE 
  FROM tblBusinessRuleCondition 
 WHERE BusinessRuleID = 110
   AND EntityType = 'PC' 
   AND EntityID = 46
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES(110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (110,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL)
GO
-- Distribute Reports
DELETE 
  FROM tblBusinessRuleCondition 
 WHERE BusinessRuleID = 111
   AND EntityType = 'PC' 
   AND EntityID = 46
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES(111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,1,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,2,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Referral Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Appointment Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Quote Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Fee Approval Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'WCClaimTechStPtEast@sentry.com','','Medical Records Request',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Cite Letter',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Appointment Delay',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Reschedule Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Attendance Confirmation',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','No Show Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','Cancellation Notice',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'ClaimsMail@sentry.com','','IME Report Cover Sheet',NULL,0,NULL),
    (111,'PC',46,2,1,GETDATE(),'Admin',GETDATE(),'Admin',NULL,3,3,NULL,1,'SentryMbrMgmt@sentry.com','','Invoice Status Inquiries',NULL,0,NULL)
GO

-- IMEC-13184 business rules for allstate client validation prior to scheduling
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (145, 'VerifyClientType', 'Appointment', 'Verify client type value of client', 1, 1101, 0, 'CaseClientType', 'Required', 'ClientTypeString', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (145, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';1;3;4;13;', 'YES', 'Adjuster, Attorney, Attorney-Defense or Paralegal', NULL, NULL, 0, NULL),
       (145, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';1;3;4;13;', 'YES', 'Adjuster, Attorney, Attorney-Defense or Paralegal', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (146, 'ClientTypeRequirements', 'Appointment', 'Client and Attorney requirements based on client type', 1, 1101, 0, 'ClientType', 'ReqDefAtty', 'ReqBillToClient', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';1;', 'YES', 'NO', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';3;4;', 'NO', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, ';13;', 'YES', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';1;', 'YES', 'NO', NULL ,NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';3;4;', 'NO', 'YES', NULL, NULL, 0, NULL),
       (146, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 5, NULL, NULL, ';13;', 'YES', 'YES', NULL, NULL, 0, NULL)
GO
-- IMEC-13184 - new security settings for Client Type Override
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('ClientTypeVerifyOverride','Case - Skip Client Type Validation', GETDATE())
GO
