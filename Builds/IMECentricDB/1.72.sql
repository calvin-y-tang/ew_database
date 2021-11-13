
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByCaseNbr]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByCaseNbr];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByCaseNbr]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + ' - ' + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Doctor,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.CaseNbr = @CaseNbr
		
	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByTransCode]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByTransCode]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByTransCode];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByTransCode]
(
	@TransCode int,
	@TranscriptionStatusCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	(SELECT COUNT(TranscriptionJobID) FROM tblTranscriptionJob WHERE tblTranscriptionJob.TransCode = @TransCode AND TranscriptionStatusCode = @TranscriptionStatusCode) AS 'TransCount',
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + ' - ' + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblTranscription.TransCompany
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.TransCode = @TransCode
		AND TranscriptionStatusCode = @TranscriptionStatusCode
	SET @Err = @@Error

	RETURN @Err
END
GO


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByTranscriptionJobID]    Script Date: 2/16/2010 11:24:36 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByTranscriptionJobID]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByTranscriptionJobID];
GO

CREATE PROCEDURE [proc_TranscriptionJob_LoadByTranscriptionJobID]
(
	@TranscriptionJobID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT 
	
	tblTranscriptionJob.*,
	tblCase.Priority,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName + ' - ' + (SELECT TOP 1 Description FROM tblSpecialty WHERE SpecialtyCode = (SELECT SpecialtyCode FROM tblDoctorSpecialty WHERE DoctorCode = tblCase.DoctorCode)) AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblExaminee.LastName + ', ' + tblExaminee.FirstName AS 'Examinee',
	tblTranscription.TransCompany,
	tblCase.ApptDate
	
	FROM tblTranscriptionJob 
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr	 
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJob.TranscriptionJobID = @TranscriptionJobID
		
	SET @Err = @@Error

	RETURN @Err
END
GO


--Add a Rank field to tblPriority 
ALTER TABLE [tblPriority]
  ADD [Rank] INTEGER
GO

UPDATE tblPriority SET RANK=100
GO

--Create a new stored proc to request the next transcription job
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'proc_RequestNextTranscriptionJob') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
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
        --Look for the next availabel job in the queue (where TranscriptionStatusCode is 2 and TransCode is -1)
        --Order the jobs by priority ranking first, in case the priority of the case is not set, default it to 100
        --then order by AppTime then TranscriptionJobID
        SET @transcriptionJobID = ( SELECT TOP 1
                                            J.TranscriptionJobID
                                    FROM    tblTranscriptionJob AS J ( UPDLOCK )
                                            INNER JOIN tblCase AS C ON J.CaseNbr = C.CaseNbr
                                            LEFT OUTER JOIN tblPriority AS P ON C.Priority = P.PriorityCode
                                    WHERE   J.TransCode = -1
                                            AND TranscriptionStatusCode = 2
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
 
------------------------------------
-- SQL Changes for WALI EDI update
------------------------------------

/* tblCodes Changes */
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'SubmitterID', '0186386')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'SubmitterName', 'ExamWorks Inc')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'SubmitterContactName', 'Xanthia Clark')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'SubmitterContactPhone', '8884525581')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'SubmitterContactEmail', 'Xanthia.Clark@examworks.com')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'ReceiverID', '916001069')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'ReceiverName', 'WASHINGTON STATE DEPT OF LABOR & INDUSTRIES')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'ReceiverCSZ', 'OLYMPIA|WA|98504')
INSERT INTO [tblCodes] ([Category], [SubCategory], [Value]) VALUES ('WALI', 'Mode', 'P')

/* tblCompany changes */
UPDATE [tblCompany] 
   SET [EDIFormat] = 'Washington L&I' 
 WHERE [EDIFormat] = 'CMS-1500 L&I'
 GO
 
--------------------------------------
--New fields for custom reporting
--------------------------------------
ALTER TABLE tblEWFlashCategory ADD
Mapping1 VARCHAR(10) NULL,
Mapping2 VARCHAR(10) NULL,
Mapping3 VARCHAR(10) NULL
GO
ALTER TABLE tblEWServiceType ADD
Mapping1 VARCHAR(10) NULL,
Mapping2 VARCHAR(10) NULL,
Mapping3 VARCHAR(10) NULL
GO

--------------------------------------
--Changes by Gary for Transcription Portal
--------------------------------------
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
			AND TranscriptionStatusCode = 2
        ORDER BY ISNULL(P.Rank, 100),  C.ApptTime, J.TranscriptionJobID

		
	SET @Err = @@Error

	RETURN @Err
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[proc_TranscriptionJob_LoadByPrimaryKey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
    DROP PROCEDURE [proc_TranscriptionJob_LoadByPrimaryKey];
GO

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
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr
	WHERE
		([TranscriptionJobID] = @TranscriptionJobID)
		
	SET @Err = @@Error

	RETURN @Err
END
GO


UPDATE tblControl SET DBVersion='1.72'
GO
