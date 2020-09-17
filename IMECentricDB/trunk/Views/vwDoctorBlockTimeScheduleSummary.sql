CREATE VIEW vwDoctorBlockTimeScheduleSummary
AS  
	
	-- DEV NOTE: the result set of this view needs to match (data type & column names) 
	--		vwDoctorScheduleSummary. These 2 views are conditionally used within the same IMEC code
	--		 and; therefore, need to be in "sync".
   
	-- This grabs all of the block time appts
	SELECT  
		Doc.LastName ,
		Doc.FirstName ,
		Loc.Location ,
		-- need to return date + "00:00" time
		DATEADD(d, DATEDIFF(d, 0, BTDay.ScheduleDate), 0) AS Date , 
          
		-- DEV NOTE: IMEC only looks for Scheduled/Hold value to count as Scheduled but only when CaseNbr is present; 
		--		"Reserved" is not considered scheduled. WHERE clause excludes late cancel/cancel appts.
		CASE BTSlot.DoctorBlockTimeSlotStatusID
			WHEN 22 THEN 'Hold'
			WHEN 30 THEN 'Scheduled' -- this will include your no shows
			ELSE 'Other'
		END AS Status, 
		
		Loc.InsideDr ,
		Doc.DoctorCode ,
		DocOff.OfficeCode ,
		BTDay.LocationCode , 
          
		-- DEV NOTE: Instead of using the Doctor.Booking value we will count the actual number
		--		slots that have been configured for each day, but only for the first slot of each day
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
		LocOff.OfficeCode as LocationOffice,
		
		-- new columns added to help debugging
		CA.CaseApptID AS CaseApptID, 
		NULL AS SchedCode, 
		BTDay.DoctorBlockTimeDayID AS DoctorBlockTimeDayID, 
		BTSlot.DoctorBlockTimeSlotID AS DoctorBlockTimeSlotID
	FROM
		tblDoctorBlockTimeDay AS BTDay
			INNER JOIN tblDoctorBlockTimeSlot AS BTSlot ON BTSlot.DoctorBlockTimeDayID = BTDay.DoctorBlockTimeDayID
			INNER JOIN tblDoctor AS Doc ON Doc.DoctorCode = BTDay.DoctorCode
			INNER JOIN tblLocation AS Loc ON Loc.LocationCode = BTDay.LocationCode
			INNER JOIN tblDoctorOffice AS DocOff ON DocOff.DoctorCode = Doc.DoctorCode 
			INNER JOIN tbllocationoffice AS LocOff ON (LocOff.OfficeCode = DocOff.OfficeCode AND LocOff.LocationCode = Loc.LocationCode) 
			LEFT OUTER JOIN tblCaseAppt AS CA ON CA.CaseApptID = BTSlot.CaseApptID AND (CA.ApptStatusID in (10, 100, 101, 102)) 
			LEFT OUTER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr AND (C.Status <> 9) 
	WHERE   
		(BTDay.Active = 1) 

	UNION ALL

	-- Which we need to UNION with the non-block time appts (include panel exam items)
	SELECT 		
		Doc.LastName ,
		Doc.FirstName ,
		Loc.Location ,
		-- need to return date + "00:00" time
		DATEADD(d, DATEDIFF(d, 0, CA.ApptTime), 0) AS Date , 
		'Scheduled' as Status, 
		Loc.InsideDr ,
		Doc.DoctorCode ,
		DocOff.OfficeCode ,
		CA.LocationCode , 
		1 AS Booking, 
		CA.CaseNbr AS CaseNbr1 , 
		CAST(NULL AS INT) AS CaseNbr2 , 
		CAST(NULL AS INT) AS CaseNbr3 , 
		CAST(NULL AS INT) AS CaseNbr4 , 
		CAST(NULL AS INT) AS CaseNbr5 , 
		CAST(NULL AS INT) AS CaseNbr6 , 
		CA.ApptTime AS StartTime,
		LocOff.OfficeCode as LocationOffice,
		-- new columns added to help debugging
		CA.CaseApptID AS CaseApptID, 
		NULL AS SchedCode, 
		NULL AS DoctorBlockTimeDayID, 
		CA.DoctorBlockTimeSlotID AS DoctorBlockTimeSlotID
	FROM
		tblCaseAppt AS CA 
			LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = CA.CaseApptID
			INNER JOIN tblDoctor AS Doc ON Doc.DoctorCode = IIF(CAP.CaseApptID IS NULL, CA.DoctorCode, CAP.DoctorCode)
			INNER JOIN tblLocation AS Loc ON Loc.LocationCode = CA.LocationCode
			INNER JOIN tblDoctorOffice AS DocOff ON DocOff.DoctorCode = Doc.DoctorCode
			INNER JOIN tbllocationoffice AS LocOff ON (LocOff.OfficeCode = DocOff.OfficeCode AND LocOff.LocationCode = Loc.LocationCode) 
			INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
	WHERE   
		 CA.DoctorBlockTimeSlotID IS NULL 
	 AND (CA.ApptStatusID IN (10, 100, 101, 102)) 
	 AND (C.Status <> 9) 
