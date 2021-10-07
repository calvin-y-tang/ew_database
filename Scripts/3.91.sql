

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
PRINT N'Altering [dbo].[tblAcctHeader]...';


GO
ALTER TABLE [dbo].[tblAcctHeader]
    ADD [TaxCode4]    VARCHAR (10) NULL,
        [TaxCode5]    VARCHAR (10) NULL,
        [TaxCode6]    VARCHAR (10) NULL,
        [TaxCode7]    VARCHAR (10) NULL,
        [TaxCode8]    VARCHAR (10) NULL,
        [TaxAmount4]  MONEY        NULL,
        [TaxAmount5]  MONEY        NULL,
        [TaxAmount6]  MONEY        NULL,
        [TaxAmount7]  MONEY        NULL,
        [TaxAmount8]  MONEY        NULL,
        [TaxHandling] INT          NULL;


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
PRINT N'Altering [dbo].[tblCaseApptRequest]...';


GO
ALTER TABLE [dbo].[tblCaseApptRequest]
    ADD [ReservationSource] VARCHAR (200) NULL;


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
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [RequireExamineeDOB] BIT CONSTRAINT [DF_tblEWParentCompany_RequireExamineeDOB] DEFAULT (0) NULL;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


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
PRINT N'Altering [dbo].[tblServices]...';


GO
ALTER TABLE [dbo].[tblServices]
    ADD [TaxAddressType] VARCHAR (2) NULL;


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

PRINT N'Adding tblTaxAddress...';
GO

CREATE TABLE [dbo].[tblTaxAddress](
	[TaxAddressID] [INT] IDENTITY(1,1) NOT NULL,
	[TableType] [VARCHAR](2) NULL,
	[TableKey] [INT] NULL,
	[TaxCode] [VARCHAR](20) NOT NULL,
	[DateAdded] [DATETIME] NOT NULL,
	[UserIDAdded] [VARCHAR](15) NOT NULL,
	[DateEdited] [DATETIME] NULL,
	[UserIDEdited] [VARCHAR](15) NULL,
 CONSTRAINT [PK_TblTaxAddress] PRIMARY KEY CLUSTERED 
(
	[TaxAddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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

--Added as part of a sprint 72 early release with the normal deployment




-- Issue 12346 - Allow for an Allstate customer data tab on the case form that requires data to be completed.
DECLARE @iPKeyID AS INTEGER
-- Create new ParamPropertyGroup & Items for Required Allstate
INSERT INTO tblParamPropertyGroup(Description, LabelText, Version, DateAdded, UserIDAdded)
VALUES('Allstate Case Customer Data - Required', 'Allstate', 1, GetDate(), 'JPais')
SELECT @iPKeyID = @@IDENTITY
INSERT INTO tblParamProperty(ParamPropertyGroupID, LabelText, FieldName, Required, DateAdded, UserIDAdded)
     (SELECT @iPKeyID, LabelText, FieldName, 1, GETDATE(), 'JPais' 
        FROM tblParamProperty 
       WHERE ParamPropertyGroupID = 2)

-- Changes to Business rules
--   1. delete existing Allstate rule
DELETE FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 7 
  AND EntityType = 'PC' 
  AND EntityID = 4

--   2. new allstate customer tab with required properties
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(7, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, 1, NULL, 'CustomerData', @iPKeyID, NULL, NULL, NULL),
     -- 3. recreate original allstate rule with properties not required
      (7, 'PC', 4, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'CustomerData', '2', NULL, NULL, NULL)
GO

-- Issue 12340 - adjust existing business rule for creating Allstate Duplicate/Sub cases
DELETE FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 153 
  AND EntityType = 'PC' 
  AND EntityID = 4
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES(153, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Always', NULL, NULL, NULL, NULL)
GO

-- Issue 12354 - need to use business rules for "Convert to Sub-Case" tblCustomerData processing
INSERT INTO tblEvent (EventID, Descrip, Category)
VALUES(1005, 'Convert Case to Sub Case', 'Case')
GO
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES (157, 'CustomerDataConvertSubCase', 'Case', 'Convert to Sub Handing of tblCustomerData', 1, 1005, 0, 'InputSourceID', NULL, NULL, NULL, NULL, 0)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5)
VALUES (157, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
       (157, 'SW', NULL, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '7', NULL, NULL, NULL, NULL)
GO


