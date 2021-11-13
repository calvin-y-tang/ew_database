CREATE VIEW vwAcctException
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
        tblCase.OfficeCode,
        tblCase.ExtCaseNbr
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    WHERE
        (tblCase.Status=8) AND
        (tblCase.VoucherAmt<>0) AND
        (tblCase.InvoiceAmt=0) OR
        (tblCase.Status=8) AND
        (tblCase.VoucherAmt=0) AND
        (tblCase.InvoiceAmt<>0)
