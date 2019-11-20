CREATE VIEW vwAssocCases
AS
    SELECT
        tblDoctor.LastName,
        tblDoctor.FirstName,
        tblDoctor.Credentials AS degree,
        tblSpecialty.Description AS Specialty,
        tblCase.ApptDate,
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.MasterSubCase,
        tblCase.MasterCaseNbr,
        tblDoctor.Prefix,
        tblSpecialty.SpecialtyCode,
        tblDoctor.DoctorCode,
        tblDoctor.WCNbr,
        tblDoctor.UnRegNbr,
        tblServices.Description AS Service,
        tblLocation.Addr1,
        tblLocation.Addr2,
        tblLocation.City,
        tblLocation.State,
        tblLocation.Zip,
        tblLocation.Phone,
        tblLocation.Fax,
        tblCaseAppt.Duration,
        tblCase.Status,
        tblProviderType.Description AS DoctorProviderType
    FROM
        tblServices
    INNER JOIN tblCase ON tblServices.ServiceCode=tblCase.ServiceCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode=tblProviderType.ProvTypeCode
    LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
    LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
