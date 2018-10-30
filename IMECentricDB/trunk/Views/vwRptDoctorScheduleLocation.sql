CREATE VIEW vwRptDoctorScheduleLocation
AS
     select  tblDoctorSchedule.SchedCode ,
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
            tblExaminee.Sex ,
            tblLocation.Location,
			tblLocation.Addr1,
            tblLocation.Addr2,
            tblLocation.City,
            tblLocation.State,
            tblLocation.Zip,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
			tblCaseType.EWBusLineID, 
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			CASE WHEN tblCase.LanguageID > 0 THEN tblLanguage.Description
				ELSE ''
			END AS [Language],
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
			tblLocationOffice.OfficeCode as LocationOffice 
    FROM    tblDoctorSchedule 
				INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
				inner join tblLocation on tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
				INNER JOIN tblLocationOffice ON tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode
				left outer join tblCase
					inner join tblClient on tblCase.ClientCode = tblClient.ClientCode
					inner join tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
					inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
					inner join tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					inner join tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
					inner join tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
					inner join tblCaseType on tblCase.CaseType = tblCaseType.Code		
					left outer join tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID			
					LEFT OUTER JOIN tblCasePanel ON tblCasePanel.PanelNbr = tblCase.PanelNbr
				ON tblDoctorSchedule.SchedCode = ISNULL(tblCasePanel.SchedCode, tblCase.SchedCode)