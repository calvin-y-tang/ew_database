
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
PRINT N'Altering [dbo].[tblCaseDocuments]...';


GO
ALTER TABLE [dbo].[tblCaseDocuments]
    ADD [FirstViewedOnWebBy]   VARCHAR (100) NULL,
        [FirstViewedOnWebDate] SMALLDATETIME NULL;


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
PRINT N'Altering [dbo].[tblClient]...';


GO
ALTER TABLE [dbo].[tblClient]
    ADD [FirstCaseNbr] INT NULL;


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
ALTER TABLE [dbo].[tblDPSBundle]
    ADD [DPSBundleTypeID] INT           NULL,
        [CaseData]        VARCHAR (MAX) NULL,
        [CancelReason]    VARCHAR (100) NULL;


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
PRINT N'Altering [dbo].[tblDPSPriority]...';


GO
ALTER TABLE [dbo].[tblDPSPriority]
    ADD [CancelPriority] BIT NULL;


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
PRINT N'Creating [dbo].[tblFSDetail]...';


GO
CREATE TABLE [dbo].[tblFSDetail] (
    [FSDetailID]    INT          IDENTITY (1, 1) NOT NULL,
    [FSHeaderID]    INT          NOT NULL,
    [ProcessOrder]  INT          NOT NULL,
    [FeeUnit]       INT          NOT NULL,
    [FeeAmt]        MONEY        NOT NULL,
    [NSFeeAmt1]     MONEY        NULL,
    [NSFeeAmt2]     MONEY        NULL,
    [NSFeeAmt3]     MONEY        NULL,
    [LateCancelAmt] MONEY        NULL,
    [CancelDays]    INT          NULL,
    [DateAdded]     DATETIME     NOT NULL,
    [UserIDAdded]   VARCHAR (30) NOT NULL,
    [DateEdited]    DATETIME     NULL,
    [UserIDEdited]  VARCHAR (30) NULL,
    CONSTRAINT [PK_tblFSDetail] PRIMARY KEY CLUSTERED ([FSDetailID] ASC)
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
PRINT N'Creating [dbo].[tblFSDetailCondition]...';


GO
CREATE TABLE [dbo].[tblFSDetailCondition] (
    [FSDetailConditionID] INT          IDENTITY (1, 1) NOT NULL,
    [FSDetailID]          INT          NOT NULL,
    [ConditionTable]      VARCHAR (30) NOT NULL,
    [ConditionKey]        INT          NOT NULL,
    CONSTRAINT [PK_tblFSDetailCondition] PRIMARY KEY CLUSTERED ([FSDetailConditionID] ASC)
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
PRINT N'Creating [dbo].[tblFSDetailSetup]...';


GO
CREATE TABLE [dbo].[tblFSDetailSetup] (
    [FSDetailSetupID] INT           IDENTITY (1, 1) NOT NULL,
    [FSHeaderSetupID] INT           NOT NULL,
    [FSDetailID]      INT           NULL,
    [ProcessOrder]    INT           NULL,
    [FeeUnit]         INT           NULL,
    [FeeAmt]          MONEY         NULL,
    [NSFeeAmt1]       MONEY         NULL,
    [NSFeeAmt2]       MONEY         NULL,
    [NSFeeAmt3]       MONEY         NULL,
    [LateCancelAmt]   MONEY         NULL,
    [CancelDays]      INT           NULL,
    [DateAdded]       DATETIME      NULL,
    [UserIDAdded]     VARCHAR (30)  NULL,
    [DateEdited]      DATETIME      NULL,
    [UserIDEdited]    VARCHAR (30)  NULL,
    [BusLine]         VARCHAR (MAX) NULL,
    [ServiceType]     VARCHAR (MAX) NULL,
    [Service]         VARCHAR (MAX) NULL,
    [Product]         VARCHAR (MAX) NULL,
    [FeeZone]         VARCHAR (MAX) NULL,
    [Specialty]       VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblFSDetailSetup] PRIMARY KEY CLUSTERED ([FSDetailSetupID] ASC)
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
PRINT N'Creating [dbo].[tblFSEntity]...';


GO
CREATE TABLE [dbo].[tblFSEntity] (
    [FSEntityID]   INT          IDENTITY (1, 1) NOT NULL,
    [FSGroupID]    INT          NOT NULL,
    [OfficeCode]   INT          NOT NULL,
    [EntityType]   CHAR (2)     NOT NULL,
    [EntityID]     INT          NOT NULL,
    [DateAdded]    DATETIME     NOT NULL,
    [UserIDAdded]  VARCHAR (30) NOT NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblFSEntity] PRIMARY KEY CLUSTERED ([FSEntityID] ASC)
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
PRINT N'Creating [dbo].[tblFSGroup]...';


GO
CREATE TABLE [dbo].[tblFSGroup] (
    [FSGroupID]       INT          IDENTITY (1, 1) NOT NULL,
    [FeeScheduleName] VARCHAR (30) NOT NULL,
    [DocumentType]    VARCHAR (2)  NOT NULL,
    [DateAdded]       DATETIME     NOT NULL,
    [UserIDAdded]     VARCHAR (30) NOT NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (30) NULL,
    CONSTRAINT [PK_tblFSGroup] PRIMARY KEY CLUSTERED ([FSGroupID] ASC)
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
PRINT N'Creating [dbo].[tblFSHeader]...';


GO
CREATE TABLE [dbo].[tblFSHeader] (
    [FSHeaderID]   INT          IDENTITY (1, 1) NOT NULL,
    [FSGroupID]    INT          NOT NULL,
    [StartDate]    DATETIME     NOT NULL,
    [EndDate]      DATETIME     NULL,
    [DateAdded]    DATETIME     NOT NULL,
    [UserIDAdded]  VARCHAR (30) NOT NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblFSHeader] PRIMARY KEY CLUSTERED ([FSHeaderID] ASC)
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
PRINT N'Creating [dbo].[tblFSHeaderSetup]...';


GO
CREATE TABLE [dbo].[tblFSHeaderSetup] (
    [FSHeaderSetupID] INT          IDENTITY (1, 1) NOT NULL,
    [FSGroupID]       INT          NULL,
    [FSHeaderID]      INT          NULL,
    [FeeScheduleName] VARCHAR (30) NULL,
    [DocumentType]    VARCHAR (2)  NULL,
    [EntityType]      VARCHAR (2)  NULL,
    [StartDate]       DATETIME     NULL,
    [EndDate]         DATETIME     NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (30) NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (30) NULL,
    CONSTRAINT [PK_tblFSHeaderSetup] PRIMARY KEY CLUSTERED ([FSHeaderSetupID] ASC)
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
PRINT N'Creating [dbo].[tblWebPortalVersionRule]...';


GO
CREATE TABLE [dbo].[tblWebPortalVersionRule] (
    [WebPortalVersionRule] INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]         INT          NOT NULL,
    [UserType]             VARCHAR (2)  NULL,
    [WebUserID]            INT          NULL,
    [CompanyCode]          INT          NULL,
    [ParentCompanyID]      INT          NULL,
    [EffectiveDate]        DATETIME     NOT NULL,
    [PortalVersion]        INT          NOT NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDAdded]          VARCHAR (15) NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblWebPortalVersionRule] PRIMARY KEY CLUSTERED ([WebPortalVersionRule] ASC)
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
PRINT N'Altering [dbo].[vwDPSCases]...';


GO
ALTER VIEW dbo.vwDPSCases
AS
    SELECT 
        C.CaseNbr,
        C.ExtCaseNbr,
        B.DPSBundleID,
		B.CombinedDPSBundleID,
		CASE
			WHEN B.DPSBundleTypeID = 1 THEN 'Original'
			WHEN B.DPSBundleTypeID = 2 THEN 'Rework'
			WHEN B.DPSBundleTypeID = 3 THEN 'Review'
		ELSE
			'Unknown'
		END AS DPSBundleType,
        DATEDIFF(d, B.DateEdited, GETDATE()) AS IQ,
        E.FirstName+' '+E.LastName AS ExamineeName,
        Com.IntName AS CompanyName,
        D.FirstName+' '+D.LastName AS DoctorName,
        C.ApptTime,
        B.ContactName,
		B.DateCompleted,
        B.DPSStatusID,       
        B.DateAcknowledged,
        C.OfficeCode,
        C.ServiceCode,
        C.SchedulerCode,
        C.QARep,
        C.MarketerCode,
        Com.ParentCompanyID,
        C.DoctorLocation,
        D.DoctorCode,
        Com.CompanyCode,
        C.CaseType,
        E.ChartNbr,
		S.Name AS Status
    FROM
        tblDPSBundle AS B
	LEFT OUTER JOIN tblDPSStatus AS S ON S.DPSStatusID = B.DPSStatusID
    LEFT OUTER JOIN tblCase AS C ON B.CaseNbr=C.CaseNbr
    LEFT OUTER JOIN tblExaminee AS E ON C.ChartNbr=E.ChartNbr
    LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode=D.DoctorCode
    LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode=C.ClientCode
    LEFT OUTER JOIN tblCompany AS Com ON Com.CompanyCode=CL.CompanyCode
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
PRINT N'Creating [dbo].[spFeeSched_SyncTableData_DetailCondition]...';


GO
CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData_DetailCondition]
     @iDetailID INTEGER,
	@sTable VARCHAR(30), 
	@sIDs VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @xmlIDs XML
	
	-- delete all conditions for the specified DetailID and ConditionTable 
	DELETE FROM tblFSDetailCondition WHERE FSDetailID = @iDetailID AND ConditionTable = @sTable 
	
	-- if IDs is -1 then nothing to do
	IF @sIDs = '-1'
	BEGIN 
		RETURN 
	END 
	ELSE 
	BEGIN 
		-- need to create an entry in tblFSDetailCondition for each of the ID values in the string 
		-- DEVNOTE: 
		-- 		we are going to do some some character subsitution and turn our comma separated 
		--		list into an XML string this XML string can then easily be parsed into a table 
		--		and used in an INSERT statement to create needed items.
		SET @xmlIDs = N'<t>' + REPLACE(@sIDs, ',', '</t><t>') + '</t>'
		INSERT INTO tblFSDetailCondition(FSDetailID, ConditionTable, ConditionKey)
			SELECT @iDetailID, @sTable, r.value('.', 'INTEGER') AS ItemID 
			  FROM @xmlIDs.nodes('t') as tmp(r)
	END 
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
PRINT N'Creating [dbo].[spFeeSched_SyncTableData_Header]...';


GO
CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData_Header]
     @iSetupID INTEGER, 
	@iHeaderID INTEGER OUTPUT
AS
BEGIN
	
	-- FSHeaderSetup variables 
	DECLARE @iGroupID INTEGER 
	DECLARE @sFSName VARCHAR(30)
	DECLARE @sDocType VARCHAR(2)
	DECLARE @dStartDate DATETIME
	DECLARE @dEndDate DATETIME 
	DECLARE @dDateAdded DATETIME 
	DECLARE @sUserIDAdded VARCHAR(30)
	DECLARE @dDateEdit DATETIME 
	DECLARE @sUserIDEdit VARCHAR(30)

	-- initialize our HeaderID to NULL to protect against "bad stuff"
	SET @iHeaderID = NULL 
	
	-- get HeaderSetup Details
	SELECT @iGroupID = FSGroupID, @iHeaderID = FSHeaderID, @sFSName = FeeScheduleName, 
	       @sDocType = DocumentType, @dStartDate = StartDate, @dEndDate = EndDate, 
		  @dDateAdded = DateAdded, @sUserIDAdded = UserIDAdded, 
		  @dDateEdit = DateEdited, @sUserIDEdit = UserIDEdited
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
		INSERT INTO tblFSGroup (FeeScheduleName, DocumentType, DateAdded, UserIDAdded)
		VALUES(@sFSName, @sDocType, @dDateAdded, @sUserIDAdded)
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
			  UserIDEdited = @sUserIDEdit
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
PRINT N'Creating [dbo].[spFeeSched_SyncTableData_Detail]...';


GO
CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData_Detail]
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
	
	-- get a list of Detail Items that make up this Header and process them
	DECLARE curDetailSetup CURSOR FOR
		SELECT FSDetailSetupID, FSDetailID, 
			  BusLine,  ServiceType, Service, Product, FeeZone, Specialty
		  FROM tblFSDetailSetup 
		 WHERE FSHeaderSetupID = @iHdrSetupID
	OPEN curDetailSetup
	FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID, @sBusLine, @sSvcType, @sService, @sProduct, @sFeeZone, @sSpecialty
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
		
		-- process next row
		FETCH NEXT FROM curDetailSetup INTO @iDtlSetupID, @iDetailID, @sBusLine, @sSvcType, @sService, @sProduct, @sFeeZone, @sSpecialty
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
PRINT N'Creating [dbo].[spFeeSched_SyncTableData]...';


GO
CREATE PROCEDURE [dbo].[spFeeSched_SyncTableData]
     @iSetupID INTEGER
AS
BEGIN
	
	DECLARE @iErrState INTEGER
	DECLARE @sErrMsg VARCHAR(MAX)
	DECLARE @iErrSeverity INTEGER
	DECLARE @iHeaderID INTEGER
	
	BEGIN TRY
		-- Process "Header" table(s)
		EXEC spFeeSched_SyncTableData_Header
				@iSetupID, 
				@iHeaderID = @iHeaderID OUTPUT 

		-- Process "Detail" table(s)
		EXEC spFeeSched_SyncTableData_Detail
			@iSetupID, 
			@iHeaderID
		
	END TRY
	BEGIN CATCH 
		-- When you specify the message_text, the RAISERROR statement uses message_id 50000 to raise the error message.
		SET @sErrMsg = ERROR_MESSAGE() + ' (Error Number = ' + CAST(ERROR_NUMBER() AS VARCHAR(MAX)) + ')'
		SET @iErrSeverity = ERROR_SEVERITY()
		SET @iErrState = ERROR_STATE() 
		-- this error is what IMECHelper will catch
		RAISERROR(@sErrMsg, @iErrSeverity, @iErrState)
		RETURN -1
	END CATCH 
	
	-- data sync completed with no errors
	RETURN 0
	
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
-- Issue 11211 - add new Security Token to allow use of unallowed Employer
INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
VALUES('ClaimEmployerOverride', 'Case - Claim Nbr Employer Override', '2019-08-12'), 
	-- Issue 11206 - add new security token to allow user to modify claim number after it has been matched/validated.
	('AllowClaimNbrChange', 'Case - Allow Change for Matched Claim Nbr', '2019-08-20')
GO

-- Issue 11211 - add new business rule to enforce specific Employer when a specified Claim Nbr format is used
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(104, 'MatchClaimNbrToEmployer', 'Case', 'Ensure that selected Employer is Valid for Claim Nbr', 1, 1016, 0, 'ClaimNbrStartsWith', 'ClaimNbrEndsWith', 'AllowedEmployerID', NULL, 'OverrideToken', 0)
GO

--Add a setting to tblSetting - a value to turn on the portal web version rule – UseWebPortalVersionRules
INSERT INTO tblSetting (Name, Value) VALUES ('UseWebPortalVersionRules', 'True')

-- Issue 11243 data patch
  UPDATE tblDPSBundle SET DPSBundleTypeID = 1
  UPDATE tblDPSBundle SET CombinedDPSBundleID = DPSBundleID

-- Issue 11208 - New evemt for Send Email for case
INSERT INTO tblEvent(EventID, Descrip, Category)
VALUES(1050, 'Send Email (Case)', 'Case')
GO
-- Issue 11208 - add new business rules to allow for an override of the client email address
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction)
VALUES(105, 'CaseSendEmailClientEmail', 'Case', 'Use alternate email address when emailing client', 1, 1050, 0, 'SchedEmail', 'StatusEmail', 'RptDistEmail', NULL, NULL, 0),
      (106, 'DistRptClientEmail', 'Case', 'Use alternate email address for client correspondence', 1, 1320, 0, 'SchedEmail', 'StatusEmail', 'RptDistEmail', NULL, NULL, 0),
	  (107, 'GenDocClientEmail', 'Case', 'Use alternate email address for client correspondence', 1, 1201, 0, 'SchedEmail', 'StatusEmail', 'RptDistEmail', NULL, NULL, 0)
GO
