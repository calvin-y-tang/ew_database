CREATE VIEW vwReferralbyMonthAppt
AS
    SELECT
        tblCase.CaseNbr,
        tblCase.Status,
        tblCase.DoctorLocation AS locationcode,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        ISNULL(tblUser.LastName, '')+
        CASE WHEN ISNULL(tblUser.LastName, '')='' OR
                  ISNULL(tblUser.FirstName, '')='' THEN ''
             ELSE ', '
        END+ISNULL(tblUser.FirstName, '') AS marketer,
        tblCase.DateAdded,
        tblCompany.IntName AS companyname,
        tblClient.LastName+', '+tblClient.FirstName AS clientname,
        tblClient.LastName,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS doctorname,
        tblLocation.Location,
        YEAR(tblCase.ApptDate) AS year,
        CASE WHEN MONTH(tblCase.ApptDate)=1 THEN 1
             ELSE 0
        END AS jan,
        CASE WHEN MONTH(tblCase.ApptDate)=2 THEN 1
             ELSE 0
        END AS feb,
        CASE WHEN MONTH(tblCase.ApptDate)=3 THEN 1
             ELSE 0
        END AS mar,
        CASE WHEN MONTH(tblCase.ApptDate)=4 THEN 1
             ELSE 0
        END AS apr,
        CASE WHEN MONTH(tblCase.ApptDate)=5 THEN 1
             ELSE 0
        END AS may,
        CASE WHEN MONTH(tblCase.ApptDate)=6 THEN 1
             ELSE 0
        END AS jun,
        CASE WHEN MONTH(tblCase.ApptDate)=7 THEN 1
             ELSE 0
        END AS jul,
        CASE WHEN MONTH(tblCase.ApptDate)=8 THEN 1
             ELSE 0
        END AS aug,
        CASE WHEN MONTH(tblCase.ApptDate)=9 THEN 1
             ELSE 0
        END AS sep,
        CASE WHEN MONTH(tblCase.ApptDate)=10 THEN 1
             ELSE 0
        END AS oct,
        CASE WHEN MONTH(tblCase.ApptDate)=11 THEN 1
             ELSE 0
        END AS nov,
        CASE WHEN MONTH(tblCase.ApptDate)=12 THEN 1
             ELSE 0
        END AS dec,
        1 AS total,
        tblCaseType.Description AS CasetypeDesc,
        tblServices.Description AS service,
        tblServices.ServiceCode,
        tblCase.CaseType,
        tblCase.OfficeCode,
        tblOffice.Description AS officename,
        tblCase.QARep AS QARepCode,
        tblDoctor.DoctorCode,
        tblCase.DoctorLocation
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblUser ON tblCase.MarketerCode=tblUser.UserID
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    WHERE
        (tblCase.Status<>9)


