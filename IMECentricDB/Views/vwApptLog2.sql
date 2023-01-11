
CREATE VIEW vwApptLog2
AS
    SELECT 
            vwCaseAppt.CaseNbr ,
            vwCaseAppt.DateAdded ,
			tblCase.DateAdded AS CaseDateAdded,
            vwCaseAppt.ApptTime ,
            DATEADD(dd, 0, DATEDIFF(dd, 0, vwCaseAppt.ApptTime)) AS ApptDate ,
            tblCaseType.Description AS [Case Type] ,
            vwCaseAppt.DoctorNames AS Doctor,
            tblClient.FirstName + ' ' + tblClient.LastName AS Client ,
	        ISNULL(tblClient.Phone1, '')+' '+ISNULL(tblClient.Phone1Ext, '') AS clientphone,
            tblCompany.IntName AS Company ,
            tblCase.DoctorLocation ,
            tblLocation.Location ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS Examinee ,
            tblCase.MarketerCode ,
            tblCase.SchedulerCode ,
            tblExaminee.SSN ,
            tblQueues.StatUSDesc ,
            vwCaseAppt.DoctorCodes AS DoctorCode ,
            tblCase.ClientCode ,
            tblCompany.CompanyCode ,
            tblCase.Priority ,
            tblCase.CommitDate ,
            tblCase.ServiceCode ,
            tblServices.ShortDesc ,
            vwCaseAppt.Specialties AS Specialty ,
            tblCase.OfficeCode ,
            tblOffice.Description AS OfficeName ,
            tblCase.QARep AS QARepCode ,
            tblCase.Casetype ,
            tblCase.MastersubCase ,
            ( SELECT TOP 1
                        tblCaseAppt.ApptTime
              FROM      tblCaseAppt
              WHERE     tblCaseAppt.CaseNbr = tblCase.CaseNbr
                        AND tblCaseAppt.CaseApptID<vwCaseAppt.CaseApptID
              ORDER BY  tblCaseAppt.CaseApptID DESC
            ) AS PreviousApptTime ,
            '' AS ProvTypeCode , 
			tblCase.ExtCaseNbr 
    FROM    vwCaseAppt
            INNER JOIN tblCase ON vwCaseAppt.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            LEFT OUTER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
    WHERE   tblCase.Status <> 9
