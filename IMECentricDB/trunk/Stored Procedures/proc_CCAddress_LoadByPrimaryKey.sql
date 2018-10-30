

CREATE PROCEDURE [proc_CCAddress_LoadByPrimaryKey]
(
 @CCCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblCCAddress]
 WHERE
  ([CCCode] = @CCCode)

 SET @Err = @@Error

 RETURN @Err
END


