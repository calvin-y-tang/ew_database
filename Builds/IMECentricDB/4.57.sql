

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
PRINT N'Altering [dbo].[tblDoctorSpecialty]...';


GO
ALTER TABLE [dbo].[tblDoctorSpecialty]
    ADD [DoNotUse] BIT NULL;


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
-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 132

-- IMEC-14109 - new security token to lock down Doctor Accounting fields
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('DoctorEditAcctngFields', 'Doctor - Edit Accounting Fields', GETDATE())
GO

-- IMEC-14110 - new security tokem to enable changes for Specialty Do Not Use setting
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES ('DoctorEditSpecialtyDoNotUse', 'Doctor - Update Specialty Do Not Use', GETDATE())
GO

-- IMEC-14076 - Business Rules to drive new "WCCaseTypeAddressee" bookmark 
-- **** DEV NOTE: This was undone in a rollback and needs to be re-applied
UPDATE tblBusinessRule
  SET EventID = 1201
WHERE Name = 'DynamicBookmarks'
GO
