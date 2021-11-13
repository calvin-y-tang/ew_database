
CREATE PROCEDURE [proc_TranscriptionJobDictation_LoadByPrimaryKey]
(
	@TranscriptionJobDictationID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblTranscriptionJobDictation]
	WHERE
		([TranscriptionJobDictationID] = @TranscriptionJobDictationID)
		
	SET @Err = @@Error

	RETURN @Err
END
