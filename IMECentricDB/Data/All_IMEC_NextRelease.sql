-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 137

-- IMEC-14254 - business rules and business rule conditions for Farmers claim number format
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip,
  IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, BrokenRuleAction)
VALUES (171, 'ClaimNbrFormat', 'Case', 'Defines claim number format on case form', 1, 1001, 1, 'Format', 'Override Sec Token', 0)
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID,
   DateAdded, UserIDAdded, EWBusLineID, Param1, Param2)
  VALUES 
   ('PC', 24, 2, 1, 171, GETDATE(), 'Admin', 2, '##########-#-#', 'ClaimNbrFormatOverride'),
   ('PC', 24, 2, 1, 171, GETDATE(), 'Admin', 5, '##########-#-#', 'ClaimNbrFormatOverride'),
   ('PC', 24, 2, 1, 171, GETDATE(), 'Admin', 3, '##########-#', 'ClaimNbrFormatOverride')
GO

-- IMEC-14254 - Start date for cases added for Farmers claim number format
INSERT INTO tblSetting ([Name], [Value])
VALUES ('FarmersClaimNbrFormatStartDate', '2024/07/01')
GO

-- IMEC-14254 - security token for Farmers claim number format override
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
  VALUES ('ClaimNbrFormatOverride', 'Case - Claim Nbr Format Override', GETDATE())
GO

-- ****************************************************************************************************************
-- IMEC-14239 (IMEC-14198) - enable CLE for tblExaminee DOB & SSN

-- Encryption Setup/Configuration
    -- create master key
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Im3Centr!c';
    GO
    -- create certificate
    CREATE CERTIFICATE IMEC_CLE_Certificate 
         WITH SUBJECT = 'IMECentric CLE';
    GO
    -- create symmetrical key
    CREATE SYMMETRIC KEY IMEC_CLE_Key 
         WITH ALGORITHM = AES_256 
         ENCRYPTION BY CERTIFICATE IMEC_CLE_Certificate;
    GO

	-- Encrypt tblExaminee
	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
    GO
    UPDATE tblExaminee
       SET ssn_encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), SSN), 
           DOB_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, DOB, 20)) 
      FROM tblExaminee
    GO

-- ****************************************************************************************************************
