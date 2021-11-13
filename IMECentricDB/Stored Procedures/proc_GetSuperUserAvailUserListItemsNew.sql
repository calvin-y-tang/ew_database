CREATE PROCEDURE [proc_GetSuperUserAvailUserListItemsNew]

@WebUserID int

AS

SELECT DISTINCT clientcode as imecentriccode, tblwebuseraccount.webuserid,  tblwebuseraccount.usertype,
tblCompany.intname company, firstname + ' ' + lastname name
	FROM tblclient
	INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	WHERE tblwebuseraccount.WebUserID <> @WebUserID AND tblClient.Status = 'Active'
UNION
SELECT DISTINCT cccode as imecentriccode, tblwebuseraccount.webuserid, tblwebuseraccount.usertype,
ISNULL(company,'N/A') company, firstname + ' ' + lastname name
	FROM tblCCAddress
	INNER JOIN tblwebuseraccount ON tblCCAddress.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
	WHERE tblwebuseraccount.WebUserID <> @WebUserID
UNION
SELECT DISTINCT doctorcode as imecentriccode, tblwebuseraccount.webuserid, tblwebuseraccount.usertype,
ISNULL(companyname,'N/A') company, firstname + ' ' + lastname name
	FROM tblDoctor
	INNER JOIN tblwebuseraccount ON tblDoctor.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
	WHERE tblwebuseraccount.WebUserID <> @WebUserID
UNION
SELECT DISTINCT transcode as imecentriccode, tblwebuseraccount.webuserid, tblwebuseraccount.usertype,
ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name
	FROM tblTranscription
	INNER JOIN tblwebuseraccount ON tblTranscription.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'TR'
	WHERE tblwebuseraccount.WebUserID <> @WebUserID
ORDER BY company, name