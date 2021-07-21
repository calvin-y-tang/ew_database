

CREATE PROCEDURE [proc_Office_LoadByPrimaryKey]
(
 @Officecode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblOffice]
 WHERE
  ([Officecode] = @Officecode)

 SET @Err = @@Error

 RETURN @Err
END


