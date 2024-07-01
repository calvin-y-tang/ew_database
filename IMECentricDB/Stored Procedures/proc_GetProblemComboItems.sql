
CREATE PROCEDURE [proc_GetProblemComboItems]

AS

	SELECT problemcode, description 
	  FROM vwtblProblem AS tblProblem 
	 WHERE PublishOnWeb = 1
	   AND Status = 'Active'
	ORDER BY description

