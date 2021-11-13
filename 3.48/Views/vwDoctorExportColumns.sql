CREATE VIEW vwDoctorExportColumns
AS
    SELECT DISTINCT
        tblDoctor.LastName,
        tblDoctor.FirstName,
        tblDoctor.MiddleInitial,
        tblDoctor.Credentials AS degree,
        tblDoctor.Prefix,
        tblDoctor.Status,
        tblDoctor.Addr1 AS Address1,
        tblDoctor.Addr2 AS Address2,
        tblDoctor.City,
        tblDoctor.State,
        tblDoctor.Zip,
        tblDoctor.Phone,
        tblDoctor.PhoneExt AS Extension,
        tblDoctor.FaxNbr AS Fax,
        tblDoctor.EmailAddr AS Email,
        tblDoctor.OPType,
        tblSpecialty.Description AS Specialty,
        tblOffice.Description AS Office,
        tblOffice.OfficeCode,
        tblDoctor.DoctorCode,
        tblProviderType.Description AS ProviderType,
        tblDoctor.USDVarchar1,
        tblDoctor.USDVarchar2,
        tblDoctor.USDDate1,
        tblDoctor.USDDate2,
        tblDoctor.USDInt1,
        tblDoctor.USDInt2,
        tblDoctor.USDMoney1,
        tblDoctor.USDMoney2,
        tblDoctor.USDDate3,
        tblDoctor.USDDate4,
        tblDoctor.USDVarchar3,
        tblDoctor.USDDate5,
        tblDoctor.USDDate6,
        tblDoctor.USDDate7,
        tblDoctor.LicenseNbr,
        tblDoctor.WCNbr,
        tblDoctor.DrMedRecsInDays
    FROM
        tblDoctor
    LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode=tblProviderType.ProvTypeCode
    LEFT OUTER JOIN tblOffice
    RIGHT OUTER JOIN tblDoctorOffice ON tblOffice.OfficeCode=tblDoctorOffice.OfficeCode ON tblDoctor.DoctorCode=tblDoctorOffice.DoctorCode
    LEFT OUTER JOIN tblSpecialty
    INNER JOIN tblDoctorSpecialty ON tblSpecialty.SpecialtyCode=tblDoctorSpecialty.SpecialtyCode ON tblDoctor.DoctorCode=tblDoctorSpecialty.DoctorCode
    WHERE
        (tblDoctor.OPType='DR')
