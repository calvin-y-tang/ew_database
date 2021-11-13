CREATE PROCEDURE [proc_GetSuperUserComboItems]

AS

SELECT DISTINCT tblwebuseraccount.webuserid AS webID, tblCompany.intname company, tblCompany.intname + ' - ' + lastname + ', ' + firstname name
	FROM tblclient
	INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	WHERE tblClient.Status = 'Active'
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(company,'N/A') company, ISNULL(company,'N/A') + ' - ' +  lastname + ', ' + firstname name
	FROM tblCCAddress
	INNER JOIN tblwebuseraccount ON tblCCAddress.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(companyname,'N/A') company, ISNULL(companyname,'N/A') + ' - ' + lastname + ', ' + firstname  name
	FROM tblDoctor
	INNER JOIN tblwebuseraccount ON tblDoctor.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
UNION
SELECT DISTINCT tblwebuseraccount.webuserid AS webID, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name
	FROM tblTranscription
	INNER JOIN tblwebuseraccount ON tblTranscription.WebUserID = tblwebuseraccount.WebUserID and isuser = 1 AND tblWebUserAccount.UserType = 'TR'
ORDER BY company, name