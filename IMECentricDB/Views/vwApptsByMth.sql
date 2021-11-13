CREATE VIEW vwApptsByMth
AS
    SELECT DISTINCT
        tblCase.CaseNbr,
        tblCaseAppt.DoctorCode,
        tblCaseAppt.LocationCode,
        tblCase.MarketerCode,
        tblCase.ClientCode,
        tblClient.CompanyCode,
        CASE WHEN tblCaseAppt.ApptStatusID=101 THEN 'NoShow'
             ELSE 'Show'
        END AS EventDesc,
        ISNULL(tblUser.LastName, '')+
        CASE WHEN ISNULL(tblUser.LastName, '')='' OR
                  ISNULL(tblUser.FirstName, '')='' THEN ''
             ELSE ', '
        END+ISNULL(tblUser.FirstName, '') AS marketer,
        CASE WHEN tblCaseAppt.ApptStatusID=101 THEN 'NoShow'
             ELSE 'Show'
        END AS Type,
        tblCase.ApptDate,
        tblCompany.IntName AS companyname,
        tblClient.FirstName+' '+tblClient.LastName AS adjustername,
        tblClient.LastName,
        tblDoctor.FirstName+' '+tblDoctor.LastName AS doctorname,
        tblLocation.Location,
        YEAR(tblCase.ApptDate) AS year,
        CASE WHEN MONTH(tblCase.ApptDate)=1 THEN 1
             ELSE 0
        END AS jan,
        CASE WHEN MONTH(tblCase.ApptDate)=1 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS janns,
        CASE WHEN MONTH(tblCase.ApptDate)=2 THEN 1
             ELSE 0
        END AS feb,
        CASE WHEN MONTH(tblCase.ApptDate)=2 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS febns,
        CASE WHEN MONTH(tblCase.ApptDate)=3 THEN 1
             ELSE 0
        END AS mar,
        CASE WHEN MONTH(tblCase.ApptDate)=3 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS marns,
        CASE WHEN MONTH(tblCase.ApptDate)=4 THEN 1
             ELSE 0
        END AS apr,
        CASE WHEN MONTH(tblCase.ApptDate)=4 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS aprns,
        CASE WHEN MONTH(tblCase.ApptDate)=5 THEN 1
             ELSE 0
        END AS may,
        CASE WHEN MONTH(tblCase.ApptDate)=5 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS mayns,
        CASE WHEN MONTH(tblCase.ApptDate)=6 THEN 1
             ELSE 0
        END AS jun,
        CASE WHEN MONTH(tblCase.ApptDate)=6 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS junns,
        CASE WHEN MONTH(tblCase.ApptDate)=7 THEN 1
             ELSE 0
        END AS jul,
        CASE WHEN MONTH(tblCase.ApptDate)=7 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS julns,
        CASE WHEN MONTH(tblCase.ApptDate)=8 THEN 1
             ELSE 0
        END AS aug,
        CASE WHEN MONTH(tblCase.ApptDate)=8 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS augns,
        CASE WHEN MONTH(tblCase.ApptDate)=9 THEN 1
             ELSE 0
        END AS sep,
        CASE WHEN MONTH(tblCase.ApptDate)=9 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS sepns,
        CASE WHEN MONTH(tblCase.ApptDate)=10 THEN 1
             ELSE 0
        END AS oct,
        CASE WHEN MONTH(tblCase.ApptDate)=10 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS octns,
        CASE WHEN MONTH(tblCase.ApptDate)=11 THEN 1
             ELSE 0
        END AS nov,
        CASE WHEN MONTH(tblCase.ApptDate)=11 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS novns,
        CASE WHEN MONTH(tblCase.ApptDate)=12 THEN 1
             ELSE 0
        END AS dec,
        CASE WHEN MONTH(tblCase.ApptDate)=12 AND
                  tblCaseAppt.ApptStatusID=101 THEN 1
             ELSE 0
        END AS decns,
        1 AS total,
        CASE WHEN tblCaseAppt.ApptStatusID=101 OR
                  tblCase.Status=9 THEN 1
             ELSE 0
        END AS totalns,
        tblCase.OfficeCode
    FROM
        tblCase
    INNER JOIN tblCaseAppt ON tblCase.CaseNbr=tblCaseAppt.CaseNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    LEFT OUTER JOIN tblUser ON tblCase.MarketerCode=tblUser.UserID
    LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode=tblLocation.LocationCode
    LEFT OUTER JOIN tblDoctor ON tblCaseAppt.DoctorCode=tblDoctor.DoctorCode
    WHERE
        tblCaseAppt.ApptStatusID IN (100, 101)


