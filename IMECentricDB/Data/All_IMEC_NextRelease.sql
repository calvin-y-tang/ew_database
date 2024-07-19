-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 138

-- IMEC-14286 - encrypt tblProblem.Description 
-- **** DEV NOTE MOVING THIS TO CHUBB DEPLOYMEMT SCRIPT (BELOW)
--GO
--OPEN SYMMETRIC KEY IMEC_CLE_Key
--      DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
--UPDATE tblProblem
--     SET Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), Description)
--     FROM tblExaminee
--GO


-- IMEC-14305 - Security Token & Business Rule to control access to "File Browse" button on Case Letter/Report
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('CaseFileBrowseBtn', 'Case - Allow File Browse', GETDATE())
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (122, 'SetEnableStateFileBrowse', 'Case', 'Set Enabled state of FIle Browse button for Documents and Reports', 1, 1016, 1, NULL, NULL, NULL, NULL, 'OvrRideSecToken', 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (122, 'PC', 16, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CaseFileBrowseBtn', 0, NULL)
GO







-- ****** NEED TO RUN THIS LAST *****
-- ***** CHUBB ENCRYPTION DEPLOYMENT *****
/*
     Background: 
          tblExaminee and tblProblem will have some encrypted columns. The original columns 
          will remain but have not data (set to NULL) and there will be new "encrypted"
          columns that will contain the encrypted values of the values in the original 
          columns. Update/Insert triggers are used to handle encrypting data values when
          items are added/modified in these tables.

     Description: 
          This is a special one-off script that will be used to encrypt some columns
          in tblExaminee and tblDescription. In order to ensure that no data loss
          occurs the following steps are needed.
               - Insert/Update triggers for tblExaminee and tblProblem must be dropped. if
                 they are not then we will end up losing the original data that was present 
                 in the columns that are being encrypted.
               - Now we can encrypted the data, which populates the new "encrypted" columns
               - At this point the original data values have been encrypted and saved to 
                 new columns. We can now blank out (set to NULL) the original columns. Leaving 
                 the original columns blank. Their only purpose is "fire" the  triggers for 
                 when those data elements are modified or new items added to the table.
               - Lastly we need to load the triggers for tblExaminee and tblProblems
*/

-- 1. Back up tables into a temp tables...
SELECT * INTO tmpProblem_PreEncrypt FROM tblProblem
SELECT * INTO tmpExaminee_PreEncrypt FROM tblExaminee
GO 

-- 2. Drop Update/Insert triggers. If we don't then encrypted values will update 
--    to the "new" values and we end up with no data!!!!
drop trigger [dbo].[tblExaminee_AfterUpdate_TRG]
drop trigger [dbo].[tblExaminee_AfterInsert_TRG]
drop trigger [dbo].[tblProblem_AfterUpdate_TRG]
drop trigger [dbo].[tblProblem_AfterInsert_TRG]
GO

-- 3. ensure Examinee data is encrypted
OPEN SYMMETRIC KEY IMEC_CLE_Key
          DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
UPDATE tblExaminee
     SET ssn_encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), SSN), 
         DOB_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, DOB, 20))
     FROM tblExaminee
     WHERE SSN_Encrypted IS NULL OR DOB_Encrypted IS NULL
GO

-- 4. ensure Problem data is encrypted
OPEN SYMMETRIC KEY IMEC_CLE_Key
      DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
UPDATE tblProblem
     SET Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), Description)
     FROM tblProblem
     WHERE Description_Encrypted IS NULL
GO

-- 4. clear out examinee and problem original values
UPDATE tblExaminee
     SET SSN = null,
         DOB = null
    FROM tblExaminee
GO
UPDATE tblProblem
   SET Description = null
  FROM tblProblem
GO

-- 5. Load triggers tblProblem
CREATE TRIGGER [dbo].[tblProblem_AfterInsert_TRG]
   ON  [dbo].[tblProblem]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate

     UPDATE P
        SET P.Description_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description)
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode;

END

GO
CREATE TRIGGER [dbo].[tblProblem_AfterUpdate_TRG]
   ON  [dbo].[tblProblem]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
     
     UPDATE P
        SET P.Description_Encrypted = IIF(I.Description = D.Description,
                                  P.Description_Encrypted,
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.Description))
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode
               INNER JOIN Deleted AS D ON I.ProblemCode = P.ProblemCode
        WHERE I.Description <> D.Description 
           OR I.Description IS NULL 
           OR D.Description IS NULL;

     UPDATE P
        SET P.Description = NULL
       FROM tblProblem AS P
               INNER JOIN Inserted AS I ON I.ProblemCode = P.ProblemCode
               INNER JOIN Deleted AS D ON I.ProblemCode = P.ProblemCode;
     
     CLOSE SYMMETRIC KEY IMEC_CLE_Key;

END

-- 6. Load triggers tblExaminee
GO
CREATE TRIGGER [dbo].[tblExaminee_AfterInsert_TRG]
   ON  [dbo].[tblExaminee]
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate

     UPDATE E
        SET E.SSN_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.SSN),
            E.DOB_Encrypted = EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, I.DOB, 20))
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr

END

GO
CREATE TRIGGER [dbo].[tblExaminee_AfterUpdate_TRG]
   ON  [dbo].[tblExaminee]
   AFTER UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

	OPEN SYMMETRIC KEY IMEC_CLE_Key
             DECRYPTION BY CERTIFICATE IMEC_CLE_Certificate
     
     UPDATE E
        SET E.SSN_Encrypted = IIF(I.SSN = D.SSN,
                                  E.SSN_Encrypted,
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), I.SSN)),
            E.DOB_Encrypted = IIF(I.DOB = D.DOB, 
                                  E.DOB_Encrypted, 
                                  EncryptByKey (Key_GUID('IMEC_CLE_Key'), CONVERT(VARCHAR, I.DOB, 20)))
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr
               INNER JOIN Deleted AS D ON D.ChartNbr = E.ChartNbr
        WHERE I.SSN <> D.SSN OR I.SSN IS NULL OR D.SSN IS NULL
           OR I.DOB <> D.DOB OR I.DOB IS NULL OR D.DOB IS NULL
     
     UPDATE E
        SET E.SSN = NULL, 
            E.DOB = NULL
       FROM tblExaminee AS E
               INNER JOIN Inserted AS I ON I.ChartNbr = E.ChartNbr
               INNER JOIN Deleted AS D ON D.ChartNbr = E.ChartNbr
     
     CLOSE SYMMETRIC KEY IMEC_CLE_Key;

END

