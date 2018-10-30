

CREATE PROCEDURE [proc_AdminCheckDupeWebUser]

@WebUserID varchar(30)

AS

SELECT * FROM tblWebUser
WHERE UserID = @WebUserID


