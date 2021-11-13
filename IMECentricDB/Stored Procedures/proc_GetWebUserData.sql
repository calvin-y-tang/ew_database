

CREATE PROCEDURE [proc_GetWebUserData]

@WebUserID int,
@UserType varchar(2)

AS

IF @UserType = 'CL'
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblClient.firstname + ' ' + tblClient.lastname AS FullName,
  tblClient.email,
  tblCompany.extName AS CompanyName
 FROM tblCompany
  INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode
  INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('OP')
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND OPType = 'OP'
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType IN ('AT','CC')
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblCCAddress.firstname + ' ' + tblCCAddress.lastname AS FullName,
  tblCCAddress.email,
  tblCCAddress.company AS CompanyName
 FROM tblWebUser
  INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'DR'
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblDoctor.firstname + ' ' + tblDoctor.lastname AS FullName,
  tblDoctor.emailaddr as email,
  tblDoctor.companyname AS CompanyName
 FROM tblWebUser
  INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode
 WHERE tblWebUser.WebUserID = @WebUserID 
END
ELSE IF @UserType = 'TR'
BEGIN
 SELECT 
  tblWebUser.UserID,
  tblWebUser.Password,
  tblTranscription.transcompany AS FullName,
  tblTranscription.Email,
  tblTranscription.transcompany AS CompanyName
 FROM tblWebUser
  INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode
 WHERE tblWebUser.WebUserID = @WebUserID 
END


