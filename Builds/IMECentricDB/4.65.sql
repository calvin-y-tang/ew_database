
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
    ADD [TATNoShowToScheduled]            INT           NULL,
        [SLAExScheduledToExam]            VARCHAR (275) NULL,
        [SLAExExamToClientNotified]       VARCHAR (275) NULL,
        [SLAExAwaitingScheduling]         VARCHAR (275) NULL,
        [SLAExAwaitingSchedulingToExam]   VARCHAR (275) NULL,
        [SALExEnteredToExam]              VARCHAR (275) NULL,
        [SLAExDateLossToApptDate]         VARCHAR (275) NULL,
        [SLAExExamSchedToQuoteSent]       VARCHAR (275) NULL,
        [SLAExExamSchedToApprovalSent]    VARCHAR (275) NULL,
        [SLAExExamDateToNotifyShowNoShow] VARCHAR (275) NULL;


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
PRINT N'Altering [dbo].[tblCaseSLARuleDetail]...';


GO
ALTER TABLE [dbo].[tblCaseSLARuleDetail]
    ADD [StartCaseApptID] INT NULL,
        [EndCaseApptID]   INT NULL;


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
PRINT N'Altering [dbo].[tblTATCalculationMethod]...';


GO
ALTER TABLE [dbo].[tblTATCalculationMethod]
    ADD [ApptEnabled]                 BIT CONSTRAINT [DF_tblTATCalculationMethod_ApptEnabled] DEFAULT (0) NULL,
        [ApptSLAExceptionDataFieldID] INT NULL;


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

            tblEmployer.EWParentEmployerID, 
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
              THEN NULL 
			  ELSE tblEmployerAddress.Address2 
			  END) AS EmployerAddr2,  

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

            BCL.firstName + ' ' + BCL.lastName AS BillClientName ,
            BCL.Phone1 + ' ' + ISNULL(BCL.Phone1ext, ' ') AS BillClientPhone ,
            BCL.Phone2 + ' ' + ISNULL(BCL.Phone2ext, ' ') AS BillClientPhone2 ,
            BCL.Addr1 AS BillClientAddr1 ,
            BCL.Addr2 AS BillClientAddr2 ,
            BCL.City + ', ' + UPPER(BCL.State) + '  ' + BCL.Zip AS BillClientCityStateZip ,
            BCL.Fax AS BillClientFax ,
            BCL.Email AS BillClientEmail ,
            'Dear ' + BCL.firstName + ' ' + BCL.lastName AS BillClientSalutation ,
            BCL.title AS BillClienttitle ,
            BCL.Prefix AS BillClientPrefix ,
            BCL.suffix AS BillClientsuffix ,
            BCL.USDvarchar1 AS BillClientUSDvarchar1 ,
            BCL.USDvarchar2 AS BillClientUSDvarchar2 ,
            BCL.USDDate1 AS BillClientUSDDate1 ,
            BCL.USDDate2 AS BillClientUSDDate2 ,
            BCL.USDtext1 AS BillClientUSDtext1 ,
            BCL.USDtext2 AS BillClientUSDtext2 ,
            BCL.USDint1 AS BillClientUSDint1 ,
            BCL.USDint2 AS BillClientUSDint2 ,
            BCL.USDmoney1 AS BillClientUSDmoney1 ,
            BCL.USDmoney2 AS BillClientUSDmoney2 ,
            BCL.CompanyCode AS BillClientCompanyCode ,
            BCL.Notes AS BillClientNotes ,
            BCL.BillAddr1 AS BillClientBillAddr1,
            BCL.BillAddr2 AS BillClientBillAddr2,
            BCL.BillCity AS BillClientBillCity,
            UPPER(BCL.BillState) AS BillClientBillState ,
            BCL.BillZip AS BillClientBillZip,
            BCL.Billattn AS BillClientBillattn,
            BCL.ARKey AS BillClientARKey,
            BCL.BillFax AS BillClientBillFax ,
            BCL.lastName AS BillClientlastName ,
            BCL.firstName AS BillClientfirstName ,
            UPPER(BCL.State) AS BillClientState ,
            BCL.City AS BillClientCity ,
            BCL.Zip AS BillClientZip ,

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

            BCO.extName AS BillingCompany ,
            BCO.USDvarchar1 AS BillingCompanyUSDvarchar1 ,
            BCO.USDvarchar2 AS BillingCompanyUSDvarchar2 ,
            BCO.USDDate1 AS BillingCompanyUSDDate1 ,
            BCO.USDDate2 AS BillingCompanyUSDDate2 ,
            BCO.USDtext1 AS BillingCompanyUSDtext1 ,
            BCO.USDtext2 AS BillingCompanyUSDtext2 ,
            BCO.USDint1 AS BillingCompanyUSDint1 ,
            BCO.USDint2 AS BillingCompanyUSDint2 ,
            BCO.USDmoney1 AS BillingCompanyUSDmoney1 ,
            BCO.USDmoney2 AS BillingCompanyUSDmoney2 ,
            BCO.Notes AS BillingCompanyNotes ,

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
			tblCase.BillClientCode,
            tblCase.WorkCompCaseType, 
			tblEWParentCompany.Name AS ParentCompanyName

    FROM    tblCase
            INNER JOIN vwtblExaminee AS tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
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

            LEFT JOIN tblClient AS BCL ON tblCase.BillClientCode = BCL.ClientCode
            LEFT JOIN tblCompany AS BCO ON BCL.CompanyCode = BCO.CompanyCode

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
			LEFT OUTER JOIN tblEWParentCompany ON tblCompany.ParentCompanyID = tblEWParentCompany.ParentCompanyID
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

            tblEmployer.EWParentEmployerID, 
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
              THEN NULL 
			  ELSE tblEmployerAddress.Address2 
			  END) AS EmployerAddr2,  

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

            BCL.firstName + ' ' + BCL.lastName AS BillClientName ,
            BCL.Phone1 + ' ' + ISNULL(BCL.Phone1ext, ' ') AS BillClientPhone ,
            BCL.Phone2 + ' ' + ISNULL(BCL.Phone2ext, ' ') AS BillClientPhone2 ,
            BCL.Addr1 AS BillClientAddr1 ,
            BCL.Addr2 AS BillClientAddr2 ,
            BCL.City + ', ' + UPPER(BCL.State) + '  ' + BCL.Zip AS BillClientCityStateZip ,
            BCL.Fax AS BillClientFax ,
            BCL.Email AS BillClientEmail ,
            'Dear ' + BCL.firstName + ' ' + BCL.lastName AS BillClientSalutation ,
            BCL.title AS BillClienttitle ,
            BCL.Prefix AS BillClientPrefix ,
            BCL.suffix AS BillClientsuffix ,
            BCL.USDvarchar1 AS BillClientUSDvarchar1 ,
            BCL.USDvarchar2 AS BillClientUSDvarchar2 ,
            BCL.USDDate1 AS BillClientUSDDate1 ,
            BCL.USDDate2 AS BillClientUSDDate2 ,
            BCL.USDtext1 AS BillClientUSDtext1 ,
            BCL.USDtext2 AS BillClientUSDtext2 ,
            BCL.USDint1 AS BillClientUSDint1 ,
            BCL.USDint2 AS BillClientUSDint2 ,
            BCL.USDmoney1 AS BillClientUSDmoney1 ,
            BCL.USDmoney2 AS BillClientUSDmoney2 ,
            BCL.CompanyCode AS BillClientCompanyCode ,
            BCL.Notes AS BillClientNotes ,
            BCL.BillAddr1 AS BillClientBillAddr1,
            BCL.BillAddr2 AS BillClientBillAddr2,
            BCL.BillCity AS BillClientBillCity,
            UPPER(BCL.BillState) AS BillClientBillState ,
            BCL.BillZip AS BillClientBillZip,
            BCL.Billattn AS BillClientBillattn,
            BCL.ARKey AS BillClientARKey,
            BCL.BillFax AS BillClientBillFax ,
            BCL.lastName AS BillClientlastName ,
            BCL.firstName AS BillClientfirstName ,
            UPPER(BCL.State) AS BillClientState ,
            BCL.City AS BillClientCity ,
            BCL.Zip AS BillClientZip ,

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

            BCO.extName AS BillingCompany ,
            BCO.USDvarchar1 AS BillingCompanyUSDvarchar1 ,
            BCO.USDvarchar2 AS BillingCompanyUSDvarchar2 ,
            BCO.USDDate1 AS BillingCompanyUSDDate1 ,
            BCO.USDDate2 AS BillingCompanyUSDDate2 ,
            BCO.USDtext1 AS BillingCompanyUSDtext1 ,
            BCO.USDtext2 AS BillingCompanyUSDtext2 ,
            BCO.USDint1 AS BillingCompanyUSDint1 ,
            BCO.USDint2 AS BillingCompanyUSDint2 ,
            BCO.USDmoney1 AS BillingCompanyUSDmoney1 ,
            BCO.USDmoney2 AS BillingCompanyUSDmoney2 ,
            BCO.Notes AS BillingCompanyNotes ,

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
            tblCase.WorkCompCaseType,

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

			tblCase.InsuringCompany as InsuringCompany,
            tblEWParentCompany.Name AS ParentCompanyName

    FROM    tblCase
            INNER JOIN vwtblExaminee AS tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
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

            LEFT JOIN tblClient AS BCL ON tblCase.BillClientCode = BCL.ClientCode
            LEFT JOIN tblCompany AS BCO ON BCL.CompanyCode = BCO.CompanyCode
			
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
			LEFT OUTER JOIN tblEWParentCompany ON tblCompany.ParentCompanyID = tblEWParentCompany.ParentCompanyID
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
PRINT N'Altering [dbo].[vwDocumentNoLock]...';


GO
ALTER VIEW [dbo].[vwDocumentNoLock]
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

            tblEmployer.EWParentEmployerID, 
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
              THEN NULL 
			  ELSE tblEmployerAddress.Address2 
			  END) AS EmployerAddr2,  

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

            BCL.firstName + ' ' + BCL.lastName AS BillClientName ,
            BCL.Phone1 + ' ' + ISNULL(BCL.Phone1ext, ' ') AS BillClientPhone ,
            BCL.Phone2 + ' ' + ISNULL(BCL.Phone2ext, ' ') AS BillClientPhone2 ,
            BCL.Addr1 AS BillClientAddr1 ,
            BCL.Addr2 AS BillClientAddr2 ,
            BCL.City + ', ' + UPPER(BCL.State) + '  ' + BCL.Zip AS BillClientCityStateZip ,
            BCL.Fax AS BillClientFax ,
            BCL.Email AS BillClientEmail ,
            'Dear ' + BCL.firstName + ' ' + BCL.lastName AS BillClientSalutation ,
            BCL.title AS BillClienttitle ,
            BCL.Prefix AS BillClientPrefix ,
            BCL.suffix AS BillClientsuffix ,
            BCL.USDvarchar1 AS BillClientUSDvarchar1 ,
            BCL.USDvarchar2 AS BillClientUSDvarchar2 ,
            BCL.USDDate1 AS BillClientUSDDate1 ,
            BCL.USDDate2 AS BillClientUSDDate2 ,
            BCL.USDtext1 AS BillClientUSDtext1 ,
            BCL.USDtext2 AS BillClientUSDtext2 ,
            BCL.USDint1 AS BillClientUSDint1 ,
            BCL.USDint2 AS BillClientUSDint2 ,
            BCL.USDmoney1 AS BillClientUSDmoney1 ,
            BCL.USDmoney2 AS BillClientUSDmoney2 ,
            BCL.CompanyCode AS BillClientCompanyCode ,
            BCL.Notes AS BillClientNotes ,
            BCL.BillAddr1 AS BillClientBillAddr1,
            BCL.BillAddr2 AS BillClientBillAddr2,
            BCL.BillCity AS BillClientBillCity,
            UPPER(BCL.BillState) AS BillClientBillState ,
            BCL.BillZip AS BillClientBillZip,
            BCL.Billattn AS BillClientBillattn,
            BCL.ARKey AS BillClientARKey,
            BCL.BillFax AS BillClientBillFax ,
            BCL.lastName AS BillClientlastName ,
            BCL.firstName AS BillClientfirstName ,
            UPPER(BCL.State) AS BillClientState ,
            BCL.City AS BillClientCity ,
            BCL.Zip AS BillClientZip ,

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

            BCO.extName AS BillingCompany ,
            BCO.USDvarchar1 AS BillingCompanyUSDvarchar1 ,
            BCO.USDvarchar2 AS BillingCompanyUSDvarchar2 ,
            BCO.USDDate1 AS BillingCompanyUSDDate1 ,
            BCO.USDDate2 AS BillingCompanyUSDDate2 ,
            BCO.USDtext1 AS BillingCompanyUSDtext1 ,
            BCO.USDtext2 AS BillingCompanyUSDtext2 ,
            BCO.USDint1 AS BillingCompanyUSDint1 ,
            BCO.USDint2 AS BillingCompanyUSDint2 ,
            BCO.USDmoney1 AS BillingCompanyUSDmoney1 ,
            BCO.USDmoney2 AS BillingCompanyUSDmoney2 ,
            BCO.Notes AS BillingCompanyNotes ,

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
			tblCase.BillClientCode,
            tblCase.WorkCompCaseType, 
			tblEWParentCompany.Name AS ParentCompanyName

    FROM    tblCase with (nolock)
            INNER JOIN vwtblExamineeNoLock AS tblExaminee with (nolock) ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice with (nolock) ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient with (nolock) ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany with (nolock) ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType with (nolock) ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues with (nolock) ON tblCase.status = tblQueues.statusCode

            LEFT OUTER JOIN tblDoctor with (nolock) ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblLocation with (nolock) ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblCaseAppt with (nolock) ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
            LEFT OUTER JOIN tblDoctorLocation with (nolock) ON tblCase.DoctorLocation = tblDoctorLocation.LocationCode
                                                 AND tblCase.DoctorCode = tblDoctorLocation.DoctorCode

            LEFT JOIN tblClient AS BCL with (nolock) ON tblCase.BillClientCode = BCL.ClientCode
            LEFT JOIN tblCompany AS BCO with (nolock) ON BCL.CompanyCode = BCO.CompanyCode

            LEFT OUTER JOIN tblSpecialty with (nolock) ON tblCase.Doctorspecialty = tblSpecialty.specialtyCode
            LEFT OUTER JOIN tblVenue with (nolock) ON tblCase.VenueID = tblVenue.VenueID
            LEFT OUTER JOIN tblProviderType with (nolock) ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode
            LEFT OUTER JOIN tblState with (nolock) ON tblCase.Jurisdiction = tblState.StateCode
            LEFT OUTER JOIN tblRecordStatus with (nolock) ON tblCase.recCode = tblRecordStatus.recCode
            LEFT OUTER JOIN tblUser with (nolock) ON tblCase.schedulerCode = tblUser.userid
            LEFT OUTER JOIN tblServices with (nolock) ON tblCase.serviceCode = tblServices.serviceCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_1 with (nolock) ON tblCase.defenseAttorneyCode = tblCCAddress_1.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_2 with (nolock) ON tblCase.plaintiffAttorneyCode = tblCCAddress_2.ccCode
            LEFT OUTER JOIN tblCCAddress AS tblCCAddress_3 with (nolock) ON tblCCAddress_3.ccCode = tblCase.DefParaLegal
            LEFT OUTER JOIN tblLanguage with (nolock) ON tblLanguage.LanguageID = tblCase.LanguageID
            LEFT OUTER JOIN tblTranscription with (nolock) ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblApptStatus with (nolock) ON tblCase.ApptStatusID = tblApptStatus.ApptStatusID
            LEFT OUTER JOIN tblEmployer with (nolock) on tblcase.EmployerID = tblEmployer.EmployerID 
            LEFT OUTER JOIN tblEmployerAddress with (nolock) on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID 
			LEFT OUTER JOIN tblEWParentCompany with (nolock) ON tblCompany.ParentCompanyID = tblEWParentCompany.ParentCompanyID
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
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255),
    @useCaseCompany BIT
AS 
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericInvoices') IS NOT NULL DROP TABLE ##tmp_GenericInvoices
print 'Gather main data set ...'

DECLARE @xml XML
DECLARE @xmlCompany XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)
SET @xmlCompany = CAST('<X>' + REPLACE(@companyCodeList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;
print 'Company Code List: ' + @companyCodeList;

WITH SLADetailsCTE AS
(SELECT DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '') as SLAReason, sla.CaseNbr
  FROM tblCaseSLARuleDetail as sla
LEFT OUTER JOIN tblSLAException as se on sla.SLAExceptionID = se.SLAExceptionID
LEFT OUTER JOIN tblSLARuleDetail as srd on sla.SLARuleDetailID = srd.SLARuleDetailID
LEFT OUTER JOIN tblTATCalculationMethod as tcm on srd.TATCalculationMethodID = tcm.TATCalculationMethodID
LEFT OUTER JOIN tblDataField as DF1 on tcm.StartDateFieldID = DF1.DataFieldID
LEFT OUTER JOIN tblDataField as DF2 on tcm.EndDateFieldID = DF2.DataFieldID
INNER JOIN tblCase as c on sla.CaseNbr = c.CaseNbr
INNER JOIN tblAcctHeader as ah on c.CaseNbr = ah.CaseNbr
WHERE ((LEN(se.Descrip) > 0) OR (LEN(sla.Explanation) > 0))
  AND (AH.DocumentType = 'IN'
  AND AH.DocumentStatus = 'Final'
  AND AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)  
GROUP BY (DF1.Descrip + ' to ' + DF2.Descrip + ': ' + se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '')), sla.CaseNbr
)
SELECT
  Inv.EWFacilityID,
  Inv.HeaderID,
  EWF.DBID as DBID,
  EWF.GPFacility + '-' + cast(Inv.DocumentNbr as varchar(15)) as InvoiceNo,
  Inv.DocumentDate as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  C.MasterCaseNbr,
  isnull(PC.Name, 'Other') as ParentCompany,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  COM.IntName as CaseCompanyInt,
  COM.ExtName as CaseCompanyExt,
  case when isnull(CLI.LastName, '') = '' then isnull(CLI.FirstName, '') else CLI.LastName+', '+isnull(CLI.FirstName, '') end as CaseClient,
  CO.State as CompanyState,
  EWCT.Name as CompanyType,
  CL.ClientCode as ClientID,
  case when isnull(CL.LastName, '') = '' then isnull(CL.FirstName, '') else CL.LastName+', '+isnull(CL.FirstName, '') end as Client,
  ISNULL(CL.Email, '') as ClientEmail,
  D.DoctorCode as DoctorID, 
  D.Zip as DoctorZip,
  CASE 
  WHEN c.PanelNbr IS NOT NULL THEN c.DoctorName 
  ELSE case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName+', '+isnull(D.FirstName, '') end
  END as Doctor, 
  C.DoctorReason,
  CT.Description as CaseType,
  BL.Name as BusinessLine,
  ST.Name as ServiceType,
  S.Description as Service,
  Inv.ClaimNbr as ClaimNo,
  C.SInternalCaseNbr as InternalCaseNbr,
  Inv.Examinee as Examinee,
  CASE ISNULL(C.EmployerID, 0)
    WHEN 0 THEN E.Employer
    ELSE EM.Name
  END AS Employer,
  E.DOB as "Examinee DOB",
  E.SSN as "Examinee SSN",
  O.ShortDesc as Office,
  EL.Location as ExamLocationName,
  EL.Addr1 as ExamLocationAddress1,
  EL.Addr2 as ExamLocationAddress2,
  EL.City as ExamLocationCity,
  EL.State as ExamLocationState,
  EL.Zip as ExamLocationZip,
  EL.County as ExamCounty,
  cast(case when isnull(M.FirstName, '') = '' then isnull(M.LastName, isnull(C.MarketerCode, '')) else M.FirstName+' '+isnull(M.LastName, '') end as varchar(30)) as Marketer,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  EWF.GPFacility as GPFacility,
  Inv.Finalized as DateFinalized,
  Inv.UserIDFinalized as UserFinalized,
  Inv.BatchNbr as GPBatchNo,
  Inv.ExportDate as GPBatchDate,
  BB.Descrip as BulkBilling,
  DOC.Description as InvoiceDocument,
  APS.Name as ApptStatus,
  AHAS.Name as InvApptStatus,
  CB.ExtName as CanceledBy,
  CA.Reason as CancelReason,
  isnull(Inv.ClientRefNbr, '') as ClientRefNo,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  C.ForecastDate,
  C.Jurisdiction,
  EWIS.Name as InputSource,
  EWIS.Mapping1 as SedgwickSource,
  isnull(CA.DateReceived, C.DateReceived) as DateReceived,
  CA.DateAdded as ApptMadeDate,
  C.OrigApptTime as OrigAppt,
  ISNULL(inv.CaseApptID, c.CaseApptID) as CaseApptID,
  CA.ApptTime as [ApptDate],
  C.RptFinalizedDate,
  C.RptSentDate,    
  C.DateMedsRecd as DateMedsReceived,
  C.OCF25Date,
  c.TATAwaitingScheduling,  
  c.TATEnteredToAcknowledged,
  c.TATEnteredToMRRReceived,
  c.TATEnteredToScheduled,
  c.TATExamToClientNotified,
  c.TATExamToRptReceived,
  c.TATQACompleteToRptSent,
  c.TATReport, 
  c.TATRptReceivedToQAComplete,
  c.TATRptSentToInvoiced,
  c.TATScheduledToExam,
  c.TATServiceLifeCycle, 
  C.DateAdded as CaseDateAdded,
  Inv.CaseDocID,
  case
    when EWReferralType=0 then ''
    when EWReferralType=1 then 'Incoming'
    when EWReferralType=2 then 'Outgoing'
    else 'Unknown'
  end as MigratingClaim,
  isnull(MCFGS.BusUnitGroupName, '') as MigratingClaimBusUnit,
  C.PhotoRqd,
  C.PhotoRcvd,
  isnull(C.TransportationRequired, 0) as TransportationRequired,
  isnull(C.InterpreterRequired, 0) as InterpreterRequired,
  LANG.Description as Language,
  '' as CaseIssues,
  case C.NeedFurtherTreatment when 1 then 'Pos' else 'Neg' end as Outcome,
  case C.IsReExam when 1 then 'Yes' else 'No' end as IsReExam,
  isnull(FZ.Name, '') as FeeZone,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID <> 50) as ApptCount,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID = 101) as NSCount,
  cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as TaxTotal,
  Inv.DocumentTotalUS-cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as Revenue,
  Inv.DocumentTotalUS as InvoiceTotal,
  isnull(VO.Expense, 0) as Expense,
  VO.VoucherCount as Vouchers,
  VO.VoucherDateMin as VoucherDate1,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMin as varchar(15)) as VoucherNo1,
  VO.VoucherDateMax as VoucherDate2,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMax as varchar(15)) as VoucherNo2,
  (select count(LI.LineNbr) from tblAcctDetail as LI where LI.HeaderID = Inv.HeaderID) as LineItems,
 STUFF((SELECT '; ' + SLAReason FROM SLADetailsCTE
    WHERE SLADetailsCTE.CaseNbr = inv.CaseNbr
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as SLAReasons,
  CONVERT(DATETIME,     NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32),  NULL) as ClaimantConfirmationStatus,
  CONVERT(INT,          NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME,     NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32),  NULL) as AttyConfirmationStatus,
  CONVERT(INT,          NULL) as AttyCallAttempts,  
  CONVERT(MONEY,        NULL) AS FeeDetailExam,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailExamUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailBillReview,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailBillRvwUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailPeer,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailPeerUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailAdd,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailAddUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailLegal,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailLegalUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailProcServ,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailProvServUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailDiag,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailDiagUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailNurseServ,
  CONVERT(MONEY,        NULL) AS FeeDetailPhone,
  CONVERT(MONEY,        NULL) AS FeeDetailMSA,
  CONVERT(MONEY,        NULL) AS FeeDetailClinical,
  CONVERT(MONEY,        NULL) AS FeeDetailTech,
  CONVERT(MONEY,        NULL) AS FeeDetailMedicare,
  CONVERT(MONEY,        NULL) AS FeeDetailOPO,
  CONVERT(MONEY,        NULL) AS FeeDetailRehab,
  CONVERT(MONEY,        NULL) AS FeeDetailAddRev,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailAddRevUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailTrans,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailTransUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailMileage,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailMileageUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailTranslate,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailTranslateUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailAdminFee,
  CONVERT(NUMERIC(10,2),NULL) AS FeeDetailAdminFeeUnit,
  CONVERT(MONEY,        NULL) AS FeeDetailFacFee,
  CONVERT(MONEY,        NULL) AS FeeDetailOther,
  ISNULL(C.InsuringCompany, '') as InsuringCompany,
  ISNULL(C.Priority, 'Normal') AS CasePriority,
  CONVERT(DATE, C.AwaitingScheduling) as DateAwaitingScheduling,
  CO.ParentCompanyID,
  CONVERT(VARCHAR(32), NULL) AS ClaimUniqueId,
  CONVERT(VARCHAR(32), NULL) AS CMSClaimNumber,
  CONVERT(VARCHAR(8),  NULL) AS ShortVendorId,
  CONVERT(VARCHAR(12), NULL) AS ProcessingOfficeId,
  CONVERT(VARCHAR(32), NULL) AS ReferralUniqueId,
  CONVERT(VARCHAR(12), NULL) AS ClientCustomerId,
  CONVERT(VARCHAR(128),NULL) AS ClientCustomerName,
  C.ClaimNbrExt as ClaimNoExt,
  CONVERT(VARCHAR(32), NULL) as FeeQuoteAmount,
  CONVERT(VARCHAR(32), NULL) as FeeScheduleAmount,
  CONVERT(VARCHAR(64), NULL) AS OutOfNetworkReason,
  CONVERT(VARCHAR(12), 'N/A') AS MedRecPages,
  CONVERT(VARCHAR(12), 'N/A') AS DocReviewPages,
  CONVERT(BIT, NULL) AS AddendumNeeded,
  C.[Status] as CaseStatus,
  C.DateReceived as CaseDateReceived,
  CA.DateShowNoShowLetterSent as DateSNSLetterSent,
  CONVERT(BIT, 
      CASE 
        WHEN DefenseAttorneyCode > 0 THEN 1
        ELSE 0
      END) [In Litigation]
INTO ##tmp_GenericInvoices
FROM tblAcctHeader AS Inv
left outer join tblCase as C on Inv.CaseNbr = C.CaseNbr
left outer join tblEmployer as EM on C.EmployerID = EM.EmployerID
left outer join tblClient as CL on Inv.ClientCode = CL.ClientCode		-- invoice client (billing client)
left outer join tblCompany as CO on CL.CompanyCode = CO.CompanyCode	    -- invoice company (billing company)
left outer join tblClient as CLI on C.ClientCode = CLI.ClientCode		-- case client
left outer join tblCompany as COM on CLI.CompanyCode = COM.CompanyCode	-- case company
left outer join tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
left outer join tblDoctor as D on Inv.DrOpCode = D.DoctorCode
left outer join vwtblExaminee as E on C.ChartNbr = E.ChartNbr
left outer join tblCaseType as CT on C.CaseType = CT.Code
left outer join tblServices as S on C.ServiceCode = S.ServiceCode
left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
left outer join tblEWFacility as EWF on Inv.EWFacilityID = EWF.EWFacilityID
left outer join tblEWFacilityGroupSummary as EFGS on Inv.EWFacilityID = EFGS.EWFacilityID
left outer join tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
left outer join tblDocument as DOC on Inv.DocumentCode = DOC.Document
left outer join tblUser as M on C.MarketerCode = M.UserID
left outer join tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
left outer join tblEWBulkBilling as BB on CO.BulkBillingID = BB.BulkBillingID
left outer join tblCaseAppt as CA on isnull(Inv.CaseApptID, C.CaseApptID) = CA.CaseApptID
left outer join tblCaseAppt as AHCA on Inv.CaseApptID = AHCA.CaseApptID
left outer join tblApptStatus as AHAS on AHCA.ApptStatusID = AHAS.ApptStatusID
left outer join tblApptStatus as APS on isnull(Inv.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
left outer join tblCanceledBy as CB on CA.CanceledByID = CB.CanceledByID
left outer join tblEWFeeZone as FZ on isnull(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
left outer join tblLanguage as LANG on C.LanguageID = LANG.LanguageID
left outer join tblEWInputSource as EWIS on C.InputSourceID = EWIS.InputSourceID
left outer join tblLocation as EL on CA.LocationCode = EL.LocationCode
left outer join
  (select
     RelatedInvHeaderID, 
     sum(DocumentTotalUS)-sum(cast(Round(TaxTotal*ExchangeRate, 2) as Money)) as Expense,
     count(DocumentNbr) as VoucherCount,
     min(DocumentDate) as VoucherDateMin,  
     min(DocumentNbr) as VoucherNoMin,
     max(DocumentDate) as VoucherDateMax,
     max(DocumentNbr) as VoucherNoMax
   from tblAcctHeader
   where DocumentType='VO' and DocumentStatus='Final' 
         and (DocumentDate >= @startDate and DocumentDate <= @endDate )
   group by RelatedInvHeaderID
  ) as VO on Inv.HeaderID = VO.RelatedInvHeaderID
WHERE (Inv.DocumentType='IN')
      AND (Inv.DocumentStatus='Final')
      AND (Inv.DocumentDate >= @startDate) and (Inv.DocumentDate <= @endDate)
      AND (inv.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND (((LEN(ISNULL(@companyCodeList, 0)) > 0 AND  IIF(@useCaseCompany = 0, CO.ParentCompanyID, COM.ParentCompanyID)  in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlCompany.nodes( 'X' ) AS [T]( [N] ))))
			OR (LEN(ISNULL(@companyCodeList, 0)) = 0 AND IIF(@useCaseCompany = 0, CO.ParentCompanyID, COM.ParentCompanyID) > 0))


ORDER BY EWF.GPFacility, Inv.DocumentNbr

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
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_PatchData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_PatchData]
	@feeDetailOption Int
AS 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsAtty') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsAtty
IF OBJECT_ID('tempdb..##tmp_GenericConfirmationsExaminee') IS NOT NULL DROP TABLE ##tmp_GenericConfirmationsExaminee

-- check if we need to add Exam Fee and Other Fee to result set
IF (@feeDetailOption = 1) 
BEGIN
  print 'Fee Detail Option 1 choosen ... linking in basic fee data'

  UPDATE GI SET 
	GI.FeeDetailExam = LI.FeeDetailExam, 
	GI.FeeDetailOther = LI.FeeDetailOther
  FROM ##tmp_GenericInvoices AS GI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		sum(case when tEWFC.Mapping6 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
		sum(case when tEWFC.Mapping6 = 'Other' or tEWFC.Mapping6 is null then tAD.ExtAmountUS else 0 end) as FeeDetailOther
		from tblAcctHeader as tAH
		inner join tblAcctDetail as tAD on tAH.HeaderID = tAD.HeaderID
		inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
		left outer join tblFRCategory as tFRC on (tC.CaseType = tFRC.CaseType) and (tAD.ProdCode = tFRC.ProductCode)
		left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		group by tAD.HeaderID
	 ) LI on GI.HeaderID = LI.HeaderID
END

-- check if we need to add all the fees to the result set
IF (@feeDetailOption = 2) 
BEGIN
  print 'Fee Detail Option 2 choosen ... linking in detailed fee data'

  UPDATE GI SET 	
	GI.FeeDetailExam		=		LI.FeeDetailExam,
	GI.FeeDetailExamUnit    =		LI.FeeDetailExamUnit,
	GI.FeeDetailBillReview	=		LI.FeeDetailBillReview,
	GI.FeeDetailBillRvwUnit =		LI.FeeDetailBillRvwUnit,
	GI.FeeDetailPeer		=		LI.FeeDetailPeer,
	GI.FeeDetailPeerUnit	=		LI.FeeDetailPeerUnit,
	GI.FeeDetailAdd			=		LI.FeeDetailAdd,
	GI.FeeDetailAddUnit		=		LI.FeeDetailAddUnit,
	GI.FeeDetailLegal		=		LI.FeeDetailLegal,
	GI.FeeDetailLegalUnit	=		LI.FeeDetailLegalUnit,
	GI.FeeDetailProcServ	=		LI.FeeDetailProcServ,
	GI.FeeDetailProvServUnit=		LI.FeeDetailProvServUnit,
	GI.FeeDetailDiag		=		LI.FeeDetailDiag,
	GI.FeeDetailDiagUnit	=		LI.FeeDetailDiagUnit,
	GI.FeeDetailNurseServ	=		LI.FeeDetailNurseServ,
	GI.FeeDetailPhone		=		LI.FeeDetailPhone,
	GI.FeeDetailMSA			=		LI.FeeDetailMSA,
	GI.FeeDetailClinical	=		LI.FeeDetailClinical,
	GI.FeeDetailTech		=		LI.FeeDetailTech,
	GI.FeeDetailMedicare	=		LI.FeeDetailMedicare,
	GI.FeeDetailOPO			=		LI.FeeDetailOPO,
	GI.FeeDetailRehab		=		LI.FeeDetailRehab,
	GI.FeeDetailAddRev		=		LI.FeeDetailAddRev,
	GI.FeeDetailAddRevUnit	=		LI.FeeDetailAddRevUnit,
	GI.FeeDetailTrans		=		LI.FeeDetailTrans,
	GI.FeeDetailTransUnit	=		LI.FeeDetailTransUnit,
	GI.FeeDetailMileage		=		LI.FeeDetailMileage,
	GI.FeeDetailMileageUnit	=		LI.FeeDetailMileageUnit,
	GI.FeeDetailTranslate	=		LI.FeeDetailTranslate,
	GI.FeeDetailTranslateUnit =		LI.FeeDetailTranslateUnit,
	GI.FeeDetailAdminFee	=		LI.FeeDetailAdminFee,
	GI.FeeDetailAdminFeeUnit=		LI.FeeDetailAdminFeeUnit,
	GI.FeeDetailFacFee		=		LI.FeeDetailFacFee,
	GI.FeeDetailOther       =		LI.FeeDetailOther
  FROM ##tmp_GenericInvoices AS GI
	LEFT OUTER JOIN 	  
    (select tAD.HeaderID,
		    sum(case when tEWFC.Mapping4 = 'Exam' then tAD.ExtAmountUS else 0 end) as FeeDetailExam,
			sum(case when tEWFC.Mapping4 = 'Exam' then tAD.Unit else 0 end) as FeeDetailExamUnit,
			sum(case when tEWFC.Mapping4 = 'BillReview' then tAD.ExtAmountUS else 0 end) as FeeDetailBillReview,
			sum(case when tEWFC.Mapping4 = 'BillReview' then tAD.Unit else 0 end) as FeeDetailBillRvwUnit,
			sum(case when tEWFC.Mapping4 = 'Peer' then tAD.ExtAmountUS else 0 end) as FeeDetailPeer,
			sum(case when tEWFC.Mapping4 = 'Peer' then tAD.Unit else 0 end) as FeeDetailPeerUnit,
			sum(case when tEWFC.Mapping4 = 'Add' then tAD.ExtAmountUS else 0 end) as FeeDetailAdd,
			sum(case when tEWFC.Mapping4 = 'Add' then tAD.Unit else 0 end) as FeeDetailAddUnit,
			sum(case when tEWFC.Mapping4 = 'Legal' then tAD.ExtAmountUS else 0 end) as FeeDetailLegal,
			sum(case when tEWFC.Mapping4 = 'Legal' then tAD.Unit else 0 end) as FeeDetailLegalUnit,			
			sum(case when tEWFC.Mapping4 = 'Proc Svr' then tAD.ExtAmountUS else 0 end) as FeeDetailProcServ,
			sum(case when tEWFC.Mapping4 = 'Proc Svr' then tAD.Unit else 0 end) as FeeDetailProvServUnit,
			sum(case when tEWFC.Mapping4 = 'Diag' then tAD.ExtAmountUS else 0 end) as FeeDetailDiag,
			sum(case when tEWFC.Mapping4 = 'Diag' then tAD.Unit else 0 end) as FeeDetailDiagUnit,
			sum(case when tEWFC.Mapping4 = 'Nurse Svc' then tAD.ExtAmountUS else 0 end) as FeeDetailNurseServ,
			sum(case when tEWFC.Mapping4 = 'Phone' then tAD.ExtAmountUS else 0 end) as FeeDetailPhone,
			sum(case when tEWFC.Mapping4 = 'MSA' then tAD.ExtAmountUS else 0 end) as FeeDetailMSA,
			sum(case when tEWFC.Mapping4 = 'Clinical' then tAD.ExtAmountUS else 0 end) as FeeDetailClinical,
			sum(case when tEWFC.Mapping4 = 'Tech' then tAD.ExtAmountUS else 0 end) as FeeDetailTech,
			sum(case when tEWFC.Mapping4 = 'Medicare' then tAD.ExtAmountUS else 0 end) as FeeDetailMedicare,
			sum(case when tEWFC.Mapping4 = 'OPO' then tAD.ExtAmountUS else 0 end) as FeeDetailOPO,
			sum(case when tEWFC.Mapping4 = 'Rehab' then tAD.ExtAmountUS else 0 end) as FeeDetailRehab,
			sum(case when tEWFC.Mapping4 = 'Add Rev' then tAD.ExtAmountUS else 0 end) as FeeDetailAddRev,
			sum(case when tEWFC.Mapping4 = 'Add Rev' then tAD.Unit else 0 end) as FeeDetailAddRevUnit,
			sum(case when tEWFC.Mapping4 = 'Trans' then tAD.ExtAmountUS else 0 end) as FeeDetailTrans,
			sum(case when tEWFC.Mapping4 = 'Trans' then tAD.Unit else 0 end) as FeeDetailTransUnit,
			sum(case when tEWFC.Mapping4 = 'Mileage' then tAD.ExtAmountUS else 0 end) as FeeDetailMileage,
			sum(case when tEWFC.Mapping4 = 'Mileage' then tAD.Unit else 0 end) as FeeDetailMileageUnit,
			sum(case when tEWFC.Mapping4 = 'Translate' then tAD.ExtAmountUS else 0 end) as FeeDetailTranslate,
			sum(case when tEWFC.Mapping4 = 'Translate' then tAD.Unit else 0 end) as FeeDetailTranslateUnit,
			sum(case when tEWFC.Mapping4 = 'AdminFee' then tAD.ExtAmountUS else 0 end) as FeeDetailAdminFee,
			sum(case when tEWFC.Mapping4 = 'AdminFee' then tAD.Unit else 0 end) as FeeDetailAdminFeeUnit,
			sum(case when tEWFC.Mapping4 = 'FacFee' then tAD.ExtAmountUS else 0 end) as FeeDetailFacFee,
			sum(case when tEWFC.Mapping4 = 'Other' or tEWFC.Mapping4 is null then tAD.ExtAmountUS else 0 end) as FeeDetailOther
		from tblAcctHeader as tAH
		inner join tblAcctDetail as tAD on tAH.HeaderID = tAD.HeaderID
		inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
		left outer join tblFRCategory as tFRC on (tC.CaseType = tFRC.CaseType) and (tAD.ProdCode = tFRC.ProductCode)
		left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		group by tAD.HeaderID
		) LI on GI.HeaderID = LI.HeaderID
END

-- get the latest confirmation results for examinee and atty phone calls 
-- and put those results into a temp table
SELECT *
   INTO ##tmp_GenericConfirmationsExaminee
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Examinee') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) EXGROUPS
	WHERE EXGROUPS.[ROW_NUM]  = 1
	ORDER BY EXGROUPS.CaseApptID

SELECT *
   INTO ##tmp_GenericConfirmationsAtty
   FROM (
		SELECT 
				cl.CaseApptID,
				cl.ContactType,
				cl.ContactedDateTime,
				ISNULL(cr.Description, cs.Name) as ConfirmationStatus,
				SUM(cl.AttemptNbr) as CallAttempts,
				ROW_NUMBER() OVER (
					PARTITION BY (cl.CaseApptID)
					ORDER BY AttemptNbr DESC
			    ) AS ROW_NUM
		   FROM ##tmp_GenericInvoices as li
				INNER JOIN tblConfirmationList as cl on li.CaseApptID = cl.CaseApptID
				LEFT OUTER JOIN tblConfirmationStatus as cs on cl.ConfirmationStatusID = cs.ConfirmationStatusID
				LEFT OUTER JOIN tblConfirmationResult as cr on cl.ConfirmationResultID = cr.ConfirmationResultID 
			WHERE cl.ContactType IN ('Attorney') and cl.ContactMethod = 1
			GROUP BY cl.CaseApptID, cl.AttemptNbr, cl.ContactType, ISNULL(cr.Description, cs.Name), cl.ContactedDateTime
		) ATYGROUPS
	WHERE ATYGROUPS.[ROW_NUM]  = 1
	ORDER BY ATYGROUPS.CaseApptID

-- update the main table with the confirmation results for the atty
UPDATE ui SET ui.AttyConfirmationDateTime = lc.ContactedDateTime, ui.AttyConfirmationStatus = lc.ConfirmationStatus, ui.AttyCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsAtty as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Attorney'

-- update the main table with the confirmation results for the claimant
UPDATE ui SET ui.ClaimantConfirmationDateTime = lc.ContactedDateTime, ui.ClaimantConfirmationStatus = lc.ConfirmationStatus, ui.ClaimantCallAttempts = lc.CallAttempts
  FROM ##tmp_GenericInvoices as ui
	inner join ##tmp_GenericConfirmationsExaminee as lc ON ui.CaseApptID = lc.CaseApptID
  WHERE lc.ContactType = 'Examinee'

-- update the main table with the most recent quote information
print 'Get Most recent FeeQuote for Case'
UPDATE gi SET gi.FeeQuoteAmount = CASE (ISNULL(gi.InvApptStatus, gi.ApptStatus))
									WHEN 'Late Canceled' THEN tbl.LateCancelAmt
									WHEN 'Canceled' THEN tbl.NoShowAmt
									WHEN 'No Show' THEN tbl.NoShowAmt
									WHEN 'Show' THEN 
										CASE
											WHEN tbl.ApprovedAmt IS NOT NULL THEN tbl.ApprovedAmt
											ELSE ISNULL(tbl.FeeAmtTo, tbl.FeeAmtFrom)
										END
									END,
	          gi.OutOfNetworkReason = tbl.OutOfNetworkReason
  FROM ##tmp_GenericInvoices  as gi
	INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY AQ.CaseNbr ORDER BY AQ.AcctQuoteID DESC) as ROWNUM,
					AQ.CaseNbr,
					CONVERT(VARCHAR(12), AQ.LateCancelAmt)	AS LateCancelAmt,
					CONVERT(VARCHAR(12), AQ.NoShowAmt)		AS NoShowAmt,		
					CONVERT(VARCHAR(12), AQ.FeeAmtFrom)		AS FeeAmtFrom,
					CONVERT(VARCHAR(12), AQ.FeeAmtTo)		AS FeeAmtTo,
					CONVERT(VARCHAR(12), AQ.ApprovedAmt)	AS ApprovedAmt,
					ISNULL(NR.Description, '')              AS OutOfNetworkReason
	              FROM tblAcctQuote as AQ 
					LEFT OUTER JOIN tblOutOfNetworkReason as NR on AQ.OutOfNetworkReasonID = NR.OutOfNetworkReasonID
			      WHERE AQ.QuoteType = 'IN') as tbl ON tbl.CaseNbr = gi.CaseNbr
				  WHERE tbl.ROWNUM = 1

-- custom Sedgwick handling for customer data values
print 'Custom Sedgwick Handling for Customer data values'
 UPDATE ginv SET 
		ginv.ClaimUniqueId		= dbo.fnGetParamValue(CD.[Param], 'ClaimUniqueId'),
		ginv.CMSClaimNumber		= dbo.fnGetParamValue(CD.[Param], 'CMSClaimNumber'),
		ginv.ShortVendorId		= dbo.fnGetParamValue(CD.[Param], 'ShortVendorId'),
		ginv.ProcessingOfficeId = dbo.fnGetParamValue(CD.[Param], 'OfficeNumber'),
		ginv.ReferralUniqueId	= dbo.fnGetParamValue(CD.[Param], 'ReferralUniqueId')
   FROM ##tmp_GenericInvoices as ginv
	    INNER JOIN tblCustomerData as CD on CD.TableType = 'tblCase' AND CD.TableKey = ginv.CaseNbr AND CD.CustomerName = 'Sedgwick CMS'
   WHERE ginv.ParentCompanyID = 44

-- get medrec page counts via MedIndex doc
print 'Step 1 - Get Medical Page Counts from Medindex'
UPDATE geninv SET MedRecPages = IIF(ISNULL(tblCD.Pages, '') = '', 'N/A', CONVERT(VARCHAR(12), tblCD.Pages))
   FROM ##tmp_GenericInvoices as geninv
		INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY CD.CaseNbr ORDER BY CD.SeqNo DESC) as ROWNUM,
					CD.CaseNbr,
					CD.Pages
					FROM tblCaseDocuments as CD
					WHERE CD.Description like '%MedIndex%') as tblCD ON tblCD.CaseNbr = geninv.CaseNbr
		WHERE tblCD.ROWNUM = 1

-- get medrec page counts for any cases that we did not have a MedIndex doc on 
print 'Step 2 - Calc missing Medical Page Counts'
UPDATE geninv SET geninv.MedRecPages = tblCD.TotalPages
  FROM ##tmp_GenericInvoices as geninv
	INNER JOIN (SELECT SUM(ISNULL(Pages, 0)) as TotalPages, CaseNbr
				  FROM tblCaseDocuments
				  WHERE MedsIncoming = 1
				  GROUP BY CaseNbr
				  ) as tblCD ON tblCD.CaseNbr = geninv.CaseNbr		
WHERE geninv.MedRecPages = 'N/A'

print 'Step 3 - Calc missing Meds to Doctor'
UPDATE geninv SET geninv.DocReviewPages = tblCD.TotalPages
  FROM ##tmp_GenericInvoices as geninv
	INNER JOIN (SELECT SUM(ISNULL(Pages, 0)) as TotalPages, CaseNbr
				  FROM tblCaseDocuments
				  WHERE MedsToDoctor = 1
				  GROUP BY CaseNbr
				  ) as tblCD ON tblCD.CaseNbr = geninv.CaseNbr		

-- addendum 
print 'Flag addendums'
UPDATE tmp SET tmp.AddendumNeeded = 1
  FROM ##tmp_GenericInvoices as tmp
where CaseNbr in (
select GI.MasterCaseNbr
	from ##tmp_GenericInvoices as GI
		inner join tblCase as C on (GI.MasterCaseNbr = C.CaseNbr) AND (C.DoctorCode = GI.DoctorID)
	where (GI.ServiceType = 'Addendum')
	  and ((GI.MasterCaseNbr is not null) and (GI.CaseNbr <> GI.MasterCaseNbr))
	  and (GI.CaseStatus <> 9)
)
UPDATE gi SET gi.AddendumNeeded = 0
  FROM ##tmp_GenericInvoices as gi
WHERE gi.AddendumNeeded IS NULL

-- return the main table
print 'return final query results'
SELECT * 
  FROM ##tmp_GenericInvoices
ORDER BY InvoiceNo

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
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255),
	@feeDetailOption Int = 0,	
	@useCaseCompany Bit = 0
AS
	EXEC [dbo].[proc_Info_Generic_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList, @companyCodeList, @useCaseCompany
	EXEC [dbo].[proc_Info_Generic_MgtRpt_PatchData] @feeDetailOption
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

-- Sprint 141
-- IMEC-14483 - Update tblSetting for CaseDocTypeMedsIncoming_True to include only CaseDocType 'Med Records' (7) and do not include 'San Med Records' (21)
UPDATE tblSetting Set Value = ';7;' where Name = 'CaseDocTypeMedsIncoming_True'
GO 

-- IMEC-14423 - Changes for Allstate SLA Metric (No Show to Exam Scheduled)
UPDATE tblTATCalculationMethod
   SET ApptEnabled = ISNULL(ApptEnabled, 0)
GO 
INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)           
VALUES(227, 'OrigAppt', 'ApptTime', 'No Show'), 
      (228, 'NextAppt', 'DateAdded', 'Exam Scheduled'),
      (229, 'OrigAppt', 'TATNoShowToScheduled', NULL)
GO
INSERT INTO tblTATCalculationMethod(TATCalculationMethodID, StartDateFieldID, EndDateFieldID, Unit, TATDataFieldID, UseTrend, ApptEnabled)
VALUES(26, 227, 228, 'Day', 229, 0, 1)
GO
INSERT INTO tblTATCalculationMethodEvent(TATCalculationMethodID, EventID)
VALUES(26, 1101)
GO

-- IMEC-14424 - add new SLA Exception Reason columns for tracking historical case appts SLA Exception reasons
--  table is managed by dev team and will be the same across all databases.
    INSERT INTO tblDataField(DataFieldID, TableName, FieldName, Descrip)           
    VALUES(231, 'tblCaseAppt', 'SLAExScheduledToExam', NULL), 
        (232, 'tblCaseAppt', 'SLAExExamToClientNotified', NULL), 
        (233, 'tblCaseAppt', 'SLAExAwaitingScheduling', NULL), 
        (234, 'tblCaseAppt', 'SLAExAwaitingSchedulingToExam', NULL), 
        (235, 'tblCaseAppt', 'SALExEnteredToExam', NULL), 
        (236, 'tblCaseAppt', 'SLAExDateLossToApptDate', NULL), 
        (237, 'tblCaseAppt', 'SLAExExamSchedToQuoteSent', NULL), 
        (238, 'tblCaseAppt', 'SLAExExamSchedToApprovalSent', NULL), 
        (239, 'tblCaseAppt', 'SLAExExamDateToNotifyShowNoShow', NULL) 
GO

-- IMEC-14424 - patch TATCalcMethod to include Appt SLA Exception Reason tabel/field where appropriate
--   table is managed by dev team and will the same across all IMEC databases.
     -- Exam Scheduled to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 231
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 8
     GO
     -- Date of Exam to Client Notified
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 232
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 11
     GO
     -- Available for Scheduling to Exam Scheduled
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 233
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 12
     GO
     -- Available for Scheduling to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 234
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 14
     GO
     -- Referral Entered into IMEC to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 235
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 15
     GO
     -- Date of Loss to Date of Exam
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 236
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 17
     GO
     -- Exam Scheduled to Fee Quote Sent
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 237
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 21
     GO
     -- Exam Scheduled to Fee Approval Sent
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 238
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 22
     GO
     -- Appt Time to Client Notified Show/No Show
     UPDATE tblTATCalculationMethod
        SET ApptSLAExceptionDataFieldID = 239
       FROM tblTATCalculationMethod
      WHERE TATCalculationMethodID = 24
     GO
