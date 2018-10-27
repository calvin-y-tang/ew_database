PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [TATEnteredToScheduled]      INT NULL,
        [TATEnteredToMRRReceived]    INT NULL,
        [TATScheduledToExam]         INT NULL,
        [TATExamToClientNotify]      INT NULL,
        [TATExamToRepReceived]       INT NULL,
        [TATRepReceivedToQAComplete] INT NULL,
        [TATQACompleteToRepSent]     INT NULL,
        [TATRepSentToInvoiced]       INT NULL,
        [TATReport]                  INT NULL,
        [TATServiceLifeCycle]        INT NULL,
        [ConfirmExamineePhone]       BIT CONSTRAINT [DF_tblCase_ConfirmExamineePhone] DEFAULT ((1)) NOT NULL,
        [ConfirmExamineeText]        BIT CONSTRAINT [DF_tblCase_ConfirmExamineeText] DEFAULT ((1)) NOT NULL,
        [ConfirmAttorneyPhone]       BIT CONSTRAINT [DF_tblCase_ConfirmAttorneyPhone] DEFAULT ((1)) NOT NULL,
        [EmployerID]                 INT NULL;


GO
PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [ApptConfirmed]           BIT CONSTRAINT [DF_tblCaseAppt_ApptConfirmed] DEFAULT 0 NOT NULL,
        [ConfirmAttemptsExaminee] INT NULL,
        [ConfirmAttemptsAttorney] INT NULL;


GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [CompanyNameStandard]      INT NULL,
        [NextConfirmationBatchNbr] INT NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [RequireInOutNetwork] INT NULL;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [ReferralNotifyEmail]   VARCHAR (200) NULL,
        [FileUploadNotifyEmail] VARCHAR (200) NULL,
        [UseConfirmation]       BIT           CONSTRAINT [DF_tblOffice_UseConfirmation] DEFAULT ((0)) NULL;


GO
PRINT N'Creating [dbo].[tblConfirmationList]...';


GO
CREATE TABLE [dbo].[tblConfirmationList] (
    [ConfirmationListID]       INT          IDENTITY (1, 1) NOT NULL,
    [CaseApptID]               INT          NOT NULL,
    [ConfirmationRuleDetailID] INT          NOT NULL,
    [ConfirmationStatusID]     INT          NOT NULL,
    [StartDate]                DATETIME     NOT NULL,
    [Selected]                 BIT          NOT NULL,
    [ContactType]              VARCHAR (20) NOT NULL,
    [Phone]                    VARCHAR (15) NOT NULL,
    [ContactMethod]            VARCHAR (10) NOT NULL,
    [BatchNbr]                 INT          NOT NULL,
    [AttemptNbr]               INT          NOT NULL,
    [DateAdded]                DATETIME     NULL,
    [UserIDAdded]              VARCHAR (15) NULL,
    [DateEdited]               DATETIME     NULL,
    [UserIDEdited]             VARCHAR (15) NULL,
    CONSTRAINT [PK_tblConfirmationList] PRIMARY KEY CLUSTERED ([ConfirmationListID] ASC)
);


GO
PRINT N'Creating [dbo].[tblConfirmationList].[IX_tblConfirmationList_BatchNbrConfirmationStatusID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblConfirmationList_BatchNbrConfirmationStatusID]
    ON [dbo].[tblConfirmationList]([BatchNbr] ASC, [ConfirmationStatusID] ASC);


GO
PRINT N'Creating [dbo].[tblConfirmationList].[IX_tblConfirmationList_StartDateConfirmationStatusID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblConfirmationList_StartDateConfirmationStatusID]
    ON [dbo].[tblConfirmationList]([StartDate] ASC, [ConfirmationStatusID] ASC);


GO
PRINT N'Creating [dbo].[tblConfirmationMessage]...';


GO
CREATE TABLE [dbo].[tblConfirmationMessage] (
    [ConfirmationMessageID] INT           IDENTITY (1, 1) NOT NULL,
    [ExtMessageID]          INT           NOT NULL,
    [Description]           VARCHAR (250) NULL,
    [DateAdded]             DATETIME      NULL,
    [UserIDAdded]           VARCHAR (15)  NULL,
    [DateEdited]            DATETIME      NULL,
    [UserIDEdited]          VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblConfirmationMessage] PRIMARY KEY CLUSTERED ([ConfirmationMessageID] ASC)
);


GO
PRINT N'Creating [dbo].[tblConfirmationRule]...';


GO
CREATE TABLE [dbo].[tblConfirmationRule] (
    [ConfirmationRuleID] INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]       INT          NULL,
    [OfficeCode]         INT          NULL,
    [CaseType]           INT          NULL,
    [ServiceCode]        INT          NULL,
    [Jurisdiction]       VARCHAR (2)  NULL,
    [EmployerID]         INT          NULL,
    [CompanyCode]        INT          NULL,
    [ClientCode]         INT          NULL,
    [DateAdded]          DATETIME     NULL,
    [UserIDAdded]        VARCHAR (15) NULL,
    [DateEdited]         DATETIME     NULL,
    [UserIDEdited]       VARCHAR (15) NULL,
    CONSTRAINT [PK_tblConfirmationRule] PRIMARY KEY CLUSTERED ([ConfirmationRuleID] ASC)
);


GO
PRINT N'Creating [dbo].[tblConfirmationRuleDetail]...';


GO
CREATE TABLE [dbo].[tblConfirmationRuleDetail] (
    [ConfirmationRuleDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [ConfirmationRuleID]       INT          NOT NULL,
    [ContactType]              VARCHAR (20) NOT NULL,
    [ContactMethod]            VARCHAR (10) NOT NULL,
    [DaysPrior]                INT          NOT NULL,
    [RuleType]                 VARCHAR (50) NOT NULL,
    [ConfirmationMessageID]    INT          NOT NULL,
    [SkipIfConfirmed]          BIT          NOT NULL,
    [CallRetries]              VARCHAR (15) NOT NULL,
    [SuccessfulAction]         VARCHAR (20) NOT NULL,
    [UnsuccessfulAction]       VARCHAR (20) NOT NULL,
    [DateAdded]                DATETIME     NULL,
    [UserIDAdded]              VARCHAR (15) NULL,
    [DateEdited]               DATETIME     NULL,
    [UserIDEdited]             VARCHAR (15) NULL,
    CONSTRAINT [PK_tblConfirmationRuleDetail] PRIMARY KEY CLUSTERED ([ConfirmationRuleDetailID] ASC)
);


GO
PRINT N'Creating [dbo].[tblEmployer]...';


GO
CREATE TABLE [dbo].[tblEmployer] (
    [EmployerID]   INT          IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (70) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (15) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblEmployer] PRIMARY KEY CLUSTERED ([EmployerID] ASC)
);


GO
PRINT N'Creating [dbo].[tblWebNotification]...';


GO
CREATE TABLE [dbo].[tblWebNotification] (
    [WebNotificationID]    INT           IDENTITY (1, 1) NOT NULL,
    [NotificationType]     VARCHAR (30)  NULL,
    [EntityID]             INT           NULL,
    [EntityType]           VARCHAR (50)  NULL,
    [IMECentricCode]       INT           NULL,
    [UserType]             CHAR (2)      NULL,
    [WebUserID]            INT           NULL,
    [WebUserCompanyName]   VARCHAR (100) NULL,
    [WebUserFirstName]     VARCHAR (50)  NULL,
    [WebUserLastName]      VARCHAR (50)  NULL,
    [WebUserEmailAddress]  VARCHAR (200) NULL,
    [ToEmailAddress]       VARCHAR (200) NULL,
    [FromEmailAddress]     VARCHAR (200) NULL,
    [NotificationSubject]  VARCHAR (100) NULL,
    [NotificationDetail]   VARCHAR (MAX) NULL,
    [ErrorMessage]         VARCHAR (500) NULL,
    [DateAdded]            SMALLDATETIME NULL,
    [UserIdAdded]          VARCHAR (100) NULL,
    [NotificationSent]     BIT           NULL,
    [NotificationSentDate] SMALLDATETIME NULL,
    CONSTRAINT [PK_tblWebNotification] PRIMARY KEY CLUSTERED ([WebNotificationID] ASC)
);


GO
PRINT N'Creating [dbo].[DF_tblConfirmationList_Selected]...';


GO
ALTER TABLE [dbo].[tblConfirmationList]
    ADD CONSTRAINT [DF_tblConfirmationList_Selected] DEFAULT 1 FOR [Selected];


GO
PRINT N'Creating [dbo].[DF_tblConfirmationRuleDetail_SkipIfConfirmed]...';


GO
ALTER TABLE [dbo].[tblConfirmationRuleDetail]
    ADD CONSTRAINT [DF_tblConfirmationRuleDetail_SkipIfConfirmed] DEFAULT 0 FOR [SkipIfConfirmed];


GO
PRINT N'Creating [dbo].[fnGetTATDays]...';


GO
CREATE FUNCTION [dbo].[fnGetTATDays]
(
	@dStartDate DATE, 
	@dEndDate DATE	
)
RETURNS INT
AS 
BEGIN
	DECLARE @iDays INT = 0
	SET @iDays = 
			-- total number of days between specified dates
			-- (DATEDIFF(dd, @dStartDate, @dEndDate) + 1) -->>> we don't want to count the start date as a day
			(DATEDIFF(dd, @dStartDate, @dEndDate)) 
			-
			-- decrease count by the number of weekend days; number of weekends is done by
			-- by counting weeks and then doubling it to get count of weekend days
			(DATEDIFF(wk, @dStartDate, @dEndDate) * 2) 
			-
			-- decrease count when our start date is Sunday
			(CASE WHEN DATENAME(dw, @dStartDate) = 'Sunday'  
				 THEN 1
				 ELSE 0 
			END)
			-
			-- decrease count when our end date is Saturday
			(CASE WHEN DATENAME(dw, @dEndDate) = 'Saturday' 
				 THEN 1
				 ELSE 0 
			END)
			- 
			-- decrease count by any days set as "Non-Working"
			(SELECT COUNT(NonWorkDay)
			   FROM tblNonWorkDays
			  WHERE NonWorkDay >= @dStartDate AND NonWorkDay <= @dEndDate
			) 


	RETURN IIF(@iDays IS NULL OR @iDays < 0, 0, @iDays)
END
GO
PRINT N'Altering [dbo].[vwClientDefaults]...';


GO
ALTER VIEW vwClientDefaults
AS
    SELECT  CL.marketercode AS ClientMarketer ,
            COM.IntName ,
		  ISNULL(COM.EWCompanyID, 0) AS EWCompanyID, 
            CL.ReportPhone ,
            CL.Priority ,
            CL.ClientCode ,
            CL.fax ,
            CL.email ,
            CL.phone1 ,
            CL.documentemail AS EmailClient ,
            CL.documentfax AS FaxClient ,
            CL.documentmail AS MailClient ,
            ISNULL(CL.casetype, COM.CaseType) AS CaseType ,
            CL.feeschedule ,
            COM.credithold ,
            COM.preinvoice ,
            CL.billaddr1 ,
            CL.billaddr2 ,
            CL.billcity ,
            CL.billstate ,
            CL.billzip ,
            CL.billattn ,
            CL.ARKey ,
            CL.addr1 ,
            CL.addr2 ,
            CL.city ,
            CL.state ,
            CL.zip ,
            CL.firstname + ' ' + CL.lastname AS clientname ,
            CL.prefix AS clientprefix ,
            CL.suffix AS clientsuffix ,
            CL.lastname ,
            CL.firstname ,
            CL.billfax ,
            CL.QARep ,
            ISNULL(CL.photoRqd, COM.photoRqd) AS photoRqd ,
            CL.CertifiedMail ,
            CL.PublishOnWeb ,
            CL.UseNotificationOverrides ,
            CL.CSR1 ,
            CL.CSR2 ,
            CL.AutoReschedule ,
            CLO.OfficeCode AS DefOfficeCode ,
            ISNULL(CL.marketercode, COM.marketercode) AS marketer ,
            COM.Jurisdiction ,
		  CL.CreateCvrLtr|COM.CreateCvrLtr As CreateCvrLtr, 
		  ISNULL(PC.RequireInOutNetwork, 0) AS RequireInOutNetwork
    FROM    tblClient AS CL
            INNER JOIN tblCompany AS COM ON CL.companycode = COM.companycode
			LEFT OUTER JOIN tblClientOffice AS CLO ON CLO.ClientCode = CL.ClientCode AND CLO.IsDefault=1
		  INNER JOIN tblEWParentCompany AS PC ON PC.ParentCompanyID = COM.ParentCompanyID
GO
PRINT N'Creating [dbo].[proc_BackFillData_TATDaysCalculation]...';


GO
CREATE PROCEDURE [dbo].[proc_BackFillData_TATDaysCalculation]
	@dStartDate DATETIME
AS
BEGIN
	-- check for and correct for a NULL Starting Date value
	IF @dStartDate IS NULL 
	BEGIN
		-- it's null grab the earliest value and use that (will update all case data)
		SET @dStartDate = (SELECT MIN(DateAdded) FROM tblCase WHERE DateAdded IS NOT NULL)
	END;
	
	-- perform TAT data calculation
	WITH CaseApptCTE AS
	(
		SELECT 
			tblCase.CaseNbr, 
			(SELECT TOP 1 DateAdded FROM tblCaseAppt Where CaseNbr = tblCase.CaseNbr ORDER BY CaseApptID DESC) As SchedDate, 
			(SELECT TOP 1 LastStatusChg FROM tblCaseAppt Where CaseNbr = tblCase.CaseNbr AND ApptStatusID IN (100, 101) ORDER BY CaseApptID DESC) AS ClientNotifyDate
		FROM tblCase
				left outer join tblCaseAppt oN tblCaseAppt.CaseNbr = tblCase.CaseNbr
		WHERE tblCase.DateAdded >= @dStartDate
	)
	UPDATE tblCase
	   SET TATEnteredToScheduled      = dbo.fnGetTATDays(DateReceived, SchedDate), 
		  TATEnteredToMRRReceived    = dbo.fnGetTATDays(DateReceived, DateMedsRecd),
		  TATScheduledToExam         = dbo.fnGetTATDays(SchedDate, ApptDate), 
		  TATExamToClientNotify      = dbo.fnGetTATDays(ApptDate, ClientNotifyDate), 
		  TATExamToRepReceived       = dbo.fnGetTATDays(ApptDate, RptInitialDraftDate), 
		  TATRepReceivedToQAComplete = dbo.fnGetTATDays(RptInitialDraftDate, RptFinalizedDate), 
		  TATQACompleteToRepSent     = dbo.fnGetTATDays(RptFinalizedDate, RptSentDate),
		  TATRepSentToInvoiced       = dbo.fnGetTATDays(RptSentDate, InvoiceDate), 
		  TATReport                  = dbo.fnGetTATDays(ApptDate, RptSentDate), 
		  TATServiceLifeCycle        = dbo.fnGetTATDays(DateReceived, RptSentDate)
	  FROM tblCase
			LEFT OUTER JOIN CaseApptCTE ON CaseApptCTE.CaseNbr = tblCase.CaseNbr
	 WHERE DateAdded >= @dStartDate
END
GO
PRINT N'Creating [dbo].[proc_TATDaysCalculation]...';


GO
CREATE PROCEDURE [dbo].[proc_TATDaysCalculation]
	@iCaseNbr INT
AS
BEGIN
	DECLARE @dSchedDate DATETIME
	DECLARE @dClientNotifyDate DATETIME
	
	SET @dSchedDate = (SELECT TOP 1 DateAdded FROM tblCaseAppt WHERE CaseNbr = @iCaseNbr ORDER BY CaseApptID DESC)
	SET @dClientNotifyDate = (SELECT TOP 1 LastStatusChg FROM tblCaseAppt WHERE CaseNbr = @iCaseNbr AND ApptStatusID IN (100, 101) ORDER BY CaseApptID DESC)
	
	UPDATE tblCase
	   SET TATEnteredToScheduled      = dbo.fnGetTATDays(DateReceived, @dSchedDate), 
		  TATEnteredToMRRReceived    = dbo.fnGetTATDays(DateReceived, DateMedsRecd),
		  TATScheduledToExam         = dbo.fnGetTATDays(@dSchedDate, ApptDate), 
		  TATExamToClientNotify      = dbo.fnGetTATDays(ApptDate, @dClientNotifyDate), 
		  TATExamToRepReceived       = dbo.fnGetTATDays(ApptDate, RptInitialDraftDate), 
		  TATRepReceivedToQAComplete = dbo.fnGetTATDays(RptInitialDraftDate, RptFinalizedDate), 
		  TATQACompleteToRepSent     = dbo.fnGetTATDays(RptFinalizedDate, RptSentDate),
		  TATRepSentToInvoiced       = dbo.fnGetTATDays(RptSentDate, InvoiceDate), 
		  TATReport                  = dbo.fnGetTATDays(ApptDate, RptSentDate), 
		  TATServiceLifeCycle        = dbo.fnGetTATDays(DateReceived, RptSentDate)
	 WHERE CaseNbr = @iCaseNbr

END
GO
PRINT N'Creating [dbo].[proc_WebNotification_Insert]...';


GO
CREATE PROCEDURE [proc_WebNotification_Insert]
(
	@WebNotificationID int = NULL output,
	@NotificationType varchar(30),
	@EntityId int = NULL,
	@EntityType varchar(50) = NULL,
	@ImeCentricCode int = NULL,
	@UserType char(2) = NULL,
	@WebUserId int = NULL,
	@WebUserCompanyName varchar(100) = NULL,
	@WebUserFirstName varchar(50) = NULL,
	@WebUserLastName varchar(50) = NULL,
	@WebUserEmailAddress varchar(200) = NULL,
	@ToEmailAddress varchar(200) = NULL,
	@FromEmailAddress varchar(200) = NULL,
	@NotificationSubject varchar(100) = NULL,
	@NotificationDetail varchar(MAX) = NULL,
	@ErrorMessage varchar(500) = NULL,
	@DateAdded smalldatetime = NULL,
	@UserIDAdded varchar(100) = NULL,
	@NotificationSent bit = NULL,
	@NotificationSentDate smalldatetime = NULL
)

AS

BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblWebNotification]
	(
		[NotificationType],
		[EntityId],
		[EntityType],
		[ImeCentricCode],
		[UserType],
		[WebUserId],
		[WebUserCompanyName],
		[WebUserFirstName],
		[WebUserLastName],
		[WebUserEmailAddress],
		[ToEmailAddress],
		[FromEmailAddress],
		[NotificationSubject],
		[NotificationDetail],
		[ErrorMessage],
		[DateAdded],
		[UserIDAdded],
		[NotificationSent],
		[NotificationSentDate]
	)
	VALUES
	(
		@NotificationType,
		@EntityId,
		@EntityType,
		@ImeCentricCode,
		@UserType,
		@WebUserId,
		@WebUserCompanyName,
		@WebUserFirstName,
		@WebUserLastName,
		@WebUserEmailAddress,
		@ToEmailAddress,
		@FromEmailAddress,
		@NotificationSubject,
		@NotificationDetail,
		@ErrorMessage,
		@DateAdded,
		@UserIDAdded,
		@NotificationSent,
		@NotificationSentDate
	)

	SET @Err = @@Error

	SELECT @WebNotificationID = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_WebNotification_LoadByPrimaryKey]...';


GO
CREATE PROCEDURE [proc_WebNotification_LoadByPrimaryKey]
(
	@WebNotificationID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblWebNotification]
	WHERE
		([WebNotificationID] = @WebNotificationID)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_WebNotification_Update]...';


GO
CREATE PROCEDURE [proc_WebNotification_Update]
(
	@WebNotificationID int,
	@NotificationType varchar(30),
	@EntityId int = NULL,
	@EntityType varchar(50) = NULL,
	@ImeCentricCode int = NULL,
	@UserType char(2) = NULL,
	@WebUserId int = NULL,
	@WebUserCompanyName varchar(100) = NULL,
	@WebUserFirstName varchar(50) = NULL,
	@WebUserLastName varchar(50) = NULL,
	@WebUserEmailAddress varchar(200) = NULL,
	@ToEmailAddress varchar(200) = NULL,
	@FromEmailAddress varchar(200) = NULL,
	@NotificationSubject varchar(100) = NULL,
	@NotificationDetail varchar(MAX) = NULL,
	@ErrorMessage varchar(500) = NULL,
	@DateAdded smalldatetime = NULL,
	@UserIDAdded varchar(100) = NULL,
	@NotificationSent bit = NULL,
	@NotificationSentDate smalldatetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblWebNotification]
	SET
		[NotificationType] = @NotificationType,
		[EntityId] = @EntityId,
		[EntityType] = @EntityType,
		[ImeCentricCode] = @ImeCentricCode,
		[UserType] = @UserType,
		[WebUserId] = @WebUserId,
		[WebUserCompanyName] = @WebUserCompanyName,
		[WebUserFirstName] = @WebUserFirstName,
		[WebUserLastName] = @WebUserLastName,
		[WebUserEmailAddress] = @WebUserEmailAddress,
		[ToEmailAddress] = @ToEmailAddress,
		[FromEmailAddress] = @FromEmailAddress,
		[NotificationSubject] = @NotificationSubject,
		[NotificationDetail] = @NotificationDetail,
		[ErrorMessage] = @ErrorMessage,
		[DateAdded] = @DateAdded,
		[UserIDAdded] = @UserIDAdded,
		[NotificationSent] = @NotificationSent,
		[NotificationSentDate] = @NotificationSentDate
	WHERE
		[WebNotificationID] = @WebNotificationID

	SET @Err = @@Error

	RETURN @Err
END
GO





INSERT INTO tblUserFunction VALUES ('ConfirmationSetup','Confirmation - Setup Rules')
INSERT INTO tblUserFunction VALUES ('ConfirmationGenerate','Confirmation - Generate List')
INSERT INTO tblUserFunction VALUES ('ConfirmationSend','Confirmation - Send List')
GO
INSERT INTO tblUserFunction VALUES ('CompanyAddEditName', 'Company - Add or Edit Name')
GO
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc) VALUES ('MergeClient', 'Client - Merge')
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc) VALUES ('MergeCompany', 'Company - Merge')
GO




Insert into tblCodes 
(Category, SubCategory, Value)
Values
('LibertyMutual','LibertyMarket','Commercial Insurance'),
('LibertyMutual','LibertyMarket','Personal'),
('LibertyMutual','LibertyMarket','America First'),
('LibertyMutual','LibertyMarket','Colorado Casualty'),
('LibertyMutual','LibertyMarket','Golden Eagle'),
('LibertyMutual','LibertyMarket','Indiana Insurance'),
('LibertyMutual','LibertyMarket','Liberty Northwest'),
('LibertyMutual','LibertyMarket','Montgomery Insurance'),
('LibertyMutual','LibertyMarket','Ohio Casualty'),
('LibertyMutual','LibertyMarket','Peerless'),
('LibertyMutual','LibertyMarket','Safeco')
GO



UPDATE tblCaseHistory SET [Type] = 'ACCT' WHERE [Type] = 'Invoice'
GO
update tblControl set CompanyNameStandard = 1
Go



EXEC proc_BackFillData_TATDaysCalculation '2015-1-1'
GO



UPDATE tblControl SET DBVersion='2.99'
GO
