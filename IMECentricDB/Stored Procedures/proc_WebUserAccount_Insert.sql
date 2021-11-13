

CREATE PROCEDURE [proc_WebUserAccount_Insert]
(
 @WebUserID int,
 @UserCode int,
 @IsUser bit,
 @DateAdded datetime = NULL,
 @IsActive bit,
 @UserType char(2) = NULL
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
  [DateAdded],
  [IsActive],
  [UserType]
 )
 VALUES
 (
  @WebUserID,
  @UserCode,
  @IsUser,
  @DateAdded,
  @IsActive,
  @UserType
 )

 SET @Err = @@Error


 RETURN @Err
END


