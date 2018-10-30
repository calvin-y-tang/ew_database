

CREATE PROCEDURE [proc_WebUser_LoadByPrimaryKey]
(
 @WebUserID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUser]
 WHERE
  ([WebUserID] = @WebUserID)

 SET @Err = @@Error

 RETURN @Err
END


