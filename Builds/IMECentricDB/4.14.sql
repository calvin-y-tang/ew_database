

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
PRINT N'Altering [dbo].[tblDoctorDocuments]...';


GO
ALTER TABLE [dbo].[tblDoctorDocuments]
    ADD [EffectiveDate]            DATETIME NULL,
        [MasterReviewerDocumentID] INT      NULL;


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
PRINT N'Altering [dbo].[tblOutOfNetworkReason]...';


GO
ALTER TABLE [dbo].[tblOutOfNetworkReason]
    ADD [Status] VARCHAR (50) CONSTRAINT [DF_tblOutOfNetworkReason_status] DEFAULT ('Active') NULL;


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
-- Sprint 91

-- IMEC-12959 - Add status to tblOutOfNetworkReason, set all existing to active
update tblOutOfNetworkReason set Status = 'Active'

-- IMEC-12913 - new setting that makes CRN Active
INSERT INTO tblSetting
VALUES ('CRNIsActive', 'False')
GO
-- IMEC-12913 - new CRN security settings
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('DoctorCRNView','Doctor - View in CRN', GETDATE()), 
      ('DoctorCRNAdd', 'Doctor - Add CRN Reviewer', GETDATE())
GO
