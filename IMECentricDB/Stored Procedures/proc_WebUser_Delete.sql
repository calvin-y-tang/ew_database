

CREATE PROCEDURE [proc_WebUser_Delete]
(
 @WebUserID int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebUser]
 WHERE
  [WebUserID] = @WebUserID
 SET @Err = @@Error

 RETURN @Err
END


