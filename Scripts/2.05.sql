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
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
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


/****** Object:  StoredProcedure [proc_TranscriptionJob_LoadByCaseNbr]    Script Date: 2/16/2010 11:24:36 PM ******/
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
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Doctor,
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
	tblDoctor.Prefix + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
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



ALTER TABLE tblIMEData
 ADD TaxCalcMethod INT
GO
UPDATE tblIMEData SET TaxCalcMethod=1
GO


UPDATE tblControl SET DBVersion='2.05'
GO
