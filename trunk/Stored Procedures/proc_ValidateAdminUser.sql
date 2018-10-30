

CREATE PROCEDURE [proc_ValidateAdminUser] 

@UserID varchar(100),
@Password varchar(30)

AS

SELECT 

tblWebUser.WebUserID

FROM tblWebUser

WHERE tblWebUser.UserID = @UserID AND tblWebUser.Password = @Password

