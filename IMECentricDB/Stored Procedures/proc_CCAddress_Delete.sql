

CREATE PROCEDURE [proc_CCAddress_Delete]
(
 @CCCode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblCCAddress]
 WHERE
  [CCCode] = @CCCode
 SET @Err = @@Error

 RETURN @Err
END


