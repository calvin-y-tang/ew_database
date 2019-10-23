
-- Issue 4744 - JAP - added DoctorOffice column to result set
CREATE VIEW vwRptDaySheet
AS

     SELECT CA.CaseApptID AS RecID,  -- SchedCode
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

            CT.Description AS Casetypedesc ,

            EE.FirstName + ' ' + EE.LastName AS ExamineeName ,

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
            L.Phone AS DoctorPhone ,
            L.Fax AS DoctorFax ,

            EWF.LegalName AS CompanyName ,

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName ,
		    DRO.OfficeCode as DoctorOffice,

            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = C.CaseNbr
                      ) = 'F' 
			  THEN 'Films'
                 ELSE ''
            END AS films , 

            S.ShortDesc ,

		    CASE WHEN C.LanguageID > 0 
			  THEN LA.Description
			  ELSE ''
		    END AS [Language]

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

