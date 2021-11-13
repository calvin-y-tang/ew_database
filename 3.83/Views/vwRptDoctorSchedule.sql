CREATE VIEW vwRptDoctorSchedule
AS
     SELECT CA.CaseApptID AS RecID,
            CA.DoctorCode ,            
			CA.LocationCode ,
            CAST(CAST(CA.ApptTime AS DATE) AS DATETIME) AS Date,
            CA.ApptTime AS StartTime, 

            C.CaseNbr , 
			C.ExtCaseNbr , 
            CAST(C.SpecialInstructions AS VARCHAR(1000)) AS SpecialInstructions ,
            C.PhotoRqd ,
            C.PanelNbr ,
            C.DoctorName AS PanelDesc,
            C.OfficeCode AS CaseOfficeCode,

            CASE WHEN C.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter,

            EE.FirstName + ' ' + EE.LastName AS ScheduleDesc1,

			ISNULL(CT.ShortDesc, '') + ' / ' + ISNULL(S.Description, '') AS ScheduleDesc2,

            CO.ExtName AS Company ,

            CL.FirstName + ' ' + CL.LastName AS ClientName ,
            CL.Phone1 AS ClientPhone ,

			LO.OfficeCode as LocationOfficeCode,
            L.Location,
			L.Addr1,
            L.Addr2,
            L.City,
            L.State,
            L.Zip,
            L.Phone AS LocationPhone ,
            L.Fax AS LocationFax ,

            EWF.LegalName AS CompanyName ,

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName,

			ISNULL((STUFF((
			SELECT CHAR(13) + CHAR(10) + CAST(P.Description AS VARCHAR)
			FROM tblProblem AS P
			INNER JOIN tblCaseProblem AS CP ON CP.ProblemCode = P.ProblemCode
			WHERE CP.CaseNbr=C.CaseNbr
			FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')),'') AS Problem

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

	WHERE CA.ApptStatusID IN (10,100,101,102)
	  AND C.Status <> 9



