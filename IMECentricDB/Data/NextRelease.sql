-- Sprint 95

-- IMEC-13046 patch specialties (need to set based on CRN Specialty list) (Check Canada in production???)
UPDATE tblSpecialty
   SET ControlledByIMEC = 0
  FROM crn.crn_production.[dbo].[Specialty_Dictionary] AS CRN 
          INNER JOIN tblSpecialty AS IMEC ON IMEC.SpecialtyCode = CRN.SpecialtyName
GO
UPDATE tblSpecialty
   SET ControlledByIMEC = 1
  FROM tblSpecialty
 WHERE controlledByIMEC IS NULL
GO
-- new security token
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('DoctorSpecialtyEdit','Doctor - Modify Attached Specialties', GETDATE())
GO
