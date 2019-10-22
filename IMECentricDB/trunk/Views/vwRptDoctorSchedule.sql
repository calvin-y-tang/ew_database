CREATE VIEW vwRptDoctorSchedule
AS
     SELECT CA.CaseApptID AS RecID,
            CA.DoctorCode ,            
			CA.LocationCode ,
            CAST(CAST(CA.ApptTime AS DATE) AS DATETIME) AS Date,
            CA.ApptTime AS StartTime, 

            --'' AS Description ,

            ApptS.Name  AS Status,

            C.CaseNbr , 
			C.ExtCaseNbr , 
            --C.ClaimNbr ,
            --C.WCBNbr ,
            CAST(C.SpecialInstructions AS VARCHAR(1000)) AS SpecialInstructions ,
            C.PhotoRqd ,
            C.PanelNbr ,
            C.DoctorName AS Paneldesc ,
            --NULL AS Panelnote ,
            C.OfficeCode,

            CASE WHEN C.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
			--CASE WHEN C.LanguageID > 0 THEN LG.Description
			--	ELSE ''
			--END AS [Language],

            --CASE WHEN C.CaseNbr IS NULL
            --     THEN 'CaseNbr1desc'
            --     ELSE NULL
            --END AS ScheduleDescription ,

            CT.ShortDesc AS CaseTypeDesc ,
			--CT.EWBusLineID, 
            S.Description AS Servicedesc ,
            --S.ShortDesc ,

            EE.FirstName + ' ' + EE.LastName AS ExamineeName ,
            --EE.Sex ,

            --CO.IntName AS CompanyIntName ,
            CO.ExtName AS Company ,

            CL.FirstName + ' ' + CL.LastName AS ClientName ,
            CL.Phone1 AS ClientPhone ,

			LO.OfficeCode as LocationOffice,
            L.Location,
			L.Addr1,
            L.Addr2,
            L.City,
            L.State,
            L.Zip,
            L.Phone AS LocationPhone ,
            L.Fax AS LocationFax ,

            EWF.LegalName AS CompanyName ,
            --EWF.Fax ,

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName

			--1 AS Duration

    FROM    tblCaseAppt AS CA
				INNER JOIN tblApptStatus AS ApptS ON ApptS.ApptStatusID = CA.ApptStatusID

				INNER JOIN tblCase AS C ON CA.CaseApptID = C.CaseApptID
				INNER JOIN tblExaminee AS EE on C.ChartNbr = EE.ChartNbr
				INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
				INNER JOIN tblCompany AS CO on CL.CompanyCode = CO.CompanyCode
				INNER JOIN tblCaseType AS CT on C.CaseType = CT.Code		
				INNER JOIN tblServices AS S on C.ServiceCode = S.ServiceCode 
				LEFT JOIN tblLanguage AS LG on LG.LanguageID = C.LanguageID

				INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
				INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID

				LEFT JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = C.CaseApptID
				INNER JOIN tblDoctor AS DR ON DR.DoctorCode = ISNULL(CA.DoctorCode, CAP.DoctorCode)
				INNER JOIN tblLocation AS L ON CA.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode



