
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
