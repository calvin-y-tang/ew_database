

CREATE PROCEDURE [proc_PublishOnWeb_LoadByPrimaryKey]
(
 @PublishID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblPublishOnWeb]
 WHERE
  ([PublishID] = @PublishID)

 SET @Err = @@Error

 RETURN @Err
END


