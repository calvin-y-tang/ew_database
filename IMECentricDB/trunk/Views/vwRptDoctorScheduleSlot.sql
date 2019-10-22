CREATE VIEW vwRptDoctorScheduleSlot
AS
     SELECT CA.SchedCode AS RecID,
            CA.DoctorCode,            
			CA.LocationCode,
            CAST(CAST(CA.Date AS DATE) AS DATETIME) AS Date,
            CA.StartTime AS StartTime, 

            NULL AS CaseNbr , 
			NULL AS ExtCaseNbr , 
            '' AS SpecialInstructions ,
            NULL AS PhotoRqd ,
            NULL AS PanelNbr ,
            '' AS PanelDesc,
            NULL AS CaseOfficeCode,

            '' AS Interpreter,

            CA.Status AS ScheduleDesc1,

			CA.Description AS ScheduleDesc2,

            '' AS Company ,

            '' AS ClientName ,
            '' AS ClientPhone ,

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

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName

    FROM    tblDoctorSchedule AS CA

				INNER JOIN tblDoctor AS DR ON DR.DoctorCode = CA.DoctorCode
				INNER JOIN tblLocation AS L ON CA.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode

				INNER JOIN tblOffice AS O ON DRO.OfficeCode = O.OfficeCode
				INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID


	WHERE CA.Status IN ('Open', 'Hold', 'Held')