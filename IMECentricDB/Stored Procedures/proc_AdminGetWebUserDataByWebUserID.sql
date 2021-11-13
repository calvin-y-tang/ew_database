

CREATE PROCEDURE [proc_AdminGetWebUserDataByWebUserID]

@WebUserID int,
@UserType varchar(2)

AS

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.*,
  tblClient.firstname + ' ' + tblClient.lastname AS FullName,
  tblClient.email,
  tblCompany.intname AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblClient.clientcode
   AND tblWebUserAccount.UserType = 'CL'  
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.*,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.DoctorCode AND OPType = 'OP'
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'OP'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.*,
  tblCCAddress.firstname + ' ' + tblCCAddress.lastname AS FullName,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblCCAddress.cccode
   AND tblWebUserAccount.UserType IN ('AT','CC')   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.*,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.DoctorCode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblDoctor.doctorcode
   AND tblWebUserAccount.UserType = 'DR'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.*,
  tblTranscription.transcompany AS FullName,
  tblTranscription.Email,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode
  INNER JOIN tblWebUserAccount ON tblWebUser.WebUserID = tblWebUserAccount.WebUserID
   AND tblWebUserAccount.IsActive = 1
   AND tblWebUserAccount.IsUser = 1
   AND tblWebUserAccount.UserCode = tblTranscription.Transcode
   AND tblWebUserAccount.UserType = 'TR'   
 WHERE tblWebUser.WebUserID = @WebUserID 
END

