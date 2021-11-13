

--Changes by Gary for transcription status number
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_CheckAssignedPendingTranscriptionsByTransCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_CheckAssignedPendingTranscriptionsByTransCode];
GO

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
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_GetNextAvailableTranscription]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_GetNextAvailableTranscription];
GO

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
GO


--Add a setting to determine the offset hours between the users local time and the server time
ALTER TABLE [tblControl]
  ADD [OffsetHours] INTEGER
GO



UPDATE tblControl SET DBVersion='1.77'
GO
