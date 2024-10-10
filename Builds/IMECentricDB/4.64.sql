
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
    ADD [MedsIncoming] BIT CONSTRAINT [DF_tblcasedocuments_MedsIncoming] DEFAULT (0) NULL,
        [MedsToDoctor] BIT CONSTRAINT [DF_tblcasedocuments_MedsToDoctor] DEFAULT (0) NULL;


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
PRINT N'Starting rebuilding table [dbo].[tblEWCoverLetter]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWCoverLetter] (
    [EWCoverLetterID]               INT           IDENTITY (1, 1) NOT NULL,
    [Description]                   VARCHAR (140) NULL,
    [ExternalName]                  VARCHAR (140) NULL,
    [Active]                        BIT           NOT NULL,
    [TemplateFilename]              VARCHAR (255) NULL,
    [EnableAdditionalQuestionsSect] BIT           NOT NULL,
    [IncludeClaimsHistorySect]      BIT           NOT NULL,
    [IncludeMedicalRecordsSect]     BIT           NOT NULL,
    [AllowSelReqCompanyName]        BIT           NOT NULL,
    [UserIDAdded]                   VARCHAR (30)  NULL,
    [DateAdded]                     DATETIME      NULL,
    [UserIDEdited]                  VARCHAR (30)  NULL,
    [DateEdited]                    DATETIME      NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWCoverLetter1] PRIMARY KEY CLUSTERED ([EWCoverLetterID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWCoverLetter])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetter] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tblEWCoverLetter] ([EWCoverLetterID], [Description], [ExternalName], [Active], [TemplateFilename], [EnableAdditionalQuestionsSect], [IncludeClaimsHistorySect], [IncludeMedicalRecordsSect], [AllowSelReqCompanyName], [UserIDAdded], [DateAdded], [UserIDEdited], [DateEdited])
        SELECT   [EWCoverLetterID],
                 [Description],
                 [ExternalName],
                 [Active],
                 [TemplateFilename],
                 [EnableAdditionalQuestionsSect],
                 [IncludeClaimsHistorySect],
                 [IncludeMedicalRecordsSect],
                 [AllowSelReqCompanyName],
                 [UserIDAdded],
                 [DateAdded],
                 [UserIDEdited],
                 [DateEdited]
        FROM     [dbo].[tblEWCoverLetter]
        ORDER BY [EWCoverLetterID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetter] OFF;
    END

DROP TABLE [dbo].[tblEWCoverLetter];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWCoverLetter]', N'tblEWCoverLetter';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWCoverLetter1]', N'PK_tblEWCoverLetter', N'OBJECT';

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
PRINT N'Starting rebuilding table [dbo].[tblEWCoverLetterBusLine]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWCoverLetterBusLine] (
    [EWCoverLetterBusLineID] INT          IDENTITY (1, 1) NOT NULL,
    [EWCoverLetterID]        INT          NOT NULL,
    [EWBusLineID]            INT          NOT NULL,
    [UserIDAdded]            VARCHAR (30) NULL,
    [DateAdded]              DATETIME     NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWCoverLetterBusLine1] PRIMARY KEY CLUSTERED ([EWCoverLetterBusLineID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWCoverLetterBusLine])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterBusLine] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tblEWCoverLetterBusLine] ([EWCoverLetterBusLineID], [EWCoverLetterID], [EWBusLineID], [UserIDAdded], [DateAdded])
        SELECT   [EWCoverLetterBusLineID],
                 [EWCoverLetterID],
                 [EWBusLineID],
                 [UserIDAdded],
                 [DateAdded]
        FROM     [dbo].[tblEWCoverLetterBusLine]
        ORDER BY [EWCoverLetterBusLineID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterBusLine] OFF;
    END

DROP TABLE [dbo].[tblEWCoverLetterBusLine];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWCoverLetterBusLine]', N'tblEWCoverLetterBusLine';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWCoverLetterBusLine1]', N'PK_tblEWCoverLetterBusLine', N'OBJECT';

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
PRINT N'Creating [dbo].[tblEWCoverLetterBusLine].[IX_U_tblEWCoverLetterBusLine_EWCoverLetterIDEWBusLineID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWCoverLetterBusLine_EWCoverLetterIDEWBusLineID]
    ON [dbo].[tblEWCoverLetterBusLine]([EWCoverLetterID] ASC, [EWBusLineID] ASC);


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
PRINT N'Starting rebuilding table [dbo].[tblEWCoverLetterClientSpecData]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWCoverLetterClientSpecData] (
    [EWCoverLetterClientSpecDataID] INT           IDENTITY (1, 1) NOT NULL,
    [EWCoverLetterID]               INT           NOT NULL,
    [SpecifiedData]                 VARCHAR (500) NULL,
    [Required]                      BIT           NOT NULL,
    [UserIDAdded]                   VARCHAR (30)  NULL,
    [DateAdded]                     DATETIME      NULL,
    [UserIDEdited]                  VARCHAR (30)  NULL,
    [DateEdited]                    DATETIME      NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWCoverLetterClientSpecData1] PRIMARY KEY CLUSTERED ([EWCoverLetterClientSpecDataID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWCoverLetterClientSpecData])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterClientSpecData] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tblEWCoverLetterClientSpecData] ([EWCoverLetterClientSpecDataID], [EWCoverLetterID], [SpecifiedData], [Required], [UserIDAdded], [DateAdded], [UserIDEdited], [DateEdited])
        SELECT   [EWCoverLetterClientSpecDataID],
                 [EWCoverLetterID],
                 [SpecifiedData],
                 [Required],
                 [UserIDAdded],
                 [DateAdded],
                 [UserIDEdited],
                 [DateEdited]
        FROM     [dbo].[tblEWCoverLetterClientSpecData]
        ORDER BY [EWCoverLetterClientSpecDataID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterClientSpecData] OFF;
    END

DROP TABLE [dbo].[tblEWCoverLetterClientSpecData];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWCoverLetterClientSpecData]', N'tblEWCoverLetterClientSpecData';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWCoverLetterClientSpecData1]', N'PK_tblEWCoverLetterClientSpecData', N'OBJECT';

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
PRINT N'Starting rebuilding table [dbo].[tblEWCoverLetterCompanyName]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWCoverLetterCompanyName] (
    [EWCoverLetterCompanyNameID] INT          IDENTITY (1, 1) NOT NULL,
    [EWCoverLetterID]            INT          NOT NULL,
    [CompanyName]                VARCHAR (80) NULL,
    [UserIDAdded]                VARCHAR (30) NULL,
    [DateAdded]                  DATETIME     NULL,
    [UserIDEdited]               VARCHAR (30) NULL,
    [DateEdited]                 DATETIME     NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWCoverLetterCompanyName1] PRIMARY KEY CLUSTERED ([EWCoverLetterCompanyNameID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWCoverLetterCompanyName])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterCompanyName] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tblEWCoverLetterCompanyName] ([EWCoverLetterCompanyNameID], [EWCoverLetterID], [CompanyName], [UserIDAdded], [DateAdded], [UserIDEdited], [DateEdited])
        SELECT   [EWCoverLetterCompanyNameID],
                 [EWCoverLetterID],
                 [CompanyName],
                 [UserIDAdded],
                 [DateAdded],
                 [UserIDEdited],
                 [DateEdited]
        FROM     [dbo].[tblEWCoverLetterCompanyName]
        ORDER BY [EWCoverLetterCompanyNameID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterCompanyName] OFF;
    END

DROP TABLE [dbo].[tblEWCoverLetterCompanyName];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWCoverLetterCompanyName]', N'tblEWCoverLetterCompanyName';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWCoverLetterCompanyName1]', N'PK_tblEWCoverLetterCompanyName', N'OBJECT';

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
PRINT N'Starting rebuilding table [dbo].[tblEWCoverLetterQuestion]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWCoverLetterQuestion] (
    [EWCoverLetterQuestionID] INT            IDENTITY (1, 1) NOT NULL,
    [EWCoverLetterID]         INT            NOT NULL,
    [QuestionText]            VARCHAR (1500) NULL,
    [Required]                BIT            NOT NULL,
    [DefaultChecked]          BIT            NOT NULL,
    [UserIDAdded]             VARCHAR (30)   NULL,
    [DateAdded]               DATETIME       NULL,
    [UserIDEdited]            VARCHAR (30)   NULL,
    [DateEdited]              DATETIME       NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWCoverLetterQuestion1] PRIMARY KEY CLUSTERED ([EWCoverLetterQuestionID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWCoverLetterQuestion])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterQuestion] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tblEWCoverLetterQuestion] ([EWCoverLetterQuestionID], [EWCoverLetterID], [QuestionText], [Required], [DefaultChecked], [UserIDAdded], [DateAdded], [UserIDEdited], [DateEdited])
        SELECT   [EWCoverLetterQuestionID],
                 [EWCoverLetterID],
                 [QuestionText],
                 [Required],
                 [DefaultChecked],
                 [UserIDAdded],
                 [DateAdded],
                 [UserIDEdited],
                 [DateEdited]
        FROM     [dbo].[tblEWCoverLetterQuestion]
        ORDER BY [EWCoverLetterQuestionID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterQuestion] OFF;
    END

DROP TABLE [dbo].[tblEWCoverLetterQuestion];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWCoverLetterQuestion]', N'tblEWCoverLetterQuestion';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWCoverLetterQuestion1]', N'PK_tblEWCoverLetterQuestion', N'OBJECT';

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
PRINT N'Starting rebuilding table [dbo].[tblEWCoverLetterState]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tblEWCoverLetterState] (
    [EWCoverLetterStateID] INT          IDENTITY (1, 1) NOT NULL,
    [EWCoverLetterID]      INT          NOT NULL,
    [StateCode]            VARCHAR (2)  NOT NULL,
    [UserIDAdded]          VARCHAR (30) NOT NULL,
    [DateAdded]            DATETIME     NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_tblEWCoverLetterState1] PRIMARY KEY CLUSTERED ([EWCoverLetterStateID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tblEWCoverLetterState])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterState] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tblEWCoverLetterState] ([EWCoverLetterStateID], [EWCoverLetterID], [StateCode], [UserIDAdded], [DateAdded])
        SELECT   [EWCoverLetterStateID],
                 [EWCoverLetterID],
                 [StateCode],
                 [UserIDAdded],
                 [DateAdded]
        FROM     [dbo].[tblEWCoverLetterState]
        ORDER BY [EWCoverLetterStateID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tblEWCoverLetterState] OFF;
    END

DROP TABLE [dbo].[tblEWCoverLetterState];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tblEWCoverLetterState]', N'tblEWCoverLetterState';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_tblEWCoverLetterState1]', N'PK_tblEWCoverLetterState', N'OBJECT';

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
PRINT N'Creating [dbo].[tblEWCoverLetterState].[IX_U_tblEWCoverLetterState_EWCoverLetterIDStateCode]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWCoverLetterState_EWCoverLetterIDStateCode]
    ON [dbo].[tblEWCoverLetterState]([EWCoverLetterID] ASC, [StateCode] ASC);


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
PRINT N'Altering [dbo].[tblTask]...';


GO
ALTER TABLE [dbo].[tblTask]
    ADD [Text9] VARCHAR (4096) NULL,
        [Bit1]  BIT            NULL;


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
PRINT N'Altering [dbo].[vwCCs]...';


GO
ALTER VIEW vwCCs
AS
    SELECT  ccCode ,
            COALESCE(Company, LastName + ', ' + FirstName, LastName, FirstName) AS CompanyOrderDisplayName ,
            COALESCE(LastName + ', ' + FirstName, LastName, FirstName) AS Contact ,
            COALESCE(LastName + ', ' + FirstName, LastName, FirstName, Company) AS ContactOrderDisplayName ,
            Company ,
            City ,
            State ,
            Status,
			Email,
			Phone,
			Fax,
            Address1 + ' ' + City + ', ' + State + ' ' + zip AS Address
    FROM    tblCCAddress
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
PRINT N'Creating [dbo].[pr_MedsToDoctor]...';


GO
-- =============================================
-- Author:		Doug Leveille
-- Create date: 2024-09-03
-- Description:	This stored procedure will generate a list of cases to publish med records to the portal for doctors

-- DML 09/26/2024 Added CaseType of Third Party (20) and Workers Comp (140)


-- =============================================
CREATE PROCEDURE [dbo].[pr_MedsToDoctor] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#Temp_Cases') IS NOT NULL DROP TABLE #Temp_Cases
	--use IMECentricEW

	select
	c.Casenbr,
	o.description as Office,
	co.intname as Company,
	ct.description as CaseType,
	s.description as Service,
	q.statusdesc as Queue,
	d.FirstName,
	d.LastName,
	c.ApptDate,
		-- if doctor has days in advance to receive med recs on doctor profile, use that, otherwise use 10 calendar days
	case when d.DrMedRecsInDays > 0 then  getdate() + d.DrMedRecsInDays else getdate() + 10 end as SelectDate

	into #temp_cases
	from tblCase c with (nolock)
	inner join tblCaseAppt ca with (nolock) on ca.CaseApptID = c.CaseApptID
	inner join tbldoctor d with (nolock) on d.doctorcode = ca.doctorcode
	inner join tblWebUser wu with (nolock) on wu.IMECentricCode = d.doctorcode and wu.UserType = 'DR' and wu.StatusID = 1 --Active
	inner join tbloffice o with (nolock) on o.officecode = c.officecode
	inner join tblcasetype ct with (nolock) on ct.code = c.casetype
	inner join tblservices s with (nolock) on s.servicecode = c.servicecode
	inner join tblqueues q with (nolock) on q.statuscode = c.status
	inner join tblclient cl with (nolock) on cl.clientcode = c.clientcode
	inner join tblcompany co with (nolock) on co.companycode = cl.companycode
	where
		c.OfficeCode in (26,28)  and -- Uniondale, Woodbury
		c.CaseType in (10,20,140) and -- First Party, Third Party, Workers Comp
		c.Status = 1130 and -- Meds To Doctor
		c.servicecode in (2070,4121,3290) -- Independent Medical Evaluation, Medical Examination, Re-Evaluation 

	select --top 10
	CaseNbr,
	Company,
	Office,
	CaseType,
	Service, 
	Queue,
	FirstName,
	LastName,
	convert(varchar,ApptDate,101) as ApptDate
	from #temp_cases T
	where 
		t.apptdate < t.SelectDate
	order by t.ApptDate

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
-- --------------------------------------------------------------------------
--	Scripts placed in here are applied against ALL IMECentric systems 
--	both US and CA
-- --------------------------------------------------------------------------

-- Sprint 140

-- IMEC 14380 - Data patch - sets bits to 0 so checkboxes are blank and then patch the data

-- Original Update
-- UPDATE tblCaseDocuments SET MedsIncoming = 0, MedsToDoctor = 0
-- UPDATE tblCaseDocuments SET MedsIncoming = 1 WHERE CaseDocTypeID = 7 AND UserIDAdded LIKE '%@%'

DECLARE @startId AS int
DECLARE @segment AS int
DECLARE @maxSeqNo AS int

set @startId = (select min(SeqNo) from [tblCaseDocuments]
       where MedsIncoming is null
              or MedsToDoctor is null);
set @segment = 4000;
set @maxSeqNo = (select max(SeqNo) from [tblCaseDocuments]);
set @startId = isnull(@startId, @maxSeqNo);

print(concat('starting row: ', @startId, '. Last row: ', @maxSeqNo, '.'))
while 1 = 1
begin
	while 1 = 1
	begin
		print(concat('starting row: ', @startId, '. Limit row: ', @startId + @segment, ' Last row: ', @maxSeqNo, '.'))
		IF @startId >= @maxSeqNo BREAK
		UPDATE [tblCaseDocuments]
		SET -- top to a lower value for locking
			MedsIncoming = (case when CaseDocTypeID = 7 AND UserIDAdded LIKE '%@%' then 1 else 0 end),
			MedsToDoctor = 0
		where
			SeqNo >= @startId
			and SeqNo <= (@startId + @segment)

		set @startId = iif(
			(@startId + @segment) > @maxSeqNo,
				@maxSeqNo,
				@startId + @segment
		)
	END
	set @maxSeqNo = (select max(SeqNo) from [tblCaseDocuments])
	print(concat('Finished Inital Upate... checking for new rows. Old limit: ', @startId, '. New limit: ', @maxSeqNo, '.'))
	IF @maxSeqNo = @startId BREAK
END

-- IMEC-14281 - new business rules and BR conditions for Progressive Albany Plaintiff Attorney emails using external email source
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (172, 'DistDocsExtEmailSys', 'Case', 'Distribute docs from an external email system instead of users email', 0, 1202, 0, 'tblDoc.DocumentName', 'Email From Address', 'Email To Entity', 'Process Name', 0)
GO

INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, BrokenRuleAction)
VALUES (173, 'GenDocsExtEmailSys', 'Case', 'Generate docs from an external email system instead of users email', 0, 1201, 0, 'tblDoc.Document', 'Email From Address', 'Email To Entity', 'Process Name', 0)
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('CO', 76626, 2, 1, 172, GETDATE(), 'Admin', 'WBPROGAPT*', 'DoNotReply@ExamWorks.com', 'PA', 'DistDocsExtEmailSys_ProgAlbany')
GO

INSERT INTO tblBusinessRuleCondition (EntityType, EntityID, BillingEntity, ProcessOrder, BusinessRuleID, DateAdded, UserIDAdded, Param1, Param2, Param3, Param4)
VALUES ('CO', 76626, 2, 1, 173, GETDATE(), 'Admin', 'WBPROGAPT*', 'DoNotReply@ExamWorks.com', 'PA', 'DistDocsExtEmailSys_ProgAlbany')
GO

-- IMEC-14381 - create new tblSetting to determine which CaseDocType items to apply for MedsIncoming
INSERT INTO tblSetting(Name, Value)
VALUES('CaseDocTypeMedsIncoming_True', ';7;21;')
GO

-- IMEC-14383 - new tblSetting to determine which CaseDocType items to apply for MedsToDoctor
INSERT INTO tblSetting(Name, Value)
VALUES('CaseDocTypeMedsToDoctor_True', ';7;21;')
GO


-- IMEC-14417 - Re-work Attorney Add/Edit Security Tokens to use individual tokens instead a single AddEdit token
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('AttorneyAdd', 'Attorney - Add', GetDate()), 
      ('AttorneyEdit', 'Attorney - Edit', GetDate())
GO
INSERT INTO tblGroupFunction (GroupCode, FunctionCode)
     SELECT GroupCode, 'AttorneyAdd'
       FROM tblGroupFunction 
      WHERE FunctionCode = 'AttorneyAddEdit'
GO
INSERT INTO tblGroupFunction (GroupCode, FunctionCode)
     SELECT GroupCode, 'AttorneyEdit'
       FROM tblGroupFunction 
      WHERE FunctionCode = 'AttorneyAddEdit'
GO
DELETE FROM tblGroupFunction WHERE FunctionCode = 'AttorneyAddEdit'
GO
DELETE FROM tblUserFunction WHERE FunctionCode = 'AttorneyAddEdit'
GO

-- IMEC-14433 (IMEC-14301) - new business rule that allows us to force MedsIncoming = False when working in the Document Workspace folder.
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, Param2Desc, Param3Desc, Param4Desc, Param5Desc, BrokenRuleAction, Param6Desc)
VALUES (136, 'FileMgrFolderRule', 'Case', 'Specify rule for a folder when using File Manager', 1, 1015, 0, 'FolderID', 'NameOfValueToSet', 'Value', NULL, NULL, 0, NULL)
GO
INSERT INTO tblBusinessRuleCondition(BusinessRuleID, EntityType, EntityID, BillingEntity, ProcessOrder, DateAdded, UserIDAdded, DateEdited, UserIDEdited, OfficeCode, EWBusLineID, EWServiceTypeID, Jurisdiction, Param1, Param2, Param3, Param4, Param5, Skip, Param6)
VALUES (136, 'SW', NULL, 2, 1, GETDATE(), 'Admin', GETDATE(), 'Admin', NULL, NULL, NULL, NULL, '99', 'MedsIncoming', 'False', NULL, NULL, 0, NULL)
GO
