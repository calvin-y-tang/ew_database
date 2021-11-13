

CREATE PROCEDURE [dbo].[proc_Client_LoadByUserIDAndEmail]
(
 @UserID varchar(100),
 @Email varchar(70)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClient]
  INNER JOIN [tblWebUser] ON [tblClient].WebUserID = [tblWebUser].WebUserID
 WHERE
  ([tblWebUser].UserID = @UserID)
 AND
  ([tblClient].Email = @Email)

 SET @Err = @@Error

 RETURN @Err
END

