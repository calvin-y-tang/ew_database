

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
PRINT N'Altering [dbo].[tblConfirmationMessage]...';


GO
ALTER TABLE [dbo].[tblConfirmationMessage] ALTER COLUMN [Message] NVARCHAR (2048) NULL;


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
PRINT N'Altering [dbo].[tblDPSBundleCaseDocument]...';


GO
ALTER TABLE [dbo].[tblDPSBundleCaseDocument] ALTER COLUMN [Filename] VARCHAR (100) NULL;


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
    ADD [Doctor]       VARCHAR (MAX) NULL,
        [ExamLocation] VARCHAR (MAX) NULL;


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
PRINT N'Altering [dbo].[tblFSGroup]...';


GO
ALTER TABLE [dbo].[tblFSGroup] ALTER COLUMN [FeeScheduleName] VARCHAR (50) NOT NULL;


GO
-- Workaroung for the following statement adding a NOT NULL column:
--ALTER TABLE [dbo].[tblFSGroup]
--    ADD [EntityType] CHAR (2) NOT NULL;

ALTER TABLE [dbo].[tblFSGroup]
    ADD [EntityType] CHAR (2) NULL;

GO

--Enter an empty string
Update tblFSGroup
set EntityType = ''
where 1 = 1

GO

--Set the column to NOT NULL like we wanted it to be
ALTER TABLE
  tblFSGroup
ALTER COLUMN
  EntityType 
     CHAR (2) NOT NULL;


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
PRINT N'Altering [dbo].[tblFSHeaderSetup]...';


GO
ALTER TABLE [dbo].[tblFSHeaderSetup] ALTER COLUMN [FeeScheduleName] VARCHAR (50) NULL;


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
    ADD [FSInvoiceSetting] INT          NULL,
        [FSVoucherSetting] INT          NULL,
        [DaySheetDocument] VARCHAR (15) NULL;


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
PRINT N'Creating [dbo].[vwDoctorBlockTimeScheduleSummary]...';


GO
CREATE VIEW vwDoctorBlockTimeScheduleSummary
AS  
	
	-- DEV NOTE: the result set of this view needs to match (data type & column names) 
	--		vwDoctorScheduleSummary. These 2 views are conditionally used within the same IMEC code
	--		 and; therefore, need to be in "sync".

   SELECT  
		Doc.LastName ,
		Doc.FirstName ,
		Loc.Location ,
		-- DEVNOTE: need to play around with ScheduleDate to return date + "00:00" time
		--		which is needed for the summary page to dispaly properly.
		DATEADD(d, DATEDIFF(d, 0, BTDay.ScheduleDate), 0) AS Date , 

		-- DEV NOTE: IMEC only looks for Scheduled/Hold value to count as Scheduled but only when CaseNbr is present; 
		--		"Reserved" is not considered scheduled.
		CASE BTSlot.DoctorBlockTimeSlotStatusID
			WHEN 10 THEN 'Open'
			WHEN 21 THEN 'Reserved' 
			WHEN 22 THEN 'Hold'
			WHEN 30 THEN 'Scheduled'
			ELSE 'Other'
		END AS Status, 
		
		Loc.InsideDr ,
		Doc.DoctorCode ,
		DocOff.OfficeCode ,
		BTDay.LocationCode , 
		
		-- DEV NOTE: Instead of using the Doctor.Booking value we will count the actualy number
		--		slots that have been configured for each day.
		(SELECT IIF(MIN(sl.DoctorBlockTimeSlotID) = BTSlot.DoctorBlockTimeSlotID, COUNT(sl.DoctorBlockTimeSlotID), 0) 
		   FROM tblDoctorBlockTimeSlot AS sl 
		  WHERE sl.DoctorBlockTimeDayID = BTDay.DoctorBlockTimeDayID AND sl.StartTime = BTSlot.StartTime) AS Booking,

		-- DEV NOTE: we now a multiple rows to define each potential booking slot at the same date/time; therefore, 
		--		we only ever have CaseNbr1 to set/process but there may be multiple rows for the same time.
		CA.CaseNbr AS CaseNbr1 , 
		CAST(NULL AS INT) AS CaseNbr2 , 
		CAST(NULL AS INT) AS CaseNbr3 , 
		CAST(NULL AS INT) AS CaseNbr4 , 
		CAST(NULL AS INT) AS CaseNbr5 , 
		CAST(NULL AS INT) AS CaseNbr6 , 
		BTSlot.StartTime, 
		LocOff.OfficeCode as LocationOffice 
    FROM    
		tblDoctorBlockTimeDay AS BTDay
			INNER JOIN tblDoctorBlockTimeSlot AS BTSlot ON BTSlot.DoctorBlockTimeDayID = BTDay.DoctorBlockTimeDayID
			INNER JOIN tblDoctor AS Doc ON Doc.DoctorCode = BTDay.DoctorCode
			INNER JOIN tblLocation AS Loc ON Loc.LocationCode = BTDay.LocationCode
			INNER JOIN tblDoctorOffice AS DocOff ON DocOff.DoctorCode = Doc.DoctorCode 
			INNER JOIN tbllocationoffice AS LocOff ON (LocOff.OfficeCode = DocOff.OfficeCode AND LocOff.LocationCode = Loc.LocationCode) 
			LEFT OUTER JOIN tblCaseAppt AS CA ON CA.CaseApptID = BTSlot.CaseApptID
    WHERE   
		(BTDay.Active = 1)
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
	DECLARE @sBusLine VARCHAR(MAX)
	DECLARE @sFeeZone VARCHAR(MAX)
	DECLARE @sProduct VARCHAR(MAX)
	DECLARE @sSpecialty VARCHAR(MAX)
	DECLARE @sSvcType VARCHAR(MAX)
	DECLARE @sService VARCHAR(MAX)
	DECLARE @sDoctor VARCHAR(MAX)
	DECLARE @sExamLocation VARCHAR(MAX)
	
	-- get a list of Detail Items that make up this Header and process them
	DECLARE curDetailSetup CURSOR FOR
		SELECT FSDetailSetupID, FSDetailID, 
			  BusLine,  ServiceType, Service, Product, FeeZone, Specialty, Doctor, ExamLocation
		  FROM tblFSDetailSetup 
		 WHERE FSHeaderSetupID = @iHdrSetupID
	OPEN curDetailSetup
	FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID, @sBusLine, @sSvcType, @sService, @sProduct, @sFeeZone, @sSpecialty, @sDoctor, @sExamLocation
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		-- update or insert item? 
		IF @iDetailID IS NULL
		BEGIN 
			INSERT INTO tblFSDetail(FSHeaderID, ProcessOrder, FeeUnit, FeeAmt, NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, DateAdded, UserIDAdded)
				SELECT @iHeaderID, ProcessOrder, FeeUnit, FeeAmt, NSFeeAmt1, NSFeeAmt2, NSFeeAmt3, LateCancelAmt, CancelDays, DateAdded, UserIDAdded
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
				  FeeAmt = ui.FeeAmt, 
				  NSFeeAmt1 = ui.NSFeeAmt1,
				  NSFeeAmt2 = ui.NSFeeAmt2, 
				  NSFeeAmt3 = ui.NSFeeAmt3, 
				  LateCancelAmt = ui.LateCancelAmt, 
				  CancelDays = ui.CancelDays, 
				  DateEdited = ui.DateEdited, 
				  UserIDEdited = ui.UserIDEdited
			  FROM tblFSDetail AS calc
					INNER JOIN tblFSDetailSetup AS ui ON ui.FSDetailID = calc.FSDetailID
			 WHERE calc.FSDetailID = @iDetailID
		END 
		
		-- Process Detail Condition selections
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblEWBusLine', 
				@sBusLine
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblEWServiceType', 
				@sSvcType
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblServices', 
				@sService
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblProduct', 
				@sProduct
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblEWFeeZone', 
				@sFeeZone
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblSpecialty', 
				@sSpecialty

		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblDoctor', 
				@sDoctor
		
		EXEC spFeeSched_SyncTableData_DetailCondition
				@iDetailID, 
				'tblLocation', 
				@sExamLocation
		
		
		-- process next row
		FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID, @sBusLine, @sSvcType, @sService, @sProduct, @sFeeZone, @sSpecialty, @sDoctor, @sExamLocation
	END
	CLOSE curDetailSetup
	DEALLOCATE curDetailSetup
	
	-- cleanup DetailCondition table for Detail items no longer part of setup table
	DELETE tblFSDetailCondition
	  FROM tblFSDetailCondition
			INNER JOIN tblFSDetail ON tblFSDetail.FSDetailID = tblFSDetailCondition.FSDetailID 
			LEFT OUTER JOIN tblFSDetailSetup ON tblFSDetailSetup.FSDetailID = tblFSDetail.FSDetailID
	 WHERE FSHeaderID = @iHeaderID 
	   AND tblFSDetailSetup.FSDetailSetupID IS NULL
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
PRINT N'Altering [dbo].[spFeeSched_SyncTableData_Header]...';


GO
ALTER PROCEDURE [dbo].[spFeeSched_SyncTableData_Header]
     @iSetupID INTEGER, 
	@iHeaderID INTEGER OUTPUT
AS
BEGIN
	
	-- FSHeaderSetup variables 
	DECLARE @iGroupID INTEGER 
	DECLARE @sFSName VARCHAR(50)
	DECLARE @sDocType VARCHAR(2)
	DECLARE @dStartDate DATETIME
	DECLARE @dEndDate DATETIME 
	DECLARE @dDateAdded DATETIME 
	DECLARE @sUserIDAdded VARCHAR(30)
	DECLARE @dDateEdit DATETIME 
	DECLARE @sUserIDEdit VARCHAR(30)
	DECLARE @sEntityType CHAR(2)

	-- initialize our HeaderID to NULL to protect against "bad stuff"
	SET @iHeaderID = NULL 
	
	-- get HeaderSetup Details
	SELECT @iGroupID = FSGroupID, @iHeaderID = FSHeaderID, @sFSName = FeeScheduleName, 
	       @sDocType = DocumentType, @dStartDate = StartDate, @dEndDate = EndDate, 
		  @dDateAdded = DateAdded, @sUserIDAdded = UserIDAdded, 
		  @dDateEdit = DateEdited, @sUserIDEdit = UserIDEdited, @sEntityType = EntityType
	  FROM tblFSHeaderSetup
	 WHERE FSHeaderSetupID = @iSetupID
	
	-- Check StartDate when NULL do nothing and exit
	IF @dStartDate IS NULL
	BEGIN 
		RAISERROR ('Draft Fee Schedule details have been saved but cannot be synced.', 11, 1);
		RETURN 
	END 
	
	-- Check FSGroupID when NULL create new entry in tblFSGroup and set value back into column
	IF @iGroupID IS NULL 
	BEGIN 
		-- need to create new tblFSGroup item
		INSERT INTO tblFSGroup (FeeScheduleName, DocumentType, DateAdded, UserIDAdded, EntityType)
		VALUES(@sFSName, @sDocType, @dDateAdded, @sUserIDAdded, @sEntityType)
		SET @iGroupID = @@IDENTITY
		IF @iGroupID IS NOT NULL AND @iGroupID > 0
		BEGIN 
			-- save GroupID back to tblFSHeaderSetup
			UPDATE tblFSHeaderSetup
			   SET FSGroupID = @iGroupID 
			 WHERE FSHeaderSetupID = @iSetupID
		END
		ELSE
		BEGIN 
			-- no GroupID; Unable to continue
			RAISERROR ('Unable to create new tblFSGroup entry (FSGroupID is not valid).', 16, 1);
			RETURN 
		END 
	END 
	ELSE
	BEGIN 
		-- need to update existing tblFSGroup entry
		UPDATE tblFSGroup 
		   SET FeeScheduleName = @sFSName, 
			  DocumentType = @sDocType, 
			  DateEdited = @dDateEdit,
			  UserIDEdited = @sUserIDEdit,
			  EntityType = @sEntityType
		 WHERE FSGroupID = @iGroupID 
	END
	-- ensure that Fee Sched Name is the same for all entries belonging to same group.
	UPDATE tblFSHeaderSetup
	   SET FeeScheduleName = @sFSName
	 WHERE FSGroupID = @iGroupID
	
	-- Check FSHeaderID when NULL create new entry in tblFSHeader and set value back into column
	IF @iHeaderID IS NULL 
	BEGIN 
		-- need to create new tblFSHeader item
		INSERT INTO tblFSHeader(FSGroupID, StartDate, EndDate, DateAdded, UserIDAdded)
		VALUES(@iGroupID, @dStartDate, @dEndDate, @dDateAdded, @sUserIDAdded)
		SET @iHeaderID = @@IDENTITY
		IF @iHeaderID IS NOT NULL AND @iHeaderID > 0 
		BEGIN 
			-- save HeaderID back to tblFSHeaderSetup
			UPDATE tblFSHeaderSetup 
			   SET FSHeaderID = @iHeaderID 
			 WHERE FSHeaderSetupID = @iSetupID
		END 
		ELSE 
		BEGIN 
			-- no HeaderID; Unable to continue 
			RAISERROR ('Unable to create new tblFSHeader entry (FSHeaderID is not valid).', 16, 1);
			RETURN 
		END
	END 
	ELSE
	BEGIN 
		-- need to update existing tblFSHeader entry 
		UPDATE tblFSHeader 
		   SET StartDate = @dStartDate, 
		       EndDate = @dEndDate, 
			  DateEdited = @dDateEdit,
			  UserIDEdited = @sUserIDEdit
		 WHERE FSHeaderID = @iHeaderID 
	END 
	
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
PRINT N'Creating [dbo].[sp_VacancyReport]...';


GO
CREATE PROCEDURE [dbo].[sp_VacancyReport]
AS

	/*
		- Provide a summary of the next 30 days for Block Time Slot Usage. Days that are set to "Draft" will be excluded.
		- The same Doc/Loc can be assigned to multiple offices. The "default" office for a specific Doc/Loc combination
		  will be the one that has had the most cases assigned to it.
	*/

	-- get case count for doc/loc combination. the office will then be the default office. 
	WITH CTE_DocLocOffCounts AS
	(
		SELECT 
			  DoctorCode, DoctorLocation AS LocationCode, OfficeCode, 
			  COUNT(CaseNbr) AS CaseCount,
			  ROW_NUMBER() OVER(PARTITION BY DoctorCode, DoctorLocation ORDER BY COUNT(CaseNbr) DESC) AS DefaultOffice
		FROM tblCase 
		WHERE DoctorCode IS NOT NULL AND DoctorLocation IS NOT NULL AND OfficeCode IS NOT NULL
		GROUP BY DoctorCode, DoctorLocation, OfficeCode 
	)
	-- for each Doc/Loc/Date combination we need to identify the status for configured Active Block Time Slots
	SELECT 
		 -- basic details so we know the doc/loc/date/status of each slot in our report
		 D.DoctorBlockTimeDayID, S.DoctorBlockTimeSlotID, 
		 D.DoctorCode, D.LocationCode, D.ScheduleDate, 
     
		 -- grab default office & Case Count
		 Cnts.OfficeCode AS DefaultOfficeCode,
		 Cnts.CaseCount AS DefaultOfficeCaseCount,
     
		 -- set an indicator so we know what "status" to count the slot as being in
		 IIF(S.DoctorBlockTimeSlotStatusID = 10, 1, 0) AS OpenSlot,
		 IIF(S.DoctorBlockTimeSlotStatusID = 30, 1, 0) AS CurrentlyScheduleSlot,
		 IIF(S.DoctorBlockTimeSlotStatusID = 21, 1, 0) AS ReservedSlot,
		 IIF(S.DoctorBlockTimeSlotStatusID = 22, 1, 0) AS HoldSlot,
		 IIF(AnyCA.CaseApptID IS NULL OR AnyCA.CaseApptID = 0, 0, 1) AS HasEverScheduled
	INTO 
		 #TempVacancyRpt
	FROM 
		 tblDoctorBlockTimeSlot AS S
			  INNER JOIN tblDoctorBlockTimeDay AS D ON D.DoctorBlockTimeDayID = S.DoctorBlockTimeDayID
			  LEFT OUTER JOIN CTE_DocLocOffCounts AS Cnts ON Cnts.DoctorCode = D.DoctorCode 
			                                             AND Cnts.LocationCode = D.LocationCode 
														 AND Cnts.DefaultOffice = 1
			  LEFT OUTER JOIN tblCaseAppt AS AnyCA ON AnyCA.DoctorBlockTimeSlotID = S.DoctorBlockTimeSlotID
	WHERE 
			 D.Active = 1
		 AND (
				   D.ScheduleDate >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) - 1, 0) 
			   AND D.ScheduleDate < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) +1, 30)
			 )
	
-- calculate totals for the various slot statuses for each Doc/Loc/Date
SELECT 
     tmp.DoctorBlockTimeDayID, tmp.DefaultOfficeCode, tmp.DoctorCode, tmp.LocationCode, tmp.ScheduleDate, tmp.DefaultOfficeCaseCount,
     COUNT(tmp.DoctorBlockTimeSlotID) AS TTLSlots, 
     SUM(tmp.OpenSlot) AS TTLOpen, 
     SUM(tmp.HoldSlot) AS TTLHold, 
     SUM(tmp.ReservedSlot) AS TTLReserved,
     SUM(tmp.CurrentlyScheduleSlot) AS TTLSched, 
     SUM(tmp.HasEverScheduled) AS TTLPrevSched
INTO 
     #TempVacancyRptTotals
FROM #TempVacancyRpt AS tmp
GROUP BY tmp.DoctorBlockTimeDayID, tmp.DefaultOfficeCode, tmp.DoctorCode, tmp.LocationCode, tmp.ScheduleDate, tmp.DefaultOfficeCaseCount

-- crete the desired summary result set using previously calculated totals
SELECT 
     -- some ID columns for linking to source data and testing/debugging purposes
	 tmp.DoctorBlockTimeDayID,
     tmp.DefaultOfficeCode, 
     tmp.LocationCode, 
     tmp.DoctorCode, 
     tmp.ScheduleDate,
     
	 -- office information
     tblOffice.Description, 
     
	 -- doctor information
     Doc.LastName, 
     Doc.FirstName, 
     Doc.Booking, 
     (SELECT TOP 1 specialtycode FROM tblDoctorSpecialty WHERE doctorcode = Doc.doctorcode) Specialty,

	 -- location information
     Loc.Location, 
     
	 -- counts
     DefaultOfficeCaseCount,
     TTLSlots,
     TTLOpen,
     TTLHold, 
     TTLReserved,
     TTLSched,
     TTLPrevSched
     
FROM #TempVacancyRptTotals AS tmp
          INNER JOIN tblOffice ON tblOffice.OfficeCode = tmp.DefaultOfficeCode
          INNER JOIN tblDoctor AS Doc ON Doc.DoctorCode = tmp.DoctorCode 
          INNER JOIN tblLocation AS Loc ON Loc.LocationCode = tmp.LocationCode 
ORDER BY Doc.LastName, Doc.FirstName, Tmp.ScheduleDate

RETURN 0
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
INSERT INTO tblSetting (Name, Value) VALUES ('UseNewFeeSchedulingMenuItems', 'True')
GO


DELETE FROM tblTATCalculationMethodEvent
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (5, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (6, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (7, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (8, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (9, 1320)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (12, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (13, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (14, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (15, 1101)
INSERT INTO [dbo].[tblTATCalculationMethodEvent] ([TATCalculationMethodID], [EventID]) VALUES (16, 1320)
GO

-- Issue 11509 - set default invoicing and vouchering fee schedule versions
  update tblOffice set [FSInvoiceSetting] = 1 where [FSInvoiceSetting] is null
  update tblOffice set [FSVoucherSetting] = 1 where [FSVoucherSetting] is null

