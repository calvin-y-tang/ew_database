

CREATE PROCEDURE [proc_Specialty_LoadByPrimaryKey]
(
 @specialtycode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblSpecialty]
 WHERE
  ([specialtycode] = @specialtycode)

 SET @Err = @@Error

 RETURN @Err
END


