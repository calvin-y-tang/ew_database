

CREATE PROCEDURE [proc_Doctor_GetActiveDoctors]

AS
BEGIN
 SET NOCOUNT ON
 DECLARE @Err int

 SELECT doctorcode, ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname 
  FROM tblDoctor WHERE (status = 'Active') AND (OPType = 'DR') AND (PublishOnWeb = 1) ORDER BY lastname, firstname

 SET @Err = @@Error

 RETURN @Err
END


