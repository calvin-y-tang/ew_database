

CREATE PROCEDURE [proc_tblWebUserAccountInsert]
(
 @WebUserID int,
 @UserCode int,
 @IsUser bit = 1,
 @UserType char(2) = null,
 @DateAdded datetime = null
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblWebUserAccount]
 (
  [WebUserID],
  [UserCode],
  [IsUser],
  [UserType],
  [DateAdded]
 )
 VALUES
 (
  @WebUserID,
  @UserCode,
  @IsUser,
  @UserType,
  getdate()
 )

 SET @Err = @@Error


 RETURN @Err
END


