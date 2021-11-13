CREATE PROCEDURE [dbo].[web_GetCaseDocumentPathExisting]
 @SeqNo int
AS

BEGIN
	DECLARE @docpath varchar(500)
	SET @docpath = dbo.fnGetCaseDocument(@SeqNo)
	SELECT RTRIM(@Docpath) AS DocumentPath
END
