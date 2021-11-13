
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
	AND TranscriptionStatusCode = 20
		
	SET @Err = @@Error

	RETURN @Err
END
