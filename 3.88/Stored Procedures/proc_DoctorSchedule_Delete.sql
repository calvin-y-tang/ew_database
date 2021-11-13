

CREATE PROCEDURE [proc_DoctorSchedule_Delete]
(
 @schedcode int,
 @locationcode int
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 DELETE
 FROM [tblDoctorSchedule]
 WHERE
  [schedcode] = @schedcode AND
  [locationcode] = @locationcode
 SET @Err = @@Error

 RETURN @Err
END


