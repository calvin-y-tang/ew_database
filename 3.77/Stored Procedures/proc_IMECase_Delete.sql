

CREATE PROCEDURE [proc_IMECase_Delete]
(
 @casenbr int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCase]
 WHERE
  [casenbr] = @casenbr
 SET @Err = @@Error

 RETURN @Err
END


