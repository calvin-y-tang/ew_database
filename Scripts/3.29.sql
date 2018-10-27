PRINT N'Altering [dbo].[tblCaseDocuments]...';


GO
ALTER TABLE [dbo].[tblCaseDocuments]
    ADD [MasterCaseNbr] INT NULL;


GO
PRINT N'Creating [dbo].[tblCaseDocuments].[IX_tblCaseDocuments_MasterCaseNbrType]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseDocuments_MasterCaseNbrType]
    ON [dbo].[tblCaseDocuments]([MasterCaseNbr] ASC, [Type] ASC)
    INCLUDE([CaseNbr], [Document], [Description], [sFilename], [DateAdded], [UserIDAdded], [PublishOnWeb], [DateEdited], [UserIDEdited], [SeqNo], [PublishedTo], [Source], [FileSize], [Pages], [FolderID], [SubFolder], [CaseDocTypeID], [SharedDoc]);


GO
PRINT N'Creating [dbo].[tblCaseDocuments_AfterInsert_TRG]...';


GO

CREATE TRIGGER tblCaseDocuments_AfterInsert_TRG
	ON tblCaseDocuments 
AFTER INSERT
AS 
BEGIN
	
	UPDATE tblCaseDocuments
	   SET tblCaseDocuments.MasterCaseNbr = tblCase.MasterCaseNbr	
	  FROM inserted 
			INNER JOIN tblCase ON tblCase.CaseNbr = inserted.CaseNbr 
	 WHERE tblCaseDocuments.SeqNo = inserted.SeqNo

END
GO
PRINT N'Altering [dbo].[spCaseDocuments]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROC [dbo].[spCaseDocuments] ( @CaseNbr INTEGER )
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




GO



UPDATE CD SET CD.MasterCaseNbr=C.MasterCaseNbr
 FROM tblCase AS C
 INNER JOIN tblCaseDocuments AS CD ON CD.CaseNbr = C.CaseNbr
 WHERE C.MasterCaseNbr IS NOT NULL AND CD.MasterCaseNbr IS NULL

GO




UPDATE tblControl SET DBVersion='3.29'
GO
