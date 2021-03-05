CREATE VIEW vwRptCancelDetailDocs
AS
    SELECT 
            tblCaseAppt.CaseNbr ,
            tblCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, tblCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCaseAppt.LocationCode ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.DateAdded ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            tblSpecialty.Description ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCaseAppt.ApptStatusID ,
            tblApptStatus.Name AS ApptStatus ,
            tblCaseAppt.LastStatusChg ,
            tblCaseAppt.Reason ,
            tblCanceledBy.ExtName AS CanceledByExtName ,
            tblCase.Casetype ,
            tblCase.MastersubCase
    FROM    tblCaseAppt
			INNER JOIN tblApptStatus ON tblCaseAppt.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON tblCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblCaseApptPanel ON tblCaseAppt.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblCanceledBy ON tblCanceledBy.CanceledByID = tblCaseAppt.CanceledByID
            LEFT OUTER JOIN tblDoctor ON ISNULL(tblCaseAppt.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCaseAppt.ApptStatusID IN (50, 51)
