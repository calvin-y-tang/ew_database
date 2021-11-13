


CREATE FUNCTION [dbo].[fnGetDoctorDocumentPath]
(
  @recID INT
)
RETURNS VARCHAR(500)
BEGIN

DECLARE @path VARCHAR(500)

 SELECT @path =
		CASE WHEN ISNULL(PathFileName,'')='' THEN NULL
		ELSE
        F.PathName
        + CAST(FLOOR(( ISNULL(DD.EWDoctorID, DD.DoctorCode) - 1 ) / 1000) * 1000 + 1 AS VARCHAR) + '\'
        + CAST(ISNULL(DD.EWDoctorID, DD.DoctorCode) AS VARCHAR) + '\'
        + PathFilename
        END
FROM    tblDoctorDocuments AS DD
        LEFT OUTER JOIN tblEWFolderDef AS F ON DD.FolderID = F.FolderID
        WHERE DD.RecID = @recID
        
 RETURN @path
END

