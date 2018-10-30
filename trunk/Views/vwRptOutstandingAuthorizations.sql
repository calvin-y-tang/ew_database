CREATE VIEW vwRptOutstandingAuthorizations
AS
    SELECT TOP 100 PERCENT
        tblExaminee.LastName+', '+tblExaminee.FirstName AS Examinee,
        tblCase.ClaimNbr,
        tblCase.CaseNbr,
        tblRecordsObtainment.DateRequested,
        tblRecordsObtainment.DateReceived,
        tblCCAddress.LastName+', '+tblCCAddress.FirstName AS AttorneyName,
        tblCCAddress.Company AS FirmName,
        tblCCAddress.Phone,
        tblCCAddress.Fax,
        DATEDIFF(dd, tblRecordsObtainment.DateRequested, GETDATE()) AS DOS,
        tblCase.OfficeCode,
        tblCase.ExtCaseNbr
    FROM
        tblRecordsObtainment
    INNER JOIN tblCase ON tblRecordsObtainment.CaseNbr=tblCase.CaseNbr
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    LEFT OUTER JOIN tblCCAddress ON tblCase.PlaintiffAttorneyCode=tblCCAddress.ccCode
    WHERE
        (tblRecordsObtainment.ObtainmentTypeID=1) AND
        (tblRecordsObtainment.DateReceived IS NULL)
