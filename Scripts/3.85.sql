
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
PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [NoShowNotificationDate] DATETIME NULL;


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
PRINT N'Altering [dbo].[tblFSDetailCondition]...';


GO
ALTER TABLE [dbo].[tblFSDetailCondition] ALTER COLUMN [ConditionKey] INT NULL;


GO
ALTER TABLE [dbo].[tblFSDetailCondition]
    ADD [ConditionValue] VARCHAR (50) NULL;


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
PRINT N'Altering [dbo].[tblFSDetailSetup]...';


GO
ALTER TABLE [dbo].[tblFSDetailSetup]
    ADD [ExamLocationCity] VARCHAR (MAX) NULL;


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
    ADD [WebCompanyID] INT NULL;


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
PRINT N'Creating [dbo].[tblDoctorBlockTimeDay].[IX_tblDoctorBlockTimeDay_ScheduleDateDoctorCodeLocationCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblDoctorBlockTimeDay_ScheduleDateDoctorCodeLocationCode]
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
PRINT N'Altering [dbo].[proc_Info_Travelers_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Travelers_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_TravelersInvoices') IS NOT NULL DROP TABLE ##tmp_TravelersInvoices
print 'Gather main data set ...'


DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;

SELECT
    'ExamWorks' as VendorName,
	ah.EWFacilityID,
	ah.HeaderID,
	EWF.DBID as DBID,
	EWF.GPFacility + '-' + CAST(ah.DocumentNbr as varchar(15)) as InvoiceNo,
	ah.DocumentDate as InvoiceDate,
	C.CaseNbr,
	C.ExtCaseNbr,
	CASE WHEN ISNULL(CL.LASTNAME, '') = '' THEN ISNULL(CL.FIRSTNAME, '') ELSE CL.LASTNAME + ', ' + ISNULL(CL.FIRSTNAME, '') END AS ReferralSource,
	CASE BL.EWBusLineID
		WHEN 1 THEN 'Bodily Injury'
		WHEN 2 THEN 'No Fault'
		WHEN 3 THEN 'Workers Compensation'
		WHEN 5 THEN 'Bodily Injury'
		ELSE BL.Name
	END as LineOfBusiness,
	CO.IntName as ClientSite,
	C.ClaimNbr,	
	CASE 
	  WHEN ST.EWServiceTypeID = 1 THEN 'IME'
	  WHEN ST.EWServiceTypeID IN (2,3,4,5,6,8) THEN 'PEER'
	  ELSE ''
	END as ProductName,
	ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) as Specialty,
	ISNULL(D.FirstName, '') + ' ' + ISNULL(D.LastName, '') as PhysicianReviewer,
	C.Jurisdiction,
    C.AwaitingScheduling as ReferralDate,
	ISNULL(CA.DateAdded, CA.DateReceived) as ScheduledDate,	
	C.DateMedsRecd as MedicalRecordsReceived,
	CONVERT(DATETIME, NULL) as OrigAppt,
	CONVERT(DATETIME, NULL) AS RescheduledApptDate,
	CA.ApptTime as ApptDate,
	C.RptSentDate as ReportSent,
	CONVERT(MONEY, NULL) AS   ExamCost,
	CONVERT(MONEY, NULL) AS   OtherCosts,
	CASE ST.EWServiceTypeID
		WHEN 8 THEN ST.Name
		ELSE ''
	END AddReExam,
	CASE CA.ApptStatusID
		WHEN 101 THEN 'Yes'
		WHEN 102 THEN 'Yes'
		ELSE 'No'
	END NoShow,
	CASE CA.ApptStatusID
		WHEN 50 THEN 'Yes'
		WHEN 51 THEN 'Yes'
		ELSE 'No'
	END Cancellation,
	CASE 
		WHEN ISNULL(C.RequestedDoc, '') <> '' THEN 'Yes'
		WHEN ISNULL(C.RequestedDoc, '') = '' THEN 'No'
	END DoctorRequested,
	CONVERT(DATETIME, NULL) as ReportDateViewed,
	CONVERT(INT, NULL) ReferralToScheduledBusDays,
	CONVERT(INT, NULL) AS ReferralToMedRecsRecvdCalDays,
	CONVERT(INT, NULL) as ScheduledToApptCalDays,
	CONVERT(INT, NULL) as ApptToReportSentCalDays, 	
    CONVERT(INT, NULL) AS ReferralReportReceviedCalDays,
	ISNULL(e.LastName, '') + ', ' + ISNULL(e.FirstName, '') as ExamineeName,
	c.RptFinalizedDate as ReportFinalizedDate,
	CD.[Param] as CustomerDataParam,
	CONVERT(VARCHAR(128), NULL) as TimeTrackReferralNbr, 
	CONVERT(VARCHAR(128), NULL) as ClaimantNbr
INTO ##tmp_TravelersInvoices
FROM tblAcctHeader AS AH
	LEFT OUTER JOIN tblCase as C on ah.CaseNbr = C.CaseNbr
	LEFT OUTER JOIN tblEmployer as EM on C.EmployerID = EM.EmployerID
	LEFT OUTER JOIN tblClient as CL on ah.ClientCode = CL.ClientCode
	LEFT OUTER JOIN tblCompany as CO on ah.CompanyCode = CO.CompanyCode
	LEFT OUTER JOIN tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
	LEFT OUTER JOIN tblDoctor as D on ah.DrOpCode = D.DoctorCode
	LEFT OUTER JOIN tblExaminee as E on C.ChartNbr = E.ChartNbr
	LEFT OUTER JOIN tblCaseType as CT on C.CaseType = CT.Code
	LEFT OUTER JOIN tblServices as S on C.ServiceCode = S.ServiceCode
	LEFT OUTER JOIN tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
	LEFT OUTER JOIN tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
	LEFT OUTER JOIN tblOffice as O on C.OfficeCode = O.OfficeCode
	LEFT OUTER JOIN tblEWFacility as EWF on ah.EWFacilityID = EWF.EWFacilityID
	LEFT OUTER JOIN tblEWFacilityGroupSummary as EFGS on ah.EWFacilityID = EFGS.EWFacilityID
	LEFT OUTER JOIN tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
	LEFT OUTER JOIN tblDocument as DOC on ah.DocumentCode = DOC.Document
	LEFT OUTER JOIN tblUser as M on C.MarketerCode = M.UserID
	LEFT OUTER JOIN tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
	LEFT OUTER JOIN tblEWBulkBilling as BB on CO.BulkBillingID = BB.BulkBillingID
	LEFT OUTER JOIN tblCaseAppt as CA on ISNULL(ah.CaseApptID, C.CaseApptID) = CA.CaseApptID
	LEFT OUTER JOIN tblApptStatus as APS on ISNULL(ah.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
	LEFT OUTER JOIN tblCanceledBy as CB on CA.CanceledByID = CB.CanceledByID
	LEFT OUTER JOIN tblEWFeeZone as FZ on ISNULL(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
	LEFT OUTER JOIN tblLanguage as LANG on C.LanguageID = LANG.LanguageID
	LEFT OUTER JOIN tblEWInputSource as EWIS on C.InputSourceID = EWIS.InputSourceID
	LEFT OUTER JOIN tblLocation as EL on CA.LocationCode = EL.LocationCode
	LEFT OUTER JOIN tblCustomerData as CD on (C.CaseNbr = CD.TableKey AND CD.TableType = 'tblCase' AND CD.CustomerName = 'Travelers')
WHERE (ah.DocumentType='IN')
      AND (ah.DocumentStatus='Final')
	  AND (CO.ParentCompanyID = 52)
      AND (ah.DocumentDate >= @startDate) and (ah.DocumentDate <= @endDate)
      AND (ah.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
ORDER BY EWF.GPFacility, ah.DocumentNbr

print 'Data retrieved'

SET NOCOUNT OFF
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

		SELECT FSDetailID, 'tblLocation', NULL, TRIM(C.value)  
		  FROM tblFSDetailSetup
					CROSS APPLY STRING_SPLIT(ExamLocationCity, ',') AS C
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

--The following seems to exist in all databases.  Not including this
-- Issue 12079 - add med status options to combo
--INSERT INTO tblRecordStatus  (Description, DateAdded, UserIDAdded, PublishOnWeb)
--VALUES ('Awaiting Declaration', GETDATE(), 'TLyde', 1),
--       ('Declaration Received', GETDATE(), 'TLyde', 1)
--
--GO

--The following seems to exist in all databases.  Not including this
-- Issue 12026 - add new security token and items to tblSetting for CCMSI
--INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
--VALUES('CaseOverview', 'Case - Overview Info', GETDATE())
--GO

--The following seems to exist in all databases.  Not including this
--INSERT INTO tblSetting(Name, Value)
--VALUES('CCMSIBaseAPIURL', 'https://api.terraclaim.com/connect/vendors/test/'),
--      ('CCMSIAPISecurityToken', '31031783bcb8466abfc45521a2fdcfe9')
--GO
