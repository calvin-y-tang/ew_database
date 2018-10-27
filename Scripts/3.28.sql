PRINT N'Altering [dbo].[tblDoctorMargin]...';


GO
ALTER TABLE [dbo].[tblDoctorMargin] ALTER COLUMN [SpecialtyCode] VARCHAR (50) NULL;


GO





PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [CaseCaption]     VARCHAR (200) NULL,
        [LitigationNotes] VARCHAR (MAX) NULL;


GO
PRINT N'Altering [dbo].[tblCaseDocType]...';


GO
ALTER TABLE [dbo].[tblCaseDocType]
    ADD [FilterKey] VARCHAR (10) NULL;


GO
PRINT N'Altering [dbo].[tblCaseDocuments]...';


GO
ALTER TABLE [dbo].[tblCaseDocuments]
    ADD [SharedDoc] BIT CONSTRAINT [DF_tblCaseDocuments_SharedDoc] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblCustomerData]...';


GO
ALTER TABLE [dbo].[tblCustomerData] ALTER COLUMN [Param] VARCHAR (MAX) NOT NULL;


GO









PRINT N'Altering [dbo].[tblDoctorSchedule]...';


GO
ALTER TABLE [dbo].[tblDoctorSchedule]
    ADD [CaseNbr4]     INT          NULL,
        [CaseNbr4Desc] VARCHAR (70) NULL,
        [CaseNbr5]     INT          NULL,
        [CaseNbr5Desc] VARCHAR (70) NULL,
        [CaseNbr6]     INT          NULL,
        [CaseNbr6Desc] VARCHAR (70) NULL;


GO
PRINT N'Creating [dbo].[tblDoctorSchedule].[IX_tblDoctorSchedule_LocationCodeStatusDoctorCodeDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSchedule_LocationCodeStatusDoctorCodeDate]
    ON [dbo].[tblDoctorSchedule]([LocationCode] ASC, [Status] ASC, [DoctorCode] ASC, [date] ASC)
    INCLUDE([StartTime], [Description], [CaseNbr1desc]);


GO
PRINT N'Altering [dbo].[tblLocation]...';


GO
ALTER TABLE [dbo].[tblLocation]
    ADD [GeoData] [sys].[geography] NULL;


GO
PRINT N'Creating [dbo].[tblLocation].[IX_tblLocation_GeoData]...';


GO
CREATE SPATIAL INDEX [IX_tblLocation_GeoData]
    ON [dbo].[tblLocation] ([GeoData]);


GO
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [UseDPS] BIT CONSTRAINT [DF_tblOffice_UseDPS] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Altering [dbo].[tblServices]...';


GO
ALTER TABLE [dbo].[tblServices]
    ADD [UseDrPortalCalendar] BIT CONSTRAINT [DF_tblServices_UseDrPortalCalendar] DEFAULT ((0)) NOT NULL;


GO
PRINT N'Creating [dbo].[tblDoctorSearchResult]...';


GO
CREATE TABLE [dbo].[tblDoctorSearchResult] (
    [PrimaryKey]     INT            IDENTITY (1, 1) NOT NULL,
    [SessionID]      VARCHAR (50)   NOT NULL,
    [DateAdded]      DATETIME       NOT NULL,
    [DoctorCode]     INT            NOT NULL,
    [LocationCode]   INT            NOT NULL,
    [SchedCode]      INT            NULL,
    [Selected]       BIT            NOT NULL,
    [Proximity]      FLOAT (53)     NULL,
    [SpecialtyCodes] VARCHAR (300)  NULL,
    [AvgMargin]      DECIMAL (8, 2) NOT NULL,
    [CaseCount]      INT            NOT NULL,
    CONSTRAINT [PK_tblDoctorSearchResult] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblDoctorSearchResult].[IX_tblDoctorSearchResult_SessionIDDoctorCodeLocationCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSearchResult_SessionIDDoctorCodeLocationCode]
    ON [dbo].[tblDoctorSearchResult]([SessionID] ASC, [DoctorCode] ASC, [LocationCode] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorSearchWeightedCriteria]...';


GO
CREATE TABLE [dbo].[tblDoctorSearchWeightedCriteria] (
    [PrimaryKey]                   INT            IDENTITY (1, 1) NOT NULL,
    [BlockTime]                    DECIMAL (8, 2) NOT NULL,
    [AverageMargin]                DECIMAL (8, 2) NOT NULL,
    [CaseCount]                    DECIMAL (8, 2) NOT NULL,
    [SchedulePriority]             DECIMAL (8, 2) NOT NULL,
    [ReceiveMedRecsElectronically] DECIMAL (8, 2) NOT NULL,
    CONSTRAINT [PK_tblDoctorSearchWeight] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSNote]...';


GO
CREATE TABLE [dbo].[tblDPSNote] (
    [DPSNoteID]    INT           IDENTITY (1, 1) NOT NULL,
    [DateAdded]    DATETIME      NOT NULL,
    [UserIDAdded]  VARCHAR (15)  NOT NULL,
    [DateEdited]   DATETIME      NOT NULL,
    [UserIDEdited] VARCHAR (15)  NOT NULL,
    [Notes]        VARCHAR (MAX) NOT NULL,
    [CaseNbr]      INT           NOT NULL,
    [DateExported] DATETIME      NULL,
    [DateImported] DATETIME      NULL,
    CONSTRAINT [PK_tblDPSNote] PRIMARY KEY CLUSTERED ([DPSNoteID] ASC)
);


GO
PRINT N'Creating [dbo].[tblDPSNote].[IX_tblDPSNote_CaseNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDPSNote_CaseNbr]
    ON [dbo].[tblDPSNote]([CaseNbr] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorLocation].[IX_tblDoctorLocation_DoctorCodeLocationCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorLocation_DoctorCodeLocationCode]
    ON [dbo].[tblDoctorLocation]([DoctorCode] ASC, [LocationCode] ASC)
    INCLUDE([Status]);


GO
PRINT N'Creating [dbo].[tblDoctorOffice].[IX_tblDoctorOffice_OfficeCodeDoctorCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorOffice_OfficeCodeDoctorCode]
    ON [dbo].[tblDoctorOffice]([OfficeCode] ASC, [DoctorCode] ASC);


GO
PRINT N'Creating [dbo].[tblDoctorSpecialty].[IX_tblDoctorSpecialty_DoctorCodeSpecialtyCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorSpecialty_DoctorCodeSpecialtyCode]
    ON [dbo].[tblDoctorSpecialty]([DoctorCode] ASC, [SpecialtyCode] ASC);


GO
PRINT N'Creating [dbo].[DF_tblDoctorSearchResult_AvgMargin]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult]
    ADD CONSTRAINT [DF_tblDoctorSearchResult_AvgMargin] DEFAULT ((0)) FOR [AvgMargin];


GO
PRINT N'Creating [dbo].[DF_tblDoctorSearchResult_CaseCount]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult]
    ADD CONSTRAINT [DF_tblDoctorSearchResult_CaseCount] DEFAULT ((0)) FOR [CaseCount];


GO
PRINT N'Creating [dbo].[DF_tblDoctorSearchResult_DateAdded]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult]
    ADD CONSTRAINT [DF_tblDoctorSearchResult_DateAdded] DEFAULT (getdate()) FOR [DateAdded];


GO
PRINT N'Creating [dbo].[DF_tblDoctorSearchResult_Selected]...';


GO
ALTER TABLE [dbo].[tblDoctorSearchResult]
    ADD CONSTRAINT [DF_tblDoctorSearchResult_Selected] DEFAULT ((0)) FOR [Selected];


GO
PRINT N'Creating [dbo].[tblLocation_AfterInsert_TRG]...';


GO
CREATE TRIGGER tblLocation_AfterInsert_TRG 
  ON tblLocation
AFTER INSERT
AS
  UPDATE tblLocation SET GeoData=
  (SELECT TOP 1 geography::STGeomFromText('POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')',4326)
   FROM tblZipCode AS Z WHERE Z.sZip=tblLocation.Zip)
   FROM Inserted
   WHERE tblLocation.LocationCode = Inserted.LocationCode
GO
PRINT N'Creating [dbo].[tblLocation_AfterUpdate_TRG]...';


GO
CREATE TRIGGER tblLocation_AfterUpdate_TRG 
  ON tblLocation
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT OFF
	DECLARE @LocationCode INT
	SELECT @LocationCode=Inserted.LocationCode FROM Inserted

	IF UPDATE(Zip)
	BEGIN
		UPDATE tblLocation SET GeoData=
		(SELECT TOP 1 geography::STGeomFromText('POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')',4326)
		FROM tblZipCode AS Z WHERE Z.sZip=tblLocation.Zip)
		FROM Inserted
		WHERE tblLocation.LocationCode = @LocationCode
	END
END
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
PRINT N'Altering [dbo].[vwDrSchedule]...';


GO
ALTER VIEW vwDrSchedule
AS
    SELECT
        DS.SchedCode,
        DS.DoctorCode,
        DS.LocationCode,
        DS.date,
        DS.StartTime,
        DS.Status,
        DS.Duration,

        DS.CaseNbr1,
        DS.CaseNbr1Desc,
        DS.CaseNbr2,
        DS.CaseNbr2Desc,
        DS.CaseNbr3,
        DS.CaseNbr3Desc,
        DS.CaseNbr4,
        DS.CaseNbr4Desc,
        DS.CaseNbr5,
        DS.CaseNbr5Desc,
        DS.CaseNbr6,
        DS.CaseNbr6Desc,

        S1.ShortDesc AS Service1,
        S2.ShortDesc AS Service2,
        S3.ShortDesc AS Service3,
        S4.ShortDesc AS Service4,
        S5.ShortDesc AS Service5,
        S6.ShortDesc AS Service6,

        CT1.ShortDesc+'/ '+S1.ShortDesc AS CaseType1,
        CT2.ShortDesc+'/ '+S2.ShortDesc AS CaseType2,
        CT3.ShortDesc+'/ '+S3.ShortDesc AS CaseType3,
        CT4.ShortDesc+'/ '+S4.ShortDesc AS CaseType4,
        CT5.ShortDesc+'/ '+S5.ShortDesc AS CaseType5,
        CT6.ShortDesc+'/ '+S6.ShortDesc AS CaseType6,

        DS.DateAdded,
        DS.UserIDAdded,
        DS.DateEdited,
        DS.UserIDEdited

    FROM tblDoctorSchedule AS DS
    LEFT OUTER JOIN tblCase C1 ON DS.CaseNbr1=C1.CaseNbr
    LEFT OUTER JOIN tblCase C2 ON DS.CaseNbr2=C2.CaseNbr
    LEFT OUTER JOIN tblCase C3 ON DS.CaseNbr3=C3.CaseNbr
    LEFT OUTER JOIN tblCase C4 ON DS.CaseNbr4=C4.CaseNbr
    LEFT OUTER JOIN tblCase C5 ON DS.CaseNbr5=C5.CaseNbr
    LEFT OUTER JOIN tblCase C6 ON DS.CaseNbr6=C6.CaseNbr
    LEFT OUTER JOIN tblCaseType CT1 ON CT1.Code=C1.CaseType
    LEFT OUTER JOIN tblCaseType CT2 ON CT2.Code=C2.CaseType
    LEFT OUTER JOIN tblCaseType CT3 ON CT3.Code=C3.CaseType
    LEFT OUTER JOIN tblCaseType CT4 ON CT4.Code=C4.CaseType
    LEFT OUTER JOIN tblCaseType CT5 ON CT5.Code=C5.CaseType
    LEFT OUTER JOIN tblCaseType CT6 ON CT6.Code=C6.CaseType
    LEFT OUTER JOIN tblServices S1 ON S1.ServiceCode=C1.ServiceCode
    LEFT OUTER JOIN tblServices S2 ON S2.ServiceCode=C2.ServiceCode
    LEFT OUTER JOIN tblServices S3 ON S3.ServiceCode=C3.ServiceCode
    LEFT OUTER JOIN tblServices S4 ON S4.ServiceCode=C4.ServiceCode
    LEFT OUTER JOIN tblServices S5 ON S5.ServiceCode=C5.ServiceCode
    LEFT OUTER JOIN tblServices S6 ON S6.ServiceCode=C6.ServiceCode
GO
PRINT N'Altering [dbo].[vw30DaySchedule]...';


GO

ALTER VIEW vw30DaySchedule
AS
    SELECT  tblDoctorSchedule.DoctorCode ,
            tblDoctorSchedule.LocationCode ,
            tblLocation.Location ,
            tblDoctorSchedule.Date ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.CaseNbr1 ,
            tblDoctorSchedule.CaseNbr2 ,
            tblDoctorSchedule.CaseNbr3 ,
            tblDoctorSchedule.CaseNbr4 ,
            tblDoctorSchedule.CaseNbr5 ,
            tblDoctorSchedule.CaseNbr6 ,
            tblDoctor.Booking
    FROM    tblDoctorSchedule
            INNER JOIN tblDoctorLocation ON tblDoctorSchedule.DoctorCode = tblDoctorLocation.DoctorCode
                                            AND tblDoctorSchedule.LocationCode = tblDoctorLocation.LocationCode
            INNER JOIN tblDoctor ON tblDoctorLocation.DoctorCode = tblDoctor.DoctorCode
            INNER JOIN tblLocation ON tblDoctorLocation.LocationCode = tblLocation.LocationCode
    WHERE   ( tblDoctorSchedule.Status <> 'Off' )
GO
PRINT N'Altering [dbo].[vwDoctorScheduleSummary]...';


GO
 
 ALTER VIEW vwDoctorScheduleSummary
AS  
   SELECT  tblDoctor.LastName ,
            tblDoctor.FirstName ,
            tblLocation.Location ,
            tblDoctorSchedule.Date ,
            tblDoctorSchedule.Status ,
            tblLocation.InsideDr ,
            tblDoctor.DoctorCode ,
            tblDoctorOffice.OfficeCode ,
            tblDoctorSchedule.LocationCode ,
            tblDoctor.Booking ,
            tblDoctorSchedule.CaseNbr1 ,
            tblDoctorSchedule.CaseNbr2 ,
            tblDoctorSchedule.CaseNbr3 ,
            tblDoctorSchedule.CaseNbr4 ,
            tblDoctorSchedule.CaseNbr5 ,
            tblDoctorSchedule.CaseNbr6 ,
            tblDoctorSchedule.StartTime, 
			tblLocationOffice.OfficeCode as LocationOffice 
    FROM    tblDoctorSchedule
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode
            INNER JOIN tblLocation ON tblDoctorSchedule.LocationCode = tblLocation.LocationCode
            INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode 
			inner join tbllocationoffice on (tbllocationoffice.officecode = tblDoctorOffice.OfficeCode and tblLocationOffice.LocationCode = tbllocation.LocationCode) 
    WHERE   ( tblDoctorSchedule.Status <> 'Off' )
GO
PRINT N'Creating [dbo].[vwDoctorSearchResult]...';


GO

CREATE VIEW [dbo].[vwDoctorSearchResult]
AS
WITH summary (SessionID, MaxAvgMargin, MaxCaseCount)
AS
(
	SELECT SessionID, MAX(AvgMargin), CAST(MAX(CaseCount) AS DECIMAL(8, 2)) FROM tblDoctorSearchResult GROUP BY SessionID
)
SELECT DSR.PrimaryKey,
	   DSR.SessionID,
       DSR.DoctorCode,
       DSR.LocationCode,
       DSR.SchedCode,
       DSR.Selected,
       DSR.Proximity,
	   IIF(DSR.Proximity=9999, '?', CAST(FORMAT(DSR.Proximity, '#.0')  AS VARCHAR)) AS ProximityString,
       REPLACE(DSR.SpecialtyCodes, ', ', CHAR(13) + CHAR(10)) AS SpecialtyCodes,

       ISNULL(CONVERT(VARCHAR, DS.date, 101), 'Call for Appt') AS FirstAvail,
       DS.Date,
       DS.StartTime,

       DR.LastName + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       DR.Prepaid,
       DR.Status,
       DR.Credentials,
       DR.Notes,
       L.Location,
       L.City,
       L.State,
       L.Phone,
       L.County,

	   IIF(L.InsideDr=1, W.BlockTime, 0) +
	   IIF(S.MaxAvgMargin=0, 0, DSR.AvgMargin/S.MaxAvgMargin * W.AverageMargin) +
	   IIF(S.MaxCaseCount=0, 0, DSR.CaseCount/S.MaxCaseCount * W.CaseCount) +
	   (6-ISNULL(DR.SchedulePriority,5))/5.0 * W.SchedulePriority +
	   IIF(DR.ReceiveMedRecsElectronically=1, W.ReceiveMedRecsElectronically, 0) AS DisplayScore
	   


FROM tblDoctorSearchResult AS DSR
	INNER JOIN summary AS S ON S.SessionID = DSR.SessionID
	INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
    INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
    INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
    LEFT OUTER JOIN tblDoctorSchedule AS DS ON DS.SchedCode = DSR.SchedCode
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

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, CaseNbr, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(casenbr) CaseCount FROM tblCase
	INNER JOIN tblDoctorSchedule ON tblCase.SchedCode = tblDoctorSchedule.SchedCode 
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), CaseNbr, DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	UNION

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, CaseNbr, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblDoctorSchedule ON tblCasePanel.SchedCode = tblDoctorSchedule.SchedCode
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), CaseNbr, DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

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
	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCase 
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblServices.UseDrPortalCalendar = 1
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION ALL

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCasePanel 
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
PRINT N'Altering [dbo].[spCaseSearchForDicom]...';


GO
ALTER proc [dbo].[spCaseSearchForDicom] 
	@casenbr int = 0,
	@claimnbr varchar(50) = null,
	@fname varchar(50) = null,
	@lname varchar(50) = null,
	@dob varchar(10) = null
as
	begin
		select 
			c.CaseNbr,  
			examinee.LastName + ', ' + examinee.FirstName   as ExamineeName,
			examinee.DOB as ExamineeDOB,
			c.ClaimNbr + ' ' + c.ClaimNbrExt as ClaimNbr ,
			c.DoctorName AS Doctor,
			convert(varchar(10), c.apptdate, 101) as ApptDate,
			co.IntName as Company,
			ct.ShortDesc as CaseType,
			svc.Description AS Service,
    		s.ShortDesc AS Status,
			c.DoctorSpecialty
		from tblCase c
			INNER JOIN tblExaminee examinee on c.ChartNbr = examinee.ChartNbr
			INNER JOIN tblCaseType ct on c.CaseType = ct.Code
			INNER JOIN tblServices svc on c.ServiceCode = svc.ServiceCode 
			INNER JOIN tblQueues AS s ON s.StatusCode = c.Status
			INNER JOIN tblclient as cl on cl.clientcode = c.ClientCode
			INNER JOIN tblcompany co on co.companycode = cl.companycode

		WHERE c.Status not in (8,9)
			AND (@casenbr = 0 OR @casenbr = c.CaseNbr)
			AND (isnull(@claimnbr,'')='' OR replace(replace(replace(replace(upper(c.ClaimNbr), '-', ''),'.',''),'_',''),' ','') like replace(replace(replace(replace(upper(@claimnbr), '-', ''),'.',''),'_',''),' ','') + '%')
			AND (ISNULL(@fname,'')='' OR examinee.FirstName like (case when isnull(@fname,'') = '' then '%' else @fname + '%' end))
			AND (ISNULL(@lname,'')='' OR examinee.LastName  like (case when isnull(@lname,'') = '' then '%' else @lname + '%' end))
			AND	(ISNULL(@dob,'')='' OR @dob=(convert(int,coalesce(convert(varchar(8),examinee.dob,(112)),(0)),(0))))
	end
GO
PRINT N'Altering [dbo].[spCaseDocuments]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [dbo].[spCaseDocuments] ( @casenbr INTEGER )
AS 
    DECLARE @MasterCaseNbr INTEGER 
	
	SET @MasterCaseNbr = (SELECT MasterCaseNbr FROM tblCase WHERE CaseNbr = @CaseNbr)
	
	SELECT  
		@CaseNbr as CaseNbr, 
		casenbr AS DocCaseNbr,
		document,
		type,
		tblCaseDocuments.description,
		sfilename,
		dateadded,
		useridadded,
		tblCaseDocuments.PublishOnWeb,
		dateedited,
		useridedited,
		seqno,
		PublishedTo,
		Source,
		FileSize,
		Pages,
		FolderID,
		SubFolder, 
		tblCaseDocuments.CaseDocTypeID, 
		(SELECT FilterKey FROM tblCaseDocType WHERE tblCaseDocType.CaseDocTypeID = tblCaseDocuments.CaseDocTypeID) AS FilterKey,
		tblCaseDocuments.SharedDoc
    FROM
		dbo.tblCaseDocuments
    WHERE
		  casenbr = @casenbr
	  AND type <> 'Report' 
	  OR SeqNo IN (SELECT SeqNo 
	                 FROM dbo.tblCaseDocuments 
					WHERE casenbr IN (SELECT casenbr FROM tblCase WHERE MasterCaseNbr = @MasterCaseNbr)
					  AND type <> 'Report' 
					  AND SharedDoc = 1)
    ORDER BY dateadded DESC
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[spDoctorSearch]...';


GO
CREATE PROCEDURE spDoctorSearch
(
	@SessionID AS VARCHAR(50) = NULL,

    @StartDate AS DATETIME,
    @PanelExam AS BIT = NULL,

    @DoctorCode AS INT = NULL,
    @ProvTypeCode AS INT = NULL,
	@IncludeInactiveDoctor AS BIT = NULL,
    @Degree AS VARCHAR(50) = NULL,
    @RequirePracticingDoctors AS BIT = NULL,
    @RequireLicencedInExamState AS BIT = NULL,
    @RequireBoardCertified AS BIT = NULL,

    @LocationCode AS INT = NULL,
    @City AS VARCHAR(50) = NULL,
    @State AS VARCHAR(2) = NULL,
    @Vicinity AS VARCHAR(50) = NULL,
    @County AS VARCHAR(50) = NULL,

	@Proximity AS INT = NULL,
	@ProximityZip AS VARCHAR(10) = NULL,

    @KeyWordIDs AS VARCHAR(100) = NULL,
    @Specialties AS VARCHAR(200) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(200)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT

	--Defalt Values
	SET @tmpSessionID = ISNULL(@SessionID, NEWID())

	IF @ParentCompanyID IS NOT NULL
	BEGIN
		IF @RequirePracticingDoctors IS NULL
			(SELECT @RequirePracticingDoctors = RequirePracticingDoctor FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
		IF @RequireBoardCertified IS NULL
			(SELECT @RequireBoardCertified = RequireCertification FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
	END

	--Format delimited list
	SET @lstSpecialties = ';;' + @Specialties
	SET @lstKeywordIDs = ';;' + REPLACE(@KeyWordIDs, ' ', '')

	--Calculate parameter geography data
	IF (@ProximityZip IS NOT NULL)
	BEGIN
		SET @geoEE = geography::STGeomFromText((SELECT TOP 1 'POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')' FROM tblZipCode AS Z WHERE Z.sZip=@ProximityZip ORDER BY Z.kIndex) ,4326)
		IF (SELECT TOP 1 DistanceUofM FROM tblIMEData)='Miles'
			SET @distanceConv = 1609.344
		ELSE
			SET @distanceConv = 1000
	END

	--Clear data from last search
	DELETE FROM tblDoctorSearchResult WHERE SessionID=@tmpSessionID


	--Set Differrent SQL String for Panel Search
	IF ISNULL(@PanelExam,0) = 1
	BEGIN
		SET @strDrSchCol = ' DS.SchedCode,'
		SET @strDrSchFrom = ' LEFT OUTER JOIN tblDoctorSchedule AS DS ON DS.DoctorCode = DL.DoctorCode AND DS.LocationCode = DL.LocationCode AND DS.Status=''Open'' AND DS.StartTime>=@_StartDate '
	END
	ELSE

		SET @strDrSchCol = '(SELECT TOP 1 SchedCode FROM tblDoctorSchedule AS DS WHERE DS.DoctorCode=DL.DoctorCode AND DS.LocationCode=DL.LocationCode AND DS.date >= dbo.fnDateValue(@_StartDate) AND DS.Status = ''Open'' ORDER BY DS.date) AS SchedCode,'

--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
    Proximity
)
SELECT
	@_tmpSessionID AS SessionID,
	DR.DoctorCode,
    L.LocationCode,
	' + @strDrSchCol + '
	ISNULL(L.GeoData.STDistance(@_geoEE)/@_distanceConv,9999) AS Proximity

FROM 
    tblDoctor AS DR
    INNER JOIN tblDoctorLocation AS DL
        ON DL.DoctorCode = DR.DoctorCode
	INNER JOIN tblLocation AS L
        ON L.LocationCode = DL.LocationCode
' + @strDrSchFrom


--Set WHERE clause string
	SET @strWhere ='WHERE DR.OPType = ''DR'''

	IF ISNULL(@IncludeInactiveDoctor,0)=0
		SET @strWhere = @strWhere + ' AND (DR.Status = ''Active'' AND DL.Status = ''Active'')'
	IF @OfficeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorOffice WHERE OfficeCode=@_OfficeCode)'

	IF @DoctorCode IS NOT NULL
		 SET @strWhere = @strWhere + ' AND @_DoctorCode = DR.DoctorCode'
	IF @ProvTypeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_ProvTypeCode = DR.ProvTypeCode'
	IF ISNULL(@Degree,'')<>''
		SET @strWhere = @strWhere + ' AND @_Degree = DR.Credentials'

	IF ISNULL(@RequirePracticingDoctors,0)=1
		SET @strWhere = @strWhere + ' AND DR.PracticingDoctor = 1'
	IF ISNULL(@RequireLicencedInExamState,0)=1
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 11 AND State = @_State)'
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2 AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'
	IF @Specialties IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorSpecialty WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID)'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode)'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode)'

	IF @LocationCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_LocationCode = L.LocationCode'
	IF ISNULL(@City,'')<>''
		SET @strWhere = @strWhere + ' AND @_City = L.City'
	IF ISNULL(@State,'')<>''
		SET @strWhere = @strWhere + ' AND @_State = L.State'
	IF ISNULL(@County,'')<>''
		SET @strWhere = @strWhere + ' AND @_County = L.County'
	IF ISNULL(@Vicinity,'')<>''
		SET @strWhere = @strWhere + ' AND @_Vicinity = L.Vicinity'

	IF @Proximity IS NOT NULL
		SET @strWhere = @strWhere + ' AND L.GeoData.STDistance(@_geoEE)/@_distanceConv<=@_Proximity'

	SET @strSQL = @strSQL + @strWhere
	PRINT @strSQL
	EXEC sp_executesql @strSQL,
		  N'@_tmpSessionID VARCHAR(50),
			@_geoEE GEOGRAPHY,
			@_distanceConv FLOAT,
			@_StartDate DATETIME ,
			@_DoctorCode INT ,
			@_LocationCode INT ,
			@_City VARCHAR(50) ,
			@_State VARCHAR(2) ,
			@_Vicinity VARCHAR(50) ,
			@_County VARCHAR(50) ,
			@_Degree VARCHAR(50) ,
			@_lstKeyWordIDs VARCHAR(100) ,
			@_lstSpecialties VARCHAR(200) ,
			@_PanelExam BIT ,
			@_ProvTypeCode INT ,		
			@_EWAccreditationID INT,	
			@_IncludeInactiveDoctor BIT,	
			@_RequirePracticingDoctors BIT,
			@_RequireLicencedInExamState BIT,
			@_RequireBoardCertified BIT,	
			@_OfficeCode INT,			
			@_ParentCompanyID INT,	
			@_CompanyCode INT,		
			@_ClientCode INT,			
			@_Proximity INT',
			@_tmpSessionID = @tmpSessionID,
			@_geoEE = @geoEE,
			@_distanceConv = @distanceConv,
			@_StartDate = @StartDate,
			@_DoctorCode = @DoctorCode,
			@_LocationCode = @LocationCode,
			@_City = @City,
			@_State = @State,
			@_Vicinity = @Vicinity,
			@_County = @County,
			@_Degree = @Degree,
			@_lstKeyWordIDs = @lstKeywordIDs ,
			@_lstSpecialties = @lstSpecialties,
			@_PanelExam = @PanelExam,
			@_ProvTypeCode = @ProvTypeCode,		
			@_EWAccreditationID = @EWAccreditationID,	
			@_IncludeInactiveDoctor = @IncludeInactiveDoctor,
			@_RequirePracticingDoctors = @RequirePracticingDoctors,
			@_RequireLicencedInExamState = @RequireLicencedInExamState,
			@_RequireBoardCertified = @RequireBoardCertified,
			@_OfficeCode = @OfficeCode,
			@_ParentCompanyID = @ParentCompanyID,
			@_CompanyCode = @CompanyCode,
			@_ClientCode = @ClientCode,	
			@_Proximity = @Proximity
	SET @returnValue = @@ROWCOUNT


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,2,'')),'')
		 FROM tblDoctorSearchResult AS DSR
		 WHERE DSR.SessionID=@tmpSessionID
		SET QUOTED_IDENTIFIER ON
	END

	--Get Doctor Margin
	UPDATE DSR SET DSR.CaseCount=stats.CaseCount, DSR.AvgMargin=stats.AvgMargin
	 FROM tblDoctorSearchResult AS DSR
	 INNER JOIN
		(
		 SELECT DM.DoctorCode, AVG(DM.Margin) AS AvgMargin, SUM(DM.CaseCount) AS CaseCount
		 FROM tblDoctorMargin AS DM
		 WHERE (@ParentCompanyID IS NULL OR DM.ParentCompanyID=@ParentCompanyID)
		  AND (@EWBusLineID IS NULL OR DM.EWBusLineID=@EWBusLineID)
		  AND (@EWServiceTypeID IS NULL OR DM.EWServiceTypeID=@EWServiceTypeID)
		  AND (@Specialties IS NULL OR PATINDEX('%;;' + DM.SpecialtyCode + ';;%', @lstSpecialties)>0)
		 GROUP BY DM.DoctorCode
		) AS stats ON stats.DoctorCode = DSR.DoctorCode
	 WHERE DSR.SessionID=@tmpSessionID


	--If SessionID is given, return the number of rows instead of the actual data
	IF @SessionID IS NOT NULL
		RETURN @returnValue
	ELSE
		SELECT * FROM tblDoctorSearchResult WHERE SessionID=@SessionID
END
GO









UPDATE tblLocation SET GeoData=
(SELECT TOP 1 geography::STGeomFromText('POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')',4326)
 FROM tblZipCode AS Z WHERE Z.sZip=tblLocation.Zip)
GO




SET IDENTITY_INSERT [dbo].[tblDoctorSearchWeightedCriteria] ON
INSERT INTO [dbo].[tblDoctorSearchWeightedCriteria] ([PrimaryKey], [BlockTime], [AverageMargin], [CaseCount], [SchedulePriority], [ReceiveMedRecsElectronically]) VALUES (1, 25.00, 35.00, 15.00, 10.00, 15.00)
SET IDENTITY_INSERT [dbo].[tblDoctorSearchWeightedCriteria] OFF
GO

-- Issue 6067 Add tokens to the list seen by the user
INSERT INTO tblMessageToken values ('@ProgressiveMedicalNecessity@', Null)
go
INSERT INTO tblMessageToken values ('@ProgressiveProviderAttorney@', Null)
go
INSERT INTO tblMessageToken values ('@ProgressivePeerInformation@', Null)
go
INSERT INTO tblMessageToken values ('@ProgressiveReportedInjuries@', Null)
go
INSERT INTO tblMessageToken values ('@ProgressiveIssues@', Null)
go
INSERT INTO tblMessageToken values ('@CaseCaption@', Null)
go
INSERT INTO tblMessageToken values ('@LitigationNotes@', Null)
go


UPDATE tblServices SET UseDrPortalCalendar=1 WHERE EWServiceTypeID IN (1,7)
GO



UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Other' WHERE [CaseDocTypeID] = 1
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Other' WHERE [CaseDocTypeID] = 2
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Acct' WHERE [CaseDocTypeID] = 3
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Other' WHERE [CaseDocTypeID] = 4
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Acct' WHERE [CaseDocTypeID] = 6
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='MedRec' WHERE [CaseDocTypeID] = 7
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='MedRec' WHERE [CaseDocTypeID] = 8
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='MedRec' WHERE [CaseDocTypeID] = 9
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='MedRec' WHERE [CaseDocTypeID] = 10
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='MedRec' WHERE [CaseDocTypeID] = 11
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Other' WHERE [CaseDocTypeID] = 12
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Acct' WHERE [CaseDocTypeID] = 16
UPDATE [dbo].[tblCaseDocType] SET [FilterKey]='Other' WHERE [CaseDocTypeID] = 17
GO



UPDATE tblControl SET DBVersion='3.28'
GO
