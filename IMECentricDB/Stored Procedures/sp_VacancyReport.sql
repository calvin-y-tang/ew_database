CREATE PROCEDURE [dbo].[sp_VacancyReport]
AS

	/*
		- Provide a summary of the next 30 days for Block Time Slot Usage. Days that are set to "Draft" will be excluded.
		- The same Doc/Loc can be assigned to multiple offices. The "default" office for a specific Doc/Loc combination
		  will be the one that has had the most cases assigned to it.
	*/

	-- get case count for doc/loc combination. the office will then be the default office. 
	WITH CTE_DocLocOffCounts AS
	(
		SELECT 
			  DoctorCode, DoctorLocation AS LocationCode, OfficeCode, 
			  COUNT(CaseNbr) AS CaseCount,
			  ROW_NUMBER() OVER(PARTITION BY DoctorCode, DoctorLocation ORDER BY COUNT(CaseNbr) DESC) AS DefaultOffice
		FROM tblCase 
		WHERE DoctorCode IS NOT NULL AND DoctorLocation IS NOT NULL AND OfficeCode IS NOT NULL
		GROUP BY DoctorCode, DoctorLocation, OfficeCode 
	)
	-- for each Doc/Loc/Date combination we need to identify the status for configured Active Block Time Slots
	SELECT 
		 -- basic details so we know the doc/loc/date/status of each slot in our report
		 D.DoctorBlockTimeDayID, S.DoctorBlockTimeSlotID, 
		 D.DoctorCode, D.LocationCode, D.ScheduleDate, 
     
		 -- grab default office & Case Count
		 Cnts.OfficeCode AS DefaultOfficeCode,
		 Cnts.CaseCount AS DefaultOfficeCaseCount,
     
		 -- set an indicator so we know what "status" to count the slot as being in
		 IIF(S.DoctorBlockTimeSlotStatusID = 10, 1, 0) AS OpenSlot,
		 IIF(S.DoctorBlockTimeSlotStatusID = 30, 1, 0) AS CurrentlyScheduleSlot,
		 IIF(S.DoctorBlockTimeSlotStatusID = 21, 1, 0) AS ReservedSlot,
		 IIF(S.DoctorBlockTimeSlotStatusID = 22, 1, 0) AS HoldSlot,
		 IIF(AnyCA.CaseApptID IS NULL OR AnyCA.CaseApptID = 0, 0, 1) AS HasEverScheduled
	INTO 
		 #TempVacancyRpt
	FROM 
		 tblDoctorBlockTimeSlot AS S
			  INNER JOIN tblDoctorBlockTimeDay AS D ON D.DoctorBlockTimeDayID = S.DoctorBlockTimeDayID
			  LEFT OUTER JOIN CTE_DocLocOffCounts AS Cnts ON Cnts.DoctorCode = D.DoctorCode 
			                                             AND Cnts.LocationCode = D.LocationCode 
														 AND Cnts.DefaultOffice = 1
			  LEFT OUTER JOIN tblCaseAppt AS AnyCA ON AnyCA.DoctorBlockTimeSlotID = S.DoctorBlockTimeSlotID
	WHERE 
			 D.Active = 1
		 AND (
				   D.ScheduleDate >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) 
			   AND D.ScheduleDate < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 30)
			 )
	
-- calculate totals for the various slot statuses for each Doc/Loc/Date
SELECT 
     tmp.DoctorBlockTimeDayID, tmp.DefaultOfficeCode, tmp.DoctorCode, tmp.LocationCode, tmp.ScheduleDate, tmp.DefaultOfficeCaseCount,
     COUNT(tmp.DoctorBlockTimeSlotID) AS TTLSlots, 
     SUM(tmp.OpenSlot) AS TTLOpen, 
     SUM(tmp.HoldSlot) AS TTLHold, 
     SUM(tmp.ReservedSlot) AS TTLReserved,
     SUM(tmp.CurrentlyScheduleSlot) AS TTLSched, 
     SUM(tmp.HasEverScheduled) AS TTLPrevSched
INTO 
     #TempVacancyRptTotals
FROM #TempVacancyRpt AS tmp
GROUP BY tmp.DoctorBlockTimeDayID, tmp.DefaultOfficeCode, tmp.DoctorCode, tmp.LocationCode, tmp.ScheduleDate, tmp.DefaultOfficeCaseCount

-- crete the desired summary result set using previously calculated totals
SELECT 
     -- some ID columns for linking to source data and testing/debugging purposes
	 tmp.DoctorBlockTimeDayID,
     tmp.DefaultOfficeCode, 
     tmp.LocationCode, 
     tmp.DoctorCode, 
     tmp.ScheduleDate,
     
	 -- office information
     tblOffice.Description, 
     
	 -- doctor information
     Doc.LastName, 
     Doc.FirstName, 
     Doc.Booking, 
     (SELECT TOP 1 specialtycode FROM tblDoctorSpecialty WHERE doctorcode = Doc.doctorcode) Specialty,

	 -- location information
     Loc.Location, 
     
	 -- counts
     DefaultOfficeCaseCount,
     TTLSlots,
     TTLOpen,
     TTLHold, 
     TTLReserved,
     TTLSched,
     TTLPrevSched
     
FROM #TempVacancyRptTotals AS tmp
          INNER JOIN tblOffice ON tblOffice.OfficeCode = tmp.DefaultOfficeCode
          INNER JOIN tblDoctor AS Doc ON Doc.DoctorCode = tmp.DoctorCode 
          INNER JOIN tblLocation AS Loc ON Loc.LocationCode = tmp.LocationCode 
ORDER BY Doc.LastName, Doc.FirstName, Tmp.ScheduleDate

RETURN 0
