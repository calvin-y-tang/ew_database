
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
PRINT N'Altering [dbo].[tblBusinessRuleCondition]...';


GO
ALTER TABLE [dbo].[tblBusinessRuleCondition]
    ADD [Skip] BIT NULL;


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
PRINT N'Altering [dbo].[tblTaxTable]...';


GO
ALTER TABLE [dbo].[tblTaxTable]
    ADD [LastVerified] DATETIME NULL,
        [LastUpdate]   DATETIME NULL,
        [DateExpired]  DATETIME NULL;


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
PRINT N'Altering [dbo].[spGetAllBusinessRules]...';


GO
ALTER PROCEDURE dbo.spGetAllBusinessRules
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

    IF OBJECT_ID('tempdb..##tmp_GetAllBusinessRules') IS NOT NULL DROP TABLE ##tmp_GetAllBusinessRules

	SELECT distinct * INTO ##tmp_GetAllBusinessRules
	FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,	 
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder,
	 tmpBR.Skip
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
		and BR.EventID=@eventID
		AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
		AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
		AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
		AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID, sortedBR.ProcessOrder

	DELETE FROM ##tmp_GetAllBusinessRules WHERE Skip = 1

	SELECT * FROM ##tmp_GetAllBusinessRules


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
PRINT N'Altering [dbo].[spGetBusinessRules]...';


GO
ALTER PROCEDURE dbo.spGetBusinessRules
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

    IF OBJECT_ID('tempdb..##tmp_GetBusinessRules') IS NOT NULL DROP TABLE ##tmp_GetBusinessRules

	DECLARE @groupDigits INT

	SET @groupDigits = 10000000

	SELECT * INTO ##tmp_GetBusinessRules
	FROM (
	SELECT BR.BusinessRuleID, BR.Category, BR.Name,
	 ROW_NUMBER() OVER (PARTITION BY BR.BusinessRuleID ORDER BY tmpBR.GroupID*@groupDigits+(CASE tmpBR.EntityType WHEN 'SW' THEN 4 WHEN 'PC' THEN 3 WHEN 'CO' THEN 2 WHEN 'CL' THEN 1 ELSE 9 END)*1000000+tmpBR.ProcessOrder) AS RowNbr,
	 tmpBR.BusinessRuleConditionID,
	 tmpBR.Param1,
	 tmpBR.Param2,
	 tmpBR.Param3,
	 tmpBR.Param4,
	 tmpBR.Param5,
	 tmpBR.EntityType,
	 tmpBR.ProcessOrder,
	 tmpBR.Skip
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
	and BR.EventID=@eventID
	AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
	AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
	AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
	AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction)
	) AS sortedBR
	WHERE sortedBR.RowNbr=1
	ORDER BY sortedBR.BusinessRuleID

	DELETE FROM ##tmp_GetBusinessRules WHERE Skip = 1

	SELECT * FROM ##tmp_GetBusinessRules

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


 -- Issue 12418 - Hartford resend quote - updating Allstate BR's to add Param2 for Quote InNetwork Required Value

 UPDATE tblBusinessRule SET Param2Desc = 'QuoteInNetworkValue' WHERE BusinessRuleID = 154

 UPDATE tblBusinessRuleCondition SET Param2 = '0' WHERE BusinessRuleID = 154 And EntityID = 4

 -- Issue 12418 - Hartford resend quote approvals a 2nd time then approve - adding business rules to add resend date for Hartford

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 154, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'CA', '8', NULL, NULL, NULL, NULL, 1)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 1, 154, GetDate(), 'Admin', NULL, NULL,    NULL, 3, NULL, 'TX', '8', NULL, NULL, NULL, NULL, 1)

INSERT INTO tblBusinessRuleCondition(EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, 
UserIDAdded, DateEdited, UserIDEdited,   OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip)
VALUES('PC', 30, 2, 2, 154, GetDate(), 'Admin', NULL, NULL,    NULL, NULL, NULL, NULL, '8', NULL, NULL, NULL, NULL, 0)

GO
