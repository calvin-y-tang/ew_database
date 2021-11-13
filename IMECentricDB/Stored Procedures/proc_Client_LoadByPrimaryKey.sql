

CREATE PROCEDURE [proc_Client_LoadByPrimaryKey]
(
 @clientcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblClient]
 WHERE
  ([clientcode] = @clientcode)

 SET @Err = @@Error

 RETURN @Err
END


