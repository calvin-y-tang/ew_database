use IMECentricPOPB
GO
DELETE FROM tblPOPBVoucher WHERE CaseDoctorCode IS NULL

UPDATE tblPOPBVoucher SET Percentage=10, DoctorCode2=1, Percentage2=10
GO
