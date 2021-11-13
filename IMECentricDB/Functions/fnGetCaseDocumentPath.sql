/*
	Table-Valued Function that will return the fully qualified invoice/voucher or document path
	office code, EW Folder ID and SubFolder name for the CaseNbr specified

	IMPORTANT: This Function is used by all EW Web Portals! DO NOT change this function's 
	signature without making cooresponding changes/suppoting changes to the portals (National, BU and InfoC)

*/
CREATE FUNCTION [dbo].[fnGetCaseDocumentPath]
(
  @caseNbr INT,			
  @docType VARCHAR(32)	
)
RETURNS @documentInfo TABLE
(
	DocumentPath VarChar(500),
	FolderID INT,
	SubFolder VarChar(32)
)
AS
BEGIN
	DECLARE @path VARCHAR(500)	
	DECLARE @folderID INT
	DECLARE @subFolder VARCHAR(32)
	IF (@docType = 'invoice' or @docType = 'voucher') 
	BEGIN
		-- accounting document folder
		SELECT @path = tblEWFolderDef.PathName 
			+ RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr),
			@folderID = tblEWFolderDef.FolderID,
			@subFolder = RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr) + '\'		
		  FROM tblCase
				LEFT OUTER JOIN tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
				INNER JOIN tblIMEData on ISNULL(tblOffice.IMECode, 1) = tblIMEData.IMECode
				INNER JOIN tblEWFolderDef on tblIMEData.AcctDocFolderID = tblEWFolderDef.FolderID
		  WHERE CaseNbr = @caseNbr 
			AND CaseNbr IS NOT NULL		
	END
	ELSE
	BEGIN
		-- case document folder
		SELECT @path = tblEWFolderDef.PathName 
			+ RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr),
			@folderID = tblEWFolderDef.FolderID,
			@subFolder = RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr) + '\'		
		  FROM tblCase
				LEFT OUTER JOIN tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
				INNER JOIN tblIMEData on ISNULL(tblOffice.IMECode, 1) = tblIMEData.IMECode
				INNER JOIN tblEWFolderDef on tblIMEData.CaseDocFolderID = tblEWFolderDef.FolderID
		  WHERE CaseNbr = @caseNbr 
			AND CaseNbr IS NOT NULL
	END	
	INSERT @documentInfo
		SELECT	@path as DocumentPath,
				@folderID as FolderID, 
				@subFolder as SubFolder
	RETURN
END

