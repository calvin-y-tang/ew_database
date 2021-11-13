PRINT N'Altering [dbo].[fnGetTranscriptionDocumentPath]...';


GO
/*
	Table-Valued Function that will return the fully qualified transcription document path,
	EW Folder ID and SubFolder name for the CaseNbr specified

	IMPORTANT: This Function is used by all EW Web Portals! DO NOT change this function's 
	signature without making cooresponding changes/suppoting changes to the portals (National, BU and InfoC)

*/
ALTER FUNCTION [dbo].[fnGetTranscriptionDocumentPath]
(
	@transJobID INT	
)
RETURNS @documentInfo TABLE
(
	DocumentPath VarChar(500),
	FolderID INT,
	SubFolder VarChar(32)
)
AS
BEGIN
	DECLARE @path VARCHAR(500)	
	DECLARE @folderID INT
	DECLARE @subFolder VARCHAR(32)
	
	SELECT @path = FD.PathName 
		+ ISNULL(TJ.SubFolder, RTRIM(YEAR(TJ.DateAdded))
								+ '-'
								+ RIGHT('0' + RTRIM(MONTH(TJ.DateAdded)), 2)
								+ '\' + CONVERT(VARCHAR, @transJobID) + '\'),
		@folderID = FD.FolderID,
		@subFolder = ISNULL(TJ.SubFolder, RTRIM(YEAR(TJ.DateAdded))
											+ '-'
											+ RIGHT('0' + RTRIM(MONTH(TJ.DateAdded)), 2)
											+ '\' + CONVERT(VARCHAR, @transJobID) + '\')
		FROM tblTranscriptionJob as TJ
			inner join tblEWTransDept as TD on TJ.EWTransDeptID = TD.EWTransDeptID
			inner join tblEWFolderDef as FD on ISNULL(TJ.FolderID, TD.FolderID) = FD.FolderID
		WHERE TJ.TranscriptionJobID = @transJobID
		  AND TJ.TranscriptionJobID IS NOT NULL

	INSERT @documentInfo
		SELECT	@path as DocumentPath,
				@folderID as FolderID, 
				@subFolder as SubFolder
	RETURN

END
GO

PRINT N'Altering [dbo].[proc_GetDoctorScheduleByDocCodeAndDate]...';


GO
ALTER PROCEDURE [dbo].[proc_GetDoctorScheduleByDocCodeAndDate]

@DoctorCode int,
@ApptDateStart smalldatetime,
@ApptDateEnd smalldatetime,
@WebUserID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.dateadded,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.ApptTime,
		tblCase.ExtCaseNbr,
		tblCase.claimnbr,
		tblLocation.Location,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT JOIN tblDoctor tblDoctor1 ON tblCase.doctorcode = tblDoctor1.doctorcode
		LEFT JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr
		LEFT JOIN tblDoctor tblDoctor2 ON tblCasePanel.DoctorCode = tblDoctor2.DoctorCode
		INNER JOIN tblLocation on tblCase.DoctorLocation = tblLocation.LocationCode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblCase.DoctorCode = @DoctorCode OR tblCasePanel.DoctorCode = @DoctorCode)
		AND (tblCase.ApptDate >= @ApptDateStart)
		AND (tblCase.ApptDate <= @ApptDateEnd)
		AND (tblCase.status <> 0)
		ORDER BY tblLocation.Location, ApptTime

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_TranscriptionJob_Insert]...';


GO
ALTER PROCEDURE [proc_TranscriptionJob_Insert]
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
	@Notes varchar(100) = NULL,
	@FolderId int = NULL,
	@SubFolder varchar(32) = NULL
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
		[Notes],
		[FolderId],
		[SubFolder]
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
		@Notes,
		@FolderId,
		@SubFolder
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobID = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_TranscriptionJob_Update]...';


GO
ALTER PROCEDURE [proc_TranscriptionJob_Update]
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
	@Notes varchar(100) = NULL,
	@FolderId int = NULL,
	@SubFolder varchar(32) = NULL
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
	[Notes] = @Notes,
	[FolderId] = @FolderId,
	[SubFolder] = @SubFolder

	WHERE
		[TranscriptionJobID] = @TranscriptionJobID


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_CaseType_LoadComboByOfficeCode]...';


GO
CREATE PROCEDURE [proc_CaseType_LoadComboByOfficeCode]

@OfficeCode nvarchar(100)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @strSQL nvarchar(800)

	SET @StrSQL = N'SELECT DISTINCT tblCaseType.Code, tblCaseType.Description FROM tblCaseType ' +
	'INNER JOIN tblCaseTypeOffice on tblCaseType.code = tblCaseTypeOffice.CaseType ' +
	'WHERE tblCaseType.PublishOnWeb = 1 ' +
	'AND tblCaseTypeOffice.OfficeCode IN (' + @OfficeCode + ')'

	BEGIN
	  EXEC SP_EXECUTESQL @StrSQL
	END

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_CheckForWebEventOverride]...';


GO
CREATE PROCEDURE [proc_CheckForWebEventOverride]

@IMECentricCode int,
@Description varchar(50)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT COUNT(*) FROM tblWebEventsOverride
		WHERE IMECentricCode = @IMECentricCode AND Description = @Description AND NotifyTo = 'CL'

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetDefaultOfficeByDefaultFlag]...';


GO
CREATE PROCEDURE [proc_GetDefaultOfficeByDefaultFlag]

@ClientCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 OfficeCode FROM tblClientOffice WHERE ClientCode = @ClientCode AND IsDefault = 1

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetDefaultOfficeByDefaultFlagByMin]...';


GO
CREATE PROCEDURE [proc_GetDefaultOfficeByDefaultFlagByMin]

@ClientCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT MIN(OfficeCode) FROM tblClientOffice WHERE ClientCode = @ClientCode

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetDoctorScheduleDatesByDoctorCode]...';


GO
CREATE PROCEDURE [dbo].[proc_GetDoctorScheduleDatesByDoctorCode]

@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT DATE FROM tblDoctorSchedule WHERE STATUS = 'Scheduled' and doctorcode = @DoctorCode and date >= getdate()

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetSaveDateTimeByOffice]...';


GO
CREATE PROCEDURE [proc_GetSaveDateTimeByOffice]
(
	@Officecode int
)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT dbo.fnGetUTCOffset (EWTimeZoneID, getutcdate()) Offset
		FROM tblEWTimeZone
		WHERE EWTimeZoneID = (SELECT EWTimeZoneID FROM tblOffice WHERE OfficeCode = @Officecode)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_LoadWebEventsByDescription]...';


GO
CREATE PROCEDURE [proc_LoadWebEventsByDescription]

@Description varchar(50)

AS

BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT * FROM tblWebEvents WHERE Description = @Description

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_Service_LoadComboByOfficeCode]...';


GO
CREATE PROCEDURE [proc_Service_LoadComboByOfficeCode]

@OfficeCode nvarchar(100)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @strSQL nvarchar(800)

	SET @StrSQL = N'SELECT DISTINCT tblServices.ServiceCode, tblServices.Description FROM tblServices ' +
	'INNER JOIN tblServiceOffice on tblServices.servicecode = tblServiceOffice.servicecode ' +
	'WHERE tblServices.PublishOnWeb = 1 ' +
	'AND tblServiceOffice.OfficeCode IN(' + @OfficeCode + ')'

	BEGIN
	  EXEC SP_EXECUTESQL @StrSQL
	END

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[web_GetTransJobDocumentPath]...';


GO
CREATE PROCEDURE [dbo].[web_GetTransJobDocumentPath]
 @TranscriptionJobID int
AS

BEGIN

	select * from [fnGetTranscriptionDocumentPath](@TranscriptionJobID)

END
GO

PRINT N'Altering [dbo].[vw_WebCoverLetterInfo]...';


GO
ALTER VIEW vw_WebCoverLetterInfo

AS

SELECT
	--case
	tblCase.casenbr AS Casenbr,
	tblCase.chartnbr AS Chartnbr,
	tblCase.doctorlocation AS Doctorlocation,
	tblCase.clientcode AS clientcode,
	tblCase.Appttime AS Appttime,
	tblCase.dateofinjury AS DOI,
	tblCase.dateofinjury AS DOI2,
	tblCase.dateofinjury2 AS DOISecond,
	tblCase.dateofinjury3 AS DOIThird,
	tblCase.dateofinjury4 AS DOIFourth,
	tblCase.notes AS Casenotes,
	tblCase.DoctorName AS doctorformalname,
	tblCase.ClaimNbrExt AS ClaimNbrExt,
	tblCase.Jurisdiction AS Jurisdiction,
	tblCase.ApptDate AS Apptdate,
	tblCase.claimnbr AS claimnbr,
	tblCase.doctorspecialty AS Specialtydesc,

	--examinee
	tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblExaminee.addr1 AS examineeaddr1,
	tblExaminee.addr2 AS examineeaddr2,
	tblExaminee.city AS ExamineeCity,
	tblExaminee.state AS ExamineeState,
	tblExaminee.zip AS ExamineeZip,
	tblExaminee.phone1 AS examineephone,
	tblExaminee.SSN AS ExamineeSSN,
	tblExaminee.sex AS ExamineeSex,
	tblExaminee.DOB AS ExamineeDOB,
	tblExaminee.insured AS insured,
	tblExaminee.employer AS Employer,
	tblExaminee.treatingphysician AS TreatingPhysician,
	tblExaminee.EmployerAddr1 AS Employeraddr1,
	tblExaminee.EmployerCity AS Employercity,
	tblExaminee.EmployerState AS Employerstate,
	tblExaminee.EmployerZip AS Employerzip,
	tblExaminee.EmployerPhone AS Employerphone,
	tblExaminee.EmployerFax AS Employerfax,
	tblExaminee.EmployerEmail AS Employeremail,

	--case type
	tblCaseType.description AS Casetype,

	--service
	tblServices.description AS servicedesc,

	--client
	tblClient.firstname + ' ' + tblClient.lastname AS clientname,
	tblClient.firstname + ' ' + tblClient.lastname AS clientname2,
	tblClient.phone1 AS clientphone,
	tblClient.fax AS Clientfax,

	--company
	tblCompany.intname company,

	--defense attorney
	cc1.firstname + ' ' + cc1.lastname AS dattorneyname,
	cc1.company AS dattorneycompany,
	cc1.address1 AS dattorneyaddr1,
	cc1.address2 AS dattorneyaddr2,
	cc1.phone AS dattorneyphone,
	cc1.fax AS dattorneyfax,
	cc1.email AS dattorneyemail,

	--plaintiff attorney
	cc2.firstname + ' ' + cc2.lastname AS pattorneyname,
	cc2.company AS pattorneycompany,
	cc2.address1 AS pattorneyaddr1,
	cc2.address2 AS pattorneyaddr2,
	cc2.phone AS pattorneyphone,
	cc2.fax AS pattorneyfax,
	cc2.email AS pattorneyemail,

	--doctor
	'Dr. ' + tblDoctor.firstname + ' ' + tblDoctor.lastname AS doctorsalutation,

	--problems
	tblProblem.description AS Problems

FROM  tblCase
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	LEFT OUTER JOIN	tblCaseType ON tblCase.casetype = tblCaseType.code
	LEFT OUTER JOIN	tblServices ON tblCase.servicecode = tblServices.servicecode
	LEFT OUTER JOIN	tblOffice ON tblCase.officecode = tblOffice.officecode
	LEFT OUTER JOIN	tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode
	LEFT OUTER JOIN	tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
	LEFT OUTER JOIN	tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
	LEFT OUTER JOIN	tblCaseProblem ON tblCase.casenbr = tblCaseProblem.casenbr
	LEFT OUTER JOIN	tblProblem ON tblCaseProblem.problemcode = tblProblem.problemcode
GO