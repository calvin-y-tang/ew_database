

CREATE PROCEDURE [dbo].[proc_WebPasswordHistory_LoadByWebUserID]
(
 @WebUserID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebPasswordHistory]
 WHERE
  ([WebUserID] = @WebUserID)

 ORDER BY 
  [PasswordDate] DESC

 SET @Err = @@Error

 RETURN @Err
END

