CREATE VIEW vwCaseServices
AS
    SELECT
        tblCase.CaseNbr,
        tblCaseOtherParty.DueDate,
        tblCaseOtherParty.Status,
        tblCase.OfficeCode,
        tblCase.DoctorLocation,
        tblCase.MarketerCode,
        tblCase.DoctorCode,
        tblExaminee.FirstName+' '+tblClient.LastName AS examineename,
        ISNULL(tblDoctor.FirstName, '')+' '+tblDoctor.LastName AS doctorname,
        tblCaseOtherParty.UserIDResponsible,
        tblCase.ApptDate,
        tblServices.ShortDesc AS service,
        tblServices.ServiceCode,
        tblDoctor.CompanyName,
        tblDoctor.OPSubType AS type
    FROM
        tblCaseOtherParty
    INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr=tblCase.CaseNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCaseOtherParty.OPCode=tblDoctor.DoctorCode
