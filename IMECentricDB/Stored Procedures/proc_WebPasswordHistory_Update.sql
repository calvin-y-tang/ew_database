

CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_Update]
(
 @WebPasswordHistoryID int,
 @WebUserID int,
 @PasswordDate datetime,
 @Password varchar(200) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblWebPasswordHistory]
 SET
  [WebUserID] = @WebUserID,
  [PasswordDate] = @PasswordDate,
  [Password] = @Password
 WHERE
  [WebPasswordHistoryID] = @WebPasswordHistoryID

 SET @Err = @@Error

 RETURN @Err
END

