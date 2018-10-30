
CREATE PROCEDURE [proc_GetProblemComboItems]

AS

SELECT problemcode, description from tblProblem 
WHERE PublishOnWeb = 1
	AND Status = 'Active'
ORDER BY description

