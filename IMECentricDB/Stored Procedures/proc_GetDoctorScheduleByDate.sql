

CREATE PROCEDURE [dbo].[proc_GetDoctorScheduleByDate]

@DoctorCode varchar(50) = NULL,
@LocationCode varchar(50) = NULL,
@ApptDate varchar(20) = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT 
   schedcode, 
   tblDoctor.doctorcode, 
   starttime, 
   duration 
   FROM tblDoctor 
   INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode AND tblDoctorSchedule.status = 'open' 
   INNER JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode 
   WHERE tblDoctorLocation.locationcode = COALESCE(@LocationCode,tblDoctorLocation.LocationCode) 
   AND tblDoctorLocation.locationcode IN (SELECT DISTINCT locationcode FROM tblLocation WHERE tblLocation.insidedr = 1) 
   AND tblDoctor.doctorcode = COALESCE(@DoctorCode,tblDoctor.DoctorCode)
   AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 
   ORDER BY starttime 


 SET @Err = @@Error

 RETURN @Err
END


