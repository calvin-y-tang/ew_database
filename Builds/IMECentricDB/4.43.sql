

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
PRINT N'Altering [dbo].[tblFSDetailSetup]...';


GO
ALTER TABLE [dbo].[tblFSDetailSetup]
    ADD [ExamLocationCounty] VARCHAR (MAX) NULL;


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
PRINT N'Altering [dbo].[spFeeSched_SyncTableData_Detail]...';


GO
ALTER PROCEDURE [dbo].[spFeeSched_SyncTableData_Detail]
     @iHdrSetupID INTEGER,
	 @iHeaderID INTEGER 
AS
BEGIN
	
	DECLARE @iDtlSetupID INTEGER 
	DECLARE @iDetailID INTEGER 
	
	-- DEV NOTE: this process will completely rebuild all items in FSDetailCondition for the Detail items
	--		that are present; therefore, before we do anything we are going dump all Condition items
	--		that are attached to the detail items for the Header we are processing.
	DELETE 
	  FROM tblFSDetailCondition 
	 WHERE FSDetailID IN (SELECT FSDetailID FROM tblFSDetail WHERE FSHeaderID = @iHeaderID)

	-- get a list of Detail Items that make up this Header and process them
	DECLARE curDetailSetup CURSOR FOR
		SELECT FSDetailSetupID, FSDetailID
		  FROM tblFSDetailSetup 
		 WHERE FSHeaderSetupID = @iHdrSetupID
	OPEN curDetailSetup
	FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID 
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		-- update or insert item? 
		IF @iDetailID IS NULL
		BEGIN 
			INSERT INTO tblFSDetail(FSHeaderID, ProcessOrder, FeeUnit, FeeAmt, NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, InchesIncluded, DateAdded, UserIDAdded)
				SELECT @iHeaderID, ProcessOrder, FeeUnit, ISNULL(FeeAmt, 0), NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, InchesIncluded, DateAdded, UserIDAdded
				  FROM tblFSDetailSetup
				 WHERE FSDetailSetupID = @iDtlSetupID
			SET @iDetailID = @@IDENTITY 
			IF @iDetailID IS NOT NULL AND @iDetailID > 0 
			BEGIN 
				UPDATE tblFSDetailSetup
				   SET FSDetailID = @iDetailID 
				 WHERE FSDetailSetupID = @iDtlSetupID
			END
			ELSE 
			BEGIN 
				-- no DetailID; unable to continue
				RAISERROR ('Unable to create new tblFSDetail entry (FSDetailID is not valid).', 16, 2);
				RETURN 
			END 
		END 
		ELSE 
		BEGIN 
			-- need to update existing tblFSDetail entry
			UPDATE calc
			   SET ProcessOrder = ui.ProcessOrder, 
				  FeeUnit = ui.FeeUnit,
				  FeeAmt = ISNULL(ui.FeeAmt, 0), 
				  NSFeeAmt1 = ui.NSFeeAmt1,
				  NSFeeAmt2 = ui.NSFeeAmt2, 
				  NSFeeAmt3 = ui.NSFeeAmt3, 
				  LateCancelAmt = ui.LateCancelAmt, 
				  CancelDays = ui.CancelDays, 
				  InchesIncluded = ui.InchesIncluded, 
				  DateEdited = ui.DateEdited, 
				  UserIDEdited = ui.UserIDEdited
			  FROM tblFSDetail AS calc
					INNER JOIN tblFSDetailSetup AS ui ON ui.FSDetailID = calc.FSDetailID
			 WHERE calc.FSDetailID = @iDetailID
		END 

		-- process next row
		FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID
	END
	CLOSE curDetailSetup
	DEALLOCATE curDetailSetup
	
	-- Process Detail Condition selections
	INSERT INTO tblFSDetailCondition(FSDetailID, ConditionTable, ConditionKey, ConditionValue)
		SELECT  FSDetailID, 'tblEWBusLine', BL.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(BusLine, ',') AS BL
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND BL.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblEWServiceType', ST.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ServiceType, ',') AS ST
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND ST.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblServices', S.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Service, ',') AS S
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND S.value <> -1

		UNION 
		
		SELECT  FSDetailID, 'tblProduct', P.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Product, ',') AS P
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND P.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblEWFeeZone', FZ.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(FeeZone, ',') AS FZ
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND FZ.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblSpecialty', SP.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Specialty, ',') AS SP
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND SP.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblDoctor', D.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(Doctor, ',') AS D
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND D.value <> -1

		UNION 

		SELECT  FSDetailID, 'tblLocation', L.value, NULL 
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ExamLocation, ',') AS L
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND L.value <> -1

		UNION 

		SELECT FSDetailID, 'tblLocationCity', NULL, TRIM(C.value)  
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ExamLocationCity, ',') AS C
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND C.value IS NOT NULL

		UNION 

		SELECT FSDetailID, 'tblLocationCounty', NULL, TRIM(C.value)  
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ExamLocationCounty, ',') AS C
		 WHERE FSHeaderSetupID = @iHdrSetupID
		   AND C.value IS NOT NULL

	
	-- cleanup Detail table for items no longer part of setup table
	DELETE tblFSDetail
	  FROM tblfsDetail 
			LEFT OUTER JOIN tblFSDetailSetup ON tblFSDetailSetup.FSDetailID = tblFSDetail.FSDetailID
	 WHERE FSHeaderID = @iHeaderID 
	   AND tblFSDetailSetup.FSDetailID IS NULL
	
	RETURN

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
	ORDER BY BusinessRuleID, ProcessOrder

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
-- Sprint 117

-- IMEC-13683 - need a data conversion/update for exisitng entries in tblFSDetailCondition tied to ExamLocation City
UPDATE tblFSDetailCondition
   SET ConditionTable = 'tblLocationCity'
 WHERE ConditionTable = 'tblLocation' 
   AND ConditionValue IS NOT NULL
GO

-- IMEC-13607 Guard Business Rules
-- Distribute Document
DELETE FROM tblBusinessRuleCondition where BusinessRuleID = 10
GO
UPDATE tblBusinessRule
   SET Param2Desc = 'ClaimNbrStartsWith'
 WHERE BusinessRuleID = 10
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (10, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', 'N9', NULL, NULL, NULL, 0, NULL),
       (10, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, NULL, NULL, NULL, 0, NULL)
GO
-- Distribute Report
DELETE FROM tblBusinessRuleCondition where BusinessRuleID = 11
GO
UPDATE tblBusinessRule
   SET Param2Desc = 'ClaimNbrStartsWith'
 WHERE BusinessRuleID = 11
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (11, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', 'N9', NULL, NULL, NULL, 0, NULL),
       (11, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, NULL, NULL, NULL, 0, NULL)
GO
-- Generate Documents (and Quote Documents)
DELETE 
FROM tblBusinessRuleCondition 
WHERE BusinessRuleID = 160 
  AND EntityType = 'PC' 
  AND EntityID = 91
GO
UPDATE tblBusinessRule
   SET Param3Desc = 'QuoteInOutNetwork', 
       Param4Desc = 'ClaimNbrStartsWith'
 WHERE BusinessRuleID = 160
GO
UPDATE tblBusinessRuleCondition 
   SET Param3 = 'OUT'
 WHERE BusinessRuleID = 160 
   AND EntityType = 'PC' 
   AND EntityID = 9
GO 
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', NULL, NULL, 'N9', NULL, 0, NULL), 
       (160, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, NULL, NULL, NULL, 0, NULL),
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Biberk.com', 'YES', 'IN', 'N9', NULL, 0, NULL),
       (160, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', 'YES', 'IN', NULL, NULL, 0, NULL), 
       (160, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'lauren.langan@biberk.com', 'YES', 'OUT', 'N9', NULL, 0, NULL), 
       (160, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Brandon.Styczen@guard.com', 'YES', 'OUT', NULL, NULL, 0, NULL)

-- Distribute Invoice
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (114, 'DistRptInvDefaultOtherEmail', 'Case', 'When Dist Rpt if Inv is an attached Doc default Other Email Address', 1, 1320, 0, 'OtherEmail', 'ClaimNbrStartsWith', 'DocNameStartsWith', NULL, NULL, 0, NULL),
       (115, 'DistDocInvDefaultOtherEmail', 'Case', 'When Dist Doc if Inv is part of dist  then default Other Email Address', 1, 1202, 0, 'OtherEmail', 'ClaimNbrStartsWith', 'DocNameStartsWith', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (114, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'mbr@guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (114, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@Biberk.com', 'N9', 'CMS', NULL, NULL, 0, NULL),
       (114, 'PC', 91, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 91, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 3, NULL, NULL, 'mbr@guard.com', NULL, 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 91, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'claims@Biberk.com', 'N9', 'CMS', NULL, NULL, 0, NULL),
       (115, 'PC', 91, 2, 3, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'Claims@Guard.com', NULL, 'CMS', NULL, NULL, 0, NULL)
GO
