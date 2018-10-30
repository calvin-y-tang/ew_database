CREATE VIEW [dbo].[vwCaseReports]
AS 

	SELECT 
		CaseNbr AS DocCaseNbr, 
        document,
        type,
        description,
        sfilename,
        dateadded,
        useridadded,
        reporttype,
        PublishOnWeb,
        dateedited,
        useridedited,
        seqno,
		PublishedTo,
        Source,
        FileSize,
        Pages,
		FolderID,
		SubFolder, 
		CaseDocTypeID,
		SharedDoc, 
		MasterCaseNbr
	FROM    
		dbo.tblCaseDocuments AS CD
	WHERE
		( type = 'Report' )
