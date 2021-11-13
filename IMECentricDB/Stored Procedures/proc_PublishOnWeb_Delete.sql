

CREATE PROCEDURE [proc_PublishOnWeb_Delete]
(
 @PublishID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblPublishOnWeb]
 WHERE
  [PublishID] = @PublishID
 SET @Err = @@Error

 RETURN @Err
END


