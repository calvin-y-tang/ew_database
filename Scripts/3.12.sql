CREATE TABLE [dbo].[tblConfirmationStatus] (
    [ConfirmationStatusID] INT          NOT NULL,
    [Name]                 VARCHAR (30) NULL,
    CONSTRAINT [PK_tblConfirmationStatus] PRIMARY KEY CLUSTERED ([ConfirmationStatusID] ASC)
);
GO

PRINT N'Altering [dbo].[tblDoctorSchedule]...';


GO
ALTER TABLE [dbo].[tblDoctorSchedule]
    ADD [WasScheduled] BIT CONSTRAINT [DF_tblDoctorSchedule_WasScheduled] DEFAULT ((0)) NOT NULL;


GO


INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (1, 'Pending For Batch')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (2, 'Selected For Batch')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (3, 'Ready For Submit')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (4, 'Submitted')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (5, 'Result Received')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (101, 'Skipped Per User')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (102, 'Skipped Office No Confirm')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (103, 'Skipped Case Canceled')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (104, 'Skipped Appt Canceled')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (105, 'Skipped Confirmed')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (106, 'Skipped Never Confirm')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (107, 'Skipped No Phone Nbr')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (108, 'Skipped Past Appt')
INSERT INTO [tblConfirmationStatus] ([ConfirmationStatusID], [Name]) VALUES (109, 'Skipped Rule Missing')
GO



PRINT N'Altering [dbo].[tblDocument]...';


GO
ALTER TABLE [dbo].[tblDocument]
    ADD [CMSBox9A]     VARCHAR (30) NULL,
        [CMSBox23]     VARCHAR (30) NULL,
        [CMSBox17Qual] VARCHAR (5)  NULL;


GO
PRINT N'Altering [dbo].[tblCaseDocuments]...';


GO
ALTER TABLE [dbo].[tblCaseDocuments]
    ADD [CaseDocTypeID] INT NULL;


GO


PRINT N'Altering [dbo].[tblExaminee]...';


GO
ALTER TABLE [dbo].[tblExaminee]
    ADD [TreatingPhysicianNPINbr] VARCHAR (20) NULL;


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
            tblCaseType.description AS CaseTypeDesc ,

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

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany,                          
			
			dbo.tblCase.DateOfInjury2 AS DOI2, 
			dbo.tblCase.DateOfInjury3 AS DOI3, 
			dbo.tblCase.DateOfInjury4 AS DOI4,
			dbo.tblCase.InsuringCompany as InsuringCompany
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
            tblCaseType.description AS CaseTypeDesc ,

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
PRINT N'Altering [dbo].[vw_EDIFileAttachments]...';


GO
ALTER VIEW vw_EDIFileAttachments
AS
SELECT	cd.[Description], 
		cd.sFilename, 
        cd.SeqNo, 
        cd.CaseNbr, 
        ah.DocumentNbr, 
        ah.DocumentType, 
        ah.HeaderID, 
        ia.InvAttachID, 
        ia.AttachType, 
        cd.[Type]
FROM   tblAcctHeader as ah 
              INNER JOIN tblCase as c on ah.CaseNbr = c.CaseNbr
              INNER JOIN tblCaseDocuments as cd on c.CaseNbr = cd.CaseNbr
              LEFT OUTER JOIN tblInvoiceAttachments as ia on (ah.HeaderID = ia.InvHeaderID and cd.SeqNo = ia.SeqNo)
WHERE (cd.[Type] in ('document', 'report'))
GO
PRINT N'Altering [dbo].[vwPDFCaseData]...';


GO
ALTER VIEW vwPDFCaseData
AS
    SELECT  C.CaseNbr ,
			C.ExtCaseNbr,
			C.PanelNbr ,
			C.OfficeCode ,
            C.ClaimNbr ,
			
			C.ClaimNbr + 
			(CASE ISNULL(C.ClaimNbrExt, '')
			 WHEN '' THEN ''
			 ELSE '-' + C.ClaimNbrExt
			 END )AS ClaimNbrWExt , 

            C.Jurisdiction ,
            C.WCBNbr ,
			C.CertMailNbr,
            
			C.DoctorCode AS CaseDoctorCode ,
            C.DoctorLocation AS CaseLocationCode ,
			C.DoctorSpecialty AS CaseDoctorSpecialty ,
            C.DoctorName ,
            C.ApptDate ,
            C.ApptTime ,

			C.MasterCaseNbr ,
			C.MasterSubCase ,
			B.BlankValue AS MasterCaseDoctorName ,
			B.BlankValue AS MasterCaseDoctorNPINbr ,
			B.BlankValue AS MasterCaseDoctorLicense ,
			B.BlankValue AS MasterCaseDoctorLicQualID ,
            
			C.DateOfInjury AS DOIValue ,
			B.BlankValue AS DOI ,
			B.BlankValue AS InjuryCurrentDateMM ,
			B.BlankValue AS InjuryCurrentDateDD ,
			B.BlankValue AS InjuryCurrentDateYYYY ,
			CASE WHEN C.DateOfInjury IS NULL THEN '' ELSE '431' END AS InjuryCurrentDateQual ,

			B.BlankValue AS ICD9Code1a ,
			B.BlankValue AS ICD9Code1b ,
			B.BlankValue AS ICD9Code1c ,
			B.BlankValue AS ICD9Code2a ,
			B.BlankValue AS ICD9Code2b ,
			B.BlankValue AS ICD9Code2c ,
			B.BlankValue AS ICD9Code3a ,
			B.BlankValue AS ICD9Code3b ,
			B.BlankValue AS ICD9Code3c ,
			B.BlankValue AS ICD9Code4a ,
			B.BlankValue AS ICD9Code4b ,
			B.BlankValue AS ICD9Code4c ,

            C.ICDCodeA AS ICD9Code1 ,
            C.ICDCodeB AS ICD9Code2 ,
            C.ICDCodeC AS ICD9Code3 ,
            C.ICDCodeD AS ICD9Code4 ,
			C.ICDCodeA ,
			C.ICDCodeB ,
			C.ICDCodeC ,
			C.ICDCodeD ,
			C.ICDCodeE ,
			C.ICDCodeF ,
			C.ICDCodeG ,
			C.ICDCodeH ,
			C.ICDCodeI ,
			C.ICDCodeJ ,
			C.ICDCodeK ,
			C.ICDCodeL ,

			C.ICDFormat ,
			B.BlankValue AS ICDIndicator ,


			B.BlankValueLong AS ProblemList ,
            
			CO.ExtName AS Company ,
            
			CL.FirstName + ' ' + CL.LastName AS ClientName ,
			B.BlankValue AS ReferringProvider,	--Fill by system option

            CL.Addr1 AS ClientAddr1 ,
            CL.Addr2 AS ClientAddr2 ,
            CL.City + ', ' + CL.State + '  ' + CL.Zip AS ClientCityStateZip ,
            B.BlankValue AS ClientFullAddress ,
            CL.Phone1 + ' ' + ISNULL(CL.Phone1ext, ' ') AS ClientPhone , --Need Extension?
            CL.Fax AS ClientFax ,
            CL.Email AS ClientEmail ,
			CL.Phone1 AS ClientPhoneAreaCode ,
			CL.Phone1 AS ClientPhoneNumber ,
			CL.Fax AS ClientFaxAreaCode ,
			CL.Fax AS ClientFaxNumber ,

            EE.LastName AS ExamineeLastName ,
            EE.FirstName AS ExamineeFirstName ,
            EE.MiddleInitial AS ExamineeMiddleInitial ,
			B.BlankValue AS ExamineeNameLFMI ,
			B.BlankValue AS ExamineeNameFMIL ,

            EE.SSN AS ExamineeSSN ,
            EE.SSN AS ExamineeSSNLast4Digits ,

            EE.Addr1 AS ExamineeAddr1 ,
            EE.Addr2 AS ExamineeAddr2 ,
            EE.City + ', ' + EE.State + '  ' + EE.Zip AS ExamineeCityStateZip ,
            EE.City AS ExamineeCity ,
            EE.State AS ExamineeState ,
            EE.Zip AS ExamineeZip ,
			B.BlankValue AS ExamineeAddress ,
			B.BlankValue AS ExamineeFullAddress ,
            EE.County AS ExamineeCounty ,

            EE.Phone1 AS ExamineePhone ,
            EE.Phone1 AS ExamineePhoneAreaCode ,
            EE.Phone1 AS ExamineePhoneNumber ,

            EE.DOB AS ExamineeDOBValue ,
			B.BlankValue AS ExamineeDOB ,
			B.BlankValue AS ExamineeDOBMM ,
			B.BlankValue AS ExamineeDOBDD ,
			B.BlankValue AS ExamineeDOBYYYY ,

            EE.Sex AS ExamineeSex ,
			EE.Sex AS ExamineeSexM ,
			EE.Sex AS ExamineeSexF ,
			
          C.EmployerID ,
          C.EmployerAddressID ,
            
			(Case ISNULL(C.EmployerID, 0)
              WHEN 0
              THEN EE.Employer  
			  ELSE EM.Name  
			  END) AS Employer,  

			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerAddr1  
			  ELSE EA.Address1 
			  END) AS EmployerAddr1,  

			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerCity  
			  ELSE EA.City  
			  END) AS EmployerCity,  

			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerState  
			  ELSE EA.State  
			  END) AS EmployerState,  

			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerZip  
			  ELSE EA.Zip  
			  END) AS EmployerZip,  
			  
			B.BlankValue AS EmployerFullAddress ,

			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerPhone  
			  ELSE EA.Phone  
			  END) AS EmployerPhone,  

			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerPhone  
			  ELSE EA.Phone  
			  END) AS EmployerPhoneAreaCode,  

			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerPhone  
			  ELSE EA.Phone  
			  END) AS EmployerPhoneNumber,  


			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerFax  
			  ELSE EA.Fax  
			  END) AS EmployerFax,  
            
			(Case ISNULL(C.EmployerID , 0)
              WHEN 0
              THEN EE.EmployerEmail  
			  ELSE EA.Email  
			  END) AS EmployerEmail,  
            
            EE.TreatingPhysicianAddr1 ,
            EE.TreatingPhysicianCity ,
            EE.TreatingPhysicianState ,
            EE.TreatingPhysicianZip ,
			B.BlankValue AS TreatingPhysicianFullAddress ,

            EE.TreatingPhysicianPhone ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneAreaCode ,
            EE.TreatingPhysicianPhone AS TreatingPhysicianPhoneNumber ,
            EE.TreatingPhysicianFax ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxAreaCode ,
            EE.TreatingPhysicianFax AS TreatingPhysicianFaxNumber ,

            EE.TreatingPhysicianLicenseNbr ,
            EE.TreatingPhysician ,
            EE.TreatingPhysicianCredentials AS TreatingPhysicianDegree ,
			EE.TreatingPhysicianNPINbr AS TreatingPhysicianNPINbr, 

            PA.FirstName + ' ' + PA.LastName AS PAttorneyName ,
            PA.Address1 AS PAttorneyAddr1 ,
            PA.Address2 AS PAttorneyAddr2 ,
            PA.City + ', ' + PA.State + '  ' + PA.Zip AS PAttorneyCityStateZip ,
			B.BlankValue AS PAttorneyFullAddress ,

            PA.Phone + ' ' + ISNULL(PA.Phoneextension, '') AS PAttorneyPhone , --Need Extension?
			PA.Phone AS PAttorneyPhoneAreaCode ,
			PA.Phone AS PAttorneyPhoneNumber ,
            PA.Fax AS PAttorneyFax ,
			PA.Fax AS PAttorneyFaxAreaCode ,
			PA.Fax AS PAttorneyFaxNumber ,
            PA.Email AS PAttorneyEmail ,

			CT.EWBusLineID ,
			O.BillingProviderNonNPINbr AS OfficeBillingProviderNonNPINbr

    FROM    tblCase AS C
            INNER JOIN tblExaminee AS EE ON EE.chartNbr = C.chartNbr
            INNER JOIN tblClient AS CL ON C.clientCode = CL.clientCode
            INNER JOIN tblCompany AS CO ON CL.companyCode = CO.companyCode
			INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
			INNER JOIN tblOffice AS O ON C.OfficeCode = O.OfficeCode
            LEFT OUTER JOIN tblCCAddress AS PA ON C.plaintiffAttorneyCode = PA.ccCode
			LEFT OUTER JOIN tblBlank AS B ON 1=1
            LEFT OUTER JOIN tblEmployer AS EM on C.EmployerID = EM.EmployerID 
            LEFT OUTER JOIN tblEmployerAddress AS EA on C.EmployerAddressID = EA.EmployerAddressID
GO
PRINT N'Altering [dbo].[vwPDFOverride]...';


GO
ALTER VIEW vwPDFOverride
AS
	SELECT
			--These are bookmarks that need to be duplicated, so they can be placed on the form multiple times, but each one is independent from each other
			'%Company%' as Company2,
			'%ClientName%' AS ClientName2,
			'%ClientFullAddress%' AS ClientFullAddress2,
			'%ClientPhoneAreaCode%' AS ClientPhoneAreaCode2,
			'%ClientPhoneNumber%' AS ClientPhoneNumber2,
			'%ClientFaxAreaCode%' AS ClientFaxAreaCode2,
			'%ClientFaxNumber%' AS ClientFaxNumber2,

			--Simply alias name for the same data field
			'%DocumentDate%' AS InvoiceDate,

			-------------------------------
			--CMS1500 Related Old Bookmarks
			-------------------------------

			--For backward compatibility, bookmarks used on old CMS1500 forms
			'Signature on file' AS AuthorizedSignature ,
			'Signature on file'	AS AssignmentSignature ,

			'%CurrentDate%' AS AuthorizedSignatureDate ,
			'%CurrentDate%' AS DoctorSignatureDate ,

			'%Checked%' AS Box1Other,
			'%Checked%' AS ExamineeRelToInsOther,
			'%Checked%' AS BillingProviderEINCheck,

			'%ClaimNbr%' AS InsuredPolicyNbr,
			'%Employer%' AS InsuredEmployer,
			'%DocumentNbr%' AS ExamineeAccountNbr,
			'%Jurisdiction%' AS AutoAccidentState,

			--For backward compatibility, one of the old forms has these bookmars
			'%CMSBox24JNonNPILine1%' AS PrimaryDoctorNonNPINbr1,
			'%CMSBox24JNonNPILine2%' AS PrimaryDoctorNonNPINbr2,
			'%CMSBox24JNonNPILine3%' AS PrimaryDoctorNonNPINbr3,
			'%CMSBox24JNonNPILine4%' AS PrimaryDoctorNonNPINbr4,
			'%CMSBox24JNonNPILine5%' AS PrimaryDoctorNonNPINbr5,
			'%CMSBox24JNonNPILine6%' AS PrimaryDoctorNonNPINbr6,

			--For backward compatibility, these fields are renamed in tblClaimInfo
			'%CMSBox23%' AS PriorAuthNbr,
			'%CMSBox31Line1%' AS DoctorNameWithDegree,
			'%CMSBox31Line2%' AS DoctorSpecialty,
			'%CMSBox32b%' AS DoctorNonNPINbr,
			'%CMSBox33b%' AS BillingProviderNonNPINbr,

			-------------------------------
			--CMS1500 Related New Bookmarks
			-------------------------------

			B.BlankValueLong AS CMSPayor ,									--doc override

			B.BlankValue AS CMSBox1a ,										--doc override
			B.BlankValue AS CMSBox4 ,										--doc and inv override
			B.BlankValue AS CMSBox7Address ,								--doc override
			B.BlankValue AS CMSBox7City ,									--doc override
			B.BlankValue AS CMSBox7State ,									--doc override
			B.BlankValue AS CMSBox7Zip ,									--doc override
			B.BlankValue AS CMSBox7AreaCode ,								--doc override
			B.BlankValue AS CMSBox7PhoneNumber ,							--doc override
			B.Blankvalue AS OtherInsuredPolicyNbr,							--doc and inv override CMSBox9a
			B.BlankValue AS CMSBox10aYes ,									--doc override
			B.BlankValue AS CMSBox10bNo ,									--doc override
			B.BlankValue AS CMSBox10bState ,								--doc override
			B.BlankValue AS CMSBox10cNo ,									--doc override

			B.BlankValue AS CMSBox17Qual,									--doc override
			B.BlankValue AS CMSBox17 ,										--doc override
			B.BlankValue AS CMSBox17a ,										--doc override
			B.BlankValue AS CMSBox17aQual ,									--doc override
			B.BlankValue AS CMSBox17b ,										--doc override
			
			B.BlankValue AS CMSBox19 ,										--doc override	

			B.BlankValue AS CMSBox23 ,										--inv override
			B.BlankValue AS CMSBox24JNonNPINbr ,							--doc and inv override
			B.BlankValue AS CMSBox24JNonNPIQual ,							--doc override

			B.BlankValue AS CMSBox24JNonNPIQualLine1 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine2 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine3 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine4 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine5 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine6 ,						--doc override

			B.BlankValue AS CMSBox24JNonNPILine1 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine2 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine3 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine4 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine5 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine6 ,							--doc override

			B.BlankValue AS CMSBox24JNPILine1 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine2 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine3 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine4 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine5 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine6 ,								--doc override

			B.BlankValue AS CMSBox25,
			B.BlankValue AS CMSBox27Yes ,									--doc override


			B.BlankValueLong AS CMSBox31Line1 ,								--doc and inv override
			B.BlankValue AS CMSBox31Line2 ,									--doc and inv override

			B.BlankValue AS CMSBox32a ,										--doc override
			B.BlankValue AS CMSBox32b ,										--doc and inv override

			B.BlankValue AS CMSBox33Line1 ,									--doc override
			B.BlankValue AS CMSBox33Line2 ,									--doc override
			B.BlankValue AS CMSBox33Line3 ,									--doc override
			B.BlankValue AS CMSBox33AreaCode,								--doc override
			B.BlankValue AS CMSBox33PhoneNumber,							--doc override
			B.BlankValue AS CMSBox33a ,										--doc override
			B.BlankValue AS CMSBox33b, 										--doc and inv override
			B.BlankValue AS CMSBox11                                        --doc override

	FROM	tblBlank AS B
GO
PRINT N'Creating [dbo].[vwInvoiceDetailsView]...';


GO
CREATE VIEW vwInvoiceDetailsView
AS
		select
			P.Description as Product,
			AD.Date,
			AD.Unit,
			AD.CPTCode,
			AD.LongDesc,
			AD.UnitAmount,
			AD.ExtendedAmount,
			AD.Taxable,
			AD.HeaderID
		from tblAcctDetail as AD
			  left outer join tblProduct as P on AD.ProdCode = P.ProdCode
GO
PRINT N'Creating [dbo].[vwInvoiceView]...';


GO
CREATE VIEW vwInvoiceView
AS
		select
			AH.HeaderID,
			AH.DocumentNbr,
			AH.DocumentStatus,
			AH.DocumentType,
			AH.DocumentDate,
			AH.CaseNbr,
			C.ExtCaseNbr,
			AH.Terms,
			AH.ClaimNbr,
			AH.Examinee,
			AH.Doctor,
			AH.ClientRefNbr,
			AH.Address,
			AH.TaxTotal,
			AH.DocumentTotal,
			FH.FeeDesc as FeeSchedule,
			EWF.FacilityName,
			UF.FirstName + ' ' + UF.LastName as UserFinalized,
			AH.ApptDate,
			AH.Message,
			RAH.DocumentNbr as RelatedDocumentNbr,
			AH.FeeExplanation
		from tblAcctHeader as AH
			inner join tblCase as C on AH.CaseNbr = C.CaseNbr
			left outer join tblFeeHeader as FH on AH.FeeCode = FH.FeeCode    
			left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
			left outer join tblUser as UF on AH.UserIDFinalized = UF.UserID      
			left outer join tblAcctHeader as RAH on AH.RelatedInvHeaderID = RAH.HeaderID
GO
PRINT N'Altering [dbo].[spCaseDocuments]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [dbo].[spCaseDocuments] ( @casenbr integer )
AS 
    SELECT  casenbr,
            document,
            type,
            description,
            sfilename,
            dateadded,
            useridadded,
            PublishOnWeb,
            dateedited,
            useridedited,
            seqno,
            PublishedTo,
            Source,
            FileSize,
            Pages,
			FolderID,
			SubFolder, 
			CaseDocTypeID 
    FROM    dbo.tblCaseDocuments
    WHERE   ( casenbr = @casenbr )
            AND ( type <> 'Report' )
    ORDER BY dateadded DESC
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[spCaseReports]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [dbo].[spCaseReports] ( @casenbr integer )
AS 
    SELECT TOP 100 PERCENT
            casenbr,
            document,
            type,
            description,
            sfilename,
            dateadded,
            useridadded,
            reporttype,
            PublishOnWeb,
            dateedited,
            useridedited,
            seqno,
            PublishedTo,
            Source,
            FileSize,
            Pages,
			FolderID,
			SubFolder, 
			CaseDocTypeID 
    FROM    dbo.tblCaseDocuments
    WHERE   ( casenbr = @casenbr )
            AND ( type = 'Report' )
    ORDER BY dateadded DESC
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO


CREATE TABLE [dbo].[tblCaseDocType](
	[CaseDocTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ShortDesc] [varchar](25) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[TypeCategory] [varchar](50) NOT NULL, 
    CONSTRAINT [PK_tblCaseDocType] PRIMARY KEY ([CaseDocTypeID])
) ON [PRIMARY]

Go



INSERT INTO tblSetting (Name, Value) Values ('ESISInvoiceExceptionStates', 'CA;GA;MN;TX;WA')
GO
EXEC sp_refreshview 'vw_EDIFileAttachments'
GO


INSERT INTO tblCaseDocType
     VALUES
           	('Document', 'Document', 'Document'),
	   ('EDocument', 'EDocument', 'EDocument'),
	   ('Invoice', 'Invoice', 'Invoice'),
	   ('Letter', 'Letter', 'Letter'),
	   ('Report', 'Report', 'Report'),
	   ('Voucher', 'Voucher', 'Voucher'),
	   ('Med Records', 'Medical Records', 'Letter'),
	   ('Films', 'Films', 'Letter'),
	   ('DICOM Img', 'DICOM Images', 'Letter'),
	   ('Photos', 'Photos', 'Letter'),
	   ('Videos', 'Videos', 'Letter'),
	   ('Cover Ltr', 'Cover Letter', 'Letter'),
	   ('Addendum', 'Addendum', 'Report'),
	   ('File Review', 'File Review', 'Report'),
	   ('Template', 'Template', 'Report')
GO


/* Document */
update tblcasedocuments 
set CaseDocTypeID = 1 
where type = 'Document'
and CaseDocTypeID is Null
Go

/* EDocument */
update tblcasedocuments 
set CaseDocTypeID = 2 
where type = 'EDocument'
and CaseDocTypeID is Null
Go

/* Invoice */
update tblcasedocuments 
set CaseDocTypeID = 3 
where type = 'Invoice'
and CaseDocTypeID is Null
Go

/* Letter */
update tblcasedocuments 
set CaseDocTypeID = 4 
where type = 'Letter'
and CaseDocTypeID is Null
Go

/* Report */
update tblcasedocuments 
set CaseDocTypeID = 5 
where type = 'Report'
and CaseDocTypeID is Null
Go

/* Voucher */
update tblcasedocuments 
set CaseDocTypeID = 6 
where type = 'Voucher'
and CaseDocTypeID is Null
Go

/* Blank */
update tblcasedocuments 
set CaseDocTypeID = 1 
where type <> 'Document' and type <> 'EDocument' and type <> 'Invoice' and type <> 'Letter' and type <> 'Report' and type <> 'Voucher'
and CaseDocTypeID is Null
Go


UPDATE tblControl SET DBVersion='3.12'
GO
