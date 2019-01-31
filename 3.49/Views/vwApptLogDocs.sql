CREATE VIEW vwApptLogDocs
AS
    SELECT 
            tblCase.CaseNbr ,
            CA.DateAdded ,
            CA.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, CA.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') AS Doctor ,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
            tblCompany.IntName AS Company ,
            tblCase.DoctorLocation ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            tblDoctor.DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            ISNULL(CA.SpecialtyCode, tblCaseApptPanel.SpecialtyCode) AS Specialty ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCase.Casetype ,
            tblCase.MastersubCase ,
            ( SELECT TOP 1
                        PriorAppt.ApptTime
              FROM      tblCaseAppt AS PriorAppt
                        WHERE PriorAppt.CaseNbr = tblCase.CaseNbr
                        AND PriorAppt.CaseApptID<CA.CaseApptID
              ORDER BY  PriorAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            tblDoctor.ProvTypeCode,
			tblCase.ExtCaseNbr
    FROM    tblCaseAppt AS CA
			INNER JOIN tblApptStatus ON CA.ApptStatusID = tblApptStatus.ApptStatusID
            INNER JOIN tblCase ON CA.CaseNbr = tblCase.CaseNbr

            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            
			LEFT OUTER JOIN tblCaseApptPanel ON CA.CaseApptID = tblCaseApptPanel.CaseApptID
            LEFT OUTER JOIN tblDoctor ON ISNULL(CA.DoctorCode, tblCaseApptPanel.DoctorCode) = tblDoctor.DoctorCode

            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON CA.LocationCode = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCase.Status <> 9 
