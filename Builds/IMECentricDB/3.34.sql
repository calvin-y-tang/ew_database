PRINT N'Altering [dbo].[tblCaseProblem]...';


GO
ALTER TABLE [dbo].[tblCaseProblem]
    ADD [ProblemAreaCode] INT NULL;


GO
PRINT N'Altering [dbo].[tblCaseSLARuleDetail]...';


GO
ALTER TABLE [dbo].[tblCaseSLARuleDetail]
    ADD [UserIDAdded]  VARCHAR (15) NULL,
        [DateEdited]   DATETIME     NULL,
        [UserIDEdited] VARCHAR (15) NULL;


GO
PRINT N'Altering [dbo].[tblPublishOnWeb]...';


GO
ALTER TABLE [dbo].[tblPublishOnWeb]
    ADD [CaseNbr] INT NULL;


GO
PRINT N'Altering [dbo].[tblTempData]...';


GO
ALTER TABLE [dbo].[tblTempData]
    ADD [IntValue3]      INT           NULL,
        [DateTimeValue1] DATETIME      NULL,
        [VarCharValue2]  VARCHAR (100) NULL;


GO
PRINT N'Creating [dbo].[tblCaseEnvelope]...';


GO
CREATE TABLE [dbo].[tblCaseEnvelope] (
    [CaseEnvelopeID]     INT          IDENTITY (1, 1) NOT NULL,
    [CaseNbr]            INT          NOT NULL,
    [EnvelopeID]         VARCHAR (32) NOT NULL,
    [AddressedToEntity]  VARCHAR (2)  NOT NULL,
    [EntityID]           INT          NOT NULL,
    [IsCertifiedMail]    BIT          NOT NULL,
    [CertifiedMailNbr]   VARCHAR (32) NULL,
    [DateAdded]          DATETIME     NOT NULL,
    [UserIDAdded]        VARCHAR (15) NOT NULL,
    [DateImported]       DATETIME     NULL,
    [DateAcknowledged]   DATETIME     NULL,
    [UserIDAcknowledged] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCaseEnvelope] PRIMARY KEY CLUSTERED ([CaseEnvelopeID] ASC)
);


GO
PRINT N'Creating [dbo].[tblCompanyCertifiedMail]...';


GO
CREATE TABLE [dbo].[tblCompanyCertifiedMail] (
    [CompanyCertifiedMailID] INT          IDENTITY (1, 1) NOT NULL,
    [CompanyCode]            INT          NOT NULL,
    [CaseTypeCode]           INT          NOT NULL,
    [CertMailActivityID]     INT          NOT NULL,
    [DateAdded]              DATETIME     NULL,
    [UserIDAdded]            VARCHAR (15) NULL,
    [DateEdited]             DATETIME     NULL,
    [UserIDEdited]           VARCHAR (15) NULL,
    CONSTRAINT [PK_tblCompanyCertifiedMail] PRIMARY KEY CLUSTERED ([CompanyCertifiedMailID] ASC)
);


GO
PRINT N'Creating [dbo].[tblCompanyCertifiedMail].[IX_U_tblCompanyCertifiedMail_CompanyCodeCaseTypeCodeCertMailActionID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblCompanyCertifiedMail_CompanyCodeCaseTypeCodeCertMailActionID]
    ON [dbo].[tblCompanyCertifiedMail]([CompanyCode] ASC, [CaseTypeCode] ASC, [CertMailActivityID] ASC);


GO
PRINT N'Creating [dbo].[tblProblemArea]...';


GO
CREATE TABLE [dbo].[tblProblemArea] (
    [ProblemAreaCode] INT          IDENTITY (1, 1) NOT NULL,
    [Description]     VARCHAR (50) NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (15) NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (15) NULL,
    PRIMARY KEY CLUSTERED ([ProblemAreaCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblProblemDetail]...';


GO
CREATE TABLE [dbo].[tblProblemDetail] (
    [ProblemAreaCode] INT          NOT NULL,
    [ProblemCode]     INT          NOT NULL,
    [DateAdded]       DATETIME     NULL,
    [UserIDAdded]     VARCHAR (15) NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (15) NULL,
    PRIMARY KEY CLUSTERED ([ProblemCode] ASC, [ProblemAreaCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblWebMobileUser]...';


GO
CREATE TABLE [dbo].[tblWebMobileUser] (
    [WebMobileUserID] INT            IDENTITY (1, 1) NOT NULL,
    [UserID]          VARCHAR (50)   NOT NULL,
    [WebUserID]       INT            NOT NULL,
    [MobileTokenID]   NVARCHAR (MAX) NOT NULL,
    [DeviceType]      VARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_tblMobileUser] PRIMARY KEY CLUSTERED ([WebMobileUserID] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'Altering [dbo].[vwCaseProblem]...';


GO
ALTER VIEW vwCaseProblem
AS
	SELECT        dbo.tblCaseProblem.CaseNbr, dbo.tblCaseProblem.ProblemCode, 
	dbo.tblProblem.Description, ISNULL(dbo.tblProblemArea.Description, '') AS AreaDesc
	FROM            dbo.tblCaseProblem 
	INNER JOIN dbo.tblProblem ON dbo.tblCaseProblem.ProblemCode = dbo.tblProblem.ProblemCode 
	LEFT OUTER JOIN  dbo.tblProblemArea ON dbo.tblCaseProblem.ProblemAreaCode = dbo.tblProblemArea.ProblemAreaCode
GO
PRINT N'Altering [dbo].[vwDocument]...';


GO
ALTER VIEW vwDocument
AS
    SELECT  tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblCase.ClaimNbr ,

            tblApptStatus.Name AS ApptStatus ,

            tblCase.ApptDate ,
            tblCase.Appttime ,
            tblCase.CaseApptID ,
            tblCase.ApptStatusID ,

            tblCase.DoctorCode ,
            tblCase.DoctorLocation ,

			tblcase.EmployerID ,
			tblcase.EmployerAddressID ,

            tblExaminee.City AS ExamineeCity ,
            tblExaminee.State AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + tblExaminee.State + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
			tblExaminee.WorkPhone AS ExamineeWorkPhone,
            tblExaminee.sex ,
            tblExaminee.DOB ,
            tblExaminee.county AS Examineecounty ,
            tblExaminee.Prefix AS ExamineePrefix ,

            tblExaminee.USDvarchar1 AS ExamineeUSDvarchar1 ,
            tblExaminee.USDvarchar2 AS ExamineeUSDvarchar2 ,
            tblExaminee.USDDate1 AS ExamineeUSDDate1 ,
            tblExaminee.USDDate2 AS ExamineeUSDDate2 ,
            tblExaminee.USDtext1 AS ExamineeUSDtext1 ,
            tblExaminee.USDtext2 AS ExamineeUSDtext2 ,
            tblExaminee.USDint1 AS ExamineeUSDint1 ,
            tblExaminee.USDint2 AS ExamineeUSDint2 ,
            tblExaminee.USDmoney1 AS ExamineeUSDmoney1 ,
            tblExaminee.USDmoney2 AS ExamineeUSDmoney2 ,

            tblExaminee.note AS ChartNotes ,
            tblExaminee.Fax AS ExamineeFax ,
            tblExaminee.Email AS ExamineeEmail ,
            tblExaminee.insured AS Examineeinsured ,
            tblExaminee.middleinitial AS Examineemiddleinitial ,
            tblExaminee.InsuredAddr1 ,
            tblExaminee.InsuredCity ,
            tblExaminee.InsuredState ,
            tblExaminee.InsuredZip ,
            tblExaminee.InsuredSex ,
            tblExaminee.InsuredRelationship ,
            tblExaminee.InsuredPhone ,
            tblExaminee.InsuredPhoneExt ,
            tblExaminee.InsuredFax ,
            tblExaminee.InsuredEmail ,
            tblExaminee.ExamineeStatus ,

            tblExaminee.TreatingPhysician ,
            tblExaminee.TreatingPhysicianAddr1 ,
            tblExaminee.TreatingPhysicianCity ,
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,
			tblExaminee.TreatingPhysicianNPINbr,

			(Case ISNULL(tblcase.EmployerID, 0)
              WHEN 0
              THEN tblExaminee.Employer  
			  ELSE tblEmployer.Name  
			  END) AS Employer,  

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
            
			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerContactLastName  
			  ELSE tblEmployerAddress.ContactLast  
			  END) AS EmployerContactLastName,  
            
			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerContactFirstName  
			  ELSE tblEmployerAddress.ContactFirst  
			  END) AS EmployerContactFirstName,  

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + tblClient.State + '  ' + tblClient.Zip AS ClientCityStateZip ,
            tblClient.Fax AS ClientFax ,
            tblClient.Email AS ClientEmail ,
            'Dear ' + tblClient.firstName + ' ' + tblClient.lastName AS ClientSalutation ,
            tblClient.title AS Clienttitle ,
            tblClient.Prefix AS ClientPrefix ,
            tblClient.suffix AS Clientsuffix ,
            tblClient.USDvarchar1 AS ClientUSDvarchar1 ,
            tblClient.USDvarchar2 AS ClientUSDvarchar2 ,
            tblClient.USDDate1 AS ClientUSDDate1 ,
            tblClient.USDDate2 AS ClientUSDDate2 ,
            tblClient.USDtext1 AS ClientUSDtext1 ,
            tblClient.USDtext2 AS ClientUSDtext2 ,
            tblClient.USDint1 AS ClientUSDint1 ,
            tblClient.USDint2 AS ClientUSDint2 ,
            tblClient.USDmoney1 AS ClientUSDmoney1 ,
            tblClient.USDmoney2 AS ClientUSDmoney2 ,
            tblClient.CompanyCode ,
            tblClient.Notes AS ClientNotes ,
            tblClient.BillAddr1 ,
            tblClient.BillAddr2 ,
            tblClient.BillCity ,
            tblClient.BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            tblClient.State AS ClientState ,
            tblClient.City AS ClientCity ,
            tblClient.Zip AS ClientZip ,

            tblCompany.extName AS Company ,
            tblCompany.USDvarchar1 AS CompanyUSDvarchar1 ,
            tblCompany.USDvarchar2 AS CompanyUSDvarchar2 ,
            tblCompany.USDDate1 AS CompanyUSDDate1 ,
            tblCompany.USDDate2 AS CompanyUSDDate2 ,
            tblCompany.USDtext1 AS CompanyUSDtext1 ,
            tblCompany.USDtext2 AS CompanyUSDtext2 ,
            tblCompany.USDint1 AS CompanyUSDint1 ,
            tblCompany.USDint2 AS CompanyUSDint2 ,
            tblCompany.USDmoney1 AS CompanyUSDmoney1 ,
            tblCompany.USDmoney2 AS CompanyUSDmoney2 ,
            tblCompany.Notes AS CompanyNotes ,

            tblCase.QARep ,
            tblCase.Doctorspecialty ,
            tblCase.BillClientCode AS CaseBillClientCode ,
            tblCase.officeCode ,
            tblCase.PanelNbr ,

            ISNULL(tblUser.lastName, '')
            + Case WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.firstName, '') AS scheduler ,

            tblCase.marketerCode AS Marketer ,
            tblCase.Dateadded AS DateCalledIn ,
            tblCase.Dateofinjury AS DOI ,
            tblCase.Allegation ,
            tblCase.Notes ,
            tblCase.CaseType ,
            'Dear ' + tblExaminee.firstName + ' ' + tblExaminee.lastName AS Examineesalutation ,
            tblCase.status ,
            tblCase.calledInBy ,
            tblCase.chartnbr ,
            tblCase.reportverbal ,
            tblCase.Datemedsrecd AS medsrecd ,
            tblCase.typemedsrecd ,
            tblCase.plaintiffAttorneyCode ,
            tblCase.defenseAttorneyCode ,
            tblCase.serviceCode ,
            tblCase.FaxPattny ,
            tblCase.FaxDoctor ,
            tblCase.FaxClient ,
            tblCase.EmailClient ,
            tblCase.EmailDoctor ,
            tblCase.EmailPattny ,
            tblCase.invoiceDate ,
            tblCase.invoiceamt ,
            tblCase.commitDate ,
            tblCase.WCBNbr ,
            tblCase.specialinstructions ,
            tblCase.priority ,
            tblCase.scheduleNotes ,
            tblCase.requesteddoc ,

            tblCase.USDvarchar1 AS CaseUSDvarchar1 ,
            tblCase.USDvarchar2 AS CaseUSDvarchar2 ,
            tblCase.USDDate1 AS CaseUSDDate1 ,
            tblCase.USDDate2 AS CaseUSDDate2 ,
            tblCase.USDtext1 AS CaseUSDtext1 ,
            tblCase.USDtext2 AS CaseUSDtext2 ,
            tblCase.USDint1 AS CaseUSDint1 ,
            tblCase.USDint2 AS CaseUSDint2 ,
            tblCase.USDmoney1 AS CaseUSDmoney1 ,
            tblCase.USDmoney2 AS CaseUSDmoney2 ,
            tblCase.USDDate3 AS CaseUSDDate3 ,
            tblCase.USDDate4 AS CaseUSDDate4 ,
            tblCase.USDDate5 AS CaseUSDDate5 ,
            tblCase.USDBit1 AS CaseUSDboolean1 ,
            tblCase.USDBit2 AS CaseUSDboolean2 ,

            tblCase.sinternalCasenbr AS internalCasenbr ,
            tblDoctor.credentials AS Doctordegree ,
            tblCase.ClientCode ,
            tblCase.feeCode ,
            tblCase.photoRqd ,
            tblCase.CertMailNbr ,
            tblCase.CertMailNbr2 ,
            tblCase.HearingDate ,
            tblCase.DoctorName ,
            tblCase.masterCasenbr ,
            tblCase.prevappt ,
            tblCase.AssessmentToAddress ,
            tblCase.OCF25Date ,
            tblCase.AssessingFacility ,
            tblCase.DateForminDispute ,
            tblCase.DateReceived ,
            tblCase.ClaimNbrExt ,
            tblCase.sreqspecialty AS RequestedSpecialty ,
            tblCase.AttorneyNote ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
            tblCase.ForecastDate ,
			tblCase.DoctorRptDueDate , 
			tblCase.DoctorReason ,
            tblCase.DefParaLegal ,

            tblCase.MasterSubCase ,
            tblCase.TransportationRequired ,
            tblCase.InterpreterRequired ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.PublishOnWeb ,
            tblCase.Jurisdiction AS JurisdictionCode ,
            tblCase.LegalEvent ,
            tblCase.PILegalEvent ,
            tblCase.TransCode ,
            tblCase.RptFinalizedDate ,

			tblCase.ICDCodeA ,
			tblCase.ICDCodeB ,
			tblCase.ICDCodeC ,
			tblCase.ICDCodeD ,
			tblCase.ICDCodeE ,
			tblCase.ICDCodeF ,
			tblCase.ICDCodeG ,
			tblCase.ICDCodeH ,
			tblCase.ICDCodeI ,
			tblCase.ICDCodeJ ,
			tblCase.ICDCodeK ,
			tblCase.ICDCodeL ,

            'Dear ' + tblDoctor.firstName + ' ' + tblDoctor.lastName + ', ' + ISNULL(tblDoctor.credentials, '') AS DoctorSalutation ,
            tblDoctor.Notes AS DoctorNotes ,
            tblDoctor.Prefix AS DoctorPrefix ,
            tblDoctor.Addr1 AS DoctorcorrespAddr1 ,
            tblDoctor.Addr2 AS DoctorcorrespAddr2 ,
            tblDoctor.City + ', ' + tblDoctor.State + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
            tblDoctor.Phone + ' ' + ISNULL(tblDoctor.PhoneExt, ' ') AS DoctorcorrespPhone ,
            tblDoctor.FaxNbr AS DoctorcorrespFax ,
            tblDoctor.EmailAddr AS DoctorcorrespEmail ,
            tblDoctor.Qualifications ,
            tblDoctor.Prepaid ,
            tblDoctor.county AS DoctorCorrespCounty ,

            tblDoctor.USDvarchar1 AS DoctorUSDvarchar1 ,
            tblDoctor.USDvarchar2 AS DoctorUSDvarchar2 ,
            tblDoctor.USDvarchar3 AS DoctorUSDvarchar3 ,
            tblDoctor.USDDate1 AS DoctorUSDDate1 ,
            tblDoctor.USDDate2 AS DoctorUSDDate2 ,
            tblDoctor.USDDate3 AS DoctorUSDDate3 ,
            tblDoctor.USDDate4 AS DoctorUSDDate4 ,
            tblDoctor.USDDate5 AS DoctorUSDDate5 ,
            tblDoctor.USDDate6 AS DoctorUSDDate6 ,
            tblDoctor.USDDate7 AS DoctorUSDDate7 ,
            tblDoctor.USDtext1 AS DoctorUSDtext1 ,
            tblDoctor.USDtext2 AS DoctorUSDtext2 ,
            tblDoctor.USDint1 AS DoctorUSDint1 ,
            tblDoctor.USDint2 AS DoctorUSDint2 ,
            tblDoctor.USDmoney1 AS DoctorUSDmoney1 ,
            tblDoctor.USDmoney2 AS DoctorUSDmoney2 ,
			tblDoctor.DrMedRecsInDays AS DrMedRecsInDays ,
			tblDoctor.ExpectedVisitDuration As ExpectedVisitDuration,

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            tblDoctor.remitState ,
            tblDoctor.remitZip ,
            tblDoctor.UPIN ,
            tblDoctor.schedulepriority ,
            tblDoctor.feeCode AS drfeeCode ,
            tblDoctor.licensenbr AS Doctorlicense ,
            tblDoctor.SSNTaxID AS DoctorTaxID ,
            tblDoctor.lastName AS DoctorlastName ,
            tblDoctor.firstName AS DoctorfirstName ,
            tblDoctor.middleinitial AS Doctormiddleinitial ,
            ISNULL(LEFT(tblDoctor.firstName, 1), '')
            + ISNULL(LEFT(tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(tblDoctor.lastName, 1), '') AS Doctorinitials ,
            tblDoctor.State AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
			tblLocation.AddressInstructions,
            tblLocation.City + ', ' + tblLocation.State + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.insidedr ,
            tblLocation.Email AS DoctorEmail ,
            tblLocation.Fax AS DoctorFax ,
            tblLocation.Faxdrschedule ,
            tblLocation.medrcdletter ,
            tblLocation.drletter ,
            tblLocation.county AS Doctorcounty ,
            tblLocation.vicinity AS Doctorvicinity ,
            tblLocation.contactPrefix AS DoctorLocationcontactPrefix ,
            tblLocation.contactfirst AS DoctorLocationcontactfirstName ,
            tblLocation.contactlast AS DoctorLocationcontactlastName ,
            tblLocation.Notes AS DoctorLocationNotes ,
            tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontact ,
            'Dear ' + tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontactsalutation ,
            tblLocation.State AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            tblLocation.State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + tblCCAddress_2.State + '  '
            + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            tblCCAddress_2.State AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + tblCCAddress_1.State + '  '
            + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            tblCCAddress_1.State AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,


            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
			tblCaseType.ExternalDesc AS CaseTypeDesc ,
            --tblCaseType.description AS CaseTypeDesc ,  -- Issue 5985 - stop usign description and use ExternalDesc

            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblDoctorSchedule.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
			tblOffice.ShortDesc AS OfficeShortDesc ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,
			tblOffice.NYWCCompanyName ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany,                          
			
			dbo.tblCase.DateOfInjury2 AS DOI2, 
			dbo.tblCase.DateOfInjury3 AS DOI3, 
			dbo.tblCase.DateOfInjury4 AS DOI4,
			dbo.tblCase.InsuringCompany as InsuringCompany,
			dbo.tblCase.CaseCaption, 
			dbo.tblCase.LitigationNotes
    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode

            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode

            LEFT OUTER JOIN tblSpecialty ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblApptStatus ON tblCase.ApptStatusID = tblApptStatus.ApptStatusID
            LEFT OUTER JOIN tblEmployer on tblcase.EmployerID = tblEmployer.EmployerID 
            LEFT OUTER JOIN tblEmployerAddress on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID
GO
PRINT N'Altering [dbo].[vwDocumentAccting]...';


GO
ALTER VIEW vwDocumentAccting
AS
    SELECT  tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblCase.ClaimNbr ,

			tblcase.EmployerID ,
			tblcase.EmployerAddressID ,

            tblAcctingTrans.SeqNO ,
            AH.DocumentNbr ,
            tblAcctingTrans.type AS DocumentType ,

            tblAcctingTrans.ApptDate ,
            tblAcctingTrans.ApptTime ,
            tblAcctingTrans.CaseApptID ,
			tblAcctingTrans.ApptStatusID ,

            CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END AS DoctorCode ,
            CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END AS DoctorLocation ,

            tblExaminee.City AS ExamineeCity ,
            tblExaminee.State AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + tblExaminee.State + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
            tblExaminee.Country ,
            tblExaminee.PolicyNumber ,
            tblExaminee.SSN ,
            tblExaminee.firstName + ' ' + tblExaminee.lastName AS ExamineeName ,
            tblExaminee.Phone1 AS ExamineePhone ,
			tblExaminee.WorkPhone AS ExamineeWorkPhone,
            tblExaminee.sex ,
            tblExaminee.DOB ,
            tblExaminee.county AS Examineecounty ,
            tblExaminee.Prefix AS ExamineePrefix ,

            tblExaminee.USDvarchar1 AS ExamineeUSDvarchar1 ,
            tblExaminee.USDvarchar2 AS ExamineeUSDvarchar2 ,
            tblExaminee.USDDate1 AS ExamineeUSDDate1 ,
            tblExaminee.USDDate2 AS ExamineeUSDDate2 ,
            tblExaminee.USDtext1 AS ExamineeUSDtext1 ,
            tblExaminee.USDtext2 AS ExamineeUSDtext2 ,
            tblExaminee.USDint1 AS ExamineeUSDint1 ,
            tblExaminee.USDint2 AS ExamineeUSDint2 ,
            tblExaminee.USDmoney1 AS ExamineeUSDmoney1 ,
            tblExaminee.USDmoney2 AS ExamineeUSDmoney2 ,

            tblExaminee.note AS ChartNotes ,
            tblExaminee.Fax AS ExamineeFax ,
            tblExaminee.Email AS ExamineeEmail ,
            tblExaminee.insured AS Examineeinsured ,
            tblExaminee.middleinitial AS Examineemiddleinitial ,
            tblExaminee.InsuredAddr1 ,
            tblExaminee.InsuredCity ,
            tblExaminee.InsuredState ,
            tblExaminee.InsuredZip ,
            tblExaminee.InsuredSex ,
            tblExaminee.InsuredRelationship ,
            tblExaminee.InsuredPhone ,
            tblExaminee.InsuredPhoneExt ,
            tblExaminee.InsuredFax ,
            tblExaminee.InsuredEmail ,
            tblExaminee.ExamineeStatus ,

            tblExaminee.TreatingPhysician ,
            tblExaminee.TreatingPhysicianAddr1 ,
            tblExaminee.TreatingPhysicianCity ,
            tblExaminee.TreatingPhysicianState ,
            tblExaminee.TreatingPhysicianZip ,
            tblExaminee.TreatingPhysicianPhone ,
            tblExaminee.TreatingPhysicianPhoneExt ,
            tblExaminee.TreatingPhysicianFax ,
            tblExaminee.TreatingPhysicianEmail ,
            tblExaminee.TreatingPhysicianLicenseNbr ,
			tblExaminee.TreatingPhysicianTaxID ,
            tblExaminee.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,
			tblExaminee.TreatingPhysicianNPINbr,

			(Case ISNULL(tblcase.EmployerID, 0)
              WHEN 0
              THEN tblExaminee.Employer  
			  ELSE tblEmployer.Name  
			  END) AS Employer,  

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
            
			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerContactLastName  
			  ELSE tblEmployerAddress.ContactLast  
			  END) AS EmployerContactLastName,  
            
			(Case ISNULL(tblcase.EmployerID , 0)
              WHEN 0
              THEN tblExaminee.EmployerContactFirstName  
			  ELSE tblEmployerAddress.ContactFirst  
			  END) AS EmployerContactFirstName,  

            tblClient.firstName + ' ' + tblClient.lastName AS ClientName ,
            tblClient.Phone1 + ' ' + ISNULL(tblClient.Phone1ext, ' ') AS ClientPhone ,
            tblClient.Phone2 + ' ' + ISNULL(tblClient.Phone2ext, ' ') AS ClientPhone2 ,
            tblClient.Addr1 AS ClientAddr1 ,
            tblClient.Addr2 AS ClientAddr2 ,
            tblClient.City + ', ' + tblClient.State + '  ' + tblClient.Zip AS ClientCityStateZip ,
            tblClient.Fax AS ClientFax ,
            tblClient.Email AS ClientEmail ,
            'Dear ' + tblClient.firstName + ' ' + tblClient.lastName AS ClientSalutation ,
            tblClient.title AS Clienttitle ,
            tblClient.Prefix AS ClientPrefix ,
            tblClient.suffix AS Clientsuffix ,
            tblClient.USDvarchar1 AS ClientUSDvarchar1 ,
            tblClient.USDvarchar2 AS ClientUSDvarchar2 ,
            tblClient.USDDate1 AS ClientUSDDate1 ,
            tblClient.USDDate2 AS ClientUSDDate2 ,
            tblClient.USDtext1 AS ClientUSDtext1 ,
            tblClient.USDtext2 AS ClientUSDtext2 ,
            tblClient.USDint1 AS ClientUSDint1 ,
            tblClient.USDint2 AS ClientUSDint2 ,
            tblClient.USDmoney1 AS ClientUSDmoney1 ,
            tblClient.USDmoney2 AS ClientUSDmoney2 ,
            tblClient.CompanyCode ,
            tblClient.Notes AS ClientNotes ,
            tblClient.BillAddr1 ,
            tblClient.BillAddr2 ,
            tblClient.BillCity ,
            tblClient.BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            tblClient.State AS ClientState ,
            tblClient.City AS ClientCity ,
            tblClient.Zip AS ClientZip ,

            tblCompany.extName AS Company ,
            tblCompany.USDvarchar1 AS CompanyUSDvarchar1 ,
            tblCompany.USDvarchar2 AS CompanyUSDvarchar2 ,
            tblCompany.USDDate1 AS CompanyUSDDate1 ,
            tblCompany.USDDate2 AS CompanyUSDDate2 ,
            tblCompany.USDtext1 AS CompanyUSDtext1 ,
            tblCompany.USDtext2 AS CompanyUSDtext2 ,
            tblCompany.USDint1 AS CompanyUSDint1 ,
            tblCompany.USDint2 AS CompanyUSDint2 ,
            tblCompany.USDmoney1 AS CompanyUSDmoney1 ,
            tblCompany.USDmoney2 AS CompanyUSDmoney2 ,
            tblCompany.Notes AS CompanyNotes ,

            tblCase.QARep ,
            tblCase.Doctorspecialty ,
            tblCase.BillClientCode AS CaseBillClientCode ,
            tblCase.officeCode ,
            tblCase.PanelNbr ,

            ISNULL(tblUser.lastName, '')
            + Case WHEN ISNULL(tblUser.LastName, '') = ''
                        OR ISNULL(tblUser.FirstName, '') = '' THEN ''
                   ELSE ', '
              END + ISNULL(tblUser.firstName, '') AS scheduler ,

            tblCase.marketerCode AS Marketer ,
            tblCase.Dateadded AS DateCalledIn ,
            tblCase.Dateofinjury AS DOI ,
            tblCase.Allegation ,
            tblCase.Notes ,
            tblCase.CaseType ,
            'Dear ' + tblExaminee.firstName + ' ' + tblExaminee.lastName AS Examineesalutation ,
            tblCase.status ,
            tblCase.calledInBy ,
            tblCase.chartnbr ,
            tblCase.reportverbal ,
            tblCase.Datemedsrecd AS medsrecd ,
            tblCase.typemedsrecd ,
            tblCase.plaintiffAttorneyCode ,
            tblCase.defenseAttorneyCode ,
            tblCase.serviceCode ,
            tblCase.FaxPattny ,
            tblCase.FaxDoctor ,
            tblCase.FaxClient ,
            tblCase.EmailClient ,
            tblCase.EmailDoctor ,
            tblCase.EmailPattny ,
            tblCase.invoiceDate ,
            tblCase.invoiceamt ,
            tblCase.commitDate ,
            tblCase.WCBNbr ,
            tblCase.specialinstructions ,
            tblCase.priority ,
            tblCase.scheduleNotes ,
            tblCase.requesteddoc ,

            tblCase.USDvarchar1 AS CaseUSDvarchar1 ,
            tblCase.USDvarchar2 AS CaseUSDvarchar2 ,
            tblCase.USDDate1 AS CaseUSDDate1 ,
            tblCase.USDDate2 AS CaseUSDDate2 ,
            tblCase.USDtext1 AS CaseUSDtext1 ,
            tblCase.USDtext2 AS CaseUSDtext2 ,
            tblCase.USDint1 AS CaseUSDint1 ,
            tblCase.USDint2 AS CaseUSDint2 ,
            tblCase.USDmoney1 AS CaseUSDmoney1 ,
            tblCase.USDmoney2 AS CaseUSDmoney2 ,
            tblCase.USDDate3 AS CaseUSDDate3 ,
            tblCase.USDDate4 AS CaseUSDDate4 ,
            tblCase.USDDate5 AS CaseUSDDate5 ,
            tblCase.USDBit1 AS CaseUSDboolean1 ,
            tblCase.USDBit2 AS CaseUSDboolean2 ,

            tblCase.sinternalCasenbr AS internalCasenbr ,
            tblDoctor.credentials AS Doctordegree ,
            tblCase.ClientCode ,
            tblCase.feeCode ,
            tblCase.photoRqd ,
            tblCase.CertMailNbr ,
			tblCase.CertMailNbr2 ,
            tblCase.HearingDate ,
            tblCase.DoctorName ,
            tblCase.masterCasenbr ,
            tblCase.prevappt ,
            tblCase.AssessmentToAddress ,
            tblCase.OCF25Date ,
            tblCase.AssessingFacility ,
            tblCase.DateForminDispute ,
            tblCase.DateReceived ,
            tblCase.ClaimNbrExt ,
            tblCase.sreqspecialty AS RequestedSpecialty ,
            tblCase.AttorneyNote ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
            tblCase.ForecastDate ,
            tblCase.DefParaLegal ,

            tblCase.MasterSubCase ,
            tblCase.TransportationRequired ,
            tblCase.InterpreterRequired ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.PublishOnWeb ,
            tblCase.Jurisdiction AS JurisdictionCode ,
            tblCase.LegalEvent ,
            tblCase.PILegalEvent ,
            tblCase.TransCode ,
            tblCase.RptFinalizedDate ,

			tblCase.ICDCodeA ,
			tblCase.ICDCodeB ,
			tblCase.ICDCodeC ,
			tblCase.ICDCodeD ,
			tblCase.ICDCodeE ,
			tblCase.ICDCodeF ,
			tblCase.ICDCodeG ,
			tblCase.ICDCodeH ,
			tblCase.ICDCodeI ,
			tblCase.ICDCodeJ ,
			tblCase.ICDCodeK ,
			tblCase.ICDCodeL ,
			tblCase.DoctorRptDueDate , 

            'Dear ' + tblDoctor.firstName + ' ' + tblDoctor.lastName + ', ' + ISNULL(tblDoctor.credentials, '') AS DoctorSalutation ,
            tblDoctor.Notes AS DoctorNotes ,
            tblDoctor.Prefix AS DoctorPrefix ,
            tblDoctor.Addr1 AS DoctorcorrespAddr1 ,
            tblDoctor.Addr2 AS DoctorcorrespAddr2 ,
            tblDoctor.City + ', ' + tblDoctor.State + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
            tblDoctor.Phone + ' ' + ISNULL(tblDoctor.PhoneExt, ' ') AS DoctorcorrespPhone ,
            tblDoctor.FaxNbr AS DoctorcorrespFax ,
            tblDoctor.EmailAddr AS DoctorcorrespEmail ,
            tblDoctor.Qualifications ,
            tblDoctor.Prepaid ,
            tblDoctor.county AS DoctorCorrespCounty ,

            tblDoctor.USDvarchar1 AS DoctorUSDvarchar1 ,
            tblDoctor.USDvarchar2 AS DoctorUSDvarchar2 ,
            tblDoctor.USDvarchar3 AS DoctorUSDvarchar3 ,
            tblDoctor.USDDate1 AS DoctorUSDDate1 ,
            tblDoctor.USDDate2 AS DoctorUSDDate2 ,
            tblDoctor.USDDate3 AS DoctorUSDDate3 ,
            tblDoctor.USDDate4 AS DoctorUSDDate4 ,
            tblDoctor.USDDate5 AS DoctorUSDDate5 ,
            tblDoctor.USDDate6 AS DoctorUSDDate6 ,
            tblDoctor.USDDate7 AS DoctorUSDDate7 ,
            tblDoctor.USDtext1 AS DoctorUSDtext1 ,
            tblDoctor.USDtext2 AS DoctorUSDtext2 ,
            tblDoctor.USDint1 AS DoctorUSDint1 ,
            tblDoctor.USDint2 AS DoctorUSDint2 ,
            tblDoctor.USDmoney1 AS DoctorUSDmoney1 ,
            tblDoctor.USDmoney2 AS DoctorUSDmoney2 ,
			tblDoctor.DrMedRecsInDays AS DrMedRecsInDays ,
			tblDoctor.ExpectedVisitDuration As ExpectedVisitDuration,

            tblDoctor.WCNbr AS Doctorwcnbr ,
            tblDoctor.remitattn ,
            tblDoctor.remitAddr1 ,
            tblDoctor.remitAddr2 ,
            tblDoctor.remitCity ,
            tblDoctor.remitState ,
            tblDoctor.remitZip ,
            tblDoctor.UPIN ,
            tblDoctor.schedulepriority ,
            tblDoctor.feeCode AS drfeeCode ,
            tblDoctor.licensenbr AS Doctorlicense ,
            tblDoctor.SSNTaxID AS DoctorTaxID ,
            tblDoctor.lastName AS DoctorlastName ,
            tblDoctor.firstName AS DoctorfirstName ,
            tblDoctor.middleinitial AS Doctormiddleinitial ,
            ISNULL(LEFT(tblDoctor.firstName, 1), '')
            + ISNULL(LEFT(tblDoctor.middleinitial, 1), '')
            + ISNULL(LEFT(tblDoctor.lastName, 1), '') AS Doctorinitials ,
            tblDoctor.State AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
			tblLocation.AddressInstructions,
            tblLocation.City + ', ' + tblLocation.State + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.insidedr ,
            tblLocation.Email AS DoctorEmail ,
            tblLocation.Fax AS DoctorFax ,
            tblLocation.Faxdrschedule ,
            tblLocation.medrcdletter ,
            tblLocation.drletter ,
            tblLocation.county AS Doctorcounty ,
            tblLocation.vicinity AS Doctorvicinity ,
            tblLocation.contactPrefix AS DoctorLocationcontactPrefix ,
            tblLocation.contactfirst AS DoctorLocationcontactfirstName ,
            tblLocation.contactlast AS DoctorLocationcontactlastName ,
            tblLocation.Notes AS DoctorLocationNotes ,
            tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontact ,
            'Dear ' + tblLocation.contactfirst + ' ' + tblLocation.contactlast AS DoctorLocationcontactsalutation ,
            tblLocation.State AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            tblLocation.State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + tblCCAddress_2.State + '  '
            + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            tblCCAddress_2.State AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + tblCCAddress_1.State + '  '
            + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            tblCCAddress_1.State AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
            tblCCAddress_3.Email AS DParaLegalEmail ,
            tblCCAddress_3.Fax AS DParaLegalFax ,

			
            tblServices.description AS ServiceDesc ,
            tblServices.ShortDesc ,

            tblCaseType.ShortDesc AS CaseTypeShortDesc ,
			tblCaseType.ExternalDesc AS CaseTypeDesc ,
            --tblCaseType.description AS CaseTypeDesc , -- Issue 5985 - stop usign description and use ExternalDesc
            
            tblQueues.StatusDesc ,

            tblSpecialty.specialtyCode ,
            tblSpecialty.description AS specialtydesc ,

            tblRecordStatus.description AS medsstatus ,

            tblDoctorLocation.correspondence AS Doctorcorrespondence ,

            tblState.StateName AS Jurisdiction ,

            tblDoctorSchedule.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
			tblOffice.ShortDesc AS OfficeShortDesc ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,
			tblOffice.NYWCCompanyName ,

            tblLanguage.Description AS Language ,
			tblCase.DateOfInjury2 AS DOI2, 
			tblCase.DateOfInjury3 AS DOI3, 
			tblCase.DateOfInjury4 AS DOI4,

            tblTranscription.TransCompany,

			tblCase.InsuringCompany as InsuringCompany

    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode

            INNER JOIN tblAcctingTrans ON tblCase.casenbr = tblAcctingTrans.casenbr
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = tblAcctingTrans.SeqNO

            LEFT OUTER JOIN tblDoctor ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorcode ELSE tblAcctingTrans.DrOpCode END = tblDoctor.doctorcode
            LEFT OUTER JOIN tblLocation ON CASE WHEN EWReferralType = 2 THEN tblCase.doctorlocation ELSE tblAcctingTrans.doctorlocation END = tblLocation.locationcode
            LEFT OUTER JOIN tblDoctorSchedule ON tblCase.schedCode = tblDoctorSchedule.schedCode
            LEFT OUTER JOIN tblDoctorLocation ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode
			
            LEFT OUTER JOIN tblSpecialty ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblEmployer on tblcase.EmployerID = tblEmployer.EmployerID 
            LEFT OUTER JOIN tblEmployerAddress on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID
GO
PRINT N'Creating [dbo].[vwCertifiedMailCases]...';


GO
CREATE VIEW [dbo].[vwCertifiedMailCases]
AS 
	SELECT 
			MAX(IIF(CaseEnv.AddressedToEntity='EE', CaseEnv.CaseEnvelopeID, 0)) AS EECaseEnvelopeID,
			MAX(IIF(CaseEnv.AddressedToEntity='AT', CaseEnv.CaseEnvelopeID, 0)) AS ATCaseEnvelopeID, 
			CaseEnv.CaseNbr AS CaseNbr, 
			tblCase.CertMailNbr AS ExamineeCertMailNbr, 
			tblCase.CertMailNbr2 AS AttorneyCertMailNbr,
			CaseEnv.DateAcknowledged AS DateAcknowledged, 
			-- columns needed for dynamic WHERE clause that is created in client code
			tblCase.OfficeCode AS OfficeCode, 
			tblCase.CaseType AS CaseType, 
			tblCompany.CompanyCode AS CompanyCode,
			tblCase.DoctorCode AS DoctorCode,
			tblCase.DoctorLocation AS DoctorLocation,
			tblCase.MarketerCode AS MarketerCode, 
			tblCompany.ParentCompanyID AS ParentCompanyID, 
			tblCase.QARep AS QARep,
			tblCase.SchedulerCode AS SchedulerCode, 
			tblCase.ServiceCode AS ServiceCode
	  FROM tblCaseEnvelope AS CaseEnv
				LEFT OUTER JOIN tblCase ON tblCase.CaseNbr = CaseEnv.CaseNbr 
				LEFT OUTER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
				LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
	WHERE CaseEnv.IsCertifiedMail = 1
	GROUP BY CaseEnv.CaseNbr, tblCase.CertMailNbr, tblCase.CertMailNbr2, CaseEnv.DateAcknowledged, 
		tblCase.OfficeCode, tblCase.CaseType, tblCompany.CompanyCode, tblCase.DoctorCode, 
		tblCase.DoctorLocation, tblCase.MarketerCode, tblCompany.ParentCompanyID, tblCase.QARep, 
		tblCase.SchedulerCode, tblCase.ServiceCode
GO
PRINT N'Altering [dbo].[proc_CaseDocument_LoadExprtGridByCaseNbr]...';


GO
ALTER PROCEDURE [proc_CaseDocument_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT tblCaseDocuments.UserIDAdded as 'User', tblPublishOnWeb.PublishAsPDF, tblCaseDocuments.DateAdded as 'Date Added', sfilename as 'File Name', Description
		FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN
				(SELECT UserCode
					FROM tblWebUserAccount
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
			AND (tblCaseDocuments.casenbr = @CaseNbr)
			AND (tblCaseDocuments.PublishOnWeb = 1)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_LoadByCaseNbrAndWebUserID]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_CaseDocuments_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL

AS

SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF, ISNULL(tblPublishOnWeb.Viewed, 0) DocViewed, tblCaseDocType.Description as DocTypeDesc
	FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseDocuments'
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN
				(SELECT UserCode
					FROM tblWebUserAccount
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType))
		INNER JOIN tblCaseDocType on isnull(tblCaseDocuments.CaseDocTypeID,1) = tblCaseDocType.CaseDocTypeID
		AND (tblPublishOnWeb.casenbr = @CaseNbr)

ORDER BY tblCaseDocuments.DateAdded DESC
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadByCaseNbrAndWebUserID]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_CaseHistory_LoadByCaseNbrAndWebUserID]

@CaseNbr int,
@WebUserID int = NULL,
@IsAdmin bit = 0

AS

IF @IsAdmin = 1
	BEGIN
		SELECT DISTINCT *
		FROM tblCaseHistory 
		WHERE tblCaseHistory.casenbr = @CaseNbr AND tblCaseHistory.PublishOnWeb = 1
	END
ELSE
	BEGIN
		SELECT DISTINCT * FROM tblCaseHistory 
			INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN 
				(SELECT UserCode 
					FROM tblWebUserAccount 
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
			AND (tblCaseHistory.casenbr = @CaseNbr)
	END
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_CaseHistory_LoadExprtGridByCaseNbr]...';


GO
ALTER PROCEDURE [proc_CaseHistory_LoadExprtGridByCaseNbr]
(
	@casenbr int,
	@WebUserID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT tblCaseHistory.UserID as 'User', tblCaseHistory.DateAdded as 'Date Added', eventdesc as Description, otherinfo as Info 
		FROM tblCaseHistory 
			INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory' 
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserCode IN 
				(SELECT UserCode 
					FROM tblWebUserAccount 
					WHERE WebUserID = COALESCE(@WebUserID,WebUserID)
					AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType)) 
			AND (tblCaseHistory.casenbr = @CaseNbr)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseVerifyAccess]...';


GO
ALTER PROCEDURE [proc_CaseVerifyAccess]

@CaseNbr int,
@WebUserID int

AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

		SELECT COUNT(tblCase.casenbr) from tblcase
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase' 
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblCase.casenbr = @CaseNbr
			AND tblWebUserAccount.WebUserID = @WebUserID

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_DoctorSchedulePortalCalendarDays]...';


GO
ALTER PROCEDURE [proc_DoctorSchedulePortalCalendarDays]

@StartDate smalldatetime,
@EndDate smalldatetime,
@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, tblCase.CaseNbr, ExtCaseNbr, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(tblCase.casenbr) CaseCount FROM tblCase
	INNER JOIN tblDoctorSchedule ON tblCase.SchedCode = tblDoctorSchedule.SchedCode 
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), tblCase.CaseNbr, ExtCaseNbr, DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	UNION

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, tblCase.CaseNbr, ExtCaseNbr, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(tblCase.casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblDoctorSchedule ON tblCasePanel.SchedCode = tblDoctorSchedule.SchedCode
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), tblCase.CaseNbr, ExtCaseNbr, DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_DoctorSchedulePortalCalendarMonth]...';


GO
ALTER PROCEDURE [proc_DoctorSchedulePortalCalendarMonth]  

@StartDate smalldatetime,
@EndDate smalldatetime,
@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ApptDate, Service, Sum(CaseCount) CaseCount FROM
	(
	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(tblCase.casenbr) CaseCount FROM tblCase 
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION ALL

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(tblCase.casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCasePanel.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name
	)
	as sq group by sq.ApptDate, sq.Service, sq.CaseCount
	
	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_getActiveCases]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_getActiveCases]
@WebUserID int

AS 

SELECT DISTINCT
	COUNT(DISTINCT tblCase.CaseNbr) AS NbrofCases, 
	tblWebQueues.statuscode AS WebStatus, 
	tblWebQueues.description AS WebDescription, 
	tblWebQueues.displayorder
FROM tblCase
	INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
	INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
	INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
		AND tblPublishOnWeb.tabletype = 'tblCase'
		AND tblPublishOnWeb.PublishOnWeb = 1 
	INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode 
		AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType	
		AND tblWebUserAccount.WebUserID = @WebUserID
WHERE (tblCase.status <> 0)
GROUP BY 
	tblWebQueues.statuscode, 
	tblWebQueues.description, 
	tblWebQueues.displayorder
ORDER BY 
	tblWebQueues.displayorder
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[proc_GetReferralSummarySinceLastLoginDateCount]...';


GO
ALTER PROCEDURE [dbo].[proc_GetReferralSummarySinceLastLoginDateCount]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

    SELECT COUNT(tblCase.casenbr) FROM tblCase
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
		WHERE (tblPublishOnWeb.tabletype = 'tblCase')
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.UserType = @userType)
			AND (tblPublishOnWeb.UserCode = @userCode)
			AND (tblPublishOnWeb.dateadded > @LastLoginDate)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_PublishOnWeb_Insert]...';


GO
ALTER PROCEDURE [proc_PublishOnWeb_Insert]
(
	@PublishID int = NULL output,
	@TableType varchar(50) = NULL,
	@TableKey int = NULL,
	@UserID varchar(50) = NULL,
	@UserType varchar(50) = NULL,
	@UserCode int = NULL,
	@PublishOnWeb bit,
	@Notify bit,
	@PublishasPDF bit,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL,
	@Viewed bit,
	@CaseNbr int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblPublishOnWeb]
	(
		[TableType],
		[TableKey],
		[UserID],
		[UserType],
		[UserCode],
		[PublishOnWeb],
		[Notify],
		[PublishasPDF],
		[DateAdded],
		[UseridAdded],
		[DateEdited],
		[UseridEdited],
		[Viewed],
		[CaseNbr]
	)
	VALUES
	(
		@TableType,
		@TableKey,
		@UserID,
		@UserType,
		@UserCode,
		@PublishOnWeb,
		@Notify,
		@PublishasPDF,
		@DateAdded,
		@UseridAdded,
		@DateEdited,
		@UseridEdited,
		@Viewed,
		@CaseNbr
	)

	SET @Err = @@Error

	SELECT @PublishID = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_PublishOnWeb_LoadByTableKeyTableType]...';


GO
ALTER PROCEDURE [proc_PublishOnWeb_LoadByTableKeyTableType]
(
	@TableKey int,
	@UserCode int,
	@TableType varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblPublishOnWeb]
	WHERE
		([TableKey] = @TableKey)
	AND
		([UserCode] = @UserCode)
	AND 
		([TableType] = @TableType)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_PublishOnWeb_Update]...';


GO
ALTER PROCEDURE [proc_PublishOnWeb_Update]
(
	@PublishID int,
	@TableType varchar(50) = NULL,
	@TableKey int = NULL,
	@UserID varchar(50) = NULL,
	@UserType varchar(50) = NULL,
	@UserCode int = NULL,
	@PublishOnWeb bit,
	@Notify bit,
	@PublishasPDF bit,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL,
	@Viewed bit = NULL,
	@CaseNbr int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblPublishOnWeb]
	SET
		[TableType] = @TableType,
		[TableKey] = @TableKey,
		[UserID] = @UserID,
		[UserType] = @UserType,
		[UserCode] = @UserCode,
		[PublishOnWeb] = @PublishOnWeb,
		[Notify] = @Notify,
		[PublishasPDF] = @PublishasPDF,
		[DateAdded] = @DateAdded,
		[UseridAdded] = @UseridAdded,
		[DateEdited] = @DateEdited,
		[UseridEdited] = @UseridEdited,
		[Viewed] = @Viewed,
		[CaseNbr] = @CaseNbr
	WHERE
		[PublishID] = @PublishID


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_IMEException]...';


GO
ALTER PROCEDURE proc_IMEException
    @ExceptionID INT ,
    @OfficeCode INT ,
    @CaseTypeCode INT ,
    @ServiceCode INT ,
    @StatusCode INT ,
    @EnterLeave INT ,
    @CaseNbr INT
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @Err INT;

    SELECT  ED.* ,
            ISNULL(C.CaseNbr, -1) AS CaseNbr ,
            CL.ClientCode ,
            CO.ParentCompanyID ,
            CL.CompanyCode ,
            C.DoctorCode ,
            C.PlaintiffAttorneyCode ,
            C.DefenseAttorneyCode ,
            C.DefParaLegal ,
            BCL.ClientCode AS BillClientCode ,
            BCO.ParentCompanyID AS BillParentCompanyID ,
            BCL.CompanyCode AS BillCompanyCode
    FROM    tblExceptionDefinition AS ED
            LEFT OUTER JOIN tblCase AS C ON C.CaseNbr = @CaseNbr
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CL.CompanyCode = CO.CompanyCode
            LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = ISNULL(C.BillClientCode, C.ClientCode)
            LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
			LEFT OUTER JOIN tblEmployer AS ER ON ER.EmployerID = C.EmployerID
			LEFT OUTER JOIN tblEWParentEmployer AS PE ON PE.EWParentEmployerID = ER.EWParentEmployerID
    WHERE   ED.Status = 'Active' AND ED.ExceptionID = @ExceptionID
			AND
			( ED.Entity = 'CS'
                OR ( ED.Entity = 'PC'
                    AND ( CO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                        
                    OR  BCO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = 'CO'
                    AND ( CL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                        
                    OR  BCL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = 'CL'
                    AND ( CL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                       
                    OR  BCL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = 'DR'
                    AND ( C.DoctorCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
                    )
                OR ( ED.Entity = 'AT'
                    AND ( C.PlaintiffAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                    
					OR C.DefenseAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        )
                    )
                OR ( ED.Entity = 'PE'
                    AND ( ER.EWParentEmployerID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
                    )
                OR ( ED.Entity = 'ER'
                    AND ( C.EmployerID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
                    )
            )
            AND ( ED.AllOffice = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = C.OfficeCode )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = @OfficeCode )
                )
            AND ( ED.CaseTypeCode = -1
                    OR ED.CaseTypeCode = @CaseTypeCode
                )
            AND ( ED.ServiceCode = -1
                    OR ED.ServiceCode = @ServiceCode
                )
            AND ( ( ED.StatusCode = -1
                    AND ( ED.ExceptionID <> 18
                            OR ISNULL(ED.StatusCodeValue, 1) = @EnterLeave
                        )
                    )
                    OR ( ED.StatusCode = @StatusCode
                        AND ED.StatusCodeValue = @EnterLeave
                        )
                )

    SET @Err = @@Error;

    RETURN @Err;
END;
GO
PRINT N'Creating [dbo].[proc_CasePeerBill_Insert]...';


GO
CREATE PROCEDURE [proc_CasePeerBill_Insert]
(
	@PeerBillId int = NULL output,
	@CaseNbr int,
	@DateBillReceived datetime = NULL,
	@ServiceDate datetime = NULL,
	@BillNumber varchar(50) = NULL,
	@BillAmount money = NULL,
	@ReferringProviderName varchar(50) = NULL,
	@ReferringProviderTIN varchar(11) = NULL,
	@ProviderName varchar(50) = NULL,
	@ProviderTIN varchar(11) = NULL,
	@ProviderSpecialtyCode varchar(50) = NULL,
	@ServiceRendered varchar(250) = NULL,
	@CPTCode varchar(50) = NULL,
	@BillAmountApproved money = NULL,
	@BillAmountDenied money = NULL,
	@DateAdded datetime = NULL,
	@UserIDAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIDEdited varchar(15) = NULL,
	@ProviderZip varchar(10) = NULL,
	@ServiceEndDate datetime = NULL
)
AS
BEGIN

 SET NOCOUNT OFF
 DECLARE @Err int

 INSERT
 INTO [tblCasePeerBill]
 (
	[CaseNbr],
	[DateBillReceived],
	[ServiceDate],
	[BillNumber],
	[BillAmount],
	[ReferringProviderName],
	[ReferringProviderTIN],
	[ProviderName],
	[ProviderTIN],
	[ProviderSpecialtyCode],
	[ServiceRendered],
	[CPTCode],
	[BillAmountApproved],
	[BillAmountDenied],
	[DateAdded],
	[UserIDAdded],
	[DateEdited],
	[UserIDEdited],
	[ProviderZip],
	[ServiceEndDate]
 )
 VALUES
 (
	@CaseNbr,
	@DateBillReceived,
	@ServiceDate,
	@BillNumber,
	@BillAmount,
	@ReferringProviderName,
	@ReferringProviderTIN,
	@ProviderName,
	@ProviderTIN,
	@ProviderSpecialtyCode,
	@ServiceRendered,
	@CPTCode,
	@BillAmountApproved,
	@BillAmountDenied,
	@DateAdded,
	@UserIDAdded,
	@DateEdited,
	@UserIDEdited,
	@ProviderZip,
	@ServiceEndDate
 )

 SET @Err = @@Error

 SELECT @PeerBillId = SCOPE_IDENTITY()

 RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_CasePeerBill_LoadByCaseNbr]...';


GO
CREATE PROCEDURE [proc_CasePeerBill_LoadByCaseNbr]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCasePeerBill]
	WHERE
		([CaseNbr] = @CaseNbr)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_CasePeerBill_LoadByPrimaryKey]...';


GO
CREATE PROCEDURE [proc_CasePeerBill_LoadByPrimaryKey]
(
	@PeerBillID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCasePeerBill]
	WHERE
		([PeerBillID] = @PeerBillID)

	SET @Err = @@Error

	RETURN @Err
END
GO








INSERT INTO tblSetting (Name, Value) VALUES ('CertMailOfficeCodes','')
GO


INSERT INTO tblMessageToken (Name, Description) VALUES ('@NYWCCompanyName@', '')
GO

SET IDENTITY_INSERT tblCodes ON
GO
	INSERT INTO tblCodes(CodeID, Category, SubCategory, Value)
	VALUES(38, 'Zurich American', 'ReferralMethod', 'EClaims - Yes')
	GO
	INSERT INTO tblCodes(CodeID, Category, SubCategory, Value)
	VALUES(39, 'Zurich American', 'ReferralMethod', 'EClaims - No')
SET IDENTITY_INSERT tblCodes OFF
GO



insert into tblProblemArea (Description) Values('Left')
insert into tblProblemArea (Description) Values('Right')
insert into tblProblemArea (Description) Values('Bilateral')
insert into tblProblemArea (Description) Values('Anterior')
insert into tblProblemArea (Description) Values('Posterior')
GO


insert into tblMessageToken (Name,Description) values ('@ProblemList@','') 
Go





INSERT INTO tblNotifyPreference
(
    WebUserID,
    NotifyEventID,
    NotifyMethodID,
    DateEdited,
    UserIDEdited,
    PreferenceValue
)
	SELECT
		WU.WebUserID,
		NA.NotifyEventID,
		NA.NotifyMethodID,
		GETDATE() AS DateEdited,
		'Admin' AS UserIDEdited,
		NA.DefaultPreferenceValue
	FROM tblWebUser AS WU
			INNER JOIN tblNotifyAudience AS NA ON NA.UserType = WU.UserType
	WHERE WU.PortalVersion = 2 AND WU.UserType = 'DR'
	AND WU.WebUserID NOT IN (SELECT WebUserID FROM tblNotifyPreference)
GO






UPDATE POW SET POW.CaseNbr=CD.CaseNbr
 FROM tblPublishOnWeb AS POW
 INNER JOIN tblCaseDocuments AS CD ON CD.SeqNo=POW.TableKey AND POW.TableType='tblCaseDocuments'
 WHERE POW.CaseNbr IS NULL
GO


INSERT INTO tblPublishOnWeb
(
    TableType,
    TableKey,
    UserID,
    UserType,
    UserCode,
    PublishOnWeb,
    Notify,
    PublishAsPDF,
    DateAdded,
    UserIDAdded,
    DateEdited,
    UserIDEdited,
    Viewed,
    CaseNbr
)
SELECT
 POW.TableType,
 POW.TableKey,
 POW.UserID,
 POW.UserType,
 POW.UserCode,
 POW.PublishOnWeb,
 POW.Notify,
 POW.PublishAsPDF,
 POW.DateAdded,
 POW.UserIDAdded,
 POW.DateEdited,
 POW.UserIDEdited,
 POW.Viewed,
 C.CaseNbr
 FROM tblCaseDocuments AS CD
 INNER JOIN tblPublishOnWeb AS POW ON POW.TableType='tblCaseDocuments' AND POW.TableKey=CD.SeqNo
 INNER JOIN tblCase AS C ON C.MasterCaseNbr = CD.MasterCaseNbr AND C.CaseNbr<>POW.CaseNbr
 WHERE CD.SharedDoc=1 AND CD.MasterCaseNbr IS NOT NULL
GO





UPDATE tblControl SET DBVersion='3.34'
GO