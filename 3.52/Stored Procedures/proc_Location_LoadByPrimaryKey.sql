

CREATE PROCEDURE [proc_Location_LoadByPrimaryKey]
(
 @locationcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblLocation]
 WHERE
  ([locationcode] = @locationcode)

 SET @Err = @@Error

 RETURN @Err
END


