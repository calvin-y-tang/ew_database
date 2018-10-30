

CREATE PROCEDURE [proc_WebUserAccount_Delete]
(
 @WebUserID int,
 @UserCode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblWebUserAccount]
 WHERE
  [WebUserID] = @WebUserID AND
  [UserCode] = @UserCode
 SET @Err = @@Error

 RETURN @Err
END


