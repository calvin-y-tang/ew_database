-- Sprint 103

-- IMEC-13360 -- need to remove security token to ensure it is not going to be used.
DELETE FROM tblUserFunction WHERE FunctionCode = 'DoctorSpecialtyEdit'
GO
DELETE FROM tblGroupFunction WHERE FunctionCode = 'DoctorSpecialtyEdit'
GO

