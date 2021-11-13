

CREATE PROCEDURE [proc_DoctorSchedule_LoadByPrimaryKey]
(
 @schedcode int,
 @locationcode int
)
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *, DATEADD(minute, dbo.tblDoctorSchedule.duration, dbo.tblDoctorSchedule.starttime) AS EndTime
 FROM [tblDoctorSchedule]
 WHERE
  ([schedcode] = @schedcode) AND
  ([locationcode] = @locationcode)

 SET @Err = @@Error

 RETURN @Err
END


