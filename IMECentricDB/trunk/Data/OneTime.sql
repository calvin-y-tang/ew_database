
-- ISSUE 12082 - remove "time" from tblDoctorBlockTimeDay.ScheduleDate
UPDATE tblDoctorBlockTimeDay
SET ScheduleDate = CAST(ScheduleDate AS Date)
FROM tblDoctorBlockTimeDay
WHERE DateAdded >= '2021-03-01'
GO


