

--Changes by Gary for Transcription Web Portal
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseTranscription_LoadByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseTranscription_LoadByCaseNbr];
GO

CREATE PROCEDURE [proc_CaseTranscription_LoadByCaseNbr]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblCaseTranscription.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Doctor,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblCaseTranscription 
		INNER JOIN tblCase ON tblCaseTranscription.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblCaseTranscription.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblCaseTranscription.CaseNbr = @CaseNbr
		
	SET @Err = @@Error

	RETURN @Err
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseTranscription_LoadByTransCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseTranscription_LoadByTransCode];
GO

CREATE PROCEDURE [proc_CaseTranscription_LoadByTransCode]
(
	@TransCode int,
	@TranscriptionStatusCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	(SELECT COUNT(TranscriptionID) FROM tblCaseTranscription WHERE tblCaseTranscription.TransCode = @TransCode AND TranscriptionStatusCode = @TranscriptionStatusCode) AS 'TransCount',
	tblCaseTranscription.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblCaseTranscription 
		INNER JOIN tblCase ON tblCaseTranscription.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblCaseTranscription.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblCaseTranscription.TransCode = @TransCode
		AND TranscriptionStatusCode = @TranscriptionStatusCode
	SET @Err = @@Error

	RETURN @Err
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseTranscription_LoadByTranscriptionID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseTranscription_LoadByTranscriptionID];
GO

CREATE PROCEDURE [proc_CaseTranscription_LoadByTranscriptionID]
(
	@TranscriptionID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblCaseTranscription.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblExaminee.LastName + ', ' + tblExaminee.FirstName AS 'Examinee',
	tblTranscription.TransCompany,
	tblCase.ApptDate
	
	FROM tblCaseTranscription 
		INNER JOIN tblCase ON tblCaseTranscription.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblCaseTranscription.TransCode = tblTranscription.TransCode
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblCaseTranscription.TranscriptionID = @TranscriptionID
		
	SET @Err = @@Error

	RETURN @Err
END
GO


--Patch ApptTime that has mismatch date part from the ApptDate
update tblCase set ApptTime=
 DATEADD(dd, 0-DATEDIFF(Day, 0, ApptTime), ApptTime)+ApptDate
 WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, apptTime))<>ApptDate
GO


----------------------------------------------------------------------
--Index to improve query performance
----------------------------------------------------------------------

CREATE INDEX [IdxtblCase_BY_DateAddedOfficeCodeStatus] ON [tblCase]([DateAdded],[OfficeCode],[Status])
GO


CREATE INDEX [IdxtblExaminee_BY_SSN] ON [tblExaminee]([SSN])
GO

----------------------------------------------------------------------
--Remove unused fields from tblEWFacility
----------------------------------------------------------------------
ALTER TABLE [tblEWFacility]
  DROP COLUMN [GPEntityPrefix]
GO

ALTER TABLE [tblEWFacility]
  DROP COLUMN [GPUserID]
GO


----------------------------------------------------------------------
--Index to improve query performance
----------------------------------------------------------------------

CREATE INDEX [IdxtblCase_BY_ClientCode] ON [tblCase]([ClientCode])
GO

CREATE INDEX [IdxtblCase_BY_BillClientCode] ON [tblCase]([BillClientCode])
GO

CREATE INDEX [IdxtblCase_BY_DoctorCode] ON [tblCase]([DoctorCode])
GO

CREATE INDEX [IdxtblCase_BY_PanelNbr] ON [tblCase]([PanelNbr])
GO


CREATE INDEX [IdxtblCasePanel_BY_DoctorCode] ON [tblCasePanel]([DoctorCode])
GO


CREATE INDEX [IdxtblClient_BY_CompanyCode] ON [tblClient]([CompanyCode])
GO


----------------------------------------------------------------------
--Changes by Gary for Transcription Portal
----------------------------------------------------------------------


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseTranscription_Insert]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseTranscription_Insert];
GO

CREATE PROCEDURE [proc_CaseTranscription_Insert]
(
	@TranscriptionID int = NULL output,
	@TranscriptionStatusCode int,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(20) = NULL,
	@DictationFile varchar(100) = NULL,
	@CaseNbr int,
	@ReportTemplate varchar(15) = NULL,
	@ReportTemplateFile varchar(100) = NULL,
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseTranscription]
	(
		[TranscriptionStatusCode],
		[DateAdded],
		[DateEdited],
		[UserIDEdited],
		[DictationFile],
		[CaseNbr],
		[ReportTemplate],
		[ReportTemplateFile],
		[CoverLetterFile],
		[TransCode],
		[DateAssigned],
		[ReportFile],
		[DateRptReceived],
		[DateCompleted]
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
		@ReportTemplateFile,
		@CoverLetterFile,
		@TransCode, 
		@DateAssigned,
		@ReportFile,
		@DateRptReceived,
		@DateCompleted
	)

	SET @Err = @@Error

	SELECT @TranscriptionID = SCOPE_IDENTITY()

	RETURN @Err
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CaseTranscription_Update]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CaseTranscription_Update];
GO

CREATE PROCEDURE [proc_CaseTranscription_Update]
(
	@TranscriptionID int,
	@TranscriptionStatusCode int,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(20) = NULL,
	@DictationFile varchar(100) = NULL,
	@CaseNbr int,
	@ReportTemplate varchar(15) = NULL,
	@ReportTemplateFile varchar(100) = NULL,
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCaseTranscription]
	SET

	[TranscriptionStatusCode] = @TranscriptionStatusCode,
	[DateAdded] = @DateAdded,
	[DateEdited] = @DateEdited,
	[UserIDEdited] = @UserIDEdited,
	[DictationFile] = @DictationFile,
	[CaseNbr] = @CaseNbr,
	[ReportTemplate] = @ReportTemplate,
	[ReportTemplateFile] = @ReportTemplateFile,
	[CoverLetterFile] = @CoverLetterFile,
	[TransCode] = @TransCode,
	[DateAssigned] = @DateAssigned,
	[ReportFile] = @ReportFile,
	[DateRptReceived] = @DateRptReceived,
	[DateCompleted] = @DateCompleted

	WHERE
		[TranscriptionID] = @TranscriptionID


	SET @Err = @@Error


	RETURN @Err
END
GO




UPDATE tblControl SET DBVersion='1.69'
GO
