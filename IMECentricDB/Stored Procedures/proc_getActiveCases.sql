CREATE PROCEDURE [proc_getActiveCases]
@WebUserID int

AS 

SELECT DISTINCT
	COUNT(DISTINCT tblCase.CaseNbr) AS NbrofCases, 
	tblWebQueues.statuscode AS WebStatus, 
	tblWebQueues.description AS WebDescription, 
	tblWebQueues.displayorder
FROM tblCase
	INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
	INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
	INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
		AND tblPublishOnWeb.tabletype = 'tblCase'
		AND tblPublishOnWeb.PublishOnWeb = 1 
	INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
		AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType	
		AND tblWebUserAccount.WebUserID = @WebUserID
WHERE (tblCase.status <> 0)
GROUP BY 
	tblWebQueues.statuscode, 
	tblWebQueues.description, 
	tblWebQueues.displayorder
ORDER BY 
	tblWebQueues.displayorder