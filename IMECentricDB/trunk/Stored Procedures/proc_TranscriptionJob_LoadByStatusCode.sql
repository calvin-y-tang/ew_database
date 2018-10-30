
CREATE PROCEDURE [proc_TranscriptionJob_LoadByStatusCode]
(
	@TransCode int,
	@Workflow int,
	@DateRptReceived smalldatetime
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	(SELECT COUNT(TranscriptionJobID) FROM tblTranscriptionJob WHERE tblTranscriptionJob.TransCode = @TransCode AND Workflow = @Workflow AND DateRptReceived >= @DateRptReceived) AS 'TransCount',
	* from tblTranscriptionJob

	WHERE tblTranscriptionJob.TransCode = @TransCode
		AND Workflow = @Workflow
		AND DateRptReceived >= @DateRptReceived

	SET @Err = @@Error

	RETURN @Err
END
