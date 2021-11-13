CREATE PROCEDURE [proc_GetClientsByCompany]

@CompanyCode int

AS

SELECT DISTINCT lastname + ', ' + firstname + ' ' + tblCompany.intname name, clientcode FROM tblclient
	INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
	INNER JOIN tblWebUser ON tblClient.ClientCode = tblWebUser.IMECentricCode and tblWebUser.UserType = 'CL'
	WHERE tblClient.CompanyCode = @CompanyCode
		AND tblClient.Status = 'Active'
	ORDER BY name