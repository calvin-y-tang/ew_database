

CREATE PROCEDURE [proc_Keyword_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT * FROM tblKeyword WHERE PublishOnWeb = 1 ORDER BY keyword

 SET @Err = @@Error

 RETURN @Err
END


