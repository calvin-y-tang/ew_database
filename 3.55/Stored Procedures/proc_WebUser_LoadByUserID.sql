

CREATE PROCEDURE [dbo].[proc_WebUser_LoadByUserID]
(
 @UserID varchar(100)
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebUser]
 WHERE
  ([UserID] = @UserID)

 SET @Err = @@Error

 RETURN @Err
END

