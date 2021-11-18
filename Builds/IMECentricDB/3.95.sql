

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
PRINT N'Dropping [dbo].[tblCaseAppt].[IX_tblCaseAppt_CaseNbrApptTimeDoctorCodeLocationCodeDoctorBlockTimeSlotID]...';


GO
DROP INDEX [IX_tblCaseAppt_CaseNbrApptTimeDoctorCodeLocationCodeDoctorBlockTimeSlotID]
    ON [dbo].[tblCaseAppt];


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
PRINT N'Dropping [dbo].[tblDoctorBlockTimeDay].[IX_tblDoctorBlockTimeDay_ScheduleDateDoctorCodeLocationCode]...';


GO
DROP INDEX [IX_tblDoctorBlockTimeDay_ScheduleDateDoctorCodeLocationCode]
    ON [dbo].[tblDoctorBlockTimeDay];


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
PRINT N'Dropping [dbo].[tblTaxAddress].[IX_tblTaxAddress_TableTypeKeyCode]...';


GO
DROP INDEX [IX_tblTaxAddress_TableTypeKeyCode]
    ON [dbo].[tblTaxAddress];


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
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [Tags] VARCHAR (1000) NULL;


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
PRINT N'Altering [dbo].[tblReferralAssignmentRule]...';


GO
ALTER TABLE [dbo].[tblReferralAssignmentRule]
    ADD [Tags] VARCHAR (1000) NULL;


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
PRINT N'Altering [dbo].[tblWorkstation]...';


GO
ALTER TABLE [dbo].[tblWorkstation]
    ADD [Param] VARCHAR (200) NULL;


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
PRINT N'Creating [dbo].[tblCaseAppt].[IX_tblCaseAppt_ApptStatusID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_ApptStatusID]
    ON [dbo].[tblCaseAppt]([ApptStatusID] ASC)
    INCLUDE([CaseNbr], [ApptTime], [DoctorCode], [LocationCode], [DoctorBlockTimeSlotID]);


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
PRINT N'Creating [dbo].[tblCaseOverviewGroup].[IX_tblCaseOverviewGroup_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseOverviewGroup_CaseNbr]
    ON [dbo].[tblCaseOverviewGroup]([CaseNbr] ASC);


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
PRINT N'Creating [dbo].[tblCaseOverviewGroupItem].[IX_tblCaseOverviewGroupItem_CaseOverviewGroupID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseOverviewGroupItem_CaseOverviewGroupID]
    ON [dbo].[tblCaseOverviewGroupItem]([CaseOverviewGroupID] ASC);


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
PRINT N'Creating [dbo].[tblCaseRecRetrieval].[IX_tblCaseRecRetrieval_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseRecRetrieval_CaseNbr]
    ON [dbo].[tblCaseRecRetrieval]([CaseNbr] ASC);


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
PRINT N'Creating [dbo].[tblCaseRecRetrievalDocument].[IX_tblCaseRecRetrievalDocument_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseRecRetrievalDocument_CaseNbr]
    ON [dbo].[tblCaseRecRetrievalDocument]([CaseNbr] ASC);


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
PRINT N'Creating [dbo].[tblDoctorBlockTimeDay].[IX_U_tblDoctorBlockTimeDay_ScheduleDateDoctorCodeLocationCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorBlockTimeDay_ScheduleDateDoctorCodeLocationCode]
    ON [dbo].[tblDoctorBlockTimeDay]([ScheduleDate] ASC, [DoctorCode] ASC, [LocationCode] ASC);


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
PRINT N'Creating [dbo].[tblTask].[IX_tblTask_ProcessNameTableTypeDate1]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTask_ProcessNameTableTypeDate1]
    ON [dbo].[tblTask]([ProcessName] ASC, [TableType] ASC, [Date1] ASC);


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
PRINT N'Creating [dbo].[tblTaxAddress].[IX_tblTaxAddress_TaxCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblTaxAddress_TaxCode]
    ON [dbo].[tblTaxAddress]([TaxCode] ASC);


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
PRINT N'Creating [dbo].[tblTaxAddress].[IX_U_tblTaxAddress_TableTypeTableKeyTaxCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblTaxAddress_TableTypeTableKeyTaxCode]
    ON [dbo].[tblTaxAddress]([TableType] ASC, [TableKey] ASC, [TaxCode] ASC);


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