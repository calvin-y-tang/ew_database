CREATE VIEW vwDoctorBlockTimeScheduleSummary
AS  
	
	-- DEV NOTE: the result set of this view needs to match (data type & column names) 
	--		vwDoctorScheduleSummary. These 2 views are conditionally used within the same IMEC code
	--		 and; therefore, need to be in "sync".

   SELECT  
		Doc.LastName ,
		Doc.FirstName ,
		Loc.Location ,
		-- DEVNOTE: need to play around with ScheduleDate to return date + "00:00" time
		--		which is needed for the summary page to dispaly properly.
		DATEADD(d, DATEDIFF(d, 0, BTDay.ScheduleDate), 0) AS Date , 

		-- DEV NOTE: IMEC only looks for Scheduled/Hold value to count as Scheduled but only when CaseNbr is present; 
		--		"Reserved" is not considered scheduled.
		CASE BTSlot.DoctorBlockTimeSlotStatusID
			WHEN 10 THEN 'Open'
			WHEN 21 THEN 'Reserved' 
			WHEN 22 THEN 'Hold'
			WHEN 30 THEN 'Scheduled'
			ELSE 'Other'
		END AS Status, 
		
		Loc.InsideDr ,
		Doc.DoctorCode ,
		DocOff.OfficeCode ,
		BTDay.LocationCode , 
		
		-- DEV NOTE: Instead of using the Doctor.Booking value we will count the actualy number
		--		slots that have been configured for each day.
		(SELECT IIF(MIN(sl.DoctorBlockTimeSlotID) = BTSlot.DoctorBlockTimeSlotID, COUNT(sl.DoctorBlockTimeSlotID), 0) 
		   FROM tblDoctorBlockTimeSlot AS sl 
		  WHERE sl.DoctorBlockTimeDayID = BTDay.DoctorBlockTimeDayID AND sl.StartTime = BTSlot.StartTime) AS Booking,

		-- DEV NOTE: we now a multiple rows to define each potential booking slot at the same date/time; therefore, 
		--		we only ever have CaseNbr1 to set/process but there may be multiple rows for the same time.
		CA.CaseNbr AS CaseNbr1 , 
		CAST(NULL AS INT) AS CaseNbr2 , 
		CAST(NULL AS INT) AS CaseNbr3 , 
		CAST(NULL AS INT) AS CaseNbr4 , 
		CAST(NULL AS INT) AS CaseNbr5 , 
		CAST(NULL AS INT) AS CaseNbr6 , 
		BTSlot.StartTime, 
		LocOff.OfficeCode as LocationOffice 
    FROM    
		tblDoctorBlockTimeDay AS BTDay
			INNER JOIN tblDoctorBlockTimeSlot AS BTSlot ON BTSlot.DoctorBlockTimeDayID = BTDay.DoctorBlockTimeDayID
			INNER JOIN tblDoctor AS Doc ON Doc.DoctorCode = BTDay.DoctorCode
			INNER JOIN tblLocation AS Loc ON Loc.LocationCode = BTDay.LocationCode
			INNER JOIN tblDoctorOffice AS DocOff ON DocOff.DoctorCode = Doc.DoctorCode 
			INNER JOIN tbllocationoffice AS LocOff ON (LocOff.OfficeCode = DocOff.OfficeCode AND LocOff.LocationCode = Loc.LocationCode) 
			LEFT OUTER JOIN tblCaseAppt AS CA ON CA.CaseApptID = BTSlot.CaseApptID
    WHERE   
		(BTDay.Active = 1) 
