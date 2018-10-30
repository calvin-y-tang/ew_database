

CREATE PROCEDURE [dbo].[proc_GetDoctorLocationsAndSchedule]

@DoctorCode int = NULL,
@ApptDate datetime = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT tblLocation.locationcode, 
  tblLocation.location, 
  tblLocation.location as locname, 
  tblLocation.addr1 + '  ' + tblLocation.city + '  ' + tblLocation.state + ' ' + ISNULL(tblLocation.zip, '') as locaddress,
  ISNULL(tblLocation.County, '') + ' County ' as loccounty
  FROM tbllocation
  INNER JOIN tblDoctorLocation ON tblLocation.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1
  INNER JOIN tblDoctor ON tblDoctorLocation.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode
  INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25
  WHERE tblLocation.insidedr = 1
  AND tblDoctor.DoctorCode = COALESCE(@DoctorCode,tblDoctor.DoctorCode) 
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 

 SET @Err = @@Error

 RETURN @Err
END


