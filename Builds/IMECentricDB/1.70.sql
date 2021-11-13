
-------------------------------------------------------------------------
--Update Transcription Manager permission name to Transcription Tracker
-------------------------------------------------------------------------

DELETE FROM tblUserFunction WHERE functioncode='TransManager'
DELETE FROM tblUserFunction WHERE functioncode='TransManagerAdmin'
GO


INSERT  INTO tbluserfunction
        ( functioncode ,
          functiondesc
        )
        SELECT  'TransTracker' ,
                'Transcription Tracker'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'TransTracker' )

GO

INSERT  INTO tbluserfunction
        ( functioncode ,
          functiondesc
        )
        SELECT  'TransTrackerManager' ,
                'Transcription Tracker - Manager'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'TransTrackerManager' )

GO


-------------------------------------
--Changes for Transcription Tracker
-------------------------------------

CREATE TABLE [tblTranscriptionJob] (
  [TranscriptionJobID] INTEGER IDENTITY(1,1) NOT NULL,
  [TranscriptionStatusCode] INTEGER NOT NULL,
  [DateAdded] DATETIME,
  [DateEdited] DATETIME,
  [UserIDEdited] VARCHAR(20),
  [DictationFile] VARCHAR(100),
  [CaseNbr] INTEGER,
  [ReportTemplate] VARCHAR(15),
  [ReportTemplateFile] VARCHAR(100),
  [CoverLetterFile] VARCHAR(100),
  [TransCode] INTEGER,
  [DateAssigned] DATETIME,
  [ReportFile] VARCHAR(100),
  [DateRptReceived] DATETIME,
  [DateCompleted] DATETIME,
  CONSTRAINT [PK_tblTranscriptionJob] PRIMARY KEY ([TranscriptionJobID])
)
GO

CREATE INDEX [IdxtblTranscriptionJob_BY_CaseNbr] ON [tblTranscriptionJob]([CaseNbr])
GO

CREATE INDEX [IdxtblTranscriptionJob_BY_TransCode] ON [tblTranscriptionJob]([TransCode])
GO

ALTER TABLE [tblTranscription]
  ADD [AllowRequestNextJob] BIT
GO

ALTER TABLE [tblTranscription]
  ADD [EmailAssignment] BIT
GO

ALTER TABLE [tblTranscription]
  ADD [Workflow] INTEGER
GO

ALTER TABLE [tblDoctor]
  ADD [DictationAuthorID] VARCHAR(10)
GO

CREATE INDEX [IdxtblDoctor_BY_DictationAuthorID] ON [tblDoctor]([DictationAuthorID])
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CheckAssignedPendingTranscriptionsByTransCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CheckAssignedPendingTranscriptionsByTransCode];
GO

CREATE PROCEDURE [proc_CheckAssignedPendingTranscriptionsByTransCode]
(
	@TransCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TranscriptionJobID FROM tblTranscriptionJob

	WHERE TransCode = @TransCode
	AND TranscriptionStatusCode = 2
		
	SET @Err = @@Error

	RETURN @Err
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_GetNextAvailableTranscription]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetNextAvailableTranscription];
GO

CREATE PROCEDURE [proc_GetNextAvailableTranscription]

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 TranscriptionJobID FROM tblTranscriptionJob WHERE transcriptionstatuscode = 2 and transcode = -1 ORDER BY dateadded 
		
	SET @Err = @@Error

	RETURN @Err
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_Delete]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_Delete];
GO

CREATE PROCEDURE [proc_TranscriptionJob_Delete]
(
	@TranscriptionJobID int
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	DELETE
	FROM [tblTranscriptionJob]
	WHERE
		[TranscriptionJobID] = @TranscriptionJobID
	SET @Err = @@Error

	RETURN @Err
END
GO
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
	INTO [tblTranscriptionJob]
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

	SELECT @TranscriptionJobID = SCOPE_IDENTITY()

	RETURN @Err
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByCaseNbr];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByCaseNbr]
(
	@CaseNbr int
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
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Doctor,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.CaseNbr = @CaseNbr
		
	SET @Err = @@Error

	RETURN @Err
END
GO
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

	SELECT *

	FROM [tblTranscriptionJob]
	WHERE
		([TranscriptionJobID] = @TranscriptionJobID)
		
	SET @Err = @@Error

	RETURN @Err
END
GO
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
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.TransCode = @TransCode
		AND TranscriptionStatusCode = @TranscriptionStatusCode
	SET @Err = @@Error

	RETURN @Err
END
GO
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
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Provider,
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

	UPDATE [tblTranscriptionJob]
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
		[TranscriptionJobID] = @TranscriptionJobID


	SET @Err = @@Error


	RETURN @Err
END
GO





UPDATE tblControl SET DBVersion='1.70'
GO
