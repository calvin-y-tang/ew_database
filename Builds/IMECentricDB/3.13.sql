PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [DateAcknowledged]         DATETIME NULL,
        [TATEnteredToAcknowledged] INT      NULL;


GO
PRINT N'Altering [dbo].[tblCompany]...';


GO
ALTER TABLE [dbo].[tblCompany]
    ADD [JopariPayerIdentifier] VARCHAR (16) NULL,
        [JopariPayerName]       VARCHAR (64) NULL,
        [CaseAcknowledgment]    BIT          NULL;


GO
PRINT N'Altering [dbo].[tblConfirmationList]...';


GO
ALTER TABLE [dbo].[tblConfirmationList]
    ADD [UITempData] VARCHAR (10) NULL;


GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [DPSServiceAddress] VARCHAR (100) NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [CaseAcknowledgment] BIT NULL;


GO
PRINT N'Altering [dbo].[tblUserFunction]...';


GO
ALTER TABLE [dbo].[tblUserFunction]
    ADD [DateAdded] DATE CONSTRAINT [DF_tblUserFunction_DateAdded] DEFAULT GETDATE() NOT NULL;


GO
PRINT N'Creating [dbo].[tblCaseDocType]...';


GO
ALTER TABLE [dbo].[tblCaseDocType]
    ADD [PublishOnWeb] BIT CONSTRAINT [DF_tblCaseDocType_PublishOnWeb] DEFAULT 0 NOT NULL;


GO
PRINT N'Altering [dbo].[vwClientDefaults]...';


GO
ALTER VIEW vwClientDefaults
AS
   SELECT  CL.marketercode AS ClientMarketer ,
            COM.IntName ,
		  ISNULL(COM.EWCompanyID, 0) AS EWCompanyID, 
            CL.ReportPhone ,
            CL.Priority ,
            CL.ClientCode ,
            CL.fax ,
            CL.email ,
            CL.phone1 ,
            CL.documentemail AS EmailClient ,
            CL.documentfax AS FaxClient ,
            CL.documentmail AS MailClient ,
            ISNULL(CL.casetype, COM.CaseType) AS CaseType ,
            CL.feeschedule ,
            COM.credithold ,
            COM.preinvoice ,
            CL.billaddr1 ,
            CL.billaddr2 ,
            CL.billcity ,
            CL.billstate ,
            CL.billzip ,
            CL.billattn ,
            CL.ARKey ,
            CL.addr1 ,
            CL.addr2 ,
            CL.city ,
            CL.state ,
            CL.zip ,
            CL.firstname + ' ' + CL.lastname AS clientname ,
            CL.prefix AS clientprefix ,
            CL.suffix AS clientsuffix ,
            CL.lastname ,
            CL.firstname ,
            CL.billfax ,
            CL.QARep ,
            ISNULL(CL.photoRqd, COM.photoRqd) AS photoRqd ,
            CL.CertifiedMail ,
            CL.PublishOnWeb ,
            CL.UseNotificationOverrides ,
            CL.CSR1 ,
            CL.CSR2 ,
            CL.AutoReschedule ,
            CLO.OfficeCode AS DefOfficeCode ,
            ISNULL(CL.marketercode, COM.marketercode) AS marketer ,
            COM.Jurisdiction ,
		  CL.CreateCvrLtr|COM.CreateCvrLtr As CreateCvrLtr, 
		  ISNULL(PC.RequireInOutNetwork, 0) AS RequireInOutNetwork,
			COM.ParentCompanyID
    FROM    tblClient AS CL
            INNER JOIN tblCompany AS COM ON CL.companycode = COM.companycode
			LEFT OUTER JOIN tblClientOffice AS CLO ON CLO.ClientCode = CL.ClientCode AND CLO.IsDefault=1
		  INNER JOIN tblEWParentCompany AS PC ON PC.ParentCompanyID = COM.ParentCompanyID
GO
PRINT N'Creating [dbo].[vwConfirmationResultsReport]...';


GO
CREATE VIEW vwConfirmationResultsReport
AS 
	SELECT  
		c.Office, 
		c.ExtCaseNbr AS 'Case Nbr', 
		FORMAT(c.ApptTime,'MM-dd-yy') AS 'Appt',
		c.ExamineefirstName + ' ' + c.ExamineelastName AS Examinee, 
		ISNULL(c.PAttorneyCompany,'') AS 'Attorney Firm', 
		ISNULL(c.pAttorneyfirstName, '') + ISNULL(c.pAttorneylastName, '') AS Attorney, 
		c.Company, 
		ct.ShortDesc AS 'Case Type', 
		s.ShortDesc AS Service, 
		cl.ContactType AS 'Contact Type', 
		IIF(cl.ContactMethod=1,'Phone','Text') AS 'Contact Method', 
		cl.Phone,  
		FORMAT(cl.TargetCallTime,'M-d-yy h:mmtt') AS 'Call Target Time', 
		FORMAT(cl.ContactedDateTime,'M-d-yy h:mmtt') AS 'Actual Call Date Time', 
		cl.NbrOfCallAttempts AS 'Nbr Attempts', 
		cr.Description AS 'Call Result', 
		IIF(ca.apptconfirmed =0, 'No','Yes') AS Confirmed,
		c.officeCode,
		cl.StartDate
	FROM tblconfirmationlist AS cl
	LEFT OUTER JOIN tblconfirmationresult AS cr ON cr.confirmationresultid = cl.confirmationresultid
	INNER JOIN tblcaseappt AS ca ON ca.caseapptid = cl.CaseApptID
	INNER JOIN vwdocument AS c ON c.casenbr = ca.CaseNbr
	INNER JOIN tblServices AS s ON c.servicecode = s.servicecode
	INNER JOIN tblCaseType AS ct ON c.casetype = ct.code
	WHERE  BatchNbr <> 0 AND (cl.Selected = 1) 
	AND (cl.ConfirmationStatusID IN (NULL,3,4,5))
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_LoadByWebUserIDAndLastLoginDate]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_CaseDocuments_LoadByWebUserIDAndLastLoginDate]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseDocuments.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblPublishOnWeb.PublishasPDF, tblCaseDocType.Description AS doctypedesc
	FROM tblCaseDocuments
		INNER JOIN tblCase ON tblCaseDocuments.casenbr = tblCase.Casenbr
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey
		LEFT JOIN tblCaseDocType on tblCaseDocuments.CaseDocTypeID = tblCaseDocType.CaseDocTypeID
	WHERE (tblPublishOnWeb.TableType = 'tblCaseDocuments')
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (tblPublishOnWeb.DateAdded > @LastLoginDate)
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_GetReferralSummaryNew]...';


GO
ALTER PROCEDURE [dbo].[proc_GetReferralSummaryNew]

@WebStatus varchar(50),
@WebUserID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.dateadded,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblCase.MMIReached,
		tblCase.MMITreatmentWeeks,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		tblQueues.statuscode AS QueueStatusCode,
		tblQueues.StatusDesc,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblWebQueues.statuscode = @WebStatus)
		AND (tblCase.status <> 0)

	SET @Err = @@Error

	RETURN @Err
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
	@DateAcknowledged datetime = NULL
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
		[DateAcknowledged]
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
		@DateAcknowledged
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
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
	@DateAcknowledged datetime = NULL
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
		[DateAcknowledged] = @DateAcknowledged
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_Insert]...';


GO
ALTER PROCEDURE [proc_CaseDocuments_Insert]
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
	@Source varchar(15),
	@FolderID int,
	@SubFolder varchar(32),
	@CaseDocTypeId int
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
		[Source],
		[FolderID],
		[SubFolder],
		[CaseDocTypeId]
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
		@Source,
		@FolderID,
		@SubFolder,
		@CaseDocTypeId
	)

	SET @Err = @@Error

	SELECT @seqno = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_LoadByCaseNbrAndWebUserID]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_CaseDocuments_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL

AS

SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF, tblCaseDocType.Description as DocTypeDesc
	FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN
				(SELECT UserCode
					FROM tblWebUserAccount
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
		INNER JOIN tblCaseDocType on isnull(tblCaseDocuments.CaseDocTypeID,1) = tblCaseDocType.CaseDocTypeID
		AND (casenbr = @CaseNbr)
		AND (tblCaseDocuments.PublishOnWeb = 1)
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_CaseDocuments_Update]...';


GO
ALTER PROCEDURE [proc_CaseDocuments_Update]
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
	@Source varchar(15),
	@FolderID int,
	@SubFolder varchar(32),
	@CaseDocTypeId int
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
		[Source] = @Source,
		[FolderID] = @FolderID,
		[SubFolder] = @SubFolder,
		[CaseDocTypeId] = @CaseDocTypeId
	WHERE
		[seqno] = @seqno


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_DoctorSchedule_Update]...';


GO
ALTER PROCEDURE [proc_DoctorSchedule_Update]
(
	@schedcode int,
	@locationcode int,
	@date datetime,
	@starttime datetime,
	@description varchar(50) = NULL,
	@status varchar(15) = NULL,
	@duration int = NULL,
	@casenbr1 int = NULL,
	@casenbr1desc varchar(70) = NULL,
	@casenbr2 int = NULL,
	@casenbr2desc varchar(70) = NULL,
	@dateadded datetime = NULL,
	@useridadded varchar(15) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(15) = NULL,
	@doctorcode int,
	@WasScheduled bit = true
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblDoctorSchedule]
	SET
		[date] = @date,
		[starttime] = @starttime,
		[description] = @description,
		[status] = @status,
		[duration] = @duration,
		[casenbr1] = @casenbr1,
		[casenbr1desc] = @casenbr1desc,
		[casenbr2] = @casenbr2,
		[casenbr2desc] = @casenbr2desc,
		[dateadded] = @dateadded,
		[useridadded] = @useridadded,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[doctorcode] = @doctorcode,
		[WasScheduled] = @WasScheduled
	WHERE
		[schedcode] = @schedcode
	AND	[locationcode] = @locationcode


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetCaseDocTypeComboItems]...';


GO
CREATE PROCEDURE [proc_GetCaseDocTypeComboItems]

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblCaseDocType WHERE PublishOnWeb = 1

	ORDER BY Description

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetStatusFromServiceWorkflow]...';


GO
CREATE PROCEDURE [proc_GetStatusFromServiceWorkflow]

@ServiceWorkflowID int,
@StatusCode int,
@Direction char(4)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	IF @Direction = 'Next'
	BEGIN
	SELECT NextStatus FROM tblServiceWorkflowQueue where ServiceWorkFlowID = @ServiceWorkflowID
		AND StatusCode = @StatusCode
	END

	IF @Direction = 'Prev'
	BEGIN
	SELECT StatusCode FROM tblServiceWorkflowQueue where ServiceWorkFlowID = @ServiceWorkflowID
		AND NextStatus = @StatusCode
	END

	SET @Err = @@Error

	RETURN @Err
END
GO




-- add row to tblCaseDocType table for billing docs and update new publishonweb field accordingly
INSERT INTO tblCaseDocType VALUES ('Billing', 'Billing Documents', 'Document', 1)
UPDATE tblCaseDocType SET PublishOnWeb = 1 WHERE CaseDocTypeID IN (7,8,9,10,11,12,13)
GO

-- set the Brickstreet Payer name and Id values (existing EDI impl)
UPDATE tblCompany SET JopariPayerName = 'BRICKSTREET', JopariPayerIdentifier = 'J1761' WHERE BulkBillingID = 6
GO
-- set the State Fund (SCIF) Payer name and Id values (existing EDI impl)
UPDATE tblCompany SET JopariPayerName = 'SCIF', JopariPayerIdentifier = '35076' WHERE BulkBillingID = 7
GO
-- set the Broadspire Payer name and Id values (new EDI impl)
UPDATE tblCompany SET JopariPayerName = 'BROADSPIRE', JopariPayerIdentifier = 'TP021' WHERE ParentCompanyID = 13
GO

-- add new SLA Rule

INSERT INTO tblDataField VALUES (112, 'tblCase', 'TATEnteredToAcknowledged', '')
GO

INSERT INTO tblDataField VALUES (211, 'tblCase', 'DateAcknowledged', 'Date Acknowledged')
GO

INSERT INTO tblTATCalculationMethod VALUES (13, 201, 211, 'Hour', 112, 0)
GO

UPDATE tblTATCalculationGroupDetail set DisplayOrder = DisplayOrder + 1 where TATCalculationGroupID = 1 AND TATCalculationGroupID = 2 
GO

INSERT INTO tblTATCalculationGroupDetail VALUES (1, 13, 0)
GO

INSERT INTO tblTATCalculationGroupDetail VALUES (2, 13, 0)
GO


-- new queue form
INSERT INTO tblQueueForms VALUES ('frmStatusPA', 'Form for Pending Acknowledgment')
GO

SET IDENTITY_INSERT tblQueues ON;  
GO  

INSERT INTO tblQueues
(StatusCode, StatusDesc,[Type],ShortDesc,DisplayOrder,FormToOpen,DateAdded,DateEdited,UserIDAdded,UserIDEdited,Status,SubType,FunctionCode,WebStatusCode,NotifyScheduler,NotifyQARep,NotifyIMECompany,WebGUID,AllowToAwaitingScheduling,IsConfirmation)
VALUES
(33,'Pending Acknowledgment','System','PendAck',999,'frmStatusPA',GETDATE(),GETDATE(),'Admin','Admin','Active','Case','None',NULL,0,0,NULL,NULL,NULL,0)
GO

SET IDENTITY_INSERT tblQueues OFF;  
GO  

INSERT INTO tblSetting (Name, Value) VALUES ('AllstateEDoc','AllstateAck')
GO

INSERT INTO tblUserFunction (FunctionCode, FunctionDesc)
 VALUES ('AckDateEdit', 'Acknowledgment Date - Edit')
GO

-- Update the new flag on the tblDoctorSchedule table to true if the status is 'Scheduled'
update tblDoctorSchedule
set WasScheduled= 1
where status = 'Scheduled'
and wasScheduled<>1
Go


UPDATE tblEWParentcompany SET CaseAcknowledgment = 1 WHERE ParentcompanyID = 4
GO


--Refreshed DPSStatus and Confirmation Result Code
TRUNCATE TABLE [tblDPSStatus]
GO

INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (0, 'New')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (10, 'Ready for Submit')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (20, 'Submitted')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (30, 'Preparing for Review')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (40, 'Reviewing')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (70, 'Combined')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (80, 'Complete')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (85, 'Pending for Cancel')
INSERT INTO [dbo].[tblDPSStatus] ([DPSStatusID], [Name]) VALUES (90, 'Canceled')
GO


TRUNCATE TABLE tblConfirmationResult
GO


SET IDENTITY_INSERT [dbo].[tblConfirmationResult] ON
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (1, '', 'Not Called', 0, 2, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (2, '#', 'Dial Tone Not Detected', 0, 2, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (3, '[', 'Answered - Confirmed Receptionist', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (4, '\', 'Exchange number not on file', 0, 2, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (5, '1', 'Called- No Answer', 0, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (6, 'B', 'Phone Busy', 0, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (7, 'C ', 'Called No TT Requested', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (8, 'F', 'Answered - Called Receptionist', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (9, 'G', 'Answered - Confirmed', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (10, 'H', 'Answered - Hung Up', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (11, 'J', 'Text Msg Sent', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (12, 'N', 'Answered - Entire Message', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (13, 'O', 'Out of Order', 0, 2, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (14, 'P', 'Invalid phone number', 0, 2, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (15, 'Q', 'Answered - Confirmed Entire Message', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (16, 'R', 'Message Element Not Recorded', 0, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (17, 'S', 'Answered - Confirmed Hung Up', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (18, 'T', 'Answered - Repeated Message', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (19, 'U', 'Answered - Confirmed No TT Required', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (20, 'W', 'Answering Machine - Message not Played', 0, 2, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (21, 'X', 'Answering Machine', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (22, 'Y', 'Answered - Yes', 1, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (23, 'Z', 'Message not Assigned', 0, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (24, '6', 'Text Msg Not Sent - Opt-In Required', 0, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (25, '%', 'Text Msg Attempted - Carrier Error', 0, 1, 2, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (27, 'failed', 'Call Failed', 0, 2, 1, NULL, 'FailedReason')
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (28, 'busy', 'Phone Busy', 0, 1, 1, 3, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (29, 'no-answer', 'Called - No Answer', 0, 1, 1, 3, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (30, 'completed', 'Answered - Hung Up', 0, 1, 1, NULL, 'CallDuration')
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (31, 'EntireMessage', 'Answered - Entire Message', 0, 1, 1, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (32, 'VM', 'Answering Machine', 0, 1, 1, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (33, 'ConfirmedKeyPressed', 'Answered - Confirmed', 1, 1, 1, NULL, NULL)
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (34, 'BU', 'Transferred to Office', 1, 1, 1, NULL, 'CallDuration')
INSERT INTO [dbo].[tblConfirmationResult] ([ConfirmationResultID], [ResultCode], [Description], [IsSuccessful], [HandleMethod], [ConfirmationSystemID], [MaxRetriesPerDay], [IncludeParams]) VALUES (35, 'InvalidPhone', 'Invalid Phone Number', 0, 2, 1, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[tblConfirmationResult] OFF
GO

INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (110, 'SkippedKeyValueChanged')
GO




UPDATE tblControl SET DBVersion='3.13'
GO
