PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [AwaitingScheduling] DATETIME NULL;


GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [DASecurityProfileID] INT NULL;


GO
PRINT N'Altering [dbo].[tblEWNetwork]...';


GO
ALTER TABLE [dbo].[tblEWNetwork]
    ADD [IsFeeZoneRequired] BIT CONSTRAINT [DF_tblEWNetwork_IsFeeZoneRequired] DEFAULT (0) NOT NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [EWNetworkID] INT NULL;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[tblIMEData]...';


GO
ALTER TABLE [dbo].[tblIMEData]
    ADD [PrmptForClientChngAssocCases] BIT CONSTRAINT [DF_tblIMEData_PrmptForClientChngAssocCases] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblProduct]...';


GO
ALTER TABLE [dbo].[tblProduct]
    ADD [IsStandard] BIT CONSTRAINT [DF_tblProduct_IsStandard] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblServices]...';


GO
ALTER TABLE [dbo].[tblServices]
    ADD [ProdCode] INT NULL;


GO
PRINT N'Altering [dbo].[tblWebReferral]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD [MedicalRecordStatusDesc] VARCHAR (100) NULL;


GO
PRINT N'Altering [dbo].[tblWebUser]...';


GO
ALTER TABLE [dbo].[tblWebUser]
    ADD [PasswordSalt] VARCHAR (36) CONSTRAINT [DF_tblWebUser_PasswordSalt] DEFAULT (NEWID()) NOT NULL;


GO
PRINT N'Creating [dbo].[tblAcctQuote]...';


GO
CREATE TABLE [dbo].[tblAcctQuote] (
    [AcctQuoteID]          INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]              INT           NOT NULL,
    [QuoteType]            VARCHAR (2)   NOT NULL,
    [DoctorCode]           INT           NULL,
    [EWSpecialtyID]        INT           NULL,
    [QuoteStatusID]        INT           NULL,
    [QuoteDate]            DATETIME      NULL,
    [ProdCode]             INT           NULL,
    [EWNetworkID]          INT           NULL,
    [FeeAmtFrom]           MONEY         NULL,
    [FeeAmtTo]             MONEY         NULL,
    [NoShowAmt]            MONEY         NULL,
    [LateCancelAmt]        MONEY         NULL,
    [CancelDays]           INT           NULL,
    [FeeUnit]              VARCHAR (10)  NULL,
    [ClientFeeBudgetAmt]   MONEY         NULL,
    [Note]                 VARCHAR (500) NULL,
    [OutOfNetworkReasonID] INT           NULL,
    [InformViaEmail]       BIT           NULL,
    [InformViaPhone]       BIT           NULL,
    [InformViaFax]         BIT           NULL,
    [DateClientInformed]   DATETIME      NULL,
    [ApproveViaEmail]      BIT           NULL,
    [ApproveViaPhone]      BIT           NULL,
    [ApproveViaFax]        BIT           NULL,
    [DateClientApproved]   DATETIME      NULL,
    [ApprovedByClientName] VARCHAR (100) NULL,
    [DateAdded]            DATETIME      NOT NULL,
    [UserIDAdded]          VARCHAR (15)  NOT NULL,
    [DateEdited]           DATETIME      NULL,
    [UserIDEdited]         VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblAcctQuote] PRIMARY KEY CLUSTERED ([AcctQuoteID] ASC)
);


GO
PRINT N'Creating [dbo].[tblCustomerFeeDetail]...';


GO
CREATE TABLE [dbo].[tblCustomerFeeDetail] (
    [CustomerFeeDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [CustomerFeeHeaderID] INT          NOT NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    [ProdCode]            INT          NOT NULL,
    [EWBusLineID]         INT          NOT NULL,
    [EWFeeZoneID]         INT          NULL,
    [EWSpecialtyID]       INT          NULL,
    [FeeUnit]             VARCHAR (10) NULL,
    [FeeAmt]              MONEY        NOT NULL,
    [LateCancelAmt]       MONEY        NULL,
    [CancelDays]          INT          NULL,
    [NoShowAmt]           MONEY        NULL,
    CONSTRAINT [PK_tblCustomerFeeDetail] PRIMARY KEY CLUSTERED ([CustomerFeeDetailID] ASC)
);


GO
PRINT N'Creating [dbo].[tblCustomerFeeDetail].[IX_U_tblCustomerFeeDetail_CustomerFeeHeaderIDProdCodeEWBusLineIDEWSpecialtyIDEWFeeZoneID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblCustomerFeeDetail_CustomerFeeHeaderIDProdCodeEWBusLineIDEWSpecialtyIDEWFeeZoneID]
    ON [dbo].[tblCustomerFeeDetail]([CustomerFeeHeaderID] ASC, [ProdCode] ASC, [EWBusLineID] ASC, [EWSpecialtyID] ASC, [EWFeeZoneID] ASC) WHERE ([EWFeeZoneID] IS NOT NULL);


GO
PRINT N'Creating [dbo].[tblCustomerFeeHeader]...';


GO
CREATE TABLE [dbo].[tblCustomerFeeHeader] (
    [CustomerFeeHeaderID] INT          IDENTITY (1, 1) NOT NULL,
    [Name]                VARCHAR (30) NULL,
    [EntityType]          VARCHAR (2)  NULL,
    [EntityID]            INT          NOT NULL,
    [StartDate]           DATETIME     NOT NULL,
    [EndDate]             DATETIME     NULL,
    [UserIDAdded]         VARCHAR (15) NULL,
    [DateAdded]           DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    [DateEdited]          DATETIME     NULL,
    CONSTRAINT [PK_tblCustomerFeeHeader] PRIMARY KEY CLUSTERED ([CustomerFeeHeaderID] ASC)
);


GO
PRINT N'Creating [dbo].[tblEmployerDefDocument]...';


GO
CREATE TABLE [dbo].[tblEmployerDefDocument] (
    [EmployerID]        INT          NOT NULL,
    [DocumentCode]      VARCHAR (15) NOT NULL,
    [DocumentQueue]     INT          NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (20) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (20) NULL,
    [DocumentToReplace] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblEmployerDefDocument] PRIMARY KEY CLUSTERED ([EmployerID] ASC, [DocumentCode] ASC, [DocumentQueue] ASC)
);


GO
PRINT N'Creating [dbo].[tblEmployerDefDocument].[IX_U_tblEmployerDefDocument_EmployerIDDocumentQueueDocumentToReplace]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEmployerDefDocument_EmployerIDDocumentQueueDocumentToReplace]
    ON [dbo].[tblEmployerDefDocument]([EmployerID] ASC, [DocumentQueue] ASC, [DocumentToReplace] ASC) WHERE ([DocumentToReplace] IS NOT NULL);


GO
PRINT N'Creating [dbo].[tblOutOfNetworkReason]...';


GO
CREATE TABLE [dbo].[tblOutOfNetworkReason] (
    [OutOfNetworkReasonID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]          VARCHAR (32) NOT NULL,
    [DateAdded]            DATETIME     NOT NULL,
    [UserIDAdded]          VARCHAR (15) NOT NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblOutOfNetworkReason] PRIMARY KEY CLUSTERED ([OutOfNetworkReasonID] ASC)
);


GO
PRINT N'Creating [dbo].[tblQuoteStatus]...';


GO
CREATE TABLE [dbo].[tblQuoteStatus] (
    [QuoteStatusID] INT          IDENTITY (1, 1) NOT NULL,
    [QuoteType]     VARCHAR (2)  NOT NULL,
    [Description]   VARCHAR (30) NOT NULL,
    [IsClosed]      BIT          NOT NULL,
    [DateAdded]     DATETIME     NOT NULL,
    [UserIDAdded]   VARCHAR (15) NOT NULL,
    [DateEdited]    DATETIME     NULL,
    [UserIDEdited]  VARCHAR (15) NULL,
    CONSTRAINT [PK_tblQuoteStatus] PRIMARY KEY CLUSTERED ([QuoteStatusID] ASC)
);


GO
PRINT N'Creating [dbo].[DF_tblAcctOuote_ApproveViaEmail]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD CONSTRAINT [DF_tblAcctOuote_ApproveViaEmail] DEFAULT ((0)) FOR [ApproveViaEmail];


GO
PRINT N'Creating [dbo].[DF_tblAcctOuote_ApproveViaFax]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD CONSTRAINT [DF_tblAcctOuote_ApproveViaFax] DEFAULT ((0)) FOR [ApproveViaFax];


GO
PRINT N'Creating [dbo].[DF_tblAcctOuote_ApproveViaPhone]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD CONSTRAINT [DF_tblAcctOuote_ApproveViaPhone] DEFAULT ((0)) FOR [ApproveViaPhone];


GO
PRINT N'Creating [dbo].[DF_tblAcctOuote_InformViaEmail]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD CONSTRAINT [DF_tblAcctOuote_InformViaEmail] DEFAULT ((0)) FOR [InformViaEmail];


GO
PRINT N'Creating [dbo].[DF_tblAcctOuote_InformViaFax]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD CONSTRAINT [DF_tblAcctOuote_InformViaFax] DEFAULT ((0)) FOR [InformViaFax];


GO
PRINT N'Creating [dbo].[DF_tblAcctOuote_InformViaPhone]...';


GO
ALTER TABLE [dbo].[tblAcctQuote]
    ADD CONSTRAINT [DF_tblAcctOuote_InformViaPhone] DEFAULT ((0)) FOR [InformViaPhone];


GO
PRINT N'Creating [dbo].[DF_tblCustomerFeeDetail_FeeAmt]...';


GO
ALTER TABLE [dbo].[tblCustomerFeeDetail]
    ADD CONSTRAINT [DF_tblCustomerFeeDetail_FeeAmt] DEFAULT ((0)) FOR [FeeAmt];


GO
PRINT N'Altering [dbo].[vwCaseAppt]...';


GO
ALTER VIEW vwCaseAppt
AS
WITH allDoctors AS (
          SELECT  
               CA.CaseApptID ,
               ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
               CASE WHEN CA.DoctorCode IS NULL THEN
               LTRIM(RTRIM(ISNULL(DP.FirstName,'')+' '+ISNULL(DP.LastName,'')+' '+ISNULL(DP.Credentials,'')))
               ELSE
               LTRIM(RTRIM(ISNULL(D.FirstName,'')+' '+ISNULL(D.LastName,'')+' '+ISNULL(D.Credentials,'')))
               END AS DoctorName,
               CASE WHEN CA.DoctorCode IS NULL THEN
               ISNULL(DP.LastName,'')+ISNULL(', '+DP.FirstName,'')
               ELSE
               ISNULL(D.LastName,'')+ISNULL(', '+D.FirstName,'')
               END AS DoctorNameLF,
               ISNULL(CA.SpecialtyCode, CAP.SpecialtyCode) AS SpecialtyCode
           FROM tblCaseAppt AS CA
           LEFT OUTER JOIN tblDoctor AS D ON CA.DoctorCode=D.DoctorCode
           LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CA.CaseApptID=CAP.CaseApptID
           LEFT OUTER JOIN tblDoctor AS DP ON CAP.DoctorCode=DP.DoctorCode
)
SELECT  DISTINCT
        CA.CaseApptID ,
        CA.CaseNbr ,
        CA.ApptStatusID ,
        S.Name AS ApptStatus,

        CA.ApptTime ,
        CA.LocationCode ,
        L.Location,

        CA.CanceledByID ,
        CB.Name AS CanceledBy ,
        CB.ExtName AS CanceledByExtName ,
        CA.Reason ,
        
        CA.DateAdded ,
        CA.UserIDAdded ,
        CA.DateEdited ,
        CA.UserIDEdited ,
        CA.LastStatusChg ,
        CAST(CASE WHEN CA.DoctorCode IS NULL THEN 1 ELSE 0 END AS BIT) AS IsPanel,
        (STUFF((
        SELECT '\'+ CAST(DoctorCode AS VARCHAR) FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(100)'),1,1,'')) AS DoctorCodes,
        (STUFF((
        SELECT '\'+DoctorName FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS DoctorNames,
        (STUFF((
        SELECT '\'+DoctorNameLF FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS DoctorNamesLF,
        (STUFF((
        SELECT '\'+ SpecialtyCode FROM allDoctors WHERE AllDoctors.CaseApptID=CA.CaseApptID
          FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')) AS Specialties,
          CA.DateReceived, 
          FZ.Name AS FeeZoneName,
		  C.OfficeCode,
		  CA.AwaitingScheduling
     FROM tblCaseAppt AS CA
	 INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
     INNER JOIN tblApptStatus AS S ON CA.ApptStatusID = S.ApptStatusID
     LEFT OUTER JOIN tblCanceledBy AS CB ON CA.CanceledByID=CB.CanceledByID
     LEFT OUTER JOIN tblLocation AS L ON CA.LocationCode=L.LocationCode
     LEFT OUTER JOIN tblEWFeeZone AS FZ ON CA.EWFeeZoneID = FZ.EWFeeZoneID
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
		  ISNULL(PC.RequireInOutNetwork, 0) AS RequireInOutNetwork,
			COM.ParentCompanyID,
			PC.Name As EWParentCompanyName,
			PC.EWNetworkID
    FROM    tblClient AS CL
            INNER JOIN tblCompany AS COM ON CL.companycode = COM.companycode
			LEFT OUTER JOIN tblClientOffice AS CLO ON CLO.ClientCode = CL.ClientCode AND CLO.IsDefault=1
		    INNER JOIN tblEWParentCompany AS PC ON PC.ParentCompanyID = COM.ParentCompanyID
GO
PRINT N'Altering [dbo].[vw_WebCaseSummaryExt]...';


GO
ALTER VIEW vw_WebCaseSummaryExt

AS

SELECT
	--case
	tblCase.casenbr,
	tblCase.ExtCaseNbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	tblCase.dateofinjury2,
	tblCase.dateofinjury3,
	tblCase.dateofinjury4,
	tblCase.notes,
	tblCase.notes AS casenotes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.TransportationRequired,
	tblCase.InterpreterRequired,
	tblCase.LanguageID,
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	tblCase.InsuringCompany,

	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineefullname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.mobilephone,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.Employer  
		ELSE tblEmployer.Name  
		END) AS Employer,  

	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.TreatingPhysicianDiagnosis,

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerAddr1  
		ELSE tblEmployerAddress.Address1 
		END) AS EmployerAddr1,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerCity  
		ELSE tblEmployerAddress.City  
		END) AS EmployerCity,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerState  
		ELSE tblEmployerAddress.State  
		END) AS EmployerState,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerZip  
		ELSE tblEmployerAddress.Zip  
		END) AS EmployerZip,  
			  
	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerPhone  
		ELSE tblEmployerAddress.Phone  
		END) AS EmployerPhone,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerPhoneExt  
		ELSE tblEmployerAddress.PhoneExt 
		END) AS EmployerPhoneExt,  

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerFax  
		ELSE tblEmployerAddress.Fax  
		END) AS EmployerFax,  
            
	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerEmail  
		ELSE tblEmployerAddress.Email  
		END) AS EmployerEmail,  

	tblExaminee.Country,
	tblExaminee.policynumber,

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerContactFirstName  
		ELSE tblEmployerAddress.ContactFirst  
		END) AS EmployerContactFirstName,  
            
	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerContactLastName  
		ELSE tblEmployerAddress.ContactLast  
		END) AS EmployerContactLastName,  

	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,
	tblExaminee.note AS StateDirected,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.description AS casetypedescription,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,
	tblClient.lastname + ', ' + tblClient.FirstName AS clientfullname,
	tblClient.phone1 AS ClientPhone,
	tblClient.email AS ClientEmail,
	tblClient.fax AS ClientFax,
	tblClient.notes AS ClientOffice,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix,

	--company
	tblCompany.extname AS InsCompanyName,
	tblCompany.addr1 AS InsCompanyAddress1,
	tblCompany.addr2 AS InsCompanyAddress2,
	tblCompany.city AS InsCompanyCity,
	tblCompany.state AS InsCompanyState,
	tblCompany.zip AS InsCompanyZip,

	--case manager
	tblRelatedParty.firstname AS CaseManagerFirstName,
	tblRelatedParty.lastname AS CaseManagerLastName,
	tblRelatedParty.address1 AS CaseManagerAddress1,
	tblRelatedParty.address2 AS CaseManagerAddress2,
	tblRelatedParty.city AS CaseManagerCity,
	tblRelatedParty.state AS CaseManagerState,
	tblRelatedParty.zip as CaseManagerZip,
	tblRelatedParty.companyname AS CaseManagerOffice,
	tblRelatedParty.phone as CaseManagerPhone,
	tblRelatedParty.fax as CaseManagerFax,
	tblRelatedParty.email as CaseManagerEmail,

	--language
	tblLanguage.Description as LanguageDescription

FROM tblCase
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	LEFT OUTER  JOIN tblLanguage ON tblCase.LanguageID = tblLanguage.LanguageID
	LEFT OUTER JOIN tblCaseRelatedParty ON tblCase.casenbr = tblCaseRelatedParty.casenbr
	LEFT OUTER JOIN tblRelatedParty ON tblCaseRelatedParty.RPCode = tblRelatedParty.RPCode
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
    LEFT OUTER JOIN tblEmployer on tblcase.EmployerID = tblEmployer.EmployerID 
    LEFT OUTER JOIN tblEmployerAddress on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID
GO
PRINT N'Altering [dbo].[vwServiceWorkflow]...';


GO
ALTER VIEW [dbo].[vwServiceWorkflow]
AS
    SELECT
        WF.ServiceWorkflowID,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.UserIDAdded,
        WF.DateAdded,
        WF.UserIDEdited,
        WF.DateEdited,
        WF.ExamineeAddrReqd,
        WF.ExamineeSSNReqd,
        WF.AttorneyReqd,
        WF.DOIRqd,
        WF.ClaimNbrRqd,
        WF.JurisdictionRqd,
        WF.EmployerRqd,
        WF.TreatingPhysicianRqd,
        WF.CalcFrom,
        WF.DaysToForecastDate,
        WF.DaysToInternalDueDate,
        WF.DaysToExternalDueDate,
		WF.DaysToDoctorRptDueDate,
        WFQ.QueueCount,
        CT.Description AS CaseTypeDesc,
        CT.Status AS CaseTypeStatus,
        S.Description AS ServiceDesc,
        S.Status AS ServiceStatus,
        S.ApptBased,
        S.ShowLegalTabOnCase,
        O.Description AS OfficeDesc,
        O.Status AS OfficeStatus,
		WF.UsePeerBill,
		S.ProdCode, 
		CT.EWBusLineID
    FROM
        tblServiceWorkflow AS WF
    INNER JOIN tblCaseType AS CT ON WF.CaseType=CT.Code
    INNER JOIN tblServices AS S ON S.ServiceCode=WF.ServiceCode
    INNER JOIN tblOffice AS O ON O.OfficeCode=WF.OfficeCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowID,
                        COUNT(ServiceWorkflowQueueID) AS QueueCount
                     FROM
                        tblServiceWorkflowQueue
                     GROUP BY
                        ServiceWorkflowID
                    ) AS WFQ ON WFQ.ServiceWorkflowID=WF.ServiceWorkflowID
GO
PRINT N'Creating [dbo].[vwQuoteApproval]...';


GO
CREATE VIEW [dbo].[vwQuoteApproval]
AS
SELECT AQ.AcctQuoteID,
       AQ.CaseNbr,
       AQ.QuoteType,
       C.ExtCaseNbr,
       C.ClaimNbr,
       CO.IntName AS CompanyName,
       ISNULL(CL.FirstName, '') + ' ' + ISNULL(CL.LastName, '') AS ClientName,
       ISNULL(EE.FirstName, '') + ' ' + ISNULL(EE.LastName, '') AS ExamineeName,
       ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       CT.ShortDesc AS CaseTypeDesc,
       S.ShortDesc AS ServiceDesc,
       C.ApptDate,
       QS.Description AS QuoteStatus,
       DATEDIFF(DAY, AQ.QuoteDate, GETDATE()) AS DaysOutstanding,
       QS.IsClosed,
       C.DoctorLocation,
       C.ClientCode,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
       C.Status,
       C.DoctorCode,
       C.DateAdded,
       CL.CompanyCode,
       C.OfficeCode,
       C.CaseType,
       C.ServiceCode,
       ISNULL(BCO.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID
 FROM tblAcctQuote AS AQ
 INNER JOIN tblQuoteStatus AS QS ON QS.QuoteStatusID = AQ.QuoteStatusID
 INNER JOIN tblCase AS C ON C.CaseNbr = AQ.CaseNbr
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = AQ.DoctorCode
 WHERE QS.IsClosed=0
GO
PRINT N'Creating [dbo].[proc_CustomerData_Insert]...';


GO
CREATE PROCEDURE [proc_CustomerData_Insert]
(
	@CustomerDataID int = NULL output,
	@Version int = NULL,
	@TableType varchar(64) = NULL,
	@TableKey int = NULL,
	@Param varchar(max) = NULL,
	@CustomerName varchar(64) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCustomerData]
	(
		[Version],
		[TableType],
		[TableKey],
		[Param],
		[CustomerName]
	)
	VALUES
	(
		@Version,
		@TableType,
		@TableKey,
		@Param,
		@CustomerName
	)

	SET @Err = @@Error

	SELECT @CustomerDataID = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_CustomerData_LoadByTableKey]...';


GO
CREATE PROCEDURE [proc_CustomerData_LoadByTableKey]
(
	@TableKey int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCustomerData]
	WHERE
		([TableKey] = @TableKey)

	SET @Err = @@Error

	RETURN @Err
END
GO






INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@ReportRecommendation@','') 
Go  

UPDATE tblCase
   SET EWFeeZoneID = FZ.EWFeeZoneID
  FROM tblCase 
		INNER JOIN tblEWFeeZone AS FZ ON FZ.StateCode = tblCase.Jurisdiction AND FZ.Status = 'Active'
WHERE tblCase.Status NOT IN (8,9)
AND tblCase.EWFeeZoneID IS NULL 
AND tblCase.Jurisdiction IN (SELECT StateCode 
						FROM tblEWFeeZone 
						WHERE Status = 'Active' 
						GROUP BY StateCode 
						HAVING COUNT(StateCode) = 1 )

GO

INSERT INTO tblUserFunction 
VALUES('AddFeeSchedNetwork', 'Fee Schedule (Network) - Add', CURRENT_TIMESTAMP),
	  ('EditFeeSchedNetwork', 'Fee Schedule (Network) - Edit', CURRENT_TIMESTAMP)
GO


insert into tblOutOfNetworkReason (Description,DateAdded,UserIDAdded) Values ('Specific Doctor Request',GETDATE(),'Admin')
insert into tblOutOfNetworkReason (Description,DateAdded,UserIDAdded) Values ('Location/Date Request',GETDATE(),'Admin')
insert into tblOutOfNetworkReason (Description,DateAdded,UserIDAdded) Values ('Specialty Not on Fee Sched',GETDATE(),'Admin')
insert into tblOutOfNetworkReason (Description,DateAdded,UserIDAdded) Values ('Extensive Meds/Films',GETDATE(),'Admin')
insert into tblOutOfNetworkReason (Description,DateAdded,UserIDAdded) Values ('Doctor Canx/NS Fee',GETDATE(),'Admin')


insert into tblQuoteStatus (QuoteType, Description,DateAdded,UserIDAdded, IsClosed) Values ('VO','Awaiting Quote',GETDATE(),'Admin',0) 
insert into tblQuoteStatus (QuoteType, Description,DateAdded,UserIDAdded, IsClosed) Values ('VO','Quote Received',GETDATE(),'Admin',1) 
insert into tblQuoteStatus (QuoteType, Description,DateAdded,UserIDAdded, IsClosed) Values ('VO','Cancelled',GETDATE(),'Admin',1) 
insert into tblQuoteStatus (QuoteType, Description,DateAdded,UserIDAdded, IsClosed) Values ('IN','Awaiting Approval',GETDATE(),'Admin',0) 
insert into tblQuoteStatus (QuoteType, Description,DateAdded,UserIDAdded, IsClosed) Values ('IN','Approved',GETDATE(),'Admin',1) 
insert into tblQuoteStatus (QuoteType, Description,DateAdded,UserIDAdded, IsClosed) Values ('IN','No Approval Needed',GETDATE(),'Admin',1) 
insert into tblQuoteStatus (QuoteType, Description,DateAdded,UserIDAdded, IsClosed) Values ('IN','Cancelled',GETDATE(),'Admin',1)

GO


insert into tblUserFunction (FunctionCode, FunctionDesc, DateAdded) Values('ReOpenQuote', 'Accounting - ReOpen Quote', getdate())
GO
insert into tblGroupFunction (GroupCode,FunctionCode) Values('8-CorpAdmin','ReOpenQuote')
GO 

UPDATE tblControl SET DASecurityProfileID = 6 WHERE DASecurityProfileID IS NULL
GO





UPDATE tblProduct SET IsStandard=0

UPDATE U SET U.IsStandard=1
 FROM tblProduct AS U
INNER JOIN
(
SELECT P.Description, P.ProdCode, COUNT(AD.DetailID) AS CntAD,
 ROW_NUMBER() OVER (PARTITION BY P.Description ORDER BY COUNT(AD.DetailID) DESC, P.ProdCode) AS RowNbr
 FROM tblProduct AS P
LEFT OUTER JOIN tblAcctDetail AS AD ON AD.ProdCode = P.ProdCode AND YEAR(AD.DateAdded)=2018
GROUP BY P.Description, P.ProdCode
) AS tmp ON tmp.ProdCode = U.ProdCode
WHERE tmp.RowNbr=1
GO


UPDATE S SET S.ProdCode=P.ProdCode
 FROM tblServices AS S
 LEFT OUTER JOIN tblProduct AS P ON S.Description=P.Description AND P.IsStandard=1
GO




UPDATE CA SET CA.AwaitingScheduling=C.AwaitingScheduling
 FROM tblCase AS C
 INNER JOIN tblCaseAppt AS CA ON CA.CaseApptID = C.CaseApptID
 WHERE CA.AwaitingScheduling IS NULL


UPDATE tblCaseAppt SET AwaitingScheduling=DateReceived
 WHERE AwaitingScheduling IS NULL
GO


UPDATE tblControl SET DBVersion='3.36'
GO