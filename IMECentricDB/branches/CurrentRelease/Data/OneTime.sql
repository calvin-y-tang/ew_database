
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


-- Issue 12030 - sprint 65 Branding for file link - set MCMC offices WebCompanyID to the MCMC Web compay ID
UPDATE IMECentricEW.dbo.tblOffice SET WebCompanyID = 62 WHERE OfficeCode = 43
GO

-- Issue 12109 - Default Dr  to "All" for network fee schedules
UPDATE dtl
SET Doctor = -1
FROM tblFSHeaderSetup AS hdr
          INNER JOIN tblFSDetailSetup AS dtl ON dtl.FSHeaderSetupID = hdr.FSHeaderSetupID
WHERE hdr.EntityType = 'NW'
GO
