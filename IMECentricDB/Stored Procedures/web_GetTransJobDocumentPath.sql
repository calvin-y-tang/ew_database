CREATE PROCEDURE [dbo].[web_GetTransJobDocumentPath]
 @TranscriptionJobID int
AS

BEGIN

	select * from [fnGetTranscriptionDocumentPath](@TranscriptionJobID)

END