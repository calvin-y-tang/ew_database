
CREATE PROCEDURE [proc_GetNextAvailableTranscription]

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 J.TranscriptionJobID FROM tblTranscriptionJob AS J ( UPDLOCK )
        INNER JOIN tblCase AS C ON J.CaseNbr = C.CaseNbr
        LEFT OUTER JOIN tblPriority AS P ON C.Priority = P.PriorityCode
        WHERE   J.TransCode = -1
			AND TranscriptionStatusCode = 20
        ORDER BY ISNULL(P.Rank, 100),  C.ApptTime, J.TranscriptionJobID

		
	SET @Err = @@Error

	RETURN @Err
END
