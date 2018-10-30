CREATE VIEW vwReportTATRpt
AS
    SELECT
        tblCaseHistory.CaseNbr,
        tblCaseHistory.EventDate,
        tblCaseHistory.Eventdesc,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS Examinee,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS Doctor,
        tblCase.ApptDate,
        DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate) AS Age,
        tblCompany.CompanyCode,
        tblCase.ServiceCode,
        tblServices.Description AS Service,
        tblCompany.IntName AS Company,
        tblClient.LastName+', '+tblClient.FirstName AS Client,
        tblClient.ClientCode,
        CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)<=7
             THEN 1
             ELSE 0
        END AS age1count,
        CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)>7 AND
                  DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)<=14
             THEN 1
             ELSE 0
        END AS age2count,
        CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)>14 AND
                  DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)<=21
             THEN 1
             ELSE 0
        END AS age3count,
        CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)>21 AND
                  DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)<=28
             THEN 1
             ELSE 0
        END AS age4count,
        CASE WHEN DATEDIFF(dd, tblCase.ApptDate, tblCaseHistory.EventDate)>28
             THEN 1
             ELSE 0
        END AS age5count,
        tblCase.DoctorLocation AS Location,
        tblCase.MarketerCode,
        tblCase.CaseType,
        tblServices.ShortDesc AS ServiceShortDesc,
        tblCase.OfficeCode,
        tblCase.QARep AS qarepCode,
        tblCaseType.Description AS Casetypedesc,
        tblDoctor.DoctorCode,
        tblCase.ExtCaseNbr
    FROM
        tblCaseHistory
    INNER JOIN tblCase ON tblCaseHistory.CaseNbr=tblCase.CaseNbr
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    WHERE
        (tblCaseHistory.Type='FinalRpt')
