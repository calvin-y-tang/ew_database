

CREATE PROCEDURE [proc_Doctor_GetDocuments]

@DoctorCode int

AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT * FROM tblDoctorDocuments 
  INNER JOIN tblDoctor ON tblDoctorDocuments.doctorcode = tblDoctor.doctorcode 
  WHERE tblDoctorDocuments.doctorcode = @DoctorCode
  AND tblDoctorDocuments.publishonweb = 1 ORDER BY description

 SET @Err = @@Error

 RETURN @Err
END


