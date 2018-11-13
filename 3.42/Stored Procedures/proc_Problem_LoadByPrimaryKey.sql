

CREATE PROCEDURE [proc_Problem_LoadByPrimaryKey]
(
 @problemcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblProblem]
 WHERE
  ([problemcode] = @problemcode)

 SET @Err = @@Error

 RETURN @Err
END


