

CREATE PROCEDURE [proc_Services_LoadByPrimaryKey]
(
 @servicecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblServices]
 WHERE
  ([servicecode] = @servicecode)

 SET @Err = @@Error

 RETURN @Err
END


