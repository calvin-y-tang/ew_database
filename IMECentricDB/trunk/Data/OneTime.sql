
-- ISSUE 12082 - remove "time" from tblDoctorBlockTimeDay.ScheduleDate
UPDATE tblDoctorBlockTimeDay
SET ScheduleDate = CAST(ScheduleDate AS Date)
FROM tblDoctorBlockTimeDay
WHERE DateAdded >= '2021-03-01'
GO

-- IMEC-12095 - need to clean up existing problem so 
--		that a unique index can be successfully created.
DELETE 
  FROM tblDoctorBlockTimeDay 
 WHERE DoctorBlockTimeDayID NOT IN (SELECT DISTINCT DoctorBlockTimeDayID FROM tblDoctorBlockTimeSlot)
GO
DELETE 
  FROM tblDoctorBlockTimeSlot 
 WHERE DoctorBlockTimeDayID NOT IN (SELECT DISTINCT DoctorBlockTimeDayID FROM tblDoctorBlockTimeDay)
GO

-- Issue 10778 - set CMS1500 Boxes 19 and 28 for past behavior
UPDATE tblDocument SET CMSBox19 = '%Blank%' 
WHERE Document LIKE 'CMS%' AND Type = 'Invoice' AND CMSBox19 IS NULL

UPDATE tblDocument SET CMSBox28Dollars = '%InvoiceAmtDollars%', CMSBox28Cents='%InvoiceAmtCents%'
WHERE Document LIKE 'CMS%' AND Type = 'Invoice' AND CMSBox28Cents IS NULL AND CMSBox28Dollars IS NULL


-- Issue 12030 - sprint 65 Branding for file link - set MCMC offices WebCompanyID to the MCMC Web compay ID
UPDATE IMECentricEW.dbo.tblOffice SET WebCompanyID = 62 WHERE OfficeCode = 43


