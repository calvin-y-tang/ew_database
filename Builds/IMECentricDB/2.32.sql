

DROP VIEW vwPDFDoctorData
GO
CREATE VIEW vwPDFDoctorData
AS
    SELECT  DoctorCode ,
			LTRIM(RTRIM(ISNULL(firstName,'') + ' ' + ISNULL(lastName,'') + ' ' + ISNULL(credentials,''))) AS DoctorFullName ,
			[Credentials] AS DoctorDegree ,

            NPINbr AS DoctorNPINbr ,
			B.BlankValue AS	DoctorWALINbr ,
            LicenseNbr AS DoctorLicense ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B' END AS DoctorLicenseQualID ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B ' + LicenseNbr END AS DoctorLicenseWithQualPrefix ,
			LEFT(LicenseNbr, 2) + RIGHT(LicenseNbr, 2) AS TexasDoctorLicenseType ,
            
			Addr1 AS DoctorCorrespAddr1 ,
            Addr2 AS DoctorCorrespAddr2 ,
            City + ', ' + State + '  ' + Zip AS DoctorCorrespCityStateZip ,

			B.BlankValueLong AS DoctorCorrespFullAddress ,

			USDVarchar1 AS DoctorUSDVarchar1 ,
			USDVarchar2 AS DoctorUSDVarchar2 ,
			USDText1 AS DoctorUSDText1 ,
			USDText2 AS DoctorUSDText2 ,

            
			Phone + ' ' + ISNULL(PhoneExt, '') AS DoctorCorrespPhone ,
			Phone AS DoctorCorrespPhoneAreaCode ,
			Phone AS DoctorCorrespPhoneNumber
    FROM    tblDoctor
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByStatusCode]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByStatusCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJob_LoadByStatusCode];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByStatusCode]
(
	@TransCode int,
	@Workflow int,
	@DateRptReceived smalldatetime
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	(SELECT COUNT(TranscriptionJobID) FROM tblTranscriptionJob WHERE tblTranscriptionJob.TransCode = @TransCode AND Workflow = @Workflow AND DateRptReceived >= @DateRptReceived) AS 'TransCount',
	* from tblTranscriptionJob

	WHERE tblTranscriptionJob.TransCode = @TransCode
		AND Workflow = @Workflow
		AND DateRptReceived >= @DateRptReceived

	SET @Err = @@Error

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
	@DictationFile varchar(100) = NULL,
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
	@DictationDownloaded bit = NULL,
	@CoverLetterDownloaded bit = NULL,
	@ReportDownloaded bit = NULL,
	@Workflow int = NULL,
	@OriginalRptFileName varchar(100) = NULL
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
	[DictationFile] = @DictationFile,
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
	[DictationDownloaded] = @DictationDownloaded,
	[CoverLetterDownloaded] = @CoverLetterDownloaded,
	[ReportDownloaded] = @ReportDownloaded,
	[Workflow] = @Workflow,
	[OriginalRptFileName] = @OriginalRptFileName

	WHERE
		[TranscriptionJobID] = @TranscriptionJobID


	SET @Err = @@Error


	RETURN @Err
END
GO

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
	@DictationFile varchar(100) = NULL,
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
	@DictationDownloaded bit = NULL,
	@CoverLetterDownloaded bit = NULL,
	@ReportDownloaded bit = NULL,
	@Workflow int = NULL,
	@OriginalRptFileName varchar(100) = NULL

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
		[DictationFile],
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
		[DictationDownloaded],
		[CoverLetterDownloaded],
		[ReportDownloaded],
		[Workflow],
		[OriginalRptFileName]
	)
	VALUES
	(
		@TranscriptionStatusCode,
		@DateAdded,
		@DateEdited,
		@UserIDEdited,
		@DictationFile,
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
		@DictationDownloaded,
		@CoverLetterDownloaded,
		@ReportDownloaded,
		@Workflow,
		@OriginalRptFileName
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobID = SCOPE_IDENTITY()

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByTranscriptionJobID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByTranscriptionJobID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJob_LoadByTranscriptionJobID];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByTranscriptionJobID]
(
	@TranscriptionJobID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblExaminee.LastName + ', ' + tblExaminee.FirstName AS 'Examinee',
	tblTranscription.TransCompany,
	tblCase.ApptDate
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.TranscriptionJobID = @TranscriptionJobID
		
	SET @Err = @@Error

	RETURN @Err
END
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

/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByPrimaryKey]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
	DROP PROCEDURE [proc_TranscriptionJob_LoadByPrimaryKey];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByPrimaryKey]
(
	@TranscriptionJobID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblTranscriptionJob.*, tblCase.Priority

	FROM [tblTranscriptionJob]
		LEFT JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr
	WHERE
		([TranscriptionJobID] = @TranscriptionJobID)
		
	SET @Err = @@Error

	RETURN @Err
END
GO



UPDATE tblControl SET DBVersion='2.32'
GO
