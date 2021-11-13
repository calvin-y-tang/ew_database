CREATE VIEW [dbo].[vwCaseDocuments]
AS 
	
	SELECT  
		casenbr AS DocCaseNbr,
		document,
		type,
		CD.description,
		sfilename,
		dateadded,
		useridadded,
		CD.PublishOnWeb,
		dateedited,
		useridedited,
		seqno,
		PublishedTo,
		Source,
		FileSize,
		Pages,
		FolderID,
		SubFolder, 
		CD.CaseDocTypeID, 
		CDT.FilterKey,
		CD.SharedDoc,
		CD.MasterCaseNbr 
    FROM
		tblCaseDocuments AS CD
			LEFT OUTER JOIN tblCaseDocType AS CDT ON CDT.CaseDocTypeID = CD.CaseDocTypeID
    WHERE
		   CD.Type <> 'Report' 
