CREATE PROCEDURE [proc_GetServiceComboItems]

@ClientCode int

AS

SELECT DISTINCT [tblServices].[servicecode], [tblServices].[description] FROM tblClient
	INNER JOIN tblClientOffice ON tblClient.ClientCode = tblClientOffice.ClientCode AND (tblClientOffice.ClientCode = @ClientCode)
	INNER JOIN tblServiceOffice ON tblClientOffice.OfficeCode = tblServiceOffice.OfficeCode
	INNER JOIN tblServices ON tblServiceOffice.ServiceCode = tblServices.ServiceCode
	WHERE (tblServices.PublishOnWeb = 1)
	ORDER BY [tblServices].[Description]

