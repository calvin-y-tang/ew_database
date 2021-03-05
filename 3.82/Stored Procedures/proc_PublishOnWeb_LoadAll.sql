

CREATE PROCEDURE [proc_PublishOnWeb_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblPublishOnWeb]


 SET @Err = @@Error

 RETURN @Err
END


