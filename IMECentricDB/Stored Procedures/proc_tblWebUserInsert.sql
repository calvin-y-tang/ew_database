

CREATE PROCEDURE [proc_tblWebUserInsert]
(
 @WebUserID int = NULL output,
 @UserID varchar(100) = NULL,
 @Password varchar(100) = NULL,
 @LastLoginDate datetime = NULL,
 @DateAdded datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblWebUser]
 (
  [UserID],
  [Password],
  [LastLoginDate],
  [DateAdded]
 )
 VALUES
 (
  @UserID,
  @Password,
  @LastLoginDate,
  @DateAdded
 )

 SET @Err = @@Error

 SELECT @WebUserID = SCOPE_IDENTITY()

 RETURN @Err
END


