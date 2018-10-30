

CREATE PROCEDURE [proc_WebUserAccount_Update]
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

 UPDATE [tblWebUserAccount]
 SET
  [IsUser] = @IsUser,
  [DateAdded] = @DateAdded,
  [IsActive] = @IsActive,
  [UserType] = @UserType
 WHERE
  [WebUserID] = @WebUserID
 AND [UserCode] = @UserCode


 SET @Err = @@Error


 RETURN @Err
END


