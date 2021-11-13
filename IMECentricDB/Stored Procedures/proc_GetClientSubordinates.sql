CREATE PROCEDURE [proc_GetClientSubordinates]

@WebUserID int

AS

SELECT DISTINCT lastname + ', ' + firstname + ' ' + tblCompany.intname name, clientcode FROM tblclient
	INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
	WHERE clientcode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID = @WebUserID)
	AND tblClient.Status = 'Active'
	ORDER BY name