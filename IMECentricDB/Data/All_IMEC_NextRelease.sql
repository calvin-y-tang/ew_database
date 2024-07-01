-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 138

-- IMEC-14286 - encrypt tblProblem.Description 
GO
OPEN SYMMETRIC KEY IMEC_CLE_Key
      DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
UPDATE tblProblem
     SET Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), Description)
     FROM tblExaminee
GO

