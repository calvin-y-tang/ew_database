CREATE PROCEDURE [proc_TranscriptionJobDictation_LoadByTranscriptionJobID]
(
	@TranscriptionJobID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT

	tblTranscriptionJob.*,
	tblTranscriptionJobDictation.*,
	tblCase.Priority,
	tblCase.ExtCaseNbr,
	tblCompany.IntName AS 'Company',
	tblServices.Description + ' - ' + tblCaseType.Description AS 'Service',
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
	tblCase.Jurisdiction AS 'State',
	tblExaminee.LastName + ', ' + tblExaminee.FirstName AS 'Examinee',
	tblTranscription.TransCompany,
	tblCase.ApptDate,
	'Dictation' AS 'FileType'

	FROM tblTranscriptionJobDictation
		INNER JOIN tblTranscriptionJob ON tblTranscriptionJobDictation.TranscriptionJobID = tblTranscriptionJob.TranscriptionJobID
		INNER JOIN tblCase ON tblTranscriptionJob.CaseNbr = tblCase.CaseNbr
		INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
		INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
		INNER JOIN tblTranscription ON tblTranscriptionJob.TransCode = tblTranscription.TransCode
		INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
		LEFT JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
		LEFT JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
		LEFT JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code

	WHERE tblTranscriptionJobDictation.TranscriptionJobID = @TranscriptionJobID

	SET @Err = @@Error

	RETURN @Err
END