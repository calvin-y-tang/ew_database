CREATE VIEW vwProfit
AS
    SELECT
        tblCase.CaseNbr,
        tblQueues.StatusDesc,
        tblCase.Status,
        tblCase.ApptDate,
        tblClient.FirstName+' '+tblClient.LastName AS clientname,
        tblCompany.IntName AS company,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS examineename,
        tblCase.VoucherAmt,
        tblCase.VoucherDate,
        tblCase.InvoiceDate,
        tblCase.InvoiceAmt,
        tblCase.DoctorLocation,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        tblServices.ServiceCode,
        tblServices.Description,
        tblCase.OfficeCode,
        tblCase.CaseType,
        tblCaseType.Description AS casetypedesc,
        tblCase.DoctorCode,
        tblCase.DoctorName,
        tblCase.ExtCaseNbr
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
