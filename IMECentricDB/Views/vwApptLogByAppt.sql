CREATE VIEW vwApptLogByAppt
AS
    SELECT
        tblCase.ApptDate,
        tblCaseType.ShortDesc AS [Case Type],
        tblCase.DoctorName AS Doctor,
        tblClient.FirstName+' '+tblClient.LastName AS Client,
        tblCompany.IntName AS Company,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName AS Examinee,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description AS OfficeName,
        GETDATE() AS today,
        tblCase.QARep AS QARepcode,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        (
         SELECT TOP 1
            tblCaseAppt.ApptTime
         FROM
            tblCaseAppt
         WHERE
            tblCaseAppt.CaseNbr=tblCase.CaseNbr AND
            tblCaseAppt.CaseApptID<tblCase.CaseApptID
         ORDER BY
            tblCaseAppt.CaseApptID DESC
        ) AS PreviousApptTime,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone AS DoctorPhone,
        tblDoctor.LastName+', '+tblDoctor.FirstName AS DoctorSortName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.ForecastDate,
        tblCase.ExtCaseNbr
    FROM
        tblCase
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblClient.CompanyCode=tblCompany.CompanyCode
    INNER JOIN vwtblExaminee AS tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblServices ON tblCase.ServiceCode=tblServices.ServiceCode
    INNER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
    LEFT OUTER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    WHERE
        (tblCase.Status<>9)
    GROUP BY
        tblCase.ApptDate,
        tblCaseType.ShortDesc,
        tblCase.DoctorName,
        tblClient.FirstName+' '+tblClient.LastName,
        tblCompany.IntName,
        tblCase.DoctorLocation,
        tblLocation.Location,
        tblExaminee.FirstName+' '+tblExaminee.LastName,
        tblCase.MarketerCode,
        tblCase.SchedulerCode,
        tblExaminee.SSN,
        tblQueues.StatusDesc,
        tblDoctor.DoctorCode,
        tblCase.ClientCode,
        tblCompany.CompanyCode,
        tblCase.DateAdded,
        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, ''),
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.Priority,
        tblCase.CommitDate,
        tblCase.Status,
        tblCase.ServiceCode,
        tblServices.ShortDesc,
        tblSpecialty.Description,
        tblCase.OfficeCode,
        tblOffice.Description,
        tblCase.QARep,
        tblCase.HearingDate,
        tblCase.CaseType,
        tblCase.PanelNbr,
        tblCase.MasterSubCase,
        tblDoctor.ProvTypeCode,
        tblDoctor.Phone,
        tblDoctor.LastName+', '+tblDoctor.FirstName,
        tblCase.ExternalDueDate,
        tblCase.InternalDueDate,
        tblCase.ForecastDate,
        tblCase.CaseApptID,
        tblCase.ExtCaseNbr 


