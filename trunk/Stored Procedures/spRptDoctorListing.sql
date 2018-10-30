CREATE  PROCEDURE [dbo].[spRptDoctorListing]
@iofficecode int
AS 
IF @iofficecode <> - 1 BEGIN 
	SELECT distinct dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblDoctor.credentials, 
                               ISNULL(dbo.tblDoctor.firstname, '') + ' ' + dbo.tblDoctor.lastname + ', ' + 
			       ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblDoctor.status, 
			       dbo.tblDoctorLocation.locationcode, dbo.tblDoctorLocation.status AS drlocationstatus, 
			       dbo.tblLocation.location, dbo.tblLocation.city,dbo.tblLocation.state, dbo.tblLocation.Phone, 
			       dbo.tblLocation.fax, dbo.tblLocation.email, dbo.tblLocation.status AS locationstatus,
			       (SELECT TOP 1 dbo.tblSpecialty.description FROM dbo.tblDoctorSpecialty INNER JOIN
				dbo.tblSpecialty ON dbo.tblDoctorSpecialty.specialtycode = dbo.tblSpecialty.specialtycode AND 
                                dbo.tbldoctorspecialty.doctorcode = dbo.tbldoctor.doctorcode) AS description, 
			        dbo.tblDoctor.lastname + ', ' + ISNULL(dbo.tblDoctor.firstname, '') + '  +' AS sortname
         FROM dbo.tblDoctor LEFT OUTER JOIN
              dbo.tblDoctorOffice ON dbo.tblDoctor.doctorcode = dbo.tblDoctorOffice.doctorcode LEFT OUTER JOIN
              dbo.tblLocation INNER JOIN dbo.tblDoctorLocation ON dbo.tblLocation.locationcode = dbo.tblDoctorLocation.locationcode ON
              dbo.tblDoctor.doctorcode = dbo.tblDoctorLocation.doctorcode
         WHERE (dbo.tblDoctorLocation.status = 'Active') AND (dbo.tblLocation.status = 'Active')
         ORDER BY dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblLocation.city 
END 
else begin
	SELECT distinct dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblDoctor.credentials, 
                               ISNULL(dbo.tblDoctor.firstname, '') + ' ' + dbo.tblDoctor.lastname + ', ' + 
			       ISNULL(dbo.tblDoctor.credentials, '') AS doctorname, dbo.tblDoctor.status, 
			       dbo.tblDoctorLocation.locationcode, dbo.tblDoctorLocation.status AS drlocationstatus, 
			       dbo.tblLocation.location, dbo.tblLocation.city,dbo.tblLocation.state, dbo.tblLocation.Phone, 
			       dbo.tblLocation.fax, dbo.tblLocation.email, dbo.tblLocation.status AS locationstatus,
			       (SELECT TOP 1 dbo.tblSpecialty.description FROM dbo.tblDoctorSpecialty INNER JOIN
				dbo.tblSpecialty ON dbo.tblDoctorSpecialty.specialtycode = dbo.tblSpecialty.specialtycode AND 
                                dbo.tbldoctorspecialty.doctorcode = dbo.tbldoctor.doctorcode) AS description, 
			        dbo.tblDoctor.lastname + ', ' + ISNULL(dbo.tblDoctor.firstname, '') + '  +' AS sortname
         FROM dbo.tblDoctor LEFT OUTER JOIN
              dbo.tblLocation INNER JOIN dbo.tblDoctorLocation ON dbo.tblLocation.locationcode = dbo.tblDoctorLocation.locationcode ON
              dbo.tblDoctor.doctorcode = dbo.tblDoctorLocation.doctorcode
         WHERE (dbo.tblDoctorLocation.status = 'Active') AND (dbo.tblLocation.status = 'Active')
         ORDER BY dbo.tblDoctor.lastname, dbo.tblDoctor.firstname, dbo.tblLocation.city 
end
