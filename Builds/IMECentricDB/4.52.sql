

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
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_SInternalCaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_SInternalCaseNbr]
    ON [dbo].[tblCase]([SInternalCaseNbr] ASC);


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
-- Sprint 127

-- IMEC-13994 - Add email address for when RPA document intake errors occur with referral numbers
INSERT INTO tblSetting (Name, Value)
VALUES ('EmailForRefrlErr_RPA_Liberty', 'william.cecil@examworks.com')
GO

-- IMEC-13980 - Add email address for when RPA document intake errors occur with case numbers for Progressive
INSERT INTO tblSetting (Name, Value)
VALUES ('EmailForCaseNbrErr_RPA_Prog', 'william.cecil@examworks.com;liabilitydocuments@examworks.com')
GO

-- IMEC-12979 - Add setting for the number of times the code tries to copy the documents before failing
INSERT INTO tblSetting (Name, Value)
VALUES ('EnvelopRecopyAttemptCount', '3')
GO

