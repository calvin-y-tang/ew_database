CREATE PROCEDURE [proc_TranscriptionJob_Insert]
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