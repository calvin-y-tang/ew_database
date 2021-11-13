CREATE VIEW vwScheduleViewer
AS
    SELECT tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS CaseTypeDesc , 
            tblServices.Description AS Servicedesc ,
            tblCase.PanelNbr ,
            tblCase.OfficeCode,			
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName
    FROM    tblDoctorSchedule 
				INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
				INNER JOIN tblLocation ON tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
				INNER JOIN tblLocationOffice ON tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode
				LEFT OUTER JOIN tblCase
					INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
					INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
					INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
					INNER JOIN tblEWFacility ON tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode 
					INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
					INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code		
					LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblcase.LanguageID
					LEFT OUTER JOIN tblCasePanel ON tblCasePanel.PanelNbr = tblCase.PanelNbr
				ON tblDoctorSchedule.SchedCode = ISNULL(tblCasePanel.SchedCode, tblCase.SchedCode)