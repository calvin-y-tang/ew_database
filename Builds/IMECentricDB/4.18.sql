

IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblSpecialty]...';


GO
ALTER TABLE [dbo].[tblSpecialty]
    ADD [ControlledByIMEC] BIT CONSTRAINT [DF_tblSpecialty_ControlledByIMEC] DEFAULT (0) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO

IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO
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
