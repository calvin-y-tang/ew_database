CREATE VIEW [dbo].[vwDoctorSearchResultNew]
AS
SELECT DSR.PrimaryKey,
	   DSR.SessionID,
       DSR.DoctorCode,
       DSR.LocationCode,
       DSR.SchedCode,
       DSR.Selected,
       DSR.Proximity,
	   IIF(DSR.Proximity=9999, '?', CAST(FORMAT(DSR.Proximity, '#.0')  AS VARCHAR)) AS ProximityString,
       REPLACE(DSR.SpecialtyCodes, ', ', CHAR(13) + CHAR(10)) AS SpecialtyCodes,

       ISNULL(CONVERT(VARCHAR, BTD.ScheduleDate, 101), 'Call for Appt') AS FirstAvail,
       BTD.ScheduleDate AS Date,
       BTS.StartTime,

       DR.LastName + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       DR.Prepaid,
       DR.Status,
       DR.Credentials,
       DR.Notes,
       L.Location,
       L.City,
       L.State,
       L.Phone,
       L.County,
	   DSR.DisplayScore,
	   DSR.DoctorRank

FROM tblDoctorSearchResult AS DSR
	INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
    INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
    INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
	LEFT OUTER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeSlotID=DSR.SchedCode
	LEFT OUTER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorBlockTimeDayID=BTS.DoctorBlockTimeDayID