

CREATE PROCEDURE [proc_GetCaseProblemsByCase]

@CaseNbr int

AS 

SELECT * 
FROM tblCaseProblem 
 INNER JOIN vwtblProblem AS tblProblem ON tblCaseProblem.Problemcode = tblProblem.Problemcode 
 WHERE casenbr = @CaseNbr

