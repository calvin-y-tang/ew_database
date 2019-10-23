
-- Issue 4744 - JAP - added DoctorOffice column to result set
CREATE VIEW vwRptDaySheet
AS
     select CA.CaseApptID AS SchedCode ,
		    CA.LocationCode ,
            CAST(CAST(CA.ApptTime AS DATE) AS DATETIME) AS date,
            CA.ApptTime AS StartTime, 
            '' AS Description ,
            --tblApptStatus.Name  AS Status,
            CA.DoctorCode ,            
            C.CaseNbr , 
		    C.ExtCaseNbr , 
            CO.ExtName AS Company ,
            EE.FirstName + ' ' + EE.LastName AS ExamineeName ,
            EE.Sex ,
            L.Location,
		    L.Addr1,
            L.Addr2,
            L.City,
            L.State,
            L.Zip,
            EWF.LegalName AS CompanyName ,
            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName ,
            C.ClaimNbr ,
            CL.FirstName + ' ' + CL.LastName AS ClientName ,
            CT.Description AS Casetypedesc ,
		    CT.EWBusLineID, 
            S.Description AS Servicedesc ,
            CAST(C.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            C.WCBNbr ,
            L.Phone AS DoctorPhone ,
            L.Fax AS DoctorFax ,
            C.PhotoRqd ,
            CL.Phone1 AS ClientPhone ,
            C.DoctorName AS Paneldesc ,
            C.PanelNbr ,
            NULL AS Panelnote ,
            C.OfficeCode,
            CASE WHEN C.CaseNbr IS NULL
                 THEN 'CaseNbr1desc'
                 ELSE NULL
            END AS ScheduleDescription ,
            S.ShortDesc ,
            EWF.Fax ,
            CASE WHEN C.InterpreterRequired = 1 
			  THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
		    CASE WHEN C.LanguageID > 0 
			  THEN LA.Description
			  ELSE ''
		    END AS [Language],
            1 AS Duration ,
            CO.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = C.CaseNbr
                      ) = 'F' 
			  THEN 'Films'
                 ELSE ''
            END AS films , 
		  LO.OfficeCode as LocationOffice, 
		  DRO.OfficeCode as DoctorOffice
    FROM    tblCaseAppt AS CA

				INNER JOIN tblCase AS C ON CA.CaseApptID = C.CaseApptID
				INNER JOIN tblExaminee AS EE on C.ChartNbr = EE.ChartNbr
				INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
				INNER JOIN tblCompany AS CO on CL.CompanyCode = CO.CompanyCode
				INNER JOIN tblCaseType AS CT on C.CaseType = CT.Code		
				INNER JOIN tblServices AS S on C.ServiceCode = S.ServiceCode 

				INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
				INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID

				LEFT JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = C.CaseApptID
				INNER JOIN tblDoctor AS DR ON DR.DoctorCode = ISNULL(CA.DoctorCode, CAP.DoctorCode)
				INNER JOIN tblLocation AS L ON CA.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode
				LEFT JOIN tblLanguage AS LA ON LA.LanguageID = C.LanguageID	
				WHERE CA.ApptStatusID IN (10,100,101,102)


