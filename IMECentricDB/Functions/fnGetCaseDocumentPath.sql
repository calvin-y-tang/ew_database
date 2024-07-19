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
	DECLARE @subFolder VARCHAR(32);
	
     WITH CaseFolderCTE AS
          (SELECT
              tblCase.CaseNbr AS CaseNbr, 
              tblCase.DateAdded AS DateAdded,
              IIF(@docType = 'invoice' OR @docType = 'voucher', 
                    IIF(PC.AcctDocFolderID IS NOT NULL AND PC.AcctDocFolderID > 0, PC.AcctDocFolderID, IME.AcctDocFolderID), 
                    IIF(PC.CaseDocFolderID IS NOT NULL AND PC.CaseDocFolderID > 0, PC.CaseDocFolderID, IME.CaseDocFolderID)
              ) AS FolderID
          FROM tblcase with (nolock)
               LEFT OUTER JOIN tblOffice with (nolock) ON tblCase.OfficeCode = tblOffice.OfficeCode
               INNER JOIN tblIMEData AS IME with (nolock) ON ISNULL(tblOffice.IMECode, 1) = IME.IMECode
               INNER JOIN tblClient AS cl with (nolock) ON cl.ClientCode = ISNULL(tblCase.BillClientCode, tblcase.ClientCode)
               INNER JOIN tblCompany AS co with (nolock) ON co.CompanyCode = cl.CompanyCode
               INNER JOIN tblEWParentCompany AS pc with (nolock) ON pc.ParentCompanyID = co.ParentCompanyID
          WHERE CaseNbr = @caseNbr 
            AND CaseNbr IS NOT NULL
          )
     SELECT @path = fldr.PathName 
			+ RTRIM(YEAR(DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, CaseNbr),

			@folderID = fldr.FolderID,
			
            @subFolder = RTRIM(YEAR(DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, CaseNbr) + '\'		
     FROM CaseFolderCTE
               LEFT OUTER JOIN tblEWFolderDef AS fldr ON fldr.FolderID = CaseFolderCTE.FolderID
	
     INSERT @documentInfo
		SELECT	@path as DocumentPath,
				@folderID as FolderID, 
				@subFolder as SubFolder
	
     RETURN
END

