
CREATE PROCEDURE [proc_GetEWCoverLetterComboItems]

@CompanyCode int,
@CaseTypeCode int,
@StateCode char(2)

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int


SELECT DISTINCT tblEWCoverLetter.ExternalName, tblEWCoverLetter.EWCoverLetterID 
FROM tblEWCoverLetter 
	INNER JOIN tblCompanyCoverLetter ON (tblEWCoverLetter.EWCoverLetterID = tblCompanyCoverLetter.EWCoverLetterID) 
	INNER JOIN tblEWCoverLetterBusLine ON (tblEWCoverLetter.EWCoverLetterID = tblEWCoverLetterBusLine.EWCoverLetterID) 
	INNER JOIN tblCaseType ON (tblEWCoverLetterBusLine.EWBusLineID = tblCaseType.EWBusLineID OR tblEWCoverLetterBusLine.EWBusLineID = -1) 
	INNER JOIN tblEWCoverLetterState ON (tblEWCoverLetter.EWCoverLetterID = tblEWCoverLetterState.EWCoverLetterID) 
	WHERE (tblEWCoverLetter.Active = 1)
	AND (tblCaseType.Code = @CaseTypeCode OR tblEWCoverLetterBusLine.EWBusLineID = -1)
	AND (tblCompanyCoverLetter.CompanyCode = @CompanyCode OR tblCompanyCoverLetter.CompanyCode = -1)
	AND (tblEWCoverLetterState.StateCode = @StateCode OR tblEWCoverLetterState.StateCode = '-1')
	ORDER BY ExternalName

	SET @Err = @@Error

	RETURN @Err
END
