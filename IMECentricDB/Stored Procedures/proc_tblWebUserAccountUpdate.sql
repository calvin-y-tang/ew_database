

CREATE PROCEDURE [proc_tblWebUserAccountUpdate]
(
 @WebUserID int,
 @UserCode int,
 @DateAdded datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 UPDATE [tblWebUserAccount]
 SET
  [DateAdded] = @DateAdded
 WHERE
  [WebUserID] = @WebUserID
 AND [UserCode] = @UserCode


 SET @Err = @@Error


 RETURN @Err
END


