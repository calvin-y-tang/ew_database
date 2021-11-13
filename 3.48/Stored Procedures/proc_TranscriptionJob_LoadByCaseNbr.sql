
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
	ISNULL(tblDoctor.Prefix, '') + ' ' + tblDoctor.FirstName + ' ' + tblDoctor.LastName AS Provider,
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
