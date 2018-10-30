
CREATE PROCEDURE [proc_GetMostRecentCoverLetterRecord] 

@CaseNbr int

AS

SELECT TOP 1 * FROM tblCaseDocuments 
	WHERE casenbr = @CaseNbr 
		AND DESCRIPTION = 'Cover Letter' 
			ORDER BY dateadded DESC

