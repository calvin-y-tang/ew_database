

CREATE PROCEDURE [proc_GetExamineeComboItemsByWebUserIDNew]

@WebUserID int

AS

SELECT DISTINCT tblExaminee.chartnbr, lastname + ', ' + firstname AS ExamineeName 
FROM tblExaminee
INNER JOIN tblCase ON tblExaminee.chartnbr = tblCase.chartnbr 
INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
 AND tblPublishOnWeb.tabletype = 'tblCase'
 AND tblPublishOnWeb.PublishOnWeb = 1 
INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
 AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType 
 AND tblWebUserAccount.WebUserID = @WebUserID 
ORDER BY ExamineeName


