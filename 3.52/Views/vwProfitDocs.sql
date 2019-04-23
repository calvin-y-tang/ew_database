CREATE  VIEW vwProfitDocs
AS
    SELECT
        tblCase.CaseNbr,
        tblQueues.StatusDesc,
        tblCase.Status,
        tblCase.ApptDate,
        tblClient.FirstName+' '+tblClient.LastName AS clientname,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctorname,
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
        tblDoctor.DoctorCode,
        tblServices.ServiceCode,
        tblServices.Description,
        tblCase.OfficeCode,
        tblCase.CaseType
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    UNION
    SELECT
        tblCase.CaseNbr,
        tblQueues.StatusDesc,
        tblCase.Status,
        tblCase.ApptDate,
        tblClient.FirstName+' '+tblClient.LastName AS clientname,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctorname,
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
        tblDoctor.DoctorCode,
        tblServices.ServiceCode,
        tblServices.Description,
        tblCase.OfficeCode,
        tblCase.CaseType
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblCasePanel ON tblCase.PanelNbr=tblCasePanel.PanelNbr
    INNER JOIN tblDoctor ON tblCasePanel.DoctorCode=tblDoctor.DoctorCode
