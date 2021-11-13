
--Changes for Transcription Web Portal by Gary
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
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL
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
	[LastStatusChg] = @LastStatusChg

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
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL
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
		[LastStatusChg]
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
		@LastStatusChg
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobID = SCOPE_IDENTITY()

	RETURN @Err
END
GO


--New Transcription tracking dates and status

ALTER TABLE [tblTranscriptionJob]
  ADD [DateTranscribingStart] DATETIME
GO

ALTER TABLE [tblTranscriptionJob]
  ADD [DateCanceled] DATETIME
GO

ALTER TABLE [tblTranscriptionJob]
  ADD [InternalTransTAT] INTEGER
GO


SET IDENTITY_INSERT [dbo].[tblTranscriptionStatus] ON
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (6, 'Canceled')
SET IDENTITY_INSERT [dbo].[tblTranscriptionStatus] OFF
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
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL,
	@DateTranscribingStart datetime = NULL
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
		[DateTranscribingStart]
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
		@DateTranscribingStart
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobID = SCOPE_IDENTITY()

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
	@CoverLetterFile varchar(100) = NULL,
	@TransCode int = NULL, 
	@DateAssigned datetime = NULL,
	@ReportFile varchar(100) = NULL,
	@DateRptReceived datetime = NULL,
	@DateCompleted datetime = NULL,
	@LastStatusChg datetime = NULL,
	@DateTranscribingStart datetime = NULL
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
	[DateTranscribingStart] = @DateTranscribingStart

	WHERE
		[TranscriptionJobID] = @TranscriptionJobID


	SET @Err = @@Error


	RETURN @Err
END
GO


--New fields to track where the service is performed for the case

ALTER TABLE [tblAcctHeader]
  ADD [ServiceAddress] VARCHAR(50)
GO

ALTER TABLE [tblAcctHeader]
  ADD [ServiceCity] VARCHAR(35)
GO

ALTER TABLE [tblAcctHeader]
  ADD [ServiceState] VARCHAR(2)
GO

ALTER TABLE [tblAcctHeader]
  ADD [ServiceZip] VARCHAR(10)
GO




UPDATE tblControl SET DBVersion='1.74'
GO
