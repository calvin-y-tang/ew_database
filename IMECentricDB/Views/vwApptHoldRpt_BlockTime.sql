CREATE VIEW [dbo].[vwApptHoldRpt_BlockTime]
	AS
	    SELECT
			CAST(ApptDay.ScheduleDate AS DATE) AS Date,
			ApptSlot.StartTime,
			ApptStatus.Name as Status,
			ApptSlot.Duration,
			ApptSlot.HoldDescription as CaseNbr1desc, 
			Doc.FirstName + ' ' + Doc.LastName AS doctor,
			Loc.Location,
			ApptSlot.UserIDEdited,
			DocOff.OfficeCode
		FROM tblDoctorBlockTimeDay AS ApptDay
				  INNER JOIN tblDoctorBlockTimeSlot AS ApptSlot ON ApptSlot.DoctorBlockTimeDayID = ApptDay.DoctorBlockTimeDayID 
				  INNER JOIN tblDoctor AS Doc ON Doc.DoctorCode = ApptDay.DoctorCode
				  INNER JOIN tblLocation AS Loc ON Loc.LocationCode = ApptDay.LocationCode
				  INNER JOIN tblDoctorOffice AS DocOff ON DocOff.DoctorCode = Doc.DoctorCode
				  INNER JOIN tblDoctorBlockTimeSlotStatus AS ApptStatus ON ApptStatus.DoctorBlockTimeSlotStatusID = ApptSlot.DoctorBlockTimeSlotStatusID
		where ApptSlot.DoctorBlockTimeSlotStatusID = 22
