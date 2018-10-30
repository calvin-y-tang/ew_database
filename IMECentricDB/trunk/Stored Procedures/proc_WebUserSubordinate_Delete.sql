

CREATE PROCEDURE [proc_WebUserSubordinate_Delete]

@WebUserID int

AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE FROM tblWebUserAccount WHERE WebUserID = @WebUserID AND IsUser = 0

 SET @Err = @@Error

 RETURN @Err
END


