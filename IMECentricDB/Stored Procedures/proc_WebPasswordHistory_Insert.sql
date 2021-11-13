

CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_Insert]
(
 @WebPasswordHistoryID int = NULL output,
 @WebUserID int,
 @PasswordDate datetime,
 @Password varchar(200) = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblWebPasswordHistory]
 (
  [WebUserID],
  [PasswordDate],
  [Password]
 )
 VALUES
 (
  @WebUserID,
  @PasswordDate,
  @Password
 )

 SET @Err = @@Error

 SELECT @WebPasswordHistoryID = SCOPE_IDENTITY()

 RETURN @Err
END

