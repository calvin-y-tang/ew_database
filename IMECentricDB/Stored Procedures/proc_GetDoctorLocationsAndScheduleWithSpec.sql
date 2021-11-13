

CREATE PROCEDURE [dbo].[proc_GetDoctorLocationsAndScheduleWithSpec]

@LocationCode int = NULL,
@ApptDate datetime = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT tblDoctor.doctorcode, 
  ISNULL(tblDoctor.prefix, '') + ' ' + tblDoctor.firstname + ' ' + tblDoctor.lastname + ' ' + ISNULL(tblDoctor.credentials,'') as doctorname, 
  tblSpecialty.description specialty 
  FROM tblDoctor 
  INNER JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode 
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode AND tblDoctorSchedule.status = 'open'
  INNER JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode 
  INNER JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode AND tblDoctorLocation.PublishOnWeb = 1
  INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25
  INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
  AND tblDoctorLocation.locationcode = COALESCE(@LocationCode,tblDoctorLocation.locationcode)
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 
  AND tblDoctor.publishonweb = 1

 SET @Err = @@Error

 RETURN @Err
END


