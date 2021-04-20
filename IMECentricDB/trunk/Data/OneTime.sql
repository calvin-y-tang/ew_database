
-- ISSUE 12082 - remove "time" from tblDoctorBlockTimeDay.ScheduleDate
UPDATE tblDoctorBlockTimeDay
SET ScheduleDate = CAST(ScheduleDate AS Date)
FROM tblDoctorBlockTimeDay
WHERE DateAdded >= '2021-03-01'
GO


-- Issue 10778 - set CMS1500 Boxes 19 and 28 for past behavior
UPDATE tblDocument SET CMSBox19 = '%Blank%' 
WHERE Document LIKE 'CMS1500%' AND CMSBox19 IS NULL

UPDATE tblDocument SET CMSBox28Dollars = '%InvAmtDetailDollars%', CMSBox28Cents='%InvAmtDetailCents'
WHERE Document LIKE 'CMS1500%' AND CMSBox28Cents IS NULL AND CMSBox28Dollars IS NULL



