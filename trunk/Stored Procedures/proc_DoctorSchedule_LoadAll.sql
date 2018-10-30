

CREATE PROCEDURE [proc_DoctorSchedule_LoadAll]

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT *, DATEADD(minute, dbo.tblDoctorSchedule.duration, dbo.tblDoctorSchedule.starttime) AS EndTime

 FROM [tblDoctorSchedule]


 SET @Err = @@Error

 RETURN @Err
END


