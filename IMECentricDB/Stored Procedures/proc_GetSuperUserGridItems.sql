

CREATE PROCEDURE [proc_GetSuperUserGridItems]

AS

SELECT DISTINCT tblWebUser.*, tblCompany.extname as company, firstname + ' ' + lastname + ' - ' + tblCompany.extname name 
 FROM tblclient 
 INNER JOIN tblWebUser ON tblClient.clientcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'CL'
 INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
UNION
SELECT DISTINCT tblWebUser.*, company, firstname + ' ' + lastname + ' - ' + ISNULL(company,'N/A') name 
 FROM tblCCAddress 
 INNER JOIN tblWebUser ON tblCCAddress.cccode = tblWebUser.IMECentricCode AND (tblWebUser.UserType = 'AT' OR tblWebUser.UserType = 'CC')
UNION
SELECT DISTINCT tblWebUser.*, companyname as company, firstname + ' ' + lastname + ' - ' + ISNULL(companyname,'N/A') name 
 FROM tblDoctor 
 INNER JOIN tblWebUser ON tblDoctor.doctorcode = tblWebUser.IMECentricCode AND (tblWebUser.UserType = 'DR' OR tblWebUser.UserType = 'OP')
UNION
SELECT DISTINCT tblWebUser.*, transcompany as company, ISNULL(transcompany,'N/A') name 
 FROM tblTranscription 
 INNER JOIN tblWebUser ON tblTranscription.transcode = tblWebUser.IMECentricCode AND tblWebUser.UserType = 'TR' 
ORDER BY company, name




