

CREATE PROCEDURE [proc_GetSuperUserAvailUserListItems]

@WebUserID int

AS

SELECT DISTINCT cast(clientcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
tblCompany.intname company, firstname + ' ' + lastname + ' - ' + tblCompany.intname name 
 FROM tblclient 
 INNER JOIN tblwebuseraccount ON tblClient.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'CL'
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
 WHERE tblwebuseraccount.WebUserID <> @WebUserID
UNION
SELECT DISTINCT cast(cccode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblwebuseraccount ON tblCCAddress.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
UNION
SELECT DISTINCT cast(doctorcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblwebuseraccount ON tblDoctor.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
UNION
SELECT DISTINCT cast(transcode as varchar(10)) + '|' + cast(tblwebuseraccount.webuserid as varchar(10)) + '^' + cast(tblwebuseraccount.usertype as varchar(10)) AS WebUserID, 
ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblwebuseraccount ON tblTranscription.webuserid = tblwebuseraccount.webuserid and isuser = 1 AND tblWebUserAccount.UserType = 'TR' 
 WHERE tblwebuseraccount.WebUserID <> @WebUserID 
ORDER BY company, name



