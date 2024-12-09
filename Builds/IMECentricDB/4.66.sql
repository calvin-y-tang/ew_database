

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
PRINT N'Dropping [dbo].[tblCaseDocuments].[IX_tblCaseDocuments_SourceDateAdded]...';


GO
DROP INDEX [IX_tblCaseDocuments_SourceDateAdded]
    ON [dbo].[tblCaseDocuments];


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
PRINT N'Altering [dbo].[tblDoctorReason]...';


GO
ALTER TABLE [dbo].[tblDoctorReason]
    ADD [Status] VARCHAR (10) NULL;


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
PRINT N'Altering [dbo].[tblQuestionSet]...';


GO
ALTER TABLE [dbo].[tblQuestionSet] DROP COLUMN [Name];


GO
ALTER TABLE [dbo].[tblQuestionSet]
    ADD [ProcessOrder]    INT         NULL,
        [ParentCompanyID] INT         NULL,
        [CompanyCode]     INT         NULL,
        [CaseType]        INT         NULL,
        [Jurisdiction]    VARCHAR (2) NULL,
        [EWServiceTypeID] INT         NULL,
        [ServiceCode]     INT         NULL,
        [OfficeCode]      INT         NULL,
        [Active]          BIT         CONSTRAINT [DF_tblQuestionSet_Active] DEFAULT (0) NULL;


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
/*
The column [dbo].[tblQuestionSetDetail].[GroupOrder] is being dropped, data loss could occur.

The column [dbo].[tblQuestionSetDetail].[IssueQuestionID] is being dropped, data loss could occur.

The column [dbo].[tblQuestionSetDetail].[RowOrder] is being dropped, data loss could occur.
*/
GO
PRINT N'Starting rebuilding table [dbo].[tblQuestionSetDetail]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblQuestionSetDetail] (
    [QuestionSetDetailID] INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [QuestionSetID]       INT          NOT NULL,
    [DateAdded]           DATETIME     NOT NULL,
    [UserIDAdded]         VARCHAR (15) NOT NULL,
    [DisplayOrder]        INT          NULL,
    [QuestionID]          INT          NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblQuestionSetDetail1] PRIMARY KEY CLUSTERED ([QuestionSetDetailID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblQuestionSetDetail])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblQuestionSetDetail] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tblQuestionSetDetail] ([QuestionSetDetailID], [QuestionSetID], [DateAdded], [UserIDAdded])
        SELECT   [QuestionSetDetailID],
                 [QuestionSetID],
                 [DateAdded],
                 [UserIDAdded]
        FROM     [dbo].[tblQuestionSetDetail]
        ORDER BY [QuestionSetDetailID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblQuestionSetDetail] OFF;
    END

DROP TABLE [dbo].[tblQuestionSetDetail];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblQuestionSetDetail]', N'tblQuestionSetDetail';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblQuestionSetDetail1]', N'PK_tblQuestionSetDetail', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


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
PRINT N'Creating [dbo].[tblQuestionSetDetail].[IX_U_tblQuestionSetDetail_QuestionSetIDIssueQuestionID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblQuestionSetDetail_QuestionSetIDIssueQuestionID]
    ON [dbo].[tblQuestionSetDetail]([QuestionSetID] ASC, [QuestionID] ASC);


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
PRINT N'Creating [dbo].[tblFeeScheduleTiers]...';


GO
CREATE TABLE [dbo].[tblFeeScheduleTiers] (
    [TierID]          INT           IDENTITY (1, 1) NOT NULL,
    [Tier]            VARCHAR (128) NOT NULL,
    [DoctorCode]      INT           NOT NULL,
    [ParentCompanyID] INT           NULL,
    [EWBusLineID]     INT           NULL,
    [EWFeeZoneID]     INT           NULL,
    [DateAdded]       DATETIME      NULL,
    [UserIDAdded]     VARCHAR (64)  NULL,
    CONSTRAINT [PK_tblFeeScheduleTiers] PRIMARY KEY CLUSTERED ([TierID] ASC)
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
PRINT N'Creating [dbo].[tblQuestion]...';


GO
CREATE TABLE [dbo].[tblQuestion] (
    [QuestionID]   INT           IDENTITY (1, 1) NOT NULL,
    [QuestionText] VARCHAR (MAX) NOT NULL,
    [DateAdded]    DATETIME      NOT NULL,
    [UserIDAdded]  VARCHAR (15)  NOT NULL,
    [DateEdited]   DATETIME      NULL,
    [UserIDEdited] VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblQuestion] PRIMARY KEY CLUSTERED ([QuestionID] ASC)
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
PRINT N'Creating [dbo].[tblCaseDocuments].[IX_tblCaseDocuments_SourceDateAdded]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseDocuments_SourceDateAdded]
    ON [dbo].[tblCaseDocuments]([Source] ASC, [DateAdded] ASC)
    INCLUDE([CaseNbr], [Description], [UserIDAdded], [CaseDocTypeID], [ReportType], [Type], [QADateTransmitted]);


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
PRINT N'Creating [dbo].[DF_Tier_DateAdded]...';


GO
ALTER TABLE [dbo].[tblFeeScheduleTiers]
    ADD CONSTRAINT [DF_Tier_DateAdded] DEFAULT (getdate()) FOR [DateAdded];


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
PRINT N'Altering [dbo].[vwCaseSummary]...';


GO
ALTER VIEW vwCaseSummary
AS
    SELECT 
            tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblUser.LastName + ', ' + tblUser.FirstName AS SchedulerName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.INQASelect ,
            tblCase.INTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.transReceived ,
            tblTranscription.TransCompany ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.MiscSelect ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.VoucherAmt ,
            tblCase.VoucherDate ,
            tblCase.OfficeCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            DATEDIFF(day, tblCase.LastStatuschg, GETDATE()) AS IQ ,
            DATEDIFF(day, tblCase.DateEdited, GETDATE()) AS DSE ,
            tblCase.LastStatusChg ,
            tblCase.PanelNbr ,
            tblCase.CommitDate ,
            tblCase.MasterSubCase ,
            tblCase.MasterCaseNbr ,
            tblCase.CertMailNbr ,
            tblCase.WebNotifyEmail ,
            tblCase.PublishOnWeb ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS DoctorName ,
            tblCase.Datemedsrecd ,
            tblCase.sInternalCaseNbr ,
            tblCase.DoctorSpecialty ,
            tblCase.USDDate1 ,
            tblqueues.FunctionCode ,
            tblCase.Casetype ,
            tblCase.ForecastDate ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
			tblCase.ReExam ,
			tblCase.ReExamDate ,
			tblCase.ReExamProcessed,
			tblCase.ReExamNoticePrinted,
            tblCase.DateCompleted ,
            tblCase.DateCanceled ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.ClaimNbrExt ,
            tblLocation.Addr1 AS LocationAddr1 ,
            tblLocation.Addr2 AS LocationAddr2 ,
            tblLocation.City AS LocationCity ,
            tblLocation.State AS LocationState ,
            tblLocation.Zip AS LocationZip , 
			tblCase.ExtCaseNbr, 
			tblCase.AwaitingScheduling,
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID, 
			tblCase.Jurisdiction, 
			CaseType.ShortDesc AS CaseTypeDesc,
            CaseType.Description AS CaseTypeLongDesc, 
			tblServices.EWServiceTypeID,
			tblEWServiceType.Name As ServiceTypDesc, 
            BillCompany.IntName AS BillCompanyName
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.transCode = tblTranscription.transCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT OUTER JOIN tblCaseType AS CaseType ON CaseType.Code = tblCase.CaseType
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
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
PRINT N'Creating [dbo].[fnGetMedsIncomingAndMedsToDoctorPageCountByCase]...';


GO
create function [dbo].[fnGetMedsIncomingAndMedsToDoctorPageCountByCase] (@CaseNbr int)
returns table
as
return (
	select sum(u.MedsIncoming) as MedsIncoming, sum(u.MedsToDoctor) as MedsToDoctor
	from (
		select tc.CaseNbr, tc.MasterCaseNbr
			, tc.CaseNbr as JoinedCaseNbr, tcd.CaseNbr as documentCaseNbr
			, 0 as MedsIncoming, isnull(Pages, 0) as MedsToDoctor, tcd.sFilename
			, tcd.MedsIncoming as MedsIncomingBit, tcd.MedsToDoctor as MedsToDoctorBit
			, tcd.SharedDoc
		from tblCase tc
		join tblCaseDocuments tcd on tc.CaseNbr = tcd.CaseNbr
		where tc.CaseNbr = @CaseNbr and MedsToDoctor = 1
		union
		select 	tc.CaseNbr
			, tc.MasterCaseNbr
			, mc.CaseNbr as JoinedCaseNbr, tcd.CaseNbr as documentCaseNbr
			, isnull(Pages, 0) as MedsIncoming, 0 as MedsToDoctor, tcd.sFilename
			, tcd.MedsIncoming as MedsIncomingBit
			, tcd.MedsToDoctor as MedsToDoctorBit
			, tcd.SharedDoc
		from tblCase tc
			join tblCase mc on  tc.CaseNbr = mc.CaseNbr --or tc.MasterCaseNbr = mc.MasterCaseNbr 
			join tblCaseDocuments tcd on mc.CaseNbr = tcd.CaseNbr
		where (tc.CaseNbr = @CaseNbr and MedsIncoming = 1)  and ((mc.CaseNbr <>  @CaseNbr and tcd.SharedDoc = 1) or (mc.CaseNbr = @CaseNbr))	
		union
		select 	tc.CaseNbr
			, tc.MasterCaseNbr
			, mc.CaseNbr as JoinedCaseNbr, tcd.CaseNbr as documentCaseNbr
			, isnull(Pages, 0) as MedsIncoming, 0 as MedsToDoctor, tcd.sFilename
			, tcd.MedsIncoming as MedsIncomingBit
			, tcd.MedsToDoctor as MedsToDoctorBit
			, tcd.SharedDoc
		from tblCase tc
			join tblCase mc on  tc.MasterCaseNbr = mc.MasterCaseNbr 
			join tblCaseDocuments tcd on mc.CaseNbr = tcd.CaseNbr
		where (tc.CaseNbr = @CaseNbr and MedsIncoming = 1)  and ((mc.CaseNbr <>  @CaseNbr and tcd.SharedDoc = 1) or (mc.CaseNbr = @CaseNbr))
	) u
)
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
-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 142
-- IMEC-14425 - No Show Letter template based on number of no show appts for case
     INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
     VALUES (137, 'NoShowTemplateToUse', 'Case', 'Determine No Show Template to use for a case based on the # of no shows', 1, 1107, 0, 'MinNoShowApptCnt', 'MaxNoShowApptCnt', 'NoShowDocument', NULL, NULL, 0, NULL)
     GO

     INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
     VALUES (137, 'PC', 4, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, '1', '1', 'AllState1stNS', NULL, NULL, 0, NULL, 0),
            (137, 'PC', 4, 2, 2, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, 2, NULL, NULL, NULL, NULL, 'AllState2ndNS', NULL, NULL, 0, NULL, 0)
    GO

-- IMEC-14445 - Changes to Implement Liberty QA Questions Feature for Finalize Report
-- Ensure that all tables are empty
	DELETE FROM tblQuestionSet
	GO 
	DELETE FROM tblQuestionSetDetail
	GO
-- New security token
	INSERT INTO tblUserFunction(FunctionCode, FunctionDesc, DateAdded)
		VALUES('CaseQAChecklistOverride', 'Case - QA Questions Override', GETDATE())
	GO


-- IMEC-14553
    DECLARE
	    @BusinessRuleID INT = 197,
	    @Today DATETIME = sysdatetime(),
	    @LibertyID INT = 31,
	    @Zone1 INT = 1250,
	    @Zone2 INT = 1275,
	    @FLCentral INT = 1000,
	    @FLNorth INT = 1100,
	    @FLSouth INT = 1200,
        @LibertyStartDateFLFeeZones date = '2024-10-01'


    -- delete the old data so that this script is idempotent
    DELETE FROM dbo.tblBusinessRule WHERE BusinessRuleID = @BusinessRuleID;
    DELETE FROM dbo.tblBusinessRuleCondition WHERE BusinessRuleID = @BusinessRuleID;

    -- header row
    INSERT INTO dbo.tblBusinessRule
    (BusinessRuleID,Category, [Name], Descrip, IsActive, EventID,
    Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, Param6Desc, 
    BrokenRuleAction, AllowOverride)
    VALUES
    (
	    -- EventID 1016 is CaseDataModified
	    197, 'Case', 'RestrictFeeZoneList', 'Exclude listed fee zones', 1, 1016,
	    'Fee zones to exclude', 'Start date for rule', NULL, NULL, NULL, NULL,
	    0, 0
    );

    -- create the detail rows for both conditions (Liberty and not Liberty)
    INSERT INTO dbo.tblBusinessRuleCondition
    (BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, 
    OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, 
    Param1, Param2, Param3, Param4, Param5, Param6, 
    [skip], ExcludeJurisdiction)
    VALUES
    -- Liberty (exclude North, South, and Central)
    (@BusinessRuleID,'PC',@LibertyID,2,1,@Today,'Admin',
    NULL,NULL,NULL,NULL,
    concat(@FLNorth, ',', @FLSouth, ',', @FLCentral), @LibertyStartDateFLFeeZones, NULL, NULL, NULL, NULL,
    0, null),
    -- Not Liberty (exclude zones 1 and 2)
    (@BusinessRuleID,'SW',-1,2,1,@Today,'Admin',
    NULL,NULL,NULL,NULL,
    concat(@Zone1, ',', @Zone2), NULL, NULL, NULL, NULL, NULL,
    0, NULL);
    GO

-- IMEC-14611 - new bizRule to check on starting date for using Question Set
    INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
    VALUES (138, 'UseQAQuestionSet', 'Case', 'Display QA Question Set when finalizing report', 1, 1310, 0, 'tblSettingStartDate', NULL, NULL, NULL, NULL, 0, NULL)
    GO
    INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6, ExcludeJurisdiction)
    VALUES (138, 'PC', 31, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, 'LibertyGuardrailsStartDate', NULL, NULL, NULL, NULL, 0, NULL, 0)
    GO
    
-- IMEC-14486 - Only use EW Selected or Client Selected When Scheduling Appts - data patch for new collumn Status
UPDATE tblDoctorReason SET [Status] = (CASE WHEN DoctorReasonID IN (1, 4) Then 'Active'  ELSE 'Inactive' END)
GO

-- IMEC-14448 - adding new product "Service Fee > 500 Pages" to tblProduct
SET IDENTITY_INSERT tblProduct ON
  INSERT INTO tblProduct (ProdCode, Description, LongDesc, Status, Taxable, INGLAcct,
      VOGLAcct, DateAdded, UserIDAdded, XferToVoucher, UnitOfMeasureCode, AllowVoNegativeAmount, AllowInvoice, AllowVoucher, IsStandard)
  Values(3030, 'Service Fee>500', 'Service Fee > 500 Pages', 'Active', 1, '400??',
         '500??', GETDATE(), 'Admin', 0, 'PG', 0, 1, 0, 1)
SET IDENTITY_INSERT tblProduct OFF
GO

