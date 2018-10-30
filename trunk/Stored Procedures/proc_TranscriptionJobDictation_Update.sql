
CREATE PROCEDURE [proc_TranscriptionJobDictation_Update]
(
	@TranscriptionJobDictationID int,
	@TranscriptionJobID int,
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

	UPDATE [tblTranscriptionJobDictation]
	SET

	[TranscriptionJobID] = @TranscriptionJobID,
	[DateAdded] = @DateAdded,
	[DateEdited] = @DateEdited,
	[UserIDAdded] = @UserIDAdded,
	[UserIDEdited] = @UserIDEdited,
	[DictationFile] = @DictationFile,
	[OriginalFileName] = @OriginalFileName,
	[DictationDownloaded] = @DictationDownloaded,
	[IntegrationId] = @IntegrationId,
	[SeqNo] = @SeqNo

	WHERE
		[TranscriptionJobDictationID] = @TranscriptionJobDictationID


	SET @Err = @@Error


	RETURN @Err
END
