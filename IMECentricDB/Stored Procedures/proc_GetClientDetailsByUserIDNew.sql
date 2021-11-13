

CREATE PROCEDURE [proc_GetClientDetailsByUserIDNew] 

@WebUserID int 

AS 

SELECT tblWebUser.WebUserID, 
tblClient.*,
tblCompany.extname 
FROM tblCompany 
INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode 
INNER JOIN tblWebUserAccount ON tblClient.WebUserID = tblWebUserAccount.WebUserID AND tblWebUserAccount.IsUser = 1
INNER JOIN tblWebUser ON tblWebUserAccount.WebUserID = tblWebUser.WebUserID 
WHERE tblWebUser.WebUserID= @WebUserID

