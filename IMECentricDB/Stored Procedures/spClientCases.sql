CREATE  PROCEDURE spClientCases
    @clientcode AS INTEGER
AS
    SELECT TOP 100 PERCENT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        'C' AS ClientType,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS examineename,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblDoctor.DoctorCode,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCase.ClientCode=@clientcode
    UNION
    SELECT TOP 100 PERCENT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        'B' AS ClientType,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS examineename,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblDoctor.DoctorCode,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCase.BillClientCode=@clientcode
    ORDER BY
        tblCase.ApptDate DESC

