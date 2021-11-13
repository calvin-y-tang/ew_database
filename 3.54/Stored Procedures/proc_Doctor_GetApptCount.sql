

CREATE PROCEDURE [proc_Doctor_GetApptCount]

@DoctorCode varchar(20) = NULL,
@LocationCode varchar(20) = NULL,
@ApptDate varchar(20)

AS

SET NOCOUNT ON
DECLARE @Err int
 
SELECT COUNT(*) AS ApptCnt FROM tblDoctorSchedule 
INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25
INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
WHERE tblDoctorSchedule.date = @ApptDate
AND tblDoctorSchedule.DoctorCode = COALESCE(@DoctorCode, tblDoctorSchedule.DoctorCode) 
AND tblDoctorSchedule.LocationCode = COALESCE(@LocationCode, tblDoctorSchedule.LocationCode)  
AND tblDoctorSchedule.status = 'open'
  
SET @Err = @@Error
RETURN @Err


