
CREATE PROCEDURE [dbo].[spCaseReports] ( @casenbr integer )
AS 
	DECLARE @MasterCaseNbr INTEGER 
	
	SET @MasterCaseNbr = (SELECT MasterCaseNbr FROM tblCase WHERE CaseNbr = @casenbr)

	SELECT 
            @casenbr AS CaseNbr,
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
			SharedDoc 
    FROM    dbo.tblCaseDocuments AS CD
    WHERE   ( type = 'Report' )
			 AND (CD.CaseNbr = @CaseNbr OR (CD.SharedDoc=1 AND CD.MasterCaseNbr = @MasterCaseNbr AND @MasterCaseNbr IS NOT NULL))
    ORDER BY dateadded DESC

