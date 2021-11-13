

CREATE PROCEDURE [proc_GetFirstAvailApptByDoctor]

@DoctorCode int

AS

SELECT top 1 CONVERT(VARCHAR(10), date, 110) + ' ' + CONVERT(VARCHAR(5), starttime, 114) startime 
 FROM tblDoctorSchedule 
 INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25 
 INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
 INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
 INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
 WHERE date >= getdate() 
 AND tblDoctorSchedule.doctorcode = @DoctorCode  
 AND tblDoctorSchedule.status = 'open' 
 ORDER BY date, starttime



