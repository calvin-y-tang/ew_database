-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 134

-- JAP - IMEC-14200 - set default value for previously added DoNotUse column
UPDATE tblDoctorSpecialty SET DoNotUse = 0 WHERE DoNotUse IS NULL
GO 

