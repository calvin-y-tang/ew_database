
CREATE PROCEDURE [proc_TranscriptionJobDictation_Insert]
(
	@TranscriptionJobDictationID int = NULL output,
	@TranscriptionJobID int = NULL,
	@DateAdded datetime = NULL,
	@DateEdited datetime = NULL,
	@UserIDAdded varchar(20) = NULL,
	@UserIDEdited varchar(20) = NULL,
	@DictationFile varchar(100) = NULL,
	@OriginalFileName varchar(100) = NULL,
	@DictationDownloaded bit = NULL,
	@IntegrationId int = NULL,
	@SeqNo int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblTranscriptionJobDictation]
	(
		[TranscriptionJobID],
		[DateAdded],
		[DateEdited],
		[UserIDAdded],
		[UserIDEdited],
		[DictationFile],
		[OriginalFileName],
		[DictationDownloaded],
		[IntegrationId],
		[SeqNo]
	)
	VALUES
	(
		@TranscriptionJobID,
		@DateAdded,
		@DateEdited,
		@UserIDAdded,
		@UserIDEdited,
		@DictationFile,
		@OriginalFileName,
		@DictationDownloaded,
		@IntegrationId,
		@SeqNo
	)

	SET @Err = @@Error

	SELECT @TranscriptionJobDictationID = SCOPE_IDENTITY()

	RETURN @Err
END
