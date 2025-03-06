PRINT N'Altering [dbo].[tblQueues]...';


GO
ALTER TABLE [dbo].[tblQueues]
    ADD [WebStatusCodeV2] INT NULL;


GO
PRINT N'Creating [dbo].[tblWebQueuesV2]...';


GO
CREATE TABLE [dbo].[tblWebQueuesV2] (
    [StatusCode]   INT          IDENTITY (1, 1) NOT NULL,
    [Description]  VARCHAR (50) NULL,
    [displayorder] INT          NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblWebQueuesV2] PRIMARY KEY CLUSTERED ([StatusCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblWebReferralForm]...';


GO
CREATE TABLE [dbo].[tblWebReferralForm] (
    [WebReferralFormID] INT          IDENTITY (1, 1) NOT NULL,
    [FormKey]           VARCHAR (50) NOT NULL,
    [Decription]        VARCHAR (50) NOT NULL,
    [UseQuestionEngine] BIT          NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (15) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (15) NULL,
    CONSTRAINT [PK_tblWebReferralForms] PRIMARY KEY CLUSTERED ([WebReferralFormID] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[tblWebReferralFormProblem]...';


GO
CREATE TABLE [dbo].[tblWebReferralFormProblem] (
    [WebReferralFormProblemID] INT IDENTITY (1, 1) NOT NULL,
    [WebReferalFormID]         INT NOT NULL,
    [ProblemCode]              INT NULL,
    CONSTRAINT [PK_tblWebReferralFormProblem] PRIMARY KEY CLUSTERED ([WebReferralFormProblemID] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[tblWebReferralFormRule]...';


GO
CREATE TABLE [dbo].[tblWebReferralFormRule] (
    [ProcessOrder]      INT         NULL,
    [CaseType]          INT         NULL,
    [Jurisdiction]      VARCHAR (2) NULL,
    [ParentCompanyID]   INT         NULL,
    [CompanyCode]       INT         NULL,
    [EWServiceTypeID]   INT         NULL,
    [ServiceCode]       INT         NULL,
    [WebReferralFormID] INT         NULL
) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[tblWebReferralFormSpecialty]...';


GO
CREATE TABLE [dbo].[tblWebReferralFormSpecialty] (
    [WebReferralFormSpecialtyID] INT IDENTITY (1, 1) NOT NULL,
    [WebReferralFormID]          INT NOT NULL,
    [EWSpecialtyID]              INT NULL,
    CONSTRAINT [PK_tblWebReferralFormSpecialty] PRIMARY KEY CLUSTERED ([WebReferralFormSpecialtyID] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'Altering [dbo].[proc_GetIssueComboItems]...';


GO
ALTER PROCEDURE [proc_GetIssueComboItems]

@WebCompanyId int

AS

IF @WebCompanyId = 46
	BEGIN
		SELECT issuecode,description from tblIssue WHERE PublishOnWeb = 1 AND Status = 'Active' ORDER BY description
	END
ELSE
	BEGIN
		SELECT issuecode,description from tblIssue WHERE PublishOnWeb = 1 AND IssueCode NOT IN (12, 39, 40, 41) AND Status = 'Active' ORDER BY description
	END
GO
PRINT N'Creating [dbo].[proc_GetPublishOnWebRecordsByCaseNbr]...';


GO

CREATE PROCEDURE [proc_GetPublishOnWebRecordsByCaseNbr]

@CaseNbr int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	select tblDoctor.CompanyName as 'UserType', publishid, tblPublishOnWeb.PublishOnWeb, firstname, lastname, tableKey AS CaseNbr, DoctorCode as UserCode from tblPublishOnWeb
	inner join tblDoctor on tblPublishOnWeb.UserCode = tblDoctor.DoctorCode and tblPublishOnWeb.UserType = 'OP' and tblPublishOnWeb.PublishOnWeb = 1
	where tablekey = @CaseNbr and tabletype = 'tblCase'
	union
	select tblDoctor.CompanyName as 'UserType', publishid, tblPublishOnWeb.PublishOnWeb, firstname, lastname, tableKey AS CaseNbr, DoctorCode as UserCode from tblPublishOnWeb
	inner join tblDoctor on tblPublishOnWeb.UserCode = tblDoctor.DoctorCode and tblPublishOnWeb.UserType = 'DR' and tblPublishOnWeb.PublishOnWeb = 1
	where tablekey = @CaseNbr and tabletype = 'tblCase'

	ORDER BY LastName, Firstname

	SET @Err = @@Error

	RETURN @Err
END
GO

insert into tblUserFunction 
values
('WebReferralFormEngine', 'Web - Referral Form Engine', '2017-08-30'),
('WebReferralFormMaint', 'Web - Referral Form Maintenance', '2017-08-30')

Go

INSERT INTO tblWebQueuesV2
VALUES
('AW Schedule', 100, Null, Null, Null, Null),
('Scheduled', 200, Null, Null, Null, Null),
('In QA', 300, Null, Null, Null, Null),
('Completed', 400, Null, Null, Null, Null),
('Canceled', 500, Null, Null, Null, Null)



GO


IF OBJECT_ID('vwGPARInvoice', 'V') IS NOT NULL
  DROP VIEW dbo.vwGPARInvoice
GO

DECLARE @countryID INT
DECLARE @sql NVARCHAR(1000)
SELECT @countryID=CountryID FROM tblControl

IF @countryID=1
	SET @sql=N'
	CREATE VIEW dbo.vwGPARInvoice
	AS
	SELECT InvoiceNbr,
		   InvoiceDate,
		   ParentGPCustomerID,
		   GPCustomerID,
		   OriginalAmount,
		   OpenAmount,
		   DaysPastDue,
		   DueDate,
		   CaseNbr,
		   ExamineeName,
		   ClaimNbr,
		   TaxAmount,
		   ClientID,
		   ClientName
	FROM [GPSQLSERVER2.DOMAIN.LOCAL].EW.dbo.IMEC_Receivables
	'
ELSE
	SET @sql=N'
	CREATE VIEW dbo.vwGPARInvoice
	AS
	SELECT InvoiceNbr,
		   InvoiceDate,
		   ParentGPCustomerID,
		   GPCustomerID,
		   OriginalAmount,
		   OpenAmount,
		   DaysPastDue,
		   DueDate,
		   CaseNbr,
		   ExamineeName,
		   ClaimNbr,
		   TaxAmount,
		   ClientID,
		   ClientName
	FROM [GPSQLSERVER2.DOMAIN.LOCAL].EWCD.dbo.IMEC_Receivables
	'
PRINT @sql
EXEC sp_executesql @sql
GO




UPDATE tblControl SET DBVersion='3.16'
GO
