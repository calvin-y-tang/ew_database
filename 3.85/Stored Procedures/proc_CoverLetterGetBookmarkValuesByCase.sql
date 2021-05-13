

CREATE PROCEDURE [proc_CoverLetterGetBookmarkValuesByCase]

@CaseNbr int

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [vw_WebCoverLetterInfo]
 
 WHERE CaseNbr = @CaseNbr

 SET @Err = @@Error

 RETURN @Err
END

