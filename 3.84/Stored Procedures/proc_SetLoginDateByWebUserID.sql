

CREATE PROCEDURE [proc_SetLoginDateByWebUserID]

@WebUserID int

AS

UPDATE tblWebUser SET LastLoginDate = getDate() WHERE WebUserID = @WebUserID

