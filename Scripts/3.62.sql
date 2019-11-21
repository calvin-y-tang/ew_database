
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

PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [Duration] INT NULL;


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
PRINT N'Creating [dbo].[tblCaseAppt].[IX_tblCaseAppt_ApptTimeApptStatusID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseAppt_ApptTimeApptStatusID]
    ON [dbo].[tblCaseAppt]([ApptTime] ASC, [ApptStatusID] ASC);


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
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD [ApptRequestStatusCode]     INT NULL,
        [ApptRequestDoctorReasonID] INT NULL;


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
PRINT N'Altering [dbo].[tblQueues]...';


GO
ALTER TABLE [dbo].[tblQueues]
    ADD [DoNotAllowManualChange] BIT NULL;


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
PRINT N'Altering [dbo].[tblWebPortalVersionRule]...';


GO
ALTER TABLE [dbo].[tblWebPortalVersionRule]
    ADD [AllowScheduling] BIT CONSTRAINT [DF_tblWebPortalVersionRule_AllowScheduling] DEFAULT (0) NULL;


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
PRINT N'Altering [dbo].[tblWebUser]...';


GO
ALTER TABLE [dbo].[tblWebUser]
    ADD [AllowScheduling] BIT CONSTRAINT [DF_tblWebUser_AllowScheduling] DEFAULT (0) NULL;


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
PRINT N'Creating [dbo].[tblCaseApptRequest]...';


GO
CREATE TABLE [dbo].[tblCaseApptRequest] (
    [CaseApptRequestID]       INT           IDENTITY (1, 1) NOT NULL,
    [DoctorBlockTimeSlotID]   INT           NOT NULL,
    [CaseNbr]                 INT           NOT NULL,
    [CaseApptRequestStatusID] INT           NOT NULL,
    [DateAdded]               DATETIME      NULL,
    [UserIDAdded]             VARCHAR (15)  NULL,
    [DateEdited]              DATETIME      NULL,
    [UserIDEdited]            VARCHAR (15)  NULL,
    [RejectionReason]         VARCHAR (100) NULL,
    CONSTRAINT [PK_tblCaseApptRequest] PRIMARY KEY CLUSTERED ([CaseApptRequestID] ASC)
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
PRINT N'Creating [dbo].[tblCaseApptRequest].[IX_tblCaseApptRequest_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseApptRequest_CaseNbr]
    ON [dbo].[tblCaseApptRequest]([CaseNbr] ASC);


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
PRINT N'Creating [dbo].[tblCaseApptRequestStatus]...';


GO
CREATE TABLE [dbo].[tblCaseApptRequestStatus] (
    [CaseApptRequestStatusID] INT          NOT NULL,
    [Name]                    VARCHAR (20) NULL,
    CONSTRAINT [PK_tblCaseApptRequestStatus] PRIMARY KEY CLUSTERED ([CaseApptRequestStatusID] ASC)
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
PRINT N'Creating [dbo].[tblDoctorBlockTimeDay]...';


GO
CREATE TABLE [dbo].[tblDoctorBlockTimeDay] (
    [DoctorBlockTimeDayID] INT          IDENTITY (1, 1) NOT NULL,
    [DoctorCode]           INT          NOT NULL,
    [LocationCode]         INT          NOT NULL,
    [ScheduleDate]         DATETIME     NOT NULL,
    [Active]               BIT          NOT NULL,
    [[MaxSlotOnWeb]        INT          NULL,
    [DateAdded]            DATETIME     NULL,
    [UserIDAdded]          VARCHAR (15) NULL,
    [DateEdited]           DATETIME     NULL,
    [UserIDEdited]         VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDoctorBlockTimeDay] PRIMARY KEY CLUSTERED ([DoctorBlockTimeDayID] ASC)
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
PRINT N'Creating [dbo].[tblDoctorBlockTimeSlot]...';


GO
CREATE TABLE [dbo].[tblDoctorBlockTimeSlot] (
    [DoctorBlockTimeSlotID]        INT          IDENTITY (1, 1) NOT NULL,
    [DoctorBlockTimeDayID]         INT          NOT NULL,
    [[DoctorBlockTimeSlotStatusID] INT          NOT NULL,
    [StartTime]                    DATETIME     NOT NULL,
    [Duration]                     INT          NULL,
    [DisplayOrder]                 INT          NULL,
    [HoldDescription]              VARCHAR (50) NULL,
    [CaseApptRequestID]            INT          NULL,
    [CaseApptID]                   INT          NULL,
    [DateAdded]                    DATETIME     NULL,
    [UserIDAdded]                  VARCHAR (15) NULL,
    [DateEdited]                   DATETIME     NULL,
    [UserIDEdited]                 VARCHAR (15) NULL,
    CONSTRAINT [PK_tblDoctorBlockTimeSlot] PRIMARY KEY CLUSTERED ([DoctorBlockTimeSlotID] ASC)
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
PRINT N'Creating [dbo].[tblDoctorBlockTimeSlotStatus]...';


GO
CREATE TABLE [dbo].[tblDoctorBlockTimeSlotStatus] (
    [DoctorBlockTimeSlotStatusID] INT          NOT NULL,
    [Name]                        VARCHAR (20) NULL,
    CONSTRAINT [PK_tblDoctorBlockTimeSlotStatus] PRIMARY KEY CLUSTERED ([DoctorBlockTimeSlotStatusID] ASC)
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
PRINT N'Altering [dbo].[vwAssocCases]...';


GO
ALTER VIEW vwAssocCases
AS
    SELECT
        tblDoctor.LastName,
        tblDoctor.FirstName,
        tblDoctor.Credentials AS degree,
        tblSpecialty.Description AS Specialty,
        tblCase.ApptDate,
        tblCase.ApptTime,
        tblCase.CaseNbr,
        tblCase.MasterSubCase,
        tblCase.MasterCaseNbr,
        tblDoctor.Prefix,
        tblSpecialty.SpecialtyCode,
        tblDoctor.DoctorCode,
        tblDoctor.WCNbr,
        tblDoctor.UnRegNbr,
        tblServices.Description AS Service,
        tblLocation.Addr1,
        tblLocation.Addr2,
        tblLocation.City,
        tblLocation.State,
        tblLocation.Zip,
        tblLocation.Phone,
        tblLocation.Fax,
        tblCaseAppt.Duration,
        tblCase.Status,
        tblProviderType.Description AS DoctorProviderType
    FROM
        tblServices
    INNER JOIN tblCase ON tblServices.ServiceCode=tblCase.ServiceCode
    LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode=tblDoctor.DoctorCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblProviderType ON tblDoctor.ProvTypeCode=tblProviderType.ProvTypeCode
    LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
    LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty=tblSpecialty.SpecialtyCode
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
PRINT N'Altering [dbo].[vwDocument]...';


GO
ALTER VIEW vwDocument
AS
    SELECT  tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblCase.ClaimNbr ,
			tblCase.AddlClaimNbrs, 

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
            UPPER(tblExaminee.State) AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + UPPER(tblExaminee.State) + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
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
            UPPER(tblExaminee.InsuredState) AS InsuredState ,
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
            UPPER(tblExaminee.TreatingPhysicianState) AS TreatingPhysicianState ,
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
              THEN UPPER(tblExaminee.EmployerState)  
			  ELSE UPPER(tblEmployerAddress.State)  
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
            tblClient.City + ', ' + UPPER(tblClient.State) + '  ' + tblClient.Zip AS ClientCityStateZip ,
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
            UPPER(tblClient.BillState) AS BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            UPPER(tblClient.State) AS ClientState ,
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
            tblDoctor.City + ', ' + UPPER(tblDoctor.State) + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
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
            UPPER(tblDoctor.remitState) AS remitState ,
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
            UPPER(tblDoctor.State) AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
			tblLocation.AddressInstructions,
            tblLocation.City + ', ' + UPPER(tblLocation.State) + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
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
            UPPER(tblLocation.State) AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            UPPER(tblLocation.State) AS State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + UPPER(tblCCAddress_2.State) + '  ' + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            UPPER(tblCCAddress_2.State) AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + UPPER(tblCCAddress_1.State) + '  ' + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            UPPER(tblCCAddress_1.State) AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + UPPER(tblCCAddress_3.State) + '  ' + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
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

            tblCaseAppt.duration AS ApptDuration ,

            tblProviderType.description AS DoctorProviderType ,

            tblVenue.County AS Venue ,

            tblOffice.description AS office ,
			tblOffice.ShortDesc AS OfficeShortDesc ,
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,
			tblOffice.NYWCCompanyName ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany,                          
			
			tblCase.DateOfInjury2 AS DOI2, 
			tblCase.DateOfInjury3 AS DOI3, 
			tblCase.DateOfInjury4 AS DOI4,
			tblCase.InsuringCompany as InsuringCompany,
			tblCase.CaseCaption, 
			tblCase.LitigationNotes, 
			tblCase.BillClientCode

    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode

            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
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
PRINT N'Altering [dbo].[vwDocumentAccting]...';


GO
ALTER VIEW vwDocumentAccting
AS
    SELECT  tblCase.CaseNbr ,
			tblCase.ExtCaseNbr,
            tblCase.ClaimNbr ,
			tblCase.AddlClaimNbrs,

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
            UPPER(tblExaminee.State) AS ExamineeState ,
            tblExaminee.Zip AS ExamineeZip ,
            tblExaminee.lastName AS ExamineelastName ,
            tblExaminee.firstName AS ExamineefirstName ,
            tblExaminee.Addr1 AS ExamineeAddr1 ,
            tblExaminee.Addr2 AS ExamineeAddr2 ,
            tblExaminee.City + ', ' + UPPER(tblExaminee.State) + '  ' + tblExaminee.Zip AS ExamineeCityStateZip ,
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
            UPPER(tblExaminee.InsuredState) AS InsuredState ,
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
            UPPER(tblExaminee.TreatingPhysicianState) AS TreatingPhysicianState,
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
              THEN UPPER(tblExaminee.EmployerState)  
			  ELSE UPPER(tblEmployerAddress.State)  
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
            tblClient.City + ', ' + UPPER(tblClient.State) + '  ' + tblClient.Zip AS ClientCityStateZip ,
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
            UPPER(tblClient.BillState) AS BillState ,
            tblClient.BillZip ,
            tblClient.Billattn ,
            tblClient.ARKey ,
            tblClient.BillFax AS ClientBillFax ,
            tblClient.lastName AS ClientlastName ,
            tblClient.firstName AS ClientfirstName ,
            UPPER(tblClient.State) AS ClientState ,
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
            tblDoctor.City + ', ' + UPPER(tblDoctor.State) + '  ' + tblDoctor.Zip AS DoctorcorrespCityStateZip ,
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
            UPPER(tblDoctor.remitState) AS remitState ,
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
            UPPER(tblDoctor.State) AS DoctorcorrespState ,
            tblDoctor.CompanyName AS PracticeName ,
            tblDoctor.NPINbr AS DoctorNPINbr ,
            tblDoctor.ProvTypeCode ,
            tblDoctor.PrintOnCheckAs ,

            tblLocation.ExtName AS LocationExtName ,
            tblLocation.Location ,
            tblLocation.Addr1 AS DoctorAddr1 ,
            tblLocation.Addr2 AS DoctorAddr2 ,
			tblLocation.AddressInstructions,
            tblLocation.City + ', ' + UPPER(tblLocation.State) + '  ' + tblLocation.Zip AS DoctorCityStateZip ,
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
            UPPER(tblLocation.State) AS DoctorState ,
            tblLocation.City AS DoctorCity ,
            tblLocation.Zip AS DoctorZip ,
            UPPER(tblLocation.State) AS State ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_2.firstName, '') + ' ' + ISNULL(tblCCAddress_2.lastName, '') AS PAttorneysalutation ,
            tblCCAddress_2.Company AS PAttorneyCompany ,
            tblCCAddress_2.Address1 AS PAttorneyAddr1 ,
            tblCCAddress_2.Address2 AS PAttorneyAddr2 ,
            tblCCAddress_2.City + ', ' + UPPER(tblCCAddress_2.State) + '  ' + tblCCAddress_2.Zip AS PAttorneyCityStateZip ,
            tblCCAddress_2.Phone + ISNULL(tblCCAddress_2.PhoneExtension, '') AS PAttorneyPhone ,
            tblCCAddress_2.Fax AS PAttorneyFax ,
            tblCCAddress_2.Email AS PAttorneyEmail ,
            tblCCAddress_2.Prefix AS pAttorneyPrefix ,
            tblCCAddress_2.lastName AS pAttorneylastName ,
            tblCCAddress_2.firstName AS pAttorneyfirstName ,
            UPPER(tblCCAddress_2.State) AS pAttorneyState ,
            tblCCAddress_2.City AS pAttorneyCity ,
            tblCCAddress_2.Zip AS pAttorneyZip ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
            tblCCAddress_1.Company AS DAttorneyCompany ,
            tblCCAddress_1.Address1 AS DAttorneyAddr1 ,
            tblCCAddress_1.Address2 AS DAttorneyAddr2 ,
            tblCCAddress_1.City + ', ' + UPPER(tblCCAddress_1.State) + '  ' + tblCCAddress_1.Zip AS DAttorneyCityStateZip ,
            tblCCAddress_1.Phone + ' ' + ISNULL(tblCCAddress_1.PhoneExtension, '') AS DattorneyPhone ,
            tblCCAddress_1.Prefix AS dAttorneyPrefix ,
            tblCCAddress_1.lastName AS dAttorneylastName ,
            tblCCAddress_1.firstName AS dAttorneyfirstName ,
            tblCCAddress_1.Fax AS DAttorneyFax ,
            tblCCAddress_1.Email AS DAttorneyEmail ,
            tblCCAddress_1.Fax ,
            UPPER(tblCCAddress_1.State) AS dAttorneyState ,

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + UPPER(tblCCAddress_3.State) + '  ' + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
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

            tblCaseAppt.duration AS ApptDuration ,

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
            LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
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
PRINT N'Altering [dbo].[vwRptProgressiveRptWebLog]...';


GO

ALTER VIEW [dbo].[vwRptProgressiveRptWebLog]
AS
SELECT 
C.CaseNbr,
CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
EE.firstName + ' ' + EE.lastName AS Examinee,
CDT.Description AS DocType,
CD.Description AS DocDescrip,
POW.DateAdded AS DateUploaded,
CL.FirstName + ' ' + CL.LastName AS Client,
CL.EmployeeNumber AS ClientEmployeeNumber,
CL1.FirstName + ' ' + CL1.LastName AS ClientViewer,
CL1.EmployeeNumber AS ClientViewerEmployeeNumber,
TCD.FirstViewedOnWebDate AS DateViewed,
DATEDIFF(DAY, POW.DateAdded, TCD.FirstViewedOnWebDate) AS Days, 
S.Description AS Service,
CT.Description AS ClaimType,
C.ApptDate,
C.DoctorSpecialty,
C.DoctorName,
C.DateOfInjury,

CL.CompanyCode,
dbo.fnDateValue(POW.DateAdded) AS FilterDate

FROM tblCaseDocuments AS CD
INNER JOIN tblCaseDocType AS CDT ON CDT.CaseDocTypeID = CD.CaseDocTypeID
INNER JOIN tblPublishOnWeb AS POW ON POW.TableType='tblCaseDocuments' AND POW.TableKey=CD.SeqNo
INNER JOIN tblCaseDocuments AS TCD ON POW.TableKey = TCD.SeqNo
INNER JOIN tblWebUser AS TWU ON TCD.FirstViewedOnWebBy = TWU.UserID
INNER JOIN tblClient AS CL ON POW.UserType='CL' AND POW.UserCode=CL.ClientCode
INNER JOIN tblClient AS CL1 ON TWU.UserType='CL' AND TWU.IMECentricCode = CL1.ClientCode
INNER JOIN tblCase AS C ON C.CaseNbr = CD.CaseNbr
INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
WHERE CD.CaseDocTypeID=5 OR CD.Description LIKE '%Closed Letter%'
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
PRINT N'Altering [dbo].[vwServiceWorkflowQueue]...';


GO
ALTER VIEW vwServiceWorkflowQueue
AS
    SELECT
        WFQ.ServiceWorkflowQueueID,
        WFQ.ServiceWorkflowID,
        WFQ.DateAdded,
        WFQ.DateEdited,
        WFQ.UserIDAdded,
        WFQ.UserIDEdited,
        WFQ.QueueOrder,
        WFQ.StatusCode,
        WFQ.NextStatus,
        WFQ.CreateVoucher,
        WFQ.CreateInvoice,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.CaseTypeDesc,
        WF.CaseTypeStatus,
        WF.ServiceDesc,
        WF.ServiceStatus,
        WF.OfficeDesc,
        WF.OfficeStatus,
        Q.DisplayOrder,
        Q.StatusDesc AS QueueDesc,
        Q.ShortDesc,
		Q.DoNotAllowManualChange,
        WFQD.DocCount
    FROM
        tblServiceWorkflowQueue AS WFQ
    INNER JOIN vwServiceWorkflow AS WF ON WF.ServiceWorkflowID=WFQ.ServiceWorkflowID
    INNER JOIN tblQueues AS Q ON Q.StatusCode=WFQ.StatusCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowQueueID,
                        COUNT(ServiceWorkflowQueueDocumentID) AS DocCount
                     FROM
                        tblServiceWorkflowQueueDocument
                     GROUP BY
                        ServiceWorkflowQueueID
                    ) AS WFQD ON WFQD.ServiceWorkflowQueueID=WFQ.ServiceWorkflowQueueID
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
PRINT N'Creating [dbo].[vwCaseWebReservedAppts]...';


GO
CREATE VIEW vwCaseWebReservedAppts
AS
    SELECT 
            tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.MarketerCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            tblCase.Priority ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr + ' ' + ISNULL(tblCase.ClaimNbrExt, '') AS ClaimNbr,
            tblLocation.Location ,
            tblCase.ApptSelect ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            DATEDIFF(day, tblCase.LastStatuschg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,

            DBTD.ScheduleDate ,
            DBTD.DoctorCode ,
            DBTD.LocationCode AS doctorLocation,
            tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName, ' ') AS DoctorName ,

            tblqueues.FunctionCode ,
            tblCase.Casetype ,
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID, 
			tblCase.Jurisdiction, 
			CaseType.ShortDesc AS CaseTypeDesc 
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
			INNER JOIN tblCaseApptRequest AS ApptReq ON tblCase.CaseNbr = ApptReq.CaseNbr
            LEFT JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
			LEFT JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT JOIN tblCaseType AS CaseType ON CaseType.Code = tblCase.CaseType
			LEFT JOIN tblDoctorBlockTimeSlot AS DBTS ON ApptReq.CaseApptRequestID = DBTS.CaseApptRequestID
			LEFT JOIN tblDoctorBlockTimeDay AS DBTD ON DBTS.DoctorBlockTimeDayID = DBTD.DoctorBlockTimeDayID
            LEFT JOIN tblLocation ON DBTD.LocationCode = tblLocation.LocationCode
            LEFT JOIN tblDoctor ON DBTD.DoctorCode = tblDoctor.DoctorCode
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
PRINT N'Creating [dbo].[vwRptDaySheetNew]...';


GO

-- Issue 4744 - JAP - added DoctorOffice column to result set
CREATE VIEW vwRptDaySheetNew
AS

     SELECT CA.CaseApptID AS SchedCode,
            CA.DoctorCode ,            
			CA.LocationCode ,
            CAST(CAST(CA.ApptTime AS DATE) AS DATETIME) AS Date,
            CA.ApptTime AS StartTime, 
            APS.Name  AS Status,

            C.CaseNbr , 
			C.ExtCaseNbr , 
            CAST(C.SpecialInstructions AS VARCHAR(1000)) AS SpecialInstructions ,
            C.PhotoRqd ,
            C.PanelNbr ,
            C.DoctorName AS PanelDesc,
            C.OfficeCode,

            CASE WHEN C.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter,

            CT.Description AS Casetypedesc ,

            EE.FirstName + ' ' + EE.LastName AS ExamineeName ,

            CO.ExtName AS Company ,

            CL.FirstName + ' ' + CL.LastName AS ClientName ,
            CL.Phone1 AS ClientPhone ,

			LO.OfficeCode as LocationOffice,
            L.Location,
			L.Addr1,
            L.Addr2,
            L.City,
            L.State,
            L.Zip,
            L.Phone AS DoctorPhone ,
            L.Fax AS DoctorFax ,

            EWF.LegalName AS CompanyName ,

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName ,
		    DRO.OfficeCode as DoctorOffice,

            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = C.CaseNbr
                      ) = 'F' 
			  THEN 'Films'
                 ELSE ''
            END AS films , 

            S.ShortDesc ,

		    CASE WHEN C.LanguageID > 0 
			  THEN LA.Description
			  ELSE ''
		    END AS [Language]

    FROM    tblCaseAppt AS CA
				INNER JOIN tblCase AS C ON CA.CaseApptID = C.CaseApptID
				INNER JOIN tblExaminee AS EE on C.ChartNbr = EE.ChartNbr
				INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
				INNER JOIN tblCompany AS CO on CL.CompanyCode = CO.CompanyCode
				INNER JOIN tblCaseType AS CT on C.CaseType = CT.Code		
				INNER JOIN tblServices AS S on C.ServiceCode = S.ServiceCode 

				INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
				INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID

				LEFT JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = C.CaseApptID
				INNER JOIN tblDoctor AS DR ON DR.DoctorCode = ISNULL(CA.DoctorCode, CAP.DoctorCode)
				INNER JOIN tblLocation AS L ON CA.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode
				LEFT JOIN tblLanguage AS LA ON LA.LanguageID = C.LanguageID	
				INNER JOIN tblApptStatus AS APS ON APS.ApptStatusID = CA.ApptStatusID AND CA.ApptStatusID = 10
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
PRINT N'Creating [dbo].[vwRptDoctorSchedule]...';


GO
CREATE VIEW vwRptDoctorSchedule
AS
     SELECT CA.CaseApptID AS RecID,
            CA.DoctorCode ,            
			CA.LocationCode ,
            CAST(CAST(CA.ApptTime AS DATE) AS DATETIME) AS Date,
            CA.ApptTime AS StartTime, 

            C.CaseNbr , 
			C.ExtCaseNbr , 
            CAST(C.SpecialInstructions AS VARCHAR(1000)) AS SpecialInstructions ,
            C.PhotoRqd ,
            C.PanelNbr ,
            C.DoctorName AS PanelDesc,
            C.OfficeCode AS CaseOfficeCode,

            CASE WHEN C.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter,

            EE.FirstName + ' ' + EE.LastName AS ScheduleDesc1,

			ISNULL(CT.ShortDesc, '') + ' / ' + ISNULL(S.Description, '') AS ScheduleDesc2,

            CO.ExtName AS Company ,

            CL.FirstName + ' ' + CL.LastName AS ClientName ,
            CL.Phone1 AS ClientPhone ,

			LO.OfficeCode as LocationOfficeCode,
            L.Location,
			L.Addr1,
            L.Addr2,
            L.City,
            L.State,
            L.Zip,
            L.Phone AS LocationPhone ,
            L.Fax AS LocationFax ,

            EWF.LegalName AS CompanyName ,

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName,

			ISNULL((STUFF((
			SELECT CHAR(13)+ CAST(P.Description AS VARCHAR)
			FROM tblProblem AS P
			INNER JOIN tblCaseProblem AS CP ON CP.ProblemCode = P.ProblemCode
			WHERE CP.CaseNbr=C.CaseNbr
			FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,1,'')),'') AS Problem

    FROM    tblCaseAppt AS CA

				INNER JOIN tblCase AS C ON CA.CaseApptID = C.CaseApptID
				INNER JOIN tblExaminee AS EE on C.ChartNbr = EE.ChartNbr
				INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
				INNER JOIN tblCompany AS CO on CL.CompanyCode = CO.CompanyCode
				INNER JOIN tblCaseType AS CT on C.CaseType = CT.Code		
				INNER JOIN tblServices AS S on C.ServiceCode = S.ServiceCode 

				INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
				INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID

				LEFT JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = C.CaseApptID
				INNER JOIN tblDoctor AS DR ON DR.DoctorCode = ISNULL(CA.DoctorCode, CAP.DoctorCode)
				INNER JOIN tblLocation AS L ON CA.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode

	WHERE CA.ApptStatusID IN (10,100,101,102)
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
PRINT N'Creating [dbo].[vwRptDoctorScheduleSlot]...';


GO
CREATE VIEW vwRptDoctorScheduleSlot
AS
     SELECT CA.SchedCode AS RecID,
            CA.DoctorCode,            
			CA.LocationCode,
            CAST(CAST(CA.Date AS DATE) AS DATETIME) AS Date,
            CA.StartTime AS StartTime, 

            NULL AS CaseNbr , 
			NULL AS ExtCaseNbr , 
            '' AS SpecialInstructions ,
            NULL AS PhotoRqd ,
            NULL AS PanelNbr ,
            '' AS PanelDesc,
            NULL AS CaseOfficeCode,

            '' AS Interpreter,

            CA.Status AS ScheduleDesc1,

			CA.Description AS ScheduleDesc2,

            '' AS Company ,

            '' AS ClientName ,
            '' AS ClientPhone ,

			LO.OfficeCode as LocationOfficeCode,
            L.Location,
			L.Addr1,
            L.Addr2,
            L.City,
            L.State,
            L.Zip,
            L.Phone AS LocationPhone ,
            L.Fax AS LocationFax ,

            EWF.LegalName AS CompanyName ,

            ISNULL(DR.FirstName, '') + ' ' + ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.Credentials, '') AS DoctorName,

			'' AS Problem

    FROM    tblDoctorSchedule AS CA

				INNER JOIN tblDoctor AS DR ON DR.DoctorCode = CA.DoctorCode
				INNER JOIN tblLocation AS L ON CA.LocationCode = L.LocationCode

				INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
				INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode

				INNER JOIN tblOffice AS O ON DRO.OfficeCode = O.OfficeCode
				INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID


	WHERE CA.Status IN ('Open', 'Hold', 'Held')
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
ALTER TABLE tblCase ADD RptQADraftDate DATETIME NULL
ALTER TABLE tblCase ADD TATQADraftToQAComplete INT NULL
GO

  INSERT INTO tblDataField (DataFieldID, TableName, FieldName, Descrip) VALUES
  (214, 'tblCase', 'RptQADraftDate', 'Report QA Draft Date'),
  (120, 'tblCase', 'TATQADraftToQAComplete', '')

  INSERT INTO tblTATCalculationMethod (TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend) VALUES
(20, 214, 204, 'Day', 120, 0)


  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 7 WHERE TATCalculationMethodID = 2 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 9 WHERE TATCalculationMethodID = 3 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 10 WHERE TATCalculationMethodID = 4 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 11 WHERE TATCalculationMethodID = 16 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 12 WHERE TATCalculationMethodID = 9 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 13 WHERE TATCalculationMethodID = 5 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 14 WHERE TATCalculationMethodID = 17 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 15 WHERE TATCalculationMethodID = 18 AND TATCalculationGroupID = 1
  UPDATE tblTATCalculationGroupDetail SET DisplayOrder = 16 WHERE TATCalculationMethodID = 19 AND TATCalculationGroupID = 1

  INSERT INTO tblTATCalculationGroupDetail (TATCalculationGroupID, TATCalculationMethodID, DisplayOrder) VALUES
  (1, 20, 8)


INSERT INTO tblQueueForms VALUES ('frmStatusWbRsvdAppts', 'Form for Web Rerserved Appointments')

SET IDENTITY_INSERT tblQueues ON
GO
INSERT INTO tblQueues (StatusCode, StatusDesc, Type, ShortDesc, DisplayOrder, 
	FormToOpen, DateAdded, DateEdited, UserIDAdded, UserIDEdited, 
	Status, SubType, FunctionCode, WebStatusCode, NotifyScheduler, 
	NotifyQARep, NotifyIMECompany, WebGUID, AllowToAwaitingScheduling, IsConfirmation, 
	WebStatusCodeV2, AwaitingReptDictation, AwaitingReptApproval, DoNotAllowManualChange)
VALUES(34, 'Web Reserved Appointment', 'System', 'WbRsvdAppt', 50, 
		'frmStatusWbRsvdAppts', GETDATE(), NULL, 'TLyde', NULL,
		'Active', 'Case', 'None', NULL, 0,
		0, 1, NULL, NULL, 0, 
		NULL, Null, NULL, 1)
GO
SET IDENTITY_INSERT tblQueues OFF


GO


UPDATE tblControl SET ApptRequestStatusCode = 34, ApptRequestDoctorReasonID = 4 WHERE InstallID = 1

UPDATE tblWebUser SET AllowScheduling = 0 
GO

UPDATE CA SET CA.Duration=DS.Duration
 FROM tblCaseAppt AS CA
 INNER JOIN tblCase AS C ON C.CaseApptID = CA.CaseApptID
 INNER JOIN tblDoctorSchedule AS DS ON DS.SchedCode = C.SchedCode

UPDATE tblCaseAppt SET Duration=1 WHERE Duration IS NULL


GO

