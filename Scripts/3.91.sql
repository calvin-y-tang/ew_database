

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

