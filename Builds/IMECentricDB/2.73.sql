
GO
PRINT N'Altering [dbo].[tblCaseDocuments]...';


GO
ALTER TABLE [dbo].[tblCaseDocuments]
    ADD [FolderID]  INT          NULL,
        [SubFolder] VARCHAR (32) NULL;


GO
PRINT N'Altering [dbo].[tblCompany]...';


GO
ALTER TABLE [dbo].[tblCompany]
    ADD [UseNotification] BIT CONSTRAINT [DF_tblCompany_UseNotification] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblDoctor]...';


GO
ALTER TABLE [dbo].[tblDoctor]
    ADD [DrMedRecsInDays] INT CONSTRAINT [DF_tblDoctor_DrMedRecsInDays] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblIMEData]...';


GO
ALTER TABLE [dbo].[tblIMEData]
    ADD [AcctDocFolderID] INT NULL,
        [CaseDocFolderID] INT NULL;


GO
PRINT N'Creating [dbo].[fnGetCaseDocument]...';


GO
/*
	Scalar-Valued Function that will return the full path, including document filename
	for a document records specified by the CaseDocument SeqNo parameter
*/
CREATE FUNCTION [dbo].[fnGetCaseDocument]
(
	@caseDocSeqNo int
)
RETURNS VARCHAR(500)
AS
BEGIN
	DECLARE @Path VARCHAR(500)
	IF (@caseDocSeqNo > 0) 
	BEGIN
		SELECT @Path = tblEWFolderDef.PathName + tblCaseDocuments.SubFolder + tblCaseDocuments.sFilename
		  FROM tblCaseDocuments 
			   INNER JOIN tblEWFolderDef on tblCaseDocuments.FolderID = tblEWFolderDef.FolderID
		 WHERE tblCaseDocuments.SeqNo = @caseDocSeqNo
		   AND @caseDocSeqNo IS NOT NULL 
	END 
	RETURN @Path
END
GO
PRINT N'Creating [dbo].[fnGetCaseDocumentPath]...';


GO
/*
	Table-Valued Function that will return the fully qualified invoice/voucher or document path
	office code, EW Folder ID and SubFolder name for the CaseNbr specified
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
				INNER JOIN tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
				INNER JOIN tblIMEData on tblOffice.IMECode = tblIMEData.IMECode
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
				INNER JOIN tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
				INNER JOIN tblIMEData on tblOffice.IMECode = tblIMEData.IMECode
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
GO

UPDATE tblControl SET DBVersion='2.73'
GO
