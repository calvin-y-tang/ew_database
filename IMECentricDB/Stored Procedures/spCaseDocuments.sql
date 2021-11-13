CREATE PROC [dbo].[spCaseDocuments] ( @CaseNbr INTEGER )
AS 
    DECLARE @MasterCaseNbr INTEGER 
	
	SET @MasterCaseNbr = (SELECT MasterCaseNbr FROM tblCase WHERE CaseNbr = @CaseNbr)
	
	SELECT  
		@CaseNbr as CaseNbr, 
		CD.CaseNbr AS DocCaseNbr,
		CD.Document,
		CD.Type,
		CD.Description,
		CD.sFilename,
		CD.DateAdded,
		CD.UserIDAdded,
		CD.PublishOnWeb,
		CD.DateEdited,
		CD.UserIDEdited,
		CD.SeqNo,
		PublishedTo,
		Source,
		FileSize,
		Pages,
		FolderID,
		SubFolder, 
		CD.CaseDocTypeID, 
		CDT.FilterKey,
		CD.SharedDoc
    FROM
		tblCaseDocuments AS CD
		LEFT OUTER JOIN tblCaseDocType AS CDT ON CDT.CaseDocTypeID = CD.CaseDocTypeID
    WHERE 
		CD.Type<>'Report' 
	 AND (CD.CaseNbr=@CaseNbr OR (CD.SharedDoc=1 AND CD.MasterCaseNbr=@MasterCaseNbr AND @MasterCaseNbr IS NOT NULL))
    ORDER BY CD.DateAdded DESC
