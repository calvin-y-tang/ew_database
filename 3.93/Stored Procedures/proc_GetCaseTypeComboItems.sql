CREATE PROCEDURE [proc_GetCaseTypeComboItems]

@ClientCode int

AS

SELECT DISTINCT [tblCaseType].[code], [tblCaseType].[description] FROM tblClient
	INNER JOIN tblClientOffice ON tblClient.ClientCode = tblClientOffice.ClientCode AND (tblClientOffice.ClientCode = @ClientCode)
	INNER JOIN tblCaseTypeOffice ON tblClientOffice.OfficeCode = tblCaseTypeOffice.OfficeCode
	INNER JOIN tblCaseType ON tblCaseTypeOffice.CaseType = tblCaseType.Code
	WHERE (tblCaseType.PublishOnWeb = 1)
	ORDER BY [tblCaseType].[Description]



