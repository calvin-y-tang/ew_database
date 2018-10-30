/*
	Scalar-Valued Function that will return the full path, including document filename
	for a document records specified by the CaseDocument SeqNo parameter

	IMPORTANT: This Function is used by all EW Web Portals! DO NOT change this function's 
	signature without making cooresponding changes/suppoting changes to the portals (National, BU and InfoC)
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
