CREATE PROCEDURE proc_RequestNextTranscriptionJob
    (
      @transCode INT ,
      @dateAssigned DATETIME ,
      @transcriptionJobID INT OUTPUT 
    )
AS 
    BEGIN
        SET NOCOUNT ON
        DECLARE @error INT
		DECLARE @workflow INT

        BEGIN TRAN
        --Look for the next availabel job in the queue (where TranscriptionStatusCode is 20 and TransCode is -1)
        --Order the jobs by priority ranking first, in case the priority of the case is not set, default it to 100
        --then order by AppTime then TranscriptionJobID
        SET @transcriptionJobID = ( SELECT TOP 1
                                            J.TranscriptionJobID
                                    FROM    tblTranscriptionJob AS J ( UPDLOCK )
                                            INNER JOIN tblCase AS C ON J.CaseNbr = C.CaseNbr
                                            LEFT OUTER JOIN tblPriority AS P ON C.Priority = P.PriorityCode
                                    WHERE   J.TransCode = -1
                                            AND TranscriptionStatusCode = 20
                                    ORDER BY ISNULL(P.Rank, 100) ,
                                            C.ApptTime ,
                                            J.TranscriptionJobID
                                  )
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done
        --If no transcription job available, exit procedure
        IF @transcriptionJobID IS NULL 
            GOTO Done
		
		--Get transcription group workflow
		SELECT @workflow = workflow FROM tblTranscription WHERE TransCode = @transCode

		--Set values in transcription job and case records
        UPDATE TJ
        SET     TransCode = @transCode ,
                DateAssigned = DATEADD(hh, dbo.fnGetUTCOffset(ISNULL(TD.EWTimeZoneID, C.EWTimeZoneID), GETUTCDATE()), GETUTCDATE()),
				Workflow = @workflow
		FROM tblTranscriptionJob AS TJ
		LEFT OUTER JOIN tblEWTransDept AS TD ON TD.EWTransDeptID = TJ.EWTransDeptID
		LEFT OUTER JOIN tblControl AS C ON 1=1
        WHERE   TranscriptionJobID = @transcriptionJobID
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

        UPDATE  tblCase
        SET     TransCode = @transCode
        WHERE   CaseNbr = ( SELECT  CaseNbr
                            FROM    tblTranscriptionJob
                            WHERE   TranscriptionJobID = @transcriptionJobID
                          )
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		--Commit transaction
        COMMIT TRAN
 
        Done:
        IF @error <> 0 
            SET @transcriptionJobID = NULL
        IF @transcriptionJobID IS NULL 
            ROLLBACK TRAN

        SET NOCOUNT OFF
        RETURN @error
    END
