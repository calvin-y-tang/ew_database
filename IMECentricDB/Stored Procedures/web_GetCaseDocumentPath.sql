CREATE PROCEDURE [dbo].[web_GetCaseDocumentPath]
 @CaseNbr int,
 @DocType varchar(25) 
AS

BEGIN

	select * from [fnGetCaseDocumentPath](@CaseNbr, @DocType)

END
