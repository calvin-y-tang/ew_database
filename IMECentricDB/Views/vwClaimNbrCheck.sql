CREATE VIEW vwClaimNbrCheck
AS
    SELECT
        tblCase.ClaimNbr,
        tblCase.ClaimNbrExt,
        tblCase.DoctorName,
        tblSpecialty.Description AS Specialty,
        tblQueues.StatusDesc AS Status,
        tblCaseType.Description AS CaseType,
        tblServices.Description AS Service,
        tblOffice.ShortDesc
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
