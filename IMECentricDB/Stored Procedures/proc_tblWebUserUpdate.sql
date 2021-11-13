

CREATE PROCEDURE [proc_tblWebUserUpdate]

@WebUserID int,
@UserIDEdited varchar(15),
@Password varchar(100)

AS

UPDATE tblWebUser 
 SET 
  tblWebUser.Password = @Password, 
  DateEdited = getdate(), 
  UserIDEdited = @UserIDEdited 
 WHERE WebUserID = @WebUserID



