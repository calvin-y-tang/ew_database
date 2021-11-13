

CREATE PROCEDURE [proc_GetWebUserUserName]

@WebUserEmail varchar(70)

AS

SELECT 'tblClient' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblClient.clientcode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblClient ON tblWebUser.IMECentricCode = tblClient.clientcode AND tblClient.email = @WebUserEmail
UNION
SELECT 'tblCCAddress' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblCCAddress.cccode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblCCAddress ON tblWebUser.IMECentricCode = tblCCAddress.cccode AND tblCCAddress.email = @WebUserEmail
UNION
SELECT 'tblDoctor' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblDoctor.doctorcode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblDoctor ON tblWebUser.IMECentricCode = tblDoctor.doctorcode AND tblDoctor.emailAddr = @WebUserEmail
UNION
SELECT 'tblCCAddress' AS TableName, tblWebUser.WebUserID, tblWebUser.UserID, tblWebUser.Password, tblWebUser.UserType, tblTranscription.transcode AS IMECentricCode 
 FROM tblWebUser 
 INNER JOIN tblTranscription ON tblWebUser.IMECentricCode = tblTranscription.transcode AND tblTranscription.email = @WebUserEmail

