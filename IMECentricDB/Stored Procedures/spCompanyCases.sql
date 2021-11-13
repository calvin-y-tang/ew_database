CREATE PROCEDURE spCompanyCases
    @CompanyCode AS INTEGER
AS
    SELECT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS ExamineeName,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS ClientName,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc AS OfficeName
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCompany.CompanyCode=@CompanyCode
    ORDER BY
        tblCase.ApptDate DESC
