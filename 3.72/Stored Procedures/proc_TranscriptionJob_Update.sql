CREATE PROCEDURE [proc_TranscriptionJob_Update]
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