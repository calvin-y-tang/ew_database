

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
    ADD [ExcludeJurisdiction] BIT CONSTRAINT [DF_tblBusinessRuleCondition_ExcludeJurisdiction] DEFAULT ((0)) NULL;


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
ALTER TABLE [dbo].[tblOffice]
    ADD [DoctorAdminEmail] VARCHAR (250) NULL;


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
PRINT N'Altering [dbo].[tblSLAException]...';


GO
ALTER TABLE [dbo].[tblSLAException]
    ADD [TATCalculationMethodID] INT NULL;


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

	SELECT DISTINCT *, ROW_NUMBER() OVER (PARTITION BY BusinessRuleID ORDER BY BusinessRuleID, ProcessOrder ASC ) AS RuleOrder 
	INTO #tmp_GetAllBusinessRules
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
			 tmpBR.Skip, 
			 tmpBR.Param6,
			 tmpBR.ExcludeJurisdiction
			FROM
				 (SELECT 1 AS GroupID, BRC.*
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
			WHERE BR.IsActive = 1
				and BR.EventID = @eventID
				AND (tmpBR.OfficeCode IS NULL OR tmpBR.OfficeCode = @officeCode)
				AND (tmpBR.EWBusLineID IS NULL OR tmpBR.EWBusLineID = CT.EWBusLineID)
				AND (tmpBR.EWServiceTypeID IS NULL OR tmpBR.EWServiceTypeID = S.EWServiceTypeID)
				AND (
				    (ISNULL(tmpBR.ExcludeJurisdiction, 0) <> 1 AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction))
				    OR  
					(ISNULL(tmpBR.ExcludeJurisdiction, 0) = 1 AND tmpBR.Jurisdiction <> @jurisdiction)
					)
	) AS sortedBR	
	ORDER BY sortedBR.BusinessRuleID, sortedBR.ProcessOrder

	-- need to remove duplicate rules (same BusinessRuleConditionID)
	DELETE bizRules 
      FROM (SELECT BusinessRuleConditionID, 
               ROW_NUMBER() OVER (PARTITION BY BusinessRuleConditionID ORDER BY RuleOrder ASC) AS ROWNUM
              FROM #tmp_GetAllBusinessRules) AS bizRules
	 WHERE bizRules.RowNum > 1

    -- remove rules that have a condition that is set to skip
	DELETE 
      FROM #tmp_GetAllBusinessRules
      WHERE BusinessRuleID IN (SELECT BusinessRuleID
                                 FROM #tmp_GetAllBusinessRules
                                WHERE skip = 1)

	-- do not return rules that are set to be "skipped"
	SELECT BusinessRuleID, 
		   Category, 
		   Name,	 
		   BusinessRuleConditionID,
		   Param1,
		   Param2,
		   Param3,
		   Param4,
		   Param5,
		   EntityType,
		   ProcessOrder,
		   Skip, 
		   Param6 ,
		   ExcludeJurisdiction
	FROM #tmp_GetAllBusinessRules
	WHERE Skip = 0

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

	DECLARE @groupDigits INT
	SET @groupDigits = 10000000

	SELECT * 
	INTO #tmp_GetBusinessRules
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
		 tmpBR.Skip, 
		 tmpBR.Param6,
		 tmpBR.ExcludeJurisdiction
		FROM
			(SELECT 1 AS GroupID, BRC.*
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
		  AND (
			  (ISNULL(tmpBR.ExcludeJurisdiction, 0) <> 1 AND (tmpBR.Jurisdiction Is Null Or tmpBR.Jurisdiction = @jurisdiction))
			  OR  
			  (ISNULL(tmpBR.ExcludeJurisdiction, 0) = 1 AND tmpBR.Jurisdiction <> @jurisdiction)
			  )
	) AS sortedBR
	WHERE sortedBR.RowNbr=1
	ORDER BY sortedBR.BusinessRuleID

	DELETE FROM #tmp_GetBusinessRules WHERE Skip = 1

	SELECT * FROM #tmp_GetBusinessRules

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
PRINT N'Altering [dbo].[proc_Info_Liberty_BulkBilling_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Liberty Bulk Billing Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_LibertyInvoices') IS NOT NULL DROP TABLE ##tmp_LibertyInvoices
print 'Gather main data set ...'

DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;

SELECT
  EWF.DBID as DBID,
  cast('Database' as varchar(15)) as DB,
  AH.HeaderID,
  AH.EWFacilityID,
  AH.CaseDocID,
  ISNULL(AH.CaseApptID, C.CaseApptID) as CaseApptID,
  EWF.GPFacility + '-' + cast(AH.DocumentNbr as VarChar(15)) as InvoiceNo,
  EWF.FedTaxID,
  isnull(EWF.RemitAddress, EWF.Address) as "VendorMailingAddress",
  cast(AH.DocumentNbr as varchar(15)) as DocumentNo,
  AH.DocumentDate as InvoiceDate,
  cast(C.CaseNbr as varchar(15)) as CaseNbr,
  cast(C.ExtCaseNbr as varchar(15)) as ExtCaseNbr,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  EWF.FacilityName "VendorName",
  ISNULL(CLI.FirstName, '') + ' ' + ISNULL(CLI.LastName, '') as ClientName,
  AH.ClaimNbr as ClaimNumber,
  C.DateAdded,
  C.RptSentDate as ReportSentDate,
  C.DateReceived,
  C.Jurisdiction,
  isnull(E.FirstName, '') + ' ' + isnull(E.LastName, '') as "ClaimantName",
  E.State as "ClaimantState",    
  CA.ApptTime as AppointmentDate,
  apts.Name as AppointmentStatus,
  case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName +', ' + isnull(D.FirstName, '') end as ProviderName,
  isnull(d.LastName, '') as ProviderLastName,
  isnull(d.FirstName, '') as ProviderFirstName,
  C.SReqSpecialty as RequestedSpecialty,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  AH.DocumentTotalUS as "Charge",
  CD.Param as "CustomerDataParam",
  CD2.Param as "InvCustomerDataParam", 
  CONVERT(VARCHAR(64), NULL) as "iCaseReferralType",
  CONVERT(VARCHAR(64), NULL) as "iCaseICMServiceType",
  CONVERT(VARCHAR(64), NULL) as "iCaseNbr",
  CONVERT(VARCHAR(64), NULL) as "iCaseCompanyMarket",
  CONVERT(VARCHAR(16), NULL) as "iCaseDateSubmitted",
  CONVERT(VARCHAR(64), NULL) as "iCaseClaimID",
  CONVERT(VARCHAR(64), NULL) as "iCaseOfficeNumber",
  CONVERT(VARCHAR(64), NULL) AS "iCaseClaimType",
  CONVERT(VARCHAR(64), NULL) AS "iCaseReportUploadDate",
  CONVERT(VARCHAR(64), NULL) AS "iCaseIMERequestAs",
  CONVERT(VARCHAR(64), NULL) AS "iCaseServiceType",
  CONVERT(VARCHAR(64), NULL) AS "iCaseMarketDesignation",
  CONVERT(BIT, NULL) as "NotiCaseReferral", 
  CONVERT(VARCHAR(128), NULL) AS CPTCodes,
  CONVERT(INT, NULL) AS "Count", 
  CONVERT(VARCHAR(10), NULL) AS "Time",
  CONVERT(DATETIME, NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as ClaimantConfirmationStatus,
  CONVERT(INT, NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME, NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as AttyConfirmationStatus,
  CONVERT(INT, NULL) as AttyCallAttempts,
  CONVERT(VARCHAR(12), NULL) AS ExpenseCode,
  BL.Name as "LineOfBusiness",
  (isnull([FeeAmount],0) + isnull([No Show],0) + isnull([Late Canceled],0) + isnull([PeerReview],0) + isnull([Addendum], 0)) as ExamFee,  
  isnull([Diag], 0) as RadiololgyFee,
  -- note: if you add/remove categories from the "other" list below, make sure you update the other service description list in patch data
  (isnull([Interpret],0) + isnull([Trans],0) + isnull([BillReview],0) + isnull([Legal],0) + isnull([Processing],0) + isnull([Nurse],0)
	+ isnull(ft.[Phone],0) + isnull([MSA],0) + isnull([Clinical],0) + isnull([Tech],0) + isnull([Medicare],0) + isnull([OPO],0) 
	+ isnull([Rehab],0)	+ isnull([AddReview],0) + isnull([AdminFee],0) + isnull([FacFee],0) + isnull([Other],0)) as Other,
  ST.Name as ServiceDescription,
  CONVERT(VARCHAR(4096), NULL) as OtherServiceDescription
INTO ##tmp_LibertyInvoices
FROM tblAcctHeader as AH
	INNER JOIN tblCase as C on AH.CaseNbr = C.CaseNbr
	INNER JOIN tblClient as CLI on AH.ClientCode = CLI.ClientCode
	INNER JOIN tblCompany as CO on CLI.CompanyCode = CO.CompanyCode
	LEFT OUTER JOIN tblDoctor as D on AH.DrOpCode = D.DoctorCode
	LEFT OUTER JOIN tblExaminee as E on C.ChartNbr = E.ChartNbr
	LEFT OUTER JOIN tblCaseType as CT on C.CaseType = CT.Code
	LEFT OUTER JOIN tblServices as S on C.ServiceCode = S.ServiceCode
	LEFT OUTER JOIN tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	LEFT OUTER JOIN tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	LEFT OUTER JOIN tblOffice as O on C.OfficeCode = O.OfficeCode
	LEFT OUTER JOIN tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
    LEFT OUTER JOIN tblCaseAppt as CA on isnull(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	LEFT OUTER JOIN tblApptStatus as apts on CA.ApptStatusID = apts.ApptStatusID
	LEFT OUTER JOIN tblCustomerData as CD on (C.CaseNbr = CD.TableKey AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Liberty Mutual')
	LEFT OUTER JOIN tblCustomerData as CD2 on (AH.HeaderID = CD2.TableKey AND CD2.TableType = 'tblAcctHeader' AND CD2.CustomerName = 'Liberty Mutual')
	LEFT OUTER JOIN
(
  select Pvt.*
  from (
    select
      AD.HeaderID,
      isnull(case when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID in (51,102) then 'Late Canceled'
                  when EWFC.Mapping5 = 'FeeAmount' and AH.ApptStatusID = 101 then 'No Show'
                  else EWFC.Mapping5 end, 'Other') as FeeColumn,
      AD.ExtendedAmount	
    from tblCase as C
    inner join tblAcctHeader as AH on C.CaseNbr = AH.CaseNbr and AH.DocumentStatus = 'Final' and AH.DocumentType = 'IN'
    inner join tblAcctDetail as AD on AH.HeaderID = AD.HeaderID
    inner join tblProduct as P on P.ProdCode = AD.ProdCode
    inner join tblCaseType as CT on C.CaseType = CT.Code
    inner join tblFRCategory as FRC on C.CaseType = FRC.CaseType and AD.ProdCode = FRC.ProductCode
    inner join tblEWFlashCategory as EWFC on FRC.EWFlashCategoryID = EWFC.EWFlashCategoryID
    left outer join tblApptStatus as A on A.ApptStatusID = AH.ApptStatusID
  ) as tmp
  pivot
  (
    sum(ExtendedAmount) --aggregrate function that give the value for the columns from FeeColumn
    for FeeColumn in (  --list out the values in FeeColumn that need to be a column
      [FeeAmount],
      [No Show],
      [Late Canceled],
      [Interpret],
      [Trans],
      [Diag],
      [BillReview],
      [PeerReview],
      [Addendum],
      [Legal],
      [Processing],
      [Nurse],
      [Phone],
      [MSA],
      [Clinical],
      [Tech],
      [Medicare],
      [OPO],
      [Rehab],
      [AddReview],
      [AdminFee],
      [FacFee],
      [Other])
  ) as Pvt
) as FT on FT.HeaderID = AH.HeaderID
where AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate
      AND AH.DocumentType = 'IN' 
      AND AH.DocumentStatus = 'Final' 
      AND CO.BulkBillingID = 1 
      AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
ORDER BY InvoiceNo

print 'Data retrieved'
set nocount off
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
PRINT N'Altering [dbo].[proc_CaseDefDocument_Insert]...';


GO
ALTER PROCEDURE [proc_CaseDefDocument_Insert]
(
	@casenbr int,
	@documentcode varchar(15),
	@documentqueue int,
	@dateadded datetime = NULL,
	@useridadded varchar(20) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(20) = NULL,
	@DocumentToReplace varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblcasedefdocument]
	(
		[casenbr],
		[documentcode],
		[documentqueue],
		[dateadded],
		[useridadded],
		[dateedited],
		[useridedited],
		[DocumentToReplace]
	)
	VALUES
	(
		@casenbr,
		@documentcode,
		@documentqueue,
		@dateadded,
		@useridadded,
		@dateedited,
		@useridedited,
		@DocumentToReplace
	)

	SET @Err = @@Error

	RETURN @Err
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
-- Sprint 112

-- IMEC-13475 - initialize value for new column to -1 (<All>)
UPDATE tblSLAException
   SET TATCalculationMethodID = -1
 WHERE TATCalculationMethodID IS NULL
 GO 

