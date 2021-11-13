

CREATE PROCEDURE [proc_AdminGetUserGrid]

AS

SET NOCOUNT OFF
DECLARE @Err int

  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, tblCompany.intname company, firstname + ' ' + lastname + ' - ' +  tblCompany.intname name
        FROM tblclient
        INNER JOIN tblwebuser ON tblclient.clientcode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'CL')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'        
        INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode

  UNION
  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(company,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name
        FROM tblCCAddress
        INNER JOIN tblwebuser ON tblCCAddress.cccode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'AT' OR tblWebUser.UserType = 'CC')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND (tblWebUserAccount.UserType = 'AT' OR tblWebUserAccount.UserType = 'CC')        

  UNION
  SELECT DISTINCT lastname, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(companyname,'N/A') company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name
        FROM tblDoctor
        INNER JOIN tblwebuser ON tblDoctor.doctorcode = tblwebuser.IMECentricCode AND (tblWebUser.UserType = 'DR' OR tblWebUser.UserType = 'OP')
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND (tblWebUserAccount.UserType = 'DR' OR tblWebUserAccount.UserType = 'OP')           

  UNION
  SELECT DISTINCT transcompany, tblWebUser.LastLoginDate, tblWebUser.webuserid AS webID, tblWebUser.UserType, ISNULL(transcompany,'N/A') company, ISNULL(transcompany,'N/A') name
        FROM tblTranscription
        INNER JOIN tblwebuser ON tblTranscription.transcode = tblwebuser.IMECentricCode AND tblWebUser.UserType = 'TR'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.transcode
   AND tblWebUserAccount.UserType = 'TR'         

SET @Err = @@Error
RETURN @Err
 


