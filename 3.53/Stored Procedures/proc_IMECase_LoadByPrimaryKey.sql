

CREATE PROCEDURE [proc_IMECase_LoadByPrimaryKey]
(
 @casenbr int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCase]
 WHERE
  ([casenbr] = @casenbr)

 SET @Err = @@Error

 RETURN @Err
END


