CREATE VIEW vwRptDoctorScheduleSlot
AS
     SELECT BTS.RecID,
            BTD.DoctorCode,            
			BTD.LocationCode,
            BTD.ScheduleDate AS Date,
			BTS.StartTime AS StartTime, 

            NULL AS CaseNbr , 
			NULL AS ExtCaseNbr , 
            '' AS SpecialInstructions ,
            NULL AS PhotoRqd ,
            NULL AS PanelNbr ,
            '' AS PanelDesc,
            NULL AS CaseOfficeCode,

            '' AS Interpreter,

            BTSS.Name AS ScheduleDesc1,

			'' AS ScheduleDesc2,

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

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName,

			'' AS Problem

    FROM (SELECT MAX(DoctorBlockTimeSlotID) AS RecID, MAX(DoctorBlockTimeSlotStatusID) AS DoctorBlockTimeSlotStatusID,
		  DoctorBlockTimeDayID, StartTime FROM tblDoctorBlockTimeSlot
		  GROUP BY DoctorBlockTimeDayID, StartTime
		  HAVING MIN(IIF(DoctorBlockTimeSlotStatusID IN (10,22), 1, 0))=1
		  ) AS BTS
			INNER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorBlockTimeDayID = BTS.DoctorBlockTimeDayID
			INNER JOIN tblDoctorBlockTimeSlotStatus AS BTSS ON BTSS.DoctorBlockTimeSlotStatusID = BTS.DoctorBlockTimeSlotStatusID
			INNER JOIN tblDoctor AS DR ON DR.DoctorCode = BTD.DoctorCode
			INNER JOIN tblLocation AS L ON BTD.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode

				INNER JOIN tblOffice AS O ON DRO.OfficeCode = O.OfficeCode
			INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID