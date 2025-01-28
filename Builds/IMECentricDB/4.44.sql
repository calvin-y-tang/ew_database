

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
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCode]...';


GO
DROP INDEX [IX_tblCase_OfficeCode]
    ON [dbo].[tblCase];


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
PRINT N'Altering [dbo].[tblBusinessRuleCondition]...';


GO
ALTER TABLE [dbo].[tblBusinessRuleCondition] ALTER COLUMN [Param1] VARCHAR (128) NULL;

ALTER TABLE [dbo].[tblBusinessRuleCondition] ALTER COLUMN [Param2] VARCHAR (128) NULL;

ALTER TABLE [dbo].[tblBusinessRuleCondition] ALTER COLUMN [Param3] VARCHAR (128) NULL;

ALTER TABLE [dbo].[tblBusinessRuleCondition] ALTER COLUMN [Param4] VARCHAR (128) NULL;

ALTER TABLE [dbo].[tblBusinessRuleCondition] ALTER COLUMN [Param5] VARCHAR (128) NULL;


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
PRINT N'Altering [dbo].[tblExternalCommunications]...';


GO
ALTER TABLE [dbo].[tblExternalCommunications]
    ADD [EntityType] VARCHAR (2)  NULL,
        [EntityID]   VARCHAR (64) NULL;


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
PRINT N'Creating [dbo].[tblExternalCommunications].[IX_tblExternalCommunications_EntityCommunicationSent]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExternalCommunications_EntityCommunicationSent]
    ON [dbo].[tblExternalCommunications]([EntityType] ASC, [EntityID] ASC, [CommunicationSent] ASC);


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
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCode]
    ON [dbo].[tblCase]([OfficeCode] ASC)
    INCLUDE([ChartNbr], [DoctorLocation], [ClientCode], [SchedulerCode], [Status], [CaseType], [ApptDate], [ClaimNbr], [PlaintiffAttorneyCode], [DefenseAttorneyCode], [ServiceCode], [DoctorCode], [DoctorSpecialty], [RecCode], [DoctorName], [CertMailNbr], [Jurisdiction], [TransCode], [DefParaLegal], [VenueID], [LanguageID], [ApptStatusID], [CaseApptID], [CertMailNbr2], [ExtCaseNbr], [EmployerID], [EmployerAddressID], [RPAMedRecRequestDate], [RPAMedRecUploadAckDate], [RPAMedRecUploadStatus]);


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
-- Sprint 118

-- IMEC-13658 - clean up old data from existing table for when the functionality gets turned on
DELETE FROM tblTask
GO

-- IMEC-13608 - Amtrust business rules related to documents/reports 
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 160 
  AND EntityType = 'PC' 
  AND EntityID = 9
GO
UPDATE tblBusinessRule
   SET Param5Desc = 'SelectedDistributeTo'
 WHERE BusinessRuleID = 160
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (160, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'AmTrustClaims@amtrustgroup.com', NULL, NULL, NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'AmTrustClaims@amtrustgroup.com', 'YES', 'IN', NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'John.Insco@amtrustgroup.com;AmTrustClaims@amtrustgroup.com', 'YES', 'OUT', NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 1, NULL, NULL, 'GSOperations@amtrustgroup.com;AmTrustClaims@amtrustgroup.com', 'YES', 'OUT', NULL, ';Client;', 0, NULL),
       (160, 'PC', 9, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'AmTrustClaims@amtrustgroup.com', 'YES', 'OUT', NULL, ';Client;', 0, NULL)
GO
UPDATE tblBusinessRule
   SET Param3Desc = 'SelectedDistributeTo'
 WHERE BusinessRuleID = 10
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (10, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ' AmTrustClaims@amtrustgroup.com', NULL, ';Client;', NULL, NULL, 0, NULL)
GO
UPDATE tblBusinessRule
   SET Param3Desc = 'SelectedDistributeTo'
 WHERE BusinessRuleID = 11
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (11, 'PC', 9, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, ' AmTrustClaims@amtrustgroup.com', NULL, ';Client;', NULL, NULL, 0, NULL)
GO
