
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
PRINT N'Altering [dbo].[tblCaseEnvelope]...';


GO
ALTER TABLE [dbo].[tblCaseEnvelope]
    ADD [PageCount] INT NULL;


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
PRINT N'Altering [dbo].[tblExceptionDefinition]...';


GO
ALTER TABLE [dbo].[tblExceptionDefinition]
    ADD [BillingEntity] INT CONSTRAINT [DF_tblExceptionDefinition_BillingEntity] DEFAULT ((0)) NOT NULL;


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
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice] DROP COLUMN [RecordRetrievalMethod];


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [RecordRetrievalDocument] VARCHAR (15) NULL;


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
PRINT N'Altering [dbo].[tblOfficeDPSSortModel]...';


GO
ALTER TABLE [dbo].[tblOfficeDPSSortModel] ALTER COLUMN [CaseType] INT NULL;


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
PRINT N'Creating [dbo].[tblOfficeDPSSortModel].[IX_U_tblOfficeDPSSortModel_OfficeCodeSortModelID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblOfficeDPSSortModel_OfficeCodeSortModelID]
    ON [dbo].[tblOfficeDPSSortModel]([Officecode] ASC, [SortModelID] ASC);


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
PRINT N'Creating [dbo].[tblWebSuperUser]...';


GO
CREATE TABLE [dbo].[tblWebSuperUser] (
    [SuperUserID]     INT           IDENTITY (1, 1) NOT NULL,
    [WebUserID]       INT           NULL,
    [EWBusLineID]     INT           NULL,
    [ParentCompanyID] INT           NULL,
    [CompanyCode]     INT           NULL,
    [SuperUserType]   CHAR (2)      NULL,
    [DateAdded]       SMALLDATETIME NULL,
    [UserIDAdded]     VARCHAR (255) NULL,
    [DateEdited]      SMALLDATETIME NULL,
    [UserIDEdited]    VARCHAR (255) NULL,
    CONSTRAINT [PK_tblWebSuperUser] PRIMARY KEY CLUSTERED ([SuperUserID] ASC) ON [PRIMARY]
) ON [PRIMARY];


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
PRINT N'Creating [dbo].[tblDoctorDPSSortModel].[IX_U_tblDoctorDPSSortModel_DoctorCodeCaseType]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblDoctorDPSSortModel_DoctorCodeCaseType]
    ON [dbo].[tblDoctorDPSSortModel]([DoctorCode] ASC, [CaseType] ASC);


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
UPDATE tblExceptionDefinition
   SET BillingEntity = 2 -- Billing client
 WHERE UseBillingEntity = 1
GO
-- set to service client where origi column = 0 and entity is CO, CL, PC
UPDATE tblExceptionDefinition
   SET BillingEntity = 1 -- service client
 WHERE UseBillingEntity = 0 and Entity in ('CO', 'CL', 'PC')
-- all other entries default to None or 0
GO

-- Issue 11737 - Allstats VAT Changes - add business rule to change company name on correspondence
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(113, 'AllstatePolicyCompanyName', 'Case', 'Use the Company Name from tblCustomerData based on Allstate referral PolicyCompanyCode', 1, 1201, 0, NULL, NULL, NULL, NULL, NULL, 0)
GO

-- Issue 11742 - create some new Exception Triggers
INSERT INTO tblExceptionList (ExceptionID, Description, Status, DateAdded, UserIDAdded, Type)
VALUES(32, 'Create Invoice Quote', 'Active', GetDate(), 'Admin', 'Case'),
      (33, 'Create Voucher Quote', 'Active', GetDate(), 'Admin', 'Case')
GO

-- Issue 11716 - Add DPS Sort models for offices - all sort models for all offices CaseType = 10
  INSERT INTO tblOfficeDPSSortModel (Officecode, SortModelID, UserIDAdded, DateAdded) 
  SELECT O.OfficeCode, D.SortModelID, 'Admin', GetDate()
  FROM tblDPSSortModel AS D
  LEFT JOIN tblOffice AS O On 1=1
GO

