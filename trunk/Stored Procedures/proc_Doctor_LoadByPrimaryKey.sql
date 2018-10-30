

CREATE PROCEDURE [proc_Doctor_LoadByPrimaryKey]
(
 @DoctorCode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *

 FROM [tblDoctor]
 WHERE
  ([DoctorCode] = @DoctorCode)

 SET @Err = @@Error

 RETURN @Err
END


