
--New fields for Info Centric

ALTER TABLE [tblEWFacilityGroupSummary]
  ADD [FacilitySeqNo] INTEGER
GO

ALTER TABLE [tblEWFacilityGroupSummary]
  ADD [RegionSeqNo] INTEGER
GO

ALTER TABLE [tblEWFacilityGroupSummary]
  ADD [SubRegionSeqNo] INTEGER
GO

ALTER TABLE [tblEWFacilityGroupSummary]
  ADD [BusUnitSeqNo] INTEGER
GO


--New fields to track transcription pages and lines
ALTER TABLE [tblTranscriptionJob]
  ADD [ReportPages] INTEGER
GO

ALTER TABLE [tblTranscriptionJob]
  ADD [ReportLines] INTEGER
GO




--Change report pages to report words
ALTER TABLE tblTranscriptionJob
  ADD ReportWords INTEGER
GO

ALTER TABLE tblTranscriptionJob
 DROP COLUMN ReportPages
GO

--Change transcription status number
DELETE FROM tblTranscriptionStatus
GO
SET IDENTITY_INSERT [dbo].[tblTranscriptionStatus] ON
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (10, 'New')
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (20, 'Assigned')
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (30, 'Transcribing')
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (40, 'Report Received')
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (50, 'Completed')
INSERT INTO [dbo].[tblTranscriptionStatus] ([TranscriptionStatusCode], [Descrip]) VALUES (60, 'Canceled')
SET IDENTITY_INSERT [dbo].[tblTranscriptionStatus] OFF
GO

DROP PROCEDURE dbo.proc_RequestNextTranscriptionJob
GO
CREATE PROCEDURE dbo.proc_RequestNextTranscriptionJob
    (
      @transCode INT ,
      @dateAssigned DATETIME ,
      @transcriptionJobID INT OUTPUT 
    )
AS 
    BEGIN
        SET NOCOUNT ON
        DECLARE @error INT

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
		
		--Set values in transcription job and case records 
        UPDATE  tblTranscriptionJob
        SET     TransCode = @transCode ,
                DateAssigned = @dateAssigned
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
GO





UPDATE tblControl SET DBVersion='1.76'
GO
