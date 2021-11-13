

CREATE PROCEDURE [proc_WebUser_CheckIfSupervisor]

@WebUserID int

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT Count(UserCode) FROM tblWebUserAccount WHERE WebUserID = @WebUserID


 SET @Err = @@Error

 RETURN @Err
END


