

CREATE PROCEDURE [proc_getActiveAdminCases]

AS SELECT DISTINCT
 COUNT(*) AS NbrofCases, 
 tblWebQueues.statuscode AS WebStatus, 
 tblWebQueues.description AS WebDescription, 
    tblWebQueues.displayorder
FROM tblCase
 INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
 INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
WHERE (tblCase.status <> 0)
AND tblCase.casenbr IN (SELECT DISTINCT TableKey FROM tblPublishOnWeb
  WHERE tblPublishOnWeb.TableType = 'tblCase' 
  AND tblPublishOnWeb.PublishOnWeb = 1) 
GROUP BY 
 tblWebQueues.statuscode, 
 tblWebQueues.description, 
 tblWebQueues.displayorder
ORDER BY 
 tblWebQueues.displayorder


