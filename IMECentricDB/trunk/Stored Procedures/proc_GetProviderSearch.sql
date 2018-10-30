CREATE PROCEDURE [proc_GetProviderSearch]

@clientCode int,
@companyCode int

AS

SET NOCOUNT OFF
DECLARE @Err int


	SELECT DISTINCT
		tblLocation.locationcode,
		tbldoctor.lastname,
		tblDoctor.firstname,
		tbldoctor.credentials,
		tblSpecialty.description specialty,
		tblSpecialty.specialtycode,
		tblLocation.zip,
		tblLocation.city,
		tblLocation.location,
		tblLocation.state,
		tbldoctor.prepaid,
		tblLocation.county,
		tblLocation.phone,
		tblDoctor.ProvTypeCode,
		tblDoctorKeyword.keywordID,
		tblDoctor.doctorcode,
		'' as Proximity,
		ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname
		FROM tblDoctor
		LEFT JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode
		LEFT JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode
		LEFT JOIN tbldoctordocuments ON tblDoctor.doctorcode = tbldoctordocuments.doctorcode AND tbldoctordocuments.publishonweb = 1
		LEFT JOIN tblDoctorKeyWord ON tblDoctor.doctorcode = tblDoctorKeyWord.doctorcode
		LEFT JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode AND tblDoctorLocation.publishonweb = 1
		LEFT JOIN tblLocation ON tblDoctorLocation.locationcode = tblLocation.locationcode
		WHERE (tblDoctor.status = 'Active')
		AND (OPType = 'DR') AND (tblDoctor.publishonweb = 1)
		AND (tblLocation.locationcode is not null)
		AND (tblLocation.Status = 'Active')
		AND (tblDoctor.DoctorCode NOT IN (SELECT DoctorCode FROM tblDrDoNotUse WHERE Code = @ClientCode AND tblDrDoNotUse.DoctorCode = tblDoctor.DoctorCode AND Type = 'CL'))
		AND (tblDoctor.DoctorCode NOT IN (SELECT DoctorCode FROM tblDrDoNotUse WHERE Code = @CompanyCode AND tblDrDoNotUse.DoctorCode = tblDoctor.DoctorCode AND Type = 'CO'))

SET @Err = @@Error
RETURN @Err