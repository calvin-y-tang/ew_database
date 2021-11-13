
CREATE PROCEDURE [proc_TranscriptionJob_LoadByPrimaryKey]
(
	@TranscriptionJobID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblTranscriptionJob.*, tblCase.Priority

	FROM [tblTranscriptionJob]
		LEFT JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr
	WHERE
		([TranscriptionJobID] = @TranscriptionJobID)
		
	SET @Err = @@Error

	RETURN @Err
END
