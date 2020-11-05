
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
PRINT N'Dropping [dbo].[DF_tblEWParentCompany_RecordRetrievalMethod]...';


GO
ALTER TABLE [dbo].[tblEWParentCompany] DROP CONSTRAINT [DF_tblEWParentCompany_RecordRetrievalMethod];


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
    ADD [CustomerSystemID] VARCHAR (50) NULL;


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
PRINT N'Altering [dbo].[tblCompany]...';


GO
ALTER TABLE [dbo].[tblCompany]
    ADD [RecordRetrievalMethod] INT NULL;


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
PRINT N'Altering [dbo].[tblDPSBundle]...';


GO
ALTER TABLE [dbo].[tblDPSBundle] ALTER COLUMN [ExtWorkBundleID] VARCHAR (30) NULL;


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
ALTER TABLE [dbo].[tblEWParentCompany] ALTER COLUMN [RecordRetrievalMethod] INT NULL;


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
PRINT N'Altering [dbo].[tblUser]...';


GO
ALTER TABLE [dbo].[tblUser]
    ADD [RestrictToFavorites] BIT CONSTRAINT [DF_tblUser_RestrictToFavorites] DEFAULT ((0)) NOT NULL;


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
PRINT N'Altering [dbo].[tblWebUser]...';


GO
ALTER TABLE [dbo].[tblWebUser]
    ADD [RecordRetrievalMethod] INT CONSTRAINT [DF_tblWebUser_RecordRetrievalMethod] DEFAULT ((0)) NULL;


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
PRINT N'Creating [dbo].[tblIntegrationBatchDetail]...';


GO
CREATE TABLE [dbo].[tblIntegrationBatchDetail] (
    [PrimaryKey]    INT          IDENTITY (1, 1) NOT NULL,
    [ProcessName]   VARCHAR (50) NULL,
    [BatchNbr]      INT          NOT NULL,
    [DateAdded]     DATETIME     NULL,
    [UserIDAdded]   VARCHAR (50) NULL,
    [DateProcessed] DATETIME     NULL,
    [BatchStatus]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tblIntegrationBatchDetail] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


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
PRINT N'Creating [dbo].[tblIntegrationBatchHeader]...';


GO
CREATE TABLE [dbo].[tblIntegrationBatchHeader] (
    [PrimaryKey]  INT           IDENTITY (1, 1) NOT NULL,
    [ProcessName] VARCHAR (50)  NULL,
    [BatchNbr]    INT           NULL,
    [TableType]   VARCHAR (50)  NULL,
    [TableKey]    INT           NOT NULL,
    [Param]       VARCHAR (100) NULL,
    [DateAdded]   DATETIME      NULL,
    [UserIDAdded] VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblIntegrationBatchHeader] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


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
PRINT N'Adding [dbo].[spGetAllBusinessRules]...';


GO
CREATE PROCEDURE [dbo].[spGetAllBusinessRules]
(
	@eventID INT,
    @clientCode INT,
    @billClientCode INT,
    @officeCode INT,
    @caseType INT,
    @serviceCode INT,
    @jurisdiction VARCHAR(5)
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT DISTINCT * FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,	 
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder
	FROM
	(
	
	SELECT 1 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @billClientCode
	LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
	WHERE 1=1
	AND (BRC.BillingEntity IN (0,2))
	AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

	UNION

	SELECT 2 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = @clientCode
	LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
	WHERE 1=1
	AND (BRC.BillingEntity IN (1,2))
	AND (CASE BRC.EntityType WHEN 'PC' THEN CO.ParentCompanyID WHEN 'CO' THEN CO.CompanyCode WHEN 'CL' THEN CL.ClientCode ELSE 0 END = BRC.EntityID)

	UNION

	SELECT 3 AS GroupID, BRC.*
	FROM tblBusinessRuleCondition AS BRC
	WHERE 1=1
	AND (BRC.EntityType='SW')
	) AS tmpBR
	INNER JOIN tblBusinessRule AS BR ON BR.BusinessRuleID = tmpBR.BusinessRuleID
	LEFT OUTER JOIN tblCaseType AS CT ON CT.Code = @caseType
	LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = @serviceCode
	WHERE BR.IsActive=1
	AND BR.EventID=@eventID
	AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
	AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
	AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
	AND (tmpBR.Jurisdiction IS NULL OR tmpBR.Jurisdiction = @jurisdiction)
	
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID
END
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

PRINT N'Altering [dbo].[vwAutoProvisions]...';


GO
ALTER VIEW vwAutoProvisions
AS 
	SELECT 
			tblAutoProvisionLog.*, 
			tblCompany.CompanyCode AS CompanyCode,
			tblCompany.ParentCompanyID AS ParentCompanyID,
			tblCompany.IntName
	  FROM tblAutoProvisionLog
			LEFT OUTER JOIN tblClient ON tblClient.ClientCode = tblAutoProvisionLog.EntityID
			LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
			LEFT OUTER JOIN tblEWParentCompany ON tblEWParentCompany.ParentCompanyID = tblCompany.ParentCompanyID
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
INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc,
    DateAdded
)
VALUES
(   'CustomATICExport',
    'Custom - ATIC Export',
    GETDATE()
    )

GO


-- Issue 11728 - New Quote number token and bookmark
INSERT INTO tblMessageToken (Name) VALUES ('@QuoteNbr@')

INSERT INTO tblMessageToken (Name) VALUES('@Jurisdiction@');
GO
