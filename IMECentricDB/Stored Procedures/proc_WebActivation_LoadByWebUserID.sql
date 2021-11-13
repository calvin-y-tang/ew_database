

CREATE PROCEDURE [dbo].[proc_WebActivation_LoadByWebUserID]
(
 @WebUserID int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblWebActivation]
 WHERE
  ([WebUserID] = @WebUserID)

 SET @Err = @@Error

 RETURN @Err
END

