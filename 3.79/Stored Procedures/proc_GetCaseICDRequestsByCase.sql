
CREATE PROCEDURE [proc_GetCaseICDRequestsByCase]

@CaseNbr int

AS 

SELECT * FROM tblCaseICDRequest 

	WHERE casenbr = @CaseNbr

