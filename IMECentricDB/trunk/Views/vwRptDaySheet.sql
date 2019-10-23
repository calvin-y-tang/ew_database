
-- Issue 4744 - JAP - added DoctorOffice column to result set
CREATE VIEW vwRptDaySheet
AS
     select tblCaseAppt.CaseApptID AS SchedCode ,
		  tblCaseAppt.LocationCode ,
            CAST(CAST(tblCaseAppt.ApptTime AS DATE) AS DATETIME) AS date,
            tblCaseAppt.ApptTime AS StartTime, 
            '' AS Description ,
            tblApptStatus.Name  AS Status,
            tblCaseAppt.DoctorCode ,            
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
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
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
                 THEN 'CaseNbr1desc'
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 
			  THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
		  CASE WHEN tblCase.LanguageID > 0 
			  THEN tblLanguage.Description
			  ELSE ''
		  END AS [Language],
            1 AS Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' 
			  THEN 'Films'
                 ELSE ''
            END AS films , 
		  tblLocationOffice.OfficeCode as LocationOffice, 
		  tblDoctorOffice.OfficeCode as DoctorOffice
    FROM    tblCaseAppt 
				LEFT JOIN tblCase ON tblCaseAppt.CaseApptID = tblCase.CaseApptID
				LEFT JOIN tblCaseApptPanel ON tblCaseApptPanel.CaseApptID = tblCase.CaseApptID
				INNER JOIN tblDoctor ON tblDoctor.DoctorCode = ISNULL(tblCaseAppt.DoctorCode, tblCaseApptPanel.DoctorCode)
				INNER JOIN tblLocation on tblCaseAppt.LocationCode = tblLocation.LocationCode
				INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
				INNER JOIN tblLocationOffice ON tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode
				LEFT JOIN tblApptStatus ON tblApptStatus.ApptStatusID = tblCaseAppt.ApptStatusID
				INNER JOIN tblClient on tblCase.ClientCode = tblClient.ClientCode
				INNER JOIN tblCompany on tblClient.CompanyCode = tblCompany.CompanyCode
				INNER JOIN tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
				INNER JOIN tblEWFacility on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
				INNER JOIN tblServices on tblCase.ServiceCode = tblServices.ServiceCode 
				INNER JOIN tblExaminee on tblCase.ChartNbr = tblExaminee.ChartNbr
				INNER JOIN tblCaseType on tblCase.CaseType = tblCaseType.Code		
				LEFT JOIN tblLanguage on tblLanguage.LanguageID = tblcase.LanguageID	
				WHERE tblApptStatus.ApptStatusID IN (10,100,101,102)

