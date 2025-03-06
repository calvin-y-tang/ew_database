

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
PRINT N'Altering [dbo].[tblDocument]...';


GO
ALTER TABLE [dbo].[tblDocument]
    ADD [CMSBox28Dollars] VARCHAR (30) NULL,
        [CMSBox28Cents]   VARCHAR (30) NULL;


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
PRINT N'Creating [dbo].[tblCaseDetermination]...';


GO
CREATE TABLE [dbo].[tblCaseDetermination] (
    [CaseNbr]       INT           NOT NULL,
    [DoctorSummary] VARCHAR (MAX) NULL,
    [EWSummary]     VARCHAR (MAX) NULL,
    [UserIDAdded]   VARCHAR (25)  NOT NULL,
    [DateAdded]     DATETIME      NOT NULL,
    [UserIDEdited]  VARCHAR (25)  NULL,
    [DateEdited]    DATETIME      NULL,
    CONSTRAINT [PK_tblCaseDetermination] PRIMARY KEY CLUSTERED ([CaseNbr] ASC)
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
PRINT N'Creating [dbo].[tblCaseOverviewGroup]...';


GO
CREATE TABLE [dbo].[tblCaseOverviewGroup] (
    [CaseOverviewGroupID] INT           IDENTITY (1, 1) NOT NULL,
    [CaseNbr]             INT           NOT NULL,
    [FieldNumber]         INT           NOT NULL,
    [Description]         VARCHAR (100) NOT NULL,
    [SelectionType]       VARCHAR (50)  NOT NULL,
    [UserIDAdded]         VARCHAR (25)  NOT NULL,
    [DateAdded]           DATETIME      NOT NULL,
    [UserIDEdited]        VARCHAR (25)  NULL,
    [DateEdited]          DATETIME      NULL,
    CONSTRAINT [PK_tblCaseOverviewGroup] PRIMARY KEY CLUSTERED ([CaseOverviewGroupID] ASC)
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
PRINT N'Creating [dbo].[tblCaseOverviewGroupItem]...';


GO
CREATE TABLE [dbo].[tblCaseOverviewGroupItem] (
    [CaseOverviewGroupItemID] INT           IDENTITY (1, 1) NOT NULL,
    [CaseOverviewGroupID]     INT           NOT NULL,
    [ItemNumber]              INT           NOT NULL,
    [ResponseValue]           VARCHAR (8)   NOT NULL,
    [Description]             VARCHAR (MAX) NOT NULL,
    [IsSelected]              BIT           NULL,
    [UserIDAdded]             VARCHAR (25)  NOT NULL,
    [DateAdded]               DATETIME      NOT NULL,
    [UserIDEdited]            VARCHAR (25)  NULL,
    [DateEdited]              DATETIME      NULL,
    CONSTRAINT [PK_tblCaseOverviewGroupItem] PRIMARY KEY CLUSTERED ([CaseOverviewGroupItemID] ASC)
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
PRINT N'Altering [dbo].[vwDrSchedGetBlockTimeAppts]...';


GO
ALTER VIEW [dbo].[vwDrSchedGetBlockTimeAppts]
	AS 
		SELECT
			-- tblDoctorBlockTimeSlot details
			TimeSlot.*,
			-- other miscellaneous IDs that are helpful to have
			c.CaseNbr AS ApptSlotCaseNbr, 
			c.ChartNbr,
			c.ClientCode, 
			c.ServiceCode, 
			c.CaseType, 
			co.CompanyCode, 
			-- details that are used in UI
			ex.LastName + ', ' + ex.Firstname as ExamineeName, 
			co.intname as CompanyName,
			ct.shortdesc as CaseTypeShortDesc,
			serv.ShortDesc as ServiceShortDesc,
			IIF(c.PanelNbr IS NOT NULL AND c.PanelNbr > 0, c.DoctorName, '') AS PanelDoctor 
		FROM 
			tblDoctorBlockTimeSlot AS TimeSlot
				LEFT OUTER JOIN tblCaseAppt AS ca ON ca.CaseApptID = TimeSlot.CaseApptID
				LEFT OUTER JOIN tblCaseApptRequest AS car ON car.CaseApptRequestID = TimeSlot.CaseApptRequestID
				LEFT OUTER JOIN tblCase AS c ON c.CaseNbr = IIF(ca.CaseNbr IS NULL, car.CaseNbr, ca.CaseNbr)
				LEFT OUTER JOIN tblExaminee AS ex ON ex.ChartNbr = c.Chartnbr
				LEFT OUTER JOIN tblServices AS serv ON serv.ServiceCode = c.ServiceCode
				LEFT OUTER JOIN tblCaseType AS ct ON ct.Code = c.CaseType
				LEFT OUTER JOIN tblclient AS cl ON cl.ClientCode = c.ClientCode
				LEFT OUTER JOIN tblCompany AS co ON co.CompanyCode = cl.CompanyCode
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
PRINT N'Altering [dbo].[vwDrSchedGetNonBlockTimeAppt]...';


GO
ALTER VIEW [dbo].[vwDrSchedGetNonBlockTimeAppt]
	AS 
		SELECT 
			ca.CaseApptID,
			ca.CaseNbr,
			ca.ApptStatusID,
			ISNULL(cap.DoctorCode, ca.DoctorCode) as Doctorcode,
			ca.LocationCode, 
			ca.ApptTime,
			ca.Duration,
			-- IDs that are useful to have at hand
			c.CaseNbr AS ApptSlotCaseNbr,
			c.ChartNbr,
			cl.ClientCode,
			c.ServiceCode,
			c.CaseType,
			co.CompanyCode,
			-- details used in UI
			ex.LastName + ', ' + ex.FirstName AS ExamineeName,
			co.IntName AS CompanyName,
			ct.ShortDesc AS CaseTypeShortDesc,
			serv.ShortDesc AS ServiceShortDesc,
			IIF(c.PanelNbr IS NOT NULL AND c.PanelNbr > 0, c.DoctorName, '') AS PanelDoctor
		FROM
			tblCaseAppt AS ca
				LEFT OUTER JOIN tblCaseApptPanel AS CAP on cap.CaseApptID = ca.CaseApptID
				INNER JOIN tblCase AS c ON c.CaseNbr = ca.CaseNbr
				INNER JOIN tblExaminee AS ex ON ex.ChartNbr = c.Chartnbr
				INNER JOIN tblServices AS serv ON serv.ServiceCode = c.ServiceCode
				INNER JOIN tblCaseType AS ct ON ct.Code = c.CaseType
				INNER JOIN tblclient AS cl ON cl.ClientCode = c.ClientCode
				INNER JOIN tblCompany AS co ON co.CompanyCode = cl.CompanyCode
		WHERE 
			ca.DoctorBlockTimeSlotID IS NULL
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
			FORMAT(C.ApptTime, 'hh:mm tt') AS ApptTimeOnly ,
			C.RptFinalizedDate ,

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
			C.InsuringCompany AS InsuringCompany,
            
			CL.FirstName + ' ' + CL.LastName AS ClientName ,
			B.BlankValue AS ReferringProvider,	--Fill by system option

            CL.Addr1 AS ClientAddr1 ,
            CL.Addr2 AS ClientAddr2 ,
            CL.City + ', ' + UPPER(CL.State) + '  ' + CL.Zip AS ClientCityStateZip ,
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
            EE.City + ', ' + UPPER(EE.State) + '  ' + EE.Zip AS ExamineeCityStateZip ,
            EE.City AS ExamineeCity ,
            UPPER(EE.State) AS ExamineeState ,
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
              THEN UPPER(EE.EmployerState)  
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
            UPPER(EE.TreatingPhysicianState) AS TreatingPhysicianState ,
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

            ISNULL(PA.FirstName,'') + ' ' + ISNULL(PA.LastName,'') AS PAttorneyName ,
            PA.Address1 AS PAttorneyAddr1 ,
            PA.Address2 AS PAttorneyAddr2 ,
            PA.City + ', ' + UPPER(PA.State) + '  ' + PA.Zip AS PAttorneyCityStateZip ,
			B.BlankValue AS PAttorneyFullAddress ,

            PA.Phone + ' ' + ISNULL(PA.Phoneextension, '') AS PAttorneyPhone , --Need Extension?
			PA.Phone AS PAttorneyPhoneAreaCode ,
			PA.Phone AS PAttorneyPhoneNumber ,
            PA.Fax AS PAttorneyFax ,
			PA.Fax AS PAttorneyFaxAreaCode ,
			PA.Fax AS PAttorneyFaxNumber ,
            PA.Email AS PAttorneyEmail ,

			CT.EWBusLineID ,

			O.BillingProviderNonNPINbr AS OfficeBillingProviderNonNPINbr ,
			O.NYWCCompanyName ,

			F.LegalName AS CaseEWFacilityLegalName ,
			F.Address AS CaseEWFacilityAddress ,
            F.City + ', ' + UPPER(F.State) + '  ' + F.Zip AS CaseEWFacilityCityStateZip ,
			F.Phone AS CaseEWFacilityPhone ,
			F.Fax AS CaseEWFacilityFax ,

			ISNULL(IIF ( C.PanelNbr > 0, '99999', D.NPINbr),'99999') AS DoctorNPINbr99999

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
			LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
			LEFT OUTER JOIN tblEWFacility AS F ON F.EWFacilityID = O.EWFacilityID
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
PRINT N'Altering [dbo].[vwPDFInvData]...';


GO
ALTER VIEW vwPDFInvData
AS
    SELECT  AH.CaseNbr AS InvCaseNbr ,
            AT.ApptDate AS InvApptDate,
            AT.ApptTime AS InvApptTime,
            AT.DrOpCode AS InvDoctorCode ,
            AT.DoctorLocation AS InvLocationCode ,
			AH.CompanyCode AS InvCompanyCode ,

			AH.HeaderID ,
			AH.DocumentNbr ,
            AH.DocumentDate AS DocumentDateValue ,
			B.BlankValue AS DocumentDate ,
            AH.DocumentType ,
            AH.TaxTotal ,
            AH.DocumentTotal ,
            AH.EWFacilityID ,
            ISNULL(CO.InvRemitEWFacilityID, ISNULL(F.InvRemitEWFacilityID, AH.EWFacilityID)) AS RemitEWFacilityID ,

			B.BlankValue AS InvoiceAmtDollars,
			B.BlankValue AS InvoiceAmtCents,
			B.BlankValue AS InvoiceAmtDollars_P1,
			B.BlankValue AS InvoiceAmtCents_P1,
			B.BlankValue AS InvoiceAmtDollars_P2,
			B.BlankValue AS InvoiceAmtCents_P2,
			B.BlankValue AS InvoiceAmtDollars_P3,
			B.BlankValue AS InvoiceAmtCents_P3,
			B.BlankValue AS InvoicePaymentCreditAmtDollars,
			B.BlankValue AS InvoicePaymentCreditAmtCents,
			B.BlankValue AS InvoiceBalanceDueDollars,
			B.BlankValue AS InvoiceBalanceDueCents,
            
			F.GPFacility ,
			F.LegalName AS BillingProviderName ,
			F.FedTaxID AS BillingProviderTaxID ,
            F.AcctingPhone AS BillingProviderPhone ,
			F.AcctingPhone AS BillingProviderPhoneAreaCode ,
			F.AcctingPhone AS BillingProviderPhoneNumber ,

			F.GPFacility+'-'+CAST(AH.DocumentNbr AS VARCHAR(20)) AS InvoiceNbr ,

			CASE WHEN ISNULL(FRemit.RemitAddress,'')='' THEN FRemit.Address ELSE FRemit.RemitAddress END AS BillingProviderAddress ,
			CASE WHEN ISNULL(FRemit.RemitAddress,'')='' THEN
			 ISNULL(FRemit.City, '') + ', ' + ISNULL(UPPER(FRemit.State), '') + ' ' + ISNULL(FRemit.Zip, '')
			ELSE
			  ISNULL(FRemit.RemitCity, '') + ', ' + ISNULL(UPPER(FRemit.RemitState), '') + ' ' + ISNULL(FRemit.RemitZip, '')
			END AS BillingProviderCityStateZip ,

			CO.ExtName AS InvCoExtName,
            
			CL.BillAddr1 AS InvClBillAddr1,
            CL.BillAddr2 AS InvClBillAddr2,
            CL.BillCity AS InvClBillCity ,
            UPPER(CL.BillState) AS InvClBillState ,
            CL.BillZip AS InvClBillZip ,
            CL.Addr1 AS InvClAddr1 ,
            CL.Addr2 AS InvClAddr2 ,
            CL.City AS InvClCity ,
            UPPER(CL.State) AS InvClState ,
            CL.Zip AS InvClZip ,
			
			B.BlankValueLong AS Payor

    FROM    tblAcctHeader AS AH
            LEFT OUTER JOIN tblAcctingTrans AS AT ON AT.SeqNO = AH.SeqNo
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = AH.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = AH.CompanyCode
            LEFT OUTER JOIN tblEWFacility AS F ON F.EWFacilityID = AH.EWFacilityID
			LEFT OUTER JOIN tblEWFacility AS FRemit ON ISNULL(CO.InvRemitEWFacilityID, ISNULL(F.InvRemitEWFacilityID, AH.EWFacilityID))=FRemit.EWFacilityID
			LEFT OUTER JOIN tblBlank AS B ON 1=1
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
PRINT N'Altering [dbo].[vwPDFInvDetData]...';


GO
ALTER VIEW vwPDFInvDetData
AS
	SELECT	
			AD1.LineNbr AS InvLineNbr1 ,
	        AD1.Date AS InvServiceDate1 ,
			B.BlankValue AS InvServiceDate1MM,
			B.BlankValue AS InvServiceDate1DD,
			B.BlankValue AS InvServiceDate1YY,
			B.BlankValue AS InvServiceDateTo1MM,
			B.BlankValue AS InvServiceDateTo1DD,
			B.BlankValue AS InvServiceDateTo1YY,
	        AD1.CPTCode AS InvCPT1,
	        AD1.Modifier AS InvModifier1,
	        AD1.Modifier2 AS InvModifier1b ,
	        AD1.Modifier3 AS InvModifier1c ,
	        AD1.Modifier4 AS InvModifier1d ,
			B.BlankValue AS InvICD1,
			B.BlankValue AS InvDiagnosisPointer1,
	        AD1.Location AS InvPlaceOfService1,
			'2' AS InvTypeOfService1,
	        AD1.SuppInfo AS SupplementalInfo1,
	        AD1.Unit AS InvUnit1,
	        AD1.ExtendedAmount AS InvDetAmt1,
			AD1.RetailAmount AS InvRetailAmt1,
	        B.BlankValue AS InvDetAmt1Dollars,
			B.BlankValue AS InvDetAmt1Cents,
	        B.BlankValue AS InvDetAmt1bDollars,
			B.BlankValue AS InvDetAmt1bCents,
			AD1.DrOpCode AS DrOpCode1,
			DR1.NPINbr AS DoctorNPINbr1,


			AD2.LineNbr AS InvLineNbr2 ,
	        AD2.Date AS InvServiceDate2 ,
			B.BlankValue AS InvServiceDate2MM,
			B.BlankValue AS InvServiceDate2DD,
			B.BlankValue AS InvServiceDate2YY,
			B.BlankValue AS InvServiceDateTo2MM,
			B.BlankValue AS InvServiceDateTo2DD,
			B.BlankValue AS InvServiceDateTo2YY,
	        AD2.CPTCode AS InvCPT2,
	        AD2.Modifier AS InvModifier2,
	        AD2.Modifier2 AS InvModifier2b ,
	        AD2.Modifier3 AS InvModifier2c ,
	        AD2.Modifier4 AS InvModifier2d ,
			B.BlankValue AS InvICD2,
			B.BlankValue AS InvDiagnosisPointer2,
	        AD2.Location AS InvPlaceOfService2,
			'2' AS InvTypeOfService2,
	        AD2.SuppInfo AS SupplementalInfo2,
	        AD2.Unit AS InvUnit2,
	        AD2.ExtendedAmount AS InvDetAmt2,
			AD2.RetailAmount AS InvRetailAmt2,
	        B.BlankValue AS InvDetAmt2Dollars,
			B.BlankValue AS InvDetAmt2Cents,
	        B.BlankValue AS InvDetAmt2bDollars,
			B.BlankValue AS InvDetAmt2bCents,
			AD2.DrOpCode AS DrOpCode2,
			DR2.NPINbr AS DoctorNPINbr2,


			AD3.LineNbr AS InvLineNbr3 ,
	        AD3.Date AS InvServiceDate3 ,
			B.BlankValue AS InvServiceDate3MM,
			B.BlankValue AS InvServiceDate3DD,
			B.BlankValue AS InvServiceDate3YY,
			B.BlankValue AS InvServiceDateTo3MM,
			B.BlankValue AS InvServiceDateTo3DD,
			B.BlankValue AS InvServiceDateTo3YY,
	        AD3.CPTCode AS InvCPT3,
	        AD3.Modifier AS InvModifier3,
	        AD3.Modifier2 AS InvModifier3b ,
	        AD3.Modifier3 AS InvModifier3c ,
	        AD3.Modifier4 AS InvModifier3d ,
			B.BlankValue AS InvICD3,
			B.BlankValue AS InvDiagnosisPointer3,
	        AD3.Location AS InvPlaceOfService3,
			'2' AS InvTypeOfService3,
	        AD3.SuppInfo AS SupplementalInfo3,
	        AD3.Unit AS InvUnit3,
	        AD3.ExtendedAmount AS InvDetAmt3,
	        AD3.RetailAmount AS InvRetailAmt3,
			B.BlankValue AS InvDetAmt3Dollars,
			B.BlankValue AS InvDetAmt3Cents,
			B.BlankValue AS InvDetAmt3bDollars,
			B.BlankValue AS InvDetAmt3bCents,
			AD3.DrOpCode AS DrOpCode3,
			DR3.NPINbr AS DoctorNPINbr3,


			AD4.LineNbr AS InvLineNbr4 ,
	        AD4.Date AS InvServiceDate4 ,
			B.BlankValue AS InvServiceDate4MM,
			B.BlankValue AS InvServiceDate4DD,
			B.BlankValue AS InvServiceDate4YY,
			B.BlankValue AS InvServiceDateTo4MM,
			B.BlankValue AS InvServiceDateTo4DD,
			B.BlankValue AS InvServiceDateTo4YY,
	        AD4.CPTCode AS InvCPT4,
	        AD4.Modifier AS InvModifier4,
	        AD4.Modifier2 AS InvModifier4b ,
	        AD4.Modifier3 AS InvModifier4c ,
	        AD4.Modifier4 AS InvModifier4d ,
			B.BlankValue AS InvICD4,
			B.BlankValue AS InvDiagnosisPointer4,
	        AD4.Location AS InvPlaceOfService4,
			'2' AS InvTypeOfService4,
	        AD4.SuppInfo AS SupplementalInfo4,
	        AD4.Unit AS InvUnit4,
	        AD4.ExtendedAmount AS InvDetAmt4,
			AD4.RetailAmount AS InvRetailAmt4,
	        B.BlankValue AS InvDetAmt4Dollars,
			B.BlankValue AS InvDetAmt4Cents,
	        B.BlankValue AS InvDetAmt4bDollars,
			B.BlankValue AS InvDetAmt4bCents,
			AD4.DrOpCode AS DrOpCode4,
			DR4.NPINbr AS DoctorNPINbr4,


			AD5.LineNbr AS InvLineNbr5 ,
	        AD5.Date AS InvServiceDate5 ,
			B.BlankValue AS InvServiceDate5MM,
			B.BlankValue AS InvServiceDate5DD,
			B.BlankValue AS InvServiceDate5YY,
			B.BlankValue AS InvServiceDateTo5MM,
			B.BlankValue AS InvServiceDateTo5DD,
			B.BlankValue AS InvServiceDateTo5YY,
	        AD5.CPTCode AS InvCPT5,
	        AD5.Modifier AS InvModifier5,
	        AD5.Modifier2 AS InvModifier5b ,
	        AD5.Modifier3 AS InvModifier5c ,
	        AD5.Modifier4 AS InvModifier5d ,
			B.BlankValue AS InvICD5,
			B.BlankValue AS InvDiagnosisPointer5,
	        AD5.Location AS InvPlaceOfService5,
			'2' AS InvTypeOfService5,
	        AD5.SuppInfo AS SupplementalInfo5,
	        AD5.Unit AS InvUnit5,
	        AD5.ExtendedAmount AS InvDetAmt5,
			AD5.RetailAmount AS InvRetailAmt5,
	        B.BlankValue AS InvDetAmt5Dollars,
			B.BlankValue AS InvDetAmt5Cents,
	        B.BlankValue AS InvDetAmt5bDollars,
			B.BlankValue AS InvDetAmt5bCents,
			AD5.DrOpCode AS DrOpCode5,
			DR5.NPINbr AS DoctorNPINbr5,


			AD6.LineNbr AS InvLineNbr6 ,
	        AD6.Date AS InvServiceDate6 ,
			B.BlankValue AS InvServiceDate6MM,
			B.BlankValue AS InvServiceDate6DD,
			B.BlankValue AS InvServiceDate6YY,
			B.BlankValue AS InvServiceDateTo6MM,
			B.BlankValue AS InvServiceDateTo6DD,
			B.BlankValue AS InvServiceDateTo6YY,
	        AD6.CPTCode AS InvCPT6,
	        AD6.Modifier AS InvModifier6,
	        AD6.Modifier2 AS InvModifier6b ,
	        AD6.Modifier3 AS InvModifier6c ,
	        AD6.Modifier4 AS InvModifier6d ,
			B.BlankValue AS InvICD6,
			B.BlankValue AS InvDiagnosisPointer6,
	        AD6.Location AS InvPlaceOfService6,
			'2' AS InvTypeOfService6,
	        AD6.SuppInfo AS SupplementalInfo6,
	        AD6.Unit AS InvUnit6,
	        AD6.ExtendedAmount AS InvDetAmt6,
			AD6.RetailAmount AS InvRetailAmt6,
	        B.BlankValue AS InvDetAmt6Dollars,
			B.BlankValue AS InvDetAmt6Cents,
	        B.BlankValue AS InvDetAmt6bDollars,
			B.BlankValue AS InvDetAmt6bCents,
			AD6.DrOpCode AS DrOpCode6,
			DR6.NPINbr AS DoctorNPINbr6,


			AD7.LineNbr AS InvLineNbr7 ,
	        AD7.Date AS InvServiceDate7 ,
			B.BlankValue AS InvServiceDate7MM,
			B.BlankValue AS InvServiceDate7DD,
			B.BlankValue AS InvServiceDate7YY,
			B.BlankValue AS InvServiceDateTo7MM,
			B.BlankValue AS InvServiceDateTo7DD,
			B.BlankValue AS InvServiceDateTo7YY,
	        AD7.CPTCode AS InvCPT7,
	        AD7.Modifier AS InvModifier7,
	        AD7.Modifier2 AS InvModifier7b ,
	        AD7.Modifier3 AS InvModifier7c ,
	        AD7.Modifier4 AS InvModifier7d ,
			B.BlankValue AS InvICD7,
			B.BlankValue AS InvDiagnosisPointer7,
	        AD7.Location AS InvPlaceOfService7,
			'2' AS InvTypeOfService7,
	        AD7.SuppInfo AS SupplementalInfo7,
	        AD7.Unit AS InvUnit7,
	        AD7.ExtendedAmount AS InvDetAmt7,
			AD7.RetailAmount AS InvRetailAmt7,
	        B.BlankValue AS InvDetAmt7Dollars,
			B.BlankValue AS InvDetAmt7Cents,
	        B.BlankValue AS InvDetAmt7bDollars,
			B.BlankValue AS InvDetAmt7bCents,
			AD7.DrOpCode AS DrOpCode7,
			DR7.NPINbr AS DoctorNPINbr7,


			AD8.LineNbr AS InvLineNbr8 ,
	        AD8.Date AS InvServiceDate8 ,
			B.BlankValue AS InvServiceDate8MM,
			B.BlankValue AS InvServiceDate8DD,
			B.BlankValue AS InvServiceDate8YY,
			B.BlankValue AS InvServiceDateTo8MM,
			B.BlankValue AS InvServiceDateTo8DD,
			B.BlankValue AS InvServiceDateTo8YY,
	        AD8.CPTCode AS InvCPT8,
	        AD8.Modifier AS InvModifier8,
	        AD8.Modifier2 AS InvModifier8b ,
	        AD8.Modifier3 AS InvModifier8c ,
	        AD8.Modifier4 AS InvModifier8d ,
			B.BlankValue AS InvICD8,
			B.BlankValue AS InvDiagnosisPointer8,
	        AD8.Location AS InvPlaceOfService8,
			'2' AS InvTypeOfService8,
	        AD8.SuppInfo AS SupplementalInfo8,
	        AD8.Unit AS InvUnit8,
	        AD8.ExtendedAmount AS InvDetAmt8,
			AD8.RetailAmount AS InvRetailAmt8,
	        B.BlankValue AS InvDetAmt8Dollars,
			B.BlankValue AS InvDetAmt8Cents,
	        B.BlankValue AS InvDetAmt8bDollars,
			B.BlankValue AS InvDetAmt8bCents,
			AD8.DrOpCode AS DrOpCode8,
			DR8.NPINbr AS DoctorNPINbr8,


	        AD9.Date AS InvServiceDate9 ,
			B.BlankValue AS InvServiceDate9MM,
			B.BlankValue AS InvServiceDate9DD,
			B.BlankValue AS InvServiceDate9YY,
			AD9.LineNbr AS InvLineNbr9 ,
			B.BlankValue AS InvServiceDateTo9MM,
			B.BlankValue AS InvServiceDateTo9DD,
			B.BlankValue AS InvServiceDateTo9YY,
	        AD9.CPTCode AS InvCPT9,
	        AD9.Modifier AS InvModifier9,
	        AD9.Modifier2 AS InvModifier9b ,
	        AD9.Modifier3 AS InvModifier9c ,
	        AD9.Modifier4 AS InvModifier9d ,
			B.BlankValue AS InvICD9,
			B.BlankValue AS InvDiagnosisPointer9,
	        AD9.Location AS InvPlaceOfService9,
			'2' AS InvTypeOfService9,
	        AD9.SuppInfo AS SupplementalInfo9,
	        AD9.Unit AS InvUnit9,
	        AD9.ExtendedAmount AS InvDetAmt9,
			AD9.RetailAmount AS InvRetailAmt9,
	        B.BlankValue AS InvDetAmt9Dollars,
			B.BlankValue AS InvDetAmt9Cents,
	        B.BlankValue AS InvDetAmt9bDollars,
			B.BlankValue AS InvDetAmt9bCents,
			AD9.DrOpCode AS DrOpCode9,
			DR9.NPINbr AS DoctorNPINbr9,


			AD10.LineNbr AS InvLineNbr10 ,
	        AD10.Date AS InvServiceDate10 ,
			B.BlankValue AS InvServiceDate10MM,
			B.BlankValue AS InvServiceDate10DD,
			B.BlankValue AS InvServiceDate10YY,
			B.BlankValue AS InvServiceDateTo10MM,
			B.BlankValue AS InvServiceDateTo10DD,
			B.BlankValue AS InvServiceDateTo10YY,
	        AD10.CPTCode AS InvCPT10,
	        AD10.Modifier AS InvModifier10,
	        AD10.Modifier2 AS InvModifier10b ,
	        AD10.Modifier3 AS InvModifier10c ,
	        AD10.Modifier4 AS InvModifier10d ,
			B.BlankValue AS InvICD10,
			B.BlankValue AS InvDiagnosisPointer10,
	        AD10.Location AS InvPlaceOfService10,
			'2' AS InvTypeOfService10,
	        AD10.SuppInfo AS SupplementalInfo10,
	        AD10.Unit AS InvUnit10,
	        AD10.ExtendedAmount AS InvDetAmt10,
			AD10.RetailAmount AS InvRetailAmt10,
	        B.BlankValue AS InvDetAmt10Dollars,
			B.BlankValue AS InvDetAmt10Cents,
	        B.BlankValue AS InvDetAmt10bDollars,
			B.BlankValue AS InvDetAmt10bCents,
			AD10.DrOpCode AS DrOpCode10,
			DR10.NPINbr AS DoctorNPINbr10,


			AD11.LineNbr AS InvLineNbr11 ,
	        AD11.Date AS InvServiceDate11 ,
			B.BlankValue AS InvServiceDate11MM,
			B.BlankValue AS InvServiceDate11DD,
			B.BlankValue AS InvServiceDate11YY,
			B.BlankValue AS InvServiceDateTo11MM,
			B.BlankValue AS InvServiceDateTo11DD,
			B.BlankValue AS InvServiceDateTo11YY,
	        AD11.CPTCode AS InvCPT11,
	        AD11.Modifier AS InvModifier11,
	        AD11.Modifier2 AS InvModifier11b ,
	        AD11.Modifier3 AS InvModifier11c ,
	        AD11.Modifier4 AS InvModifier11d ,
			B.BlankValue AS InvICD11,
			B.BlankValue AS InvDiagnosisPointer11,
	        AD11.Location AS InvPlaceOfService11,
			'2' AS InvTypeOfService11,
	        AD11.SuppInfo AS SupplementalInfo11,
	        AD11.Unit AS InvUnit11,
	        AD11.ExtendedAmount AS InvDetAmt11,
			AD11.RetailAmount AS InvRetailAmt11,
	        B.BlankValue AS InvDetAmt11Dollars,
			B.BlankValue AS InvDetAmt11Cents,
	        B.BlankValue AS InvDetAmt11bDollars,
			B.BlankValue AS InvDetAmt11bCents,
			AD11.DrOpCode AS DrOpCode11,
			DR11.NPINbr AS DoctorNPINbr11,

			AD12.LineNbr AS InvLineNbr12 ,
	        AD12.Date AS InvServiceDate12 ,
			B.BlankValue AS InvServiceDate12MM,
			B.BlankValue AS InvServiceDate12DD,
			B.BlankValue AS InvServiceDate12YY,
			B.BlankValue AS InvServiceDateTo12MM,
			B.BlankValue AS InvServiceDateTo12DD,
			B.BlankValue AS InvServiceDateTo12YY,
	        AD12.CPTCode AS InvCPT12,
	        AD12.Modifier AS InvModifier12,
	        AD12.Modifier2 AS InvModifier12b ,
	        AD12.Modifier3 AS InvModifier12c ,
	        AD12.Modifier4 AS InvModifier12d ,
			B.BlankValue AS InvICD12,
			B.BlankValue AS InvDiagnosisPointer12,
	        AD12.Location AS InvPlaceOfService12,
			'2' AS InvTypeOfService12,
	        AD12.SuppInfo AS SupplementalInfo12,
	        AD12.Unit AS InvUnit12,
	        AD12.ExtendedAmount AS InvDetAmt12,
			AD12.RetailAmount AS InvRetailAmt12,
	        B.BlankValue AS InvDetAmt12Dollars,
			B.BlankValue AS InvDetAmt12Cents,
	        B.BlankValue AS InvDetAmt12bDollars,
			B.BlankValue AS InvDetAmt12bCents,
			AD12.DrOpCode AS DrOpCode12,
			DR12.NPINbr AS DoctorNPINbr12,


			AD13.LineNbr AS InvLineNbr13 ,
	        AD13.Date AS InvServiceDate13 ,
			B.BlankValue AS InvServiceDate13MM,
			B.BlankValue AS InvServiceDate13DD,
			B.BlankValue AS InvServiceDate13YY,
			B.BlankValue AS InvServiceDateTo13MM,
			B.BlankValue AS InvServiceDateTo13DD,
			B.BlankValue AS InvServiceDateTo13YY,
	        AD13.CPTCode AS InvCPT13,
	        AD13.Modifier AS InvModifier13,
	        AD13.Modifier2 AS InvModifier13b ,
	        AD13.Modifier3 AS InvModifier13c ,
	        AD13.Modifier4 AS InvModifier13d ,
			B.BlankValue AS InvICD13,
			B.BlankValue AS InvDiagnosisPointer13,
	        AD13.Location AS InvPlaceOfService13,
			'2' AS InvTypeOfService13,
	        AD13.SuppInfo AS SupplementalInfo13,
	        AD13.Unit AS InvUnit13,
	        AD13.ExtendedAmount AS InvDetAmt13,
			AD13.RetailAmount AS InvRetailAmt13,
	        B.BlankValue AS InvDetAmt13Dollars,
			B.BlankValue AS InvDetAmt13Cents,
	        B.BlankValue AS InvDetAmt13bDollars,
			B.BlankValue AS InvDetAmt13bCents,
			AD13.DrOpCode AS DrOpCode13,
			DR13.NPINbr AS DoctorNPINbr13,


			AD14.LineNbr AS InvLineNbr14 ,
	        AD14.Date AS InvServiceDate14 ,
			B.BlankValue AS InvServiceDate14MM,
			B.BlankValue AS InvServiceDate14DD,
			B.BlankValue AS InvServiceDate14YY,
			B.BlankValue AS InvServiceDateTo14MM,
			B.BlankValue AS InvServiceDateTo14DD,
			B.BlankValue AS InvServiceDateTo14YY,
	        AD14.CPTCode AS InvCPT14,
	        AD14.Modifier AS InvModifier14,
	        AD14.Modifier2 AS InvModifier14b ,
	        AD14.Modifier3 AS InvModifier14c ,
	        AD14.Modifier4 AS InvModifier14d ,
			B.BlankValue AS InvICD14,
			B.BlankValue AS InvDiagnosisPointer14,
	        AD14.Location AS InvPlaceOfService14,
			'2' AS InvTypeOfService14,
	        AD14.SuppInfo AS SupplementalInfo14,
	        AD14.Unit AS InvUnit14,
	        AD14.ExtendedAmount AS InvDetAmt14,
			AD14.RetailAmount AS InvRetailAmt14,
	        B.BlankValue AS InvDetAmt14Dollars,
			B.BlankValue AS InvDetAmt14Cents,
	        B.BlankValue AS InvDetAmt14bDollars,
			B.BlankValue AS InvDetAmt14bCents,
			AD14.DrOpCode AS DrOpCode14,
			DR14.NPINbr AS DoctorNPINbr14,


			AD15.LineNbr AS InvLineNbr15 ,
	        AD15.Date AS InvServiceDate15 ,
			B.BlankValue AS InvServiceDate15MM,
			B.BlankValue AS InvServiceDate15DD,
			B.BlankValue AS InvServiceDate15YY,
			B.BlankValue AS InvServiceDateTo15MM,
			B.BlankValue AS InvServiceDateTo15DD,
			B.BlankValue AS InvServiceDateTo15YY,
	        AD15.CPTCode AS InvCPT15,
	        AD15.Modifier AS InvModifier15,
	        AD15.Modifier2 AS InvModifier15b ,
	        AD15.Modifier3 AS InvModifier15c ,
	        AD15.Modifier4 AS InvModifier15d ,
			B.BlankValue AS InvICD15,
			B.BlankValue AS InvDiagnosisPointer15,
	        AD15.Location AS InvPlaceOfService15,
			'2' AS InvTypeOfService15,
	        AD15.SuppInfo AS SupplementalInfo15,
	        AD15.Unit AS InvUnit15,
	        AD15.ExtendedAmount AS InvDetAmt15,
			AD15.RetailAmount AS InvRetailAmt15,
	        B.BlankValue AS InvDetAmt15Dollars,
			B.BlankValue AS InvDetAmt15Cents,
	        B.BlankValue AS InvDetAmt15bDollars,
			B.BlankValue AS InvDetAmt15bCents,
			AD15.DrOpCode AS DrOpCode15,
			DR15.NPINbr AS DoctorNPINbr15,


			AD16.LineNbr AS InvLineNbr16 ,
	        AD16.Date AS InvServiceDate16 ,
			B.BlankValue AS InvServiceDate16MM,
			B.BlankValue AS InvServiceDate16DD,
			B.BlankValue AS InvServiceDate16YY,
			B.BlankValue AS InvServiceDateTo16MM,
			B.BlankValue AS InvServiceDateTo16DD,
			B.BlankValue AS InvServiceDateTo16YY,
	        AD16.CPTCode AS InvCPT16,
	        AD16.Modifier AS InvModifier16,
	        AD16.Modifier2 AS InvModifier16b ,
	        AD16.Modifier3 AS InvModifier16c ,
	        AD16.Modifier4 AS InvModifier16d ,
			B.BlankValue AS InvICD16,
			B.BlankValue AS InvDiagnosisPointer16,
	        AD16.Location AS InvPlaceOfService16,
			'2' AS InvTypeOfService16,
	        AD16.SuppInfo AS SupplementalInfo16,
	        AD16.Unit AS InvUnit16,
	        AD16.ExtendedAmount AS InvDetAmt16,
			AD16.RetailAmount AS InvRetailAmt16,
	        B.BlankValue AS InvDetAmt16Dollars,
			B.BlankValue AS InvDetAmt16Cents,
	        B.BlankValue AS InvDetAmt16bDollars,
			B.BlankValue AS InvDetAmt16bCents,
			AD16.DrOpCode AS DrOpCode16,
			DR16.NPINbr AS DoctorNPINbr16,


			AD17.LineNbr AS InvLineNbr17 ,
	        AD17.Date AS InvServiceDate17 ,
			B.BlankValue AS InvServiceDate17MM,
			B.BlankValue AS InvServiceDate17DD,
			B.BlankValue AS InvServiceDate17YY,
			B.BlankValue AS InvServiceDateTo17MM,
			B.BlankValue AS InvServiceDateTo17DD,
			B.BlankValue AS InvServiceDateTo17YY,
	        AD17.CPTCode AS InvCPT17,
	        AD17.Modifier AS InvModifier17,
	        AD17.Modifier2 AS InvModifier17b ,
	        AD17.Modifier3 AS InvModifier17c ,
	        AD17.Modifier4 AS InvModifier17d ,
			B.BlankValue AS InvICD17,
			B.BlankValue AS InvDiagnosisPointer17,
	        AD17.Location AS InvPlaceOfService17,
			'2' AS InvTypeOfService17,
	        AD17.SuppInfo AS SupplementalInfo17,
	        AD17.Unit AS InvUnit17,
	        AD17.ExtendedAmount AS InvDetAmt17,
			AD17.RetailAmount AS InvRetailAmt17,
	        B.BlankValue AS InvDetAmt17Dollars,
			B.BlankValue AS InvDetAmt17Cents,
	        B.BlankValue AS InvDetAmt17bDollars,
			B.BlankValue AS InvDetAmt17bCents,
			AD17.DrOpCode AS DrOpCode17,
			DR17.NPINbr AS DoctorNPINbr17,


			AD18.LineNbr AS InvLineNbr18 ,
	        AD18.Date AS InvServiceDate18 ,
			B.BlankValue AS InvServiceDate18MM,
			B.BlankValue AS InvServiceDate18DD,
			B.BlankValue AS InvServiceDate18YY,
			B.BlankValue AS InvServiceDateTo18MM,
			B.BlankValue AS InvServiceDateTo18DD,
			B.BlankValue AS InvServiceDateTo18YY,
	        AD18.CPTCode AS InvCPT18,
	        AD18.Modifier AS InvModifier18,
	        AD18.Modifier2 AS InvModifier18b ,
	        AD18.Modifier3 AS InvModifier18c ,
	        AD18.Modifier4 AS InvModifier18d ,
			B.BlankValue AS InvICD18,
			B.BlankValue AS InvDiagnosisPointer18,
	        AD18.Location AS InvPlaceOfService18,
			'2' AS InvTypeOfService18,
	        AD18.SuppInfo AS SupplementalInfo18,
	        AD18.Unit AS InvUnit18,
	        AD18.ExtendedAmount AS InvDetAmt18,
			AD18.RetailAmount AS InvRetailAmt18,
	        B.BlankValue AS InvDetAmt18Dollars,
			B.BlankValue AS InvDetAmt18Cents,
	        B.BlankValue AS InvDetAmt18bDollars,
			B.BlankValue AS InvDetAmt18bCents,
			AD18.DrOpCode AS DrOpCode18,
			DR18.NPINbr AS DoctorNPINbr18,

			B.BlankValue AS InvICDDiagnosisPointer,
			AD1.HeaderID AS InvDetHeaderID

	FROM	tblAcctDetail AS AD1
	LEFT OUTER JOIN tblAcctDetail AS AD2 ON AD2.HeaderID = AD1.HeaderID AND AD2.LineNbr=2
	LEFT OUTER JOIN tblAcctDetail AS AD3 ON AD3.HeaderID = AD1.HeaderID AND AD3.LineNbr=3
	LEFT OUTER JOIN tblAcctDetail AS AD4 ON AD4.HeaderID = AD1.HeaderID AND AD4.LineNbr=4
	LEFT OUTER JOIN tblAcctDetail AS AD5 ON AD5.HeaderID = AD1.HeaderID AND AD5.LineNbr=5
	LEFT OUTER JOIN tblAcctDetail AS AD6 ON AD6.HeaderID = AD1.HeaderID AND AD6.LineNbr=6
	LEFT OUTER JOIN tblAcctDetail AS AD7 ON AD7.HeaderID = AD1.HeaderID AND AD7.LineNbr=7
	LEFT OUTER JOIN tblAcctDetail AS AD8 ON AD8.HeaderID = AD1.HeaderID AND AD8.LineNbr=8
	LEFT OUTER JOIN tblAcctDetail AS AD9 ON AD9.HeaderID = AD1.HeaderID AND AD9.LineNbr=9
	LEFT OUTER JOIN tblAcctDetail AS AD10 ON AD10.HeaderID = AD1.HeaderID AND AD10.LineNbr=10
	LEFT OUTER JOIN tblAcctDetail AS AD11 ON AD11.HeaderID = AD1.HeaderID AND AD11.LineNbr=11
	LEFT OUTER JOIN tblAcctDetail AS AD12 ON AD12.HeaderID = AD1.HeaderID AND AD12.LineNbr=12
	LEFT OUTER JOIN tblAcctDetail AS AD13 ON AD13.HeaderID = AD1.HeaderID AND AD13.LineNbr=13
	LEFT OUTER JOIN tblAcctDetail AS AD14 ON AD14.HeaderID = AD1.HeaderID AND AD14.LineNbr=14
	LEFT OUTER JOIN tblAcctDetail AS AD15 ON AD15.HeaderID = AD1.HeaderID AND AD15.LineNbr=15
	LEFT OUTER JOIN tblAcctDetail AS AD16 ON AD16.HeaderID = AD1.HeaderID AND AD16.LineNbr=16
	LEFT OUTER JOIN tblAcctDetail AS AD17 ON AD17.HeaderID = AD1.HeaderID AND AD17.LineNbr=17
	LEFT OUTER JOIN tblAcctDetail AS AD18 ON AD18.HeaderID = AD1.HeaderID AND AD18.LineNbr=18
	LEFT OUTER JOIN tblDoctor AS DR1 ON AD1.DrOpCode=DR1.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR2 ON AD2.DrOpCode=DR2.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR3 ON AD3.DrOpCode=DR3.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR4 ON AD4.DrOpCode=DR4.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR5 ON AD5.DrOpCode=DR5.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR6 ON AD6.DrOpCode=DR6.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR7 ON AD7.DrOpCode=DR7.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR8 ON AD8.DrOpCode=DR8.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR9 ON AD9.DrOpCode=DR9.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR10 ON AD10.DrOpCode=DR10.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR11 ON AD11.DrOpCode=DR11.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR12 ON AD12.DrOpCode=DR12.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR13 ON AD13.DrOpCode=DR13.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR14 ON AD14.DrOpCode=DR14.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR15 ON AD15.DrOpCode=DR15.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR16 ON AD16.DrOpCode=DR16.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR17 ON AD17.DrOpCode=DR17.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR18 ON AD18.DrOpCode=DR18.DoctorCode
	LEFT OUTER JOIN tblBlank AS B ON 1=1
	WHERE AD1.LineNbr=1
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
			'%CMSBox24JNonNPILine7%' AS PrimaryDoctorNonNPINbr7,
			'%CMSBox24JNonNPILine8%' AS PrimaryDoctorNonNPINbr8,
			'%CMSBox24JNonNPILine9%' AS PrimaryDoctorNonNPINbr9,
			'%CMSBox24JNonNPILine10%' AS PrimaryDoctorNonNPINbr10,
			'%CMSBox24JNonNPILine11%' AS PrimaryDoctorNonNPINbr11,
			'%CMSBox24JNonNPILine12%' AS PrimaryDoctorNonNPINbr12,
			'%CMSBox24JNonNPILine13%' AS PrimaryDoctorNonNPINbr13,
			'%CMSBox24JNonNPILine14%' AS PrimaryDoctorNonNPINbr14,
			'%CMSBox24JNonNPILine15%' AS PrimaryDoctorNonNPINbr15,
			'%CMSBox24JNonNPILine16%' AS PrimaryDoctorNonNPINbr16,
			'%CMSBox24JNonNPILine17%' AS PrimaryDoctorNonNPINbr17,
			'%CMSBox24JNonNPILine18%' AS PrimaryDoctorNonNPINbr18,

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
			B.BlankValue AS CMSBox6Other ,									--doc override
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

			B.BlankValue AS CMSBox11,                                       --doc override
			B.BlankValue AS CMSBox12,                                       --doc override
			B.BlankValue AS CMSBox12Date,                                   --doc override
			B.BlankValue AS CMSBox13,                                       --doc override
			B.BlankValue AS CMSBox14Qual,									--doc override

			B.BlankValue AS CMSBox17Qual,									--doc override
			B.BlankValue AS CMSBox17 ,										--doc override
			B.BlankValue AS CMSBox17a ,										--doc override
			B.BlankValue AS CMSBox17aQual ,									--doc override
			B.BlankValue AS CMSBox17b ,										--doc override
			
			B.BlankValue AS CMSBox19 ,										--doc override	
			B.BlankValue AS CMSBox19_P1 ,									--doc override	
			B.BlankValue AS CMSBox19_P2 ,									--doc override
			B.BlankValue AS CMSBox19_P3 ,									--doc override

			B.BlankValue AS CMSBox23 ,										--inv override
			B.BlankValue AS CMSBox24JNonNPINbr ,							--doc and inv override
			B.BlankValue AS CMSBox24JNonNPIQual ,							--doc override

			B.BlankValue AS CMSBox24JNonNPIQualLine1 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine2 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine3 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine4 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine5 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine6 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine7 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine8 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine9 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine10 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine11 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine12 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine13 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine14 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine15 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine16 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine17 ,						--doc override
			B.BlankValue AS CMSBox24JNonNPIQualLine18 ,						--doc override

			B.BlankValue AS CMSBox24JNonNPILine1 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine2 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine3 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine4 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine5 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine6 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine7 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine8 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine9 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine10 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine11 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine12 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine13 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine14 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine15 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine16 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine17 ,							--doc override
			B.BlankValue AS CMSBox24JNonNPILine18 ,							--doc override

			B.BlankValue AS CMSBox24JNPILine1 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine2 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine3 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine4 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine5 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine6 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine7 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine8 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine9 ,								--doc override
			B.BlankValue AS CMSBox24JNPILine10 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine11 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine12 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine13 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine14 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine15 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine16 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine17 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine18 ,							--doc override

			B.BlankValue AS CMSBox25,
			B.BlankValue AS CMSBox26,										--inv override
			B.BlankValue AS CMSBox27Yes ,									--doc override

			B.BlankValue AS CMSBox28Dollars_P1,								--inv override
			B.BlankValue AS CMSBox28Dollars_P2,								--inv override
			B.BlankValue AS CMSBox28Dollars_P3,								--inv override
			B.BlankValue AS CMSBox28Cents_P1,								--inv override
			B.BlankValue AS CMSBox28Cents_P2,								--inv override
			B.BlankValue AS CMSBox28Cents_P3,								--inv override

			B.BlankValueLong AS CMSBox31Line1 ,								--doc and inv override
			B.BlankValue AS CMSBox31Line2 ,									--doc and inv override

			B.BlankValue AS CMSBox32a ,										--doc override
			B.BlankValue AS CMSBox32b ,										--doc and inv override

			B.BlankValue AS CMSBox33Line1 ,									--doc override
			B.BlankValue AS CMSBox33Line2 ,									--doc override
			B.BlankValue AS CMSBox33Line3 ,									--doc override
			B.BlankValue AS CMSBox33AreaCode,								--doc override
			B.BlankValue AS CMSBox33PhoneNumber,							--doc override
			B.BlankValue AS CMSBox33a,										--doc override
			B.BlankValue AS CMSBox33b 										--doc and inv override

	FROM	tblBlank AS B
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
PRINT N'Altering [dbo].[vwRptDoctorScheduleSlot]...';


GO
ALTER VIEW vwRptDoctorScheduleSlot
AS
     SELECT BTS.RecID,
            BTD.DoctorCode,            
			BTD.LocationCode,
            BTD.ScheduleDate AS Date,
			BTS.StartTime AS StartTime, 

            NULL AS CaseNbr , 
			NULL AS ExtCaseNbr , 
            '' AS SpecialInstructions ,
            NULL AS PhotoRqd ,
            NULL AS PanelNbr ,
            '' AS PanelDesc,
            NULL AS CaseOfficeCode,

            '' AS Interpreter,

            BTSS.Name AS ScheduleDesc1,

			BTS.HoldDescription AS ScheduleDesc2,

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

    FROM (SELECT 
			  MAX(DoctorBlockTimeSlotID) AS RecID, 
			  MAX(DoctorBlockTimeSlotStatusID) AS DoctorBlockTimeSlotStatusID,
			  DoctorBlockTimeDayID, 
			  StartTime, 
			  HoldDescription 
			FROM tblDoctorBlockTimeSlot
			GROUP BY DoctorBlockTimeDayID, StartTime, HoldDescription
			HAVING MIN(IIF(DoctorBlockTimeSlotStatusID IN (10,22), 1, 0)) = 1
		  ) AS BTS
			INNER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorBlockTimeDayID = BTS.DoctorBlockTimeDayID
			INNER JOIN tblDoctorBlockTimeSlotStatus AS BTSS ON BTSS.DoctorBlockTimeSlotStatusID = BTS.DoctorBlockTimeSlotStatusID
			INNER JOIN tblDoctor AS DR ON DR.DoctorCode = BTD.DoctorCode
			INNER JOIN tblLocation AS L ON BTD.LocationCode = L.LocationCode

			INNER JOIN tblDoctorOffice AS DRO ON DR.DoctorCode = DRO.DoctorCode
			INNER JOIN tblLocationOffice AS LO ON LO.OfficeCode = DRO.OfficeCode AND LO.LocationCode = L.LocationCode

			INNER JOIN tblOffice AS O ON DRO.OfficeCode = O.OfficeCode
			INNER JOIN tblEWFacility AS EWF on O.EWFacilityID = EWF.EWFacilityID
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
PRINT N'Creating [dbo].[vwPDFInvDetData1]...';


GO
CREATE VIEW vwPDFInvDetData1
AS
	SELECT	
			AD1.LineNbr AS InvLineNbr1 ,
	        AD1.Date AS InvServiceDate1 ,
			B.BlankValue AS InvServiceDate1MM,
			B.BlankValue AS InvServiceDate1DD,
			B.BlankValue AS InvServiceDate1YY,
			B.BlankValue AS InvServiceDateTo1MM,
			B.BlankValue AS InvServiceDateTo1DD,
			B.BlankValue AS InvServiceDateTo1YY,
	        AD1.CPTCode AS InvCPT1,
	        AD1.Modifier AS InvModifier1,
	        AD1.Modifier2 AS InvModifier1b ,
	        AD1.Modifier3 AS InvModifier1c ,
	        AD1.Modifier4 AS InvModifier1d ,
			B.BlankValue AS InvICD1,
			B.BlankValue AS InvDiagnosisPointer1,
	        AD1.Location AS InvPlaceOfService1,
			'2' AS InvTypeOfService1,
	        AD1.SuppInfo AS SupplementalInfo1,
	        AD1.Unit AS InvUnit1,
	        AD1.ExtendedAmount AS InvDetAmt1,
			AD1.RetailAmount AS InvRetailAmt1,
	        B.BlankValue AS InvDetAmt1Dollars,
			B.BlankValue AS InvDetAmt1Cents,
	        B.BlankValue AS InvDetAmt1bDollars,
			B.BlankValue AS InvDetAmt1bCents,
			AD1.DrOpCode AS DrOpCode1,
			DR1.NPINbr AS DoctorNPINbr1,


			AD2.LineNbr AS InvLineNbr2 ,
	        AD2.Date AS InvServiceDate2 ,
			B.BlankValue AS InvServiceDate2MM,
			B.BlankValue AS InvServiceDate2DD,
			B.BlankValue AS InvServiceDate2YY,
			B.BlankValue AS InvServiceDateTo2MM,
			B.BlankValue AS InvServiceDateTo2DD,
			B.BlankValue AS InvServiceDateTo2YY,
	        AD2.CPTCode AS InvCPT2,
	        AD2.Modifier AS InvModifier2,
	        AD2.Modifier2 AS InvModifier2b ,
	        AD2.Modifier3 AS InvModifier2c ,
	        AD2.Modifier4 AS InvModifier2d ,
			B.BlankValue AS InvICD2,
			B.BlankValue AS InvDiagnosisPointer2,
	        AD2.Location AS InvPlaceOfService2,
			'2' AS InvTypeOfService2,
	        AD2.SuppInfo AS SupplementalInfo2,
	        AD2.Unit AS InvUnit2,
	        AD2.ExtendedAmount AS InvDetAmt2,
			AD2.RetailAmount AS InvRetailAmt2,
	        B.BlankValue AS InvDetAmt2Dollars,
			B.BlankValue AS InvDetAmt2Cents,
	        B.BlankValue AS InvDetAmt2bDollars,
			B.BlankValue AS InvDetAmt2bCents,
			AD2.DrOpCode AS DrOpCode2,
			DR2.NPINbr AS DoctorNPINbr2,


			AD3.LineNbr AS InvLineNbr3 ,
	        AD3.Date AS InvServiceDate3 ,
			B.BlankValue AS InvServiceDate3MM,
			B.BlankValue AS InvServiceDate3DD,
			B.BlankValue AS InvServiceDate3YY,
			B.BlankValue AS InvServiceDateTo3MM,
			B.BlankValue AS InvServiceDateTo3DD,
			B.BlankValue AS InvServiceDateTo3YY,
	        AD3.CPTCode AS InvCPT3,
	        AD3.Modifier AS InvModifier3,
	        AD3.Modifier2 AS InvModifier3b ,
	        AD3.Modifier3 AS InvModifier3c ,
	        AD3.Modifier4 AS InvModifier3d ,
			B.BlankValue AS InvICD3,
			B.BlankValue AS InvDiagnosisPointer3,
	        AD3.Location AS InvPlaceOfService3,
			'2' AS InvTypeOfService3,
	        AD3.SuppInfo AS SupplementalInfo3,
	        AD3.Unit AS InvUnit3,
	        AD3.ExtendedAmount AS InvDetAmt3,
	        AD3.RetailAmount AS InvRetailAmt3,
			B.BlankValue AS InvDetAmt3Dollars,
			B.BlankValue AS InvDetAmt3Cents,
			B.BlankValue AS InvDetAmt3bDollars,
			B.BlankValue AS InvDetAmt3bCents,
			AD3.DrOpCode AS DrOpCode3,
			DR3.NPINbr AS DoctorNPINbr3,


			AD4.LineNbr AS InvLineNbr4 ,
	        AD4.Date AS InvServiceDate4 ,
			B.BlankValue AS InvServiceDate4MM,
			B.BlankValue AS InvServiceDate4DD,
			B.BlankValue AS InvServiceDate4YY,
			B.BlankValue AS InvServiceDateTo4MM,
			B.BlankValue AS InvServiceDateTo4DD,
			B.BlankValue AS InvServiceDateTo4YY,
	        AD4.CPTCode AS InvCPT4,
	        AD4.Modifier AS InvModifier4,
	        AD4.Modifier2 AS InvModifier4b ,
	        AD4.Modifier3 AS InvModifier4c ,
	        AD4.Modifier4 AS InvModifier4d ,
			B.BlankValue AS InvICD4,
			B.BlankValue AS InvDiagnosisPointer4,
	        AD4.Location AS InvPlaceOfService4,
			'2' AS InvTypeOfService4,
	        AD4.SuppInfo AS SupplementalInfo4,
	        AD4.Unit AS InvUnit4,
	        AD4.ExtendedAmount AS InvDetAmt4,
			AD4.RetailAmount AS InvRetailAmt4,
	        B.BlankValue AS InvDetAmt4Dollars,
			B.BlankValue AS InvDetAmt4Cents,
	        B.BlankValue AS InvDetAmt4bDollars,
			B.BlankValue AS InvDetAmt4bCents,
			AD4.DrOpCode AS DrOpCode4,
			DR4.NPINbr AS DoctorNPINbr4,


			AD5.LineNbr AS InvLineNbr5 ,
	        AD5.Date AS InvServiceDate5 ,
			B.BlankValue AS InvServiceDate5MM,
			B.BlankValue AS InvServiceDate5DD,
			B.BlankValue AS InvServiceDate5YY,
			B.BlankValue AS InvServiceDateTo5MM,
			B.BlankValue AS InvServiceDateTo5DD,
			B.BlankValue AS InvServiceDateTo5YY,
	        AD5.CPTCode AS InvCPT5,
	        AD5.Modifier AS InvModifier5,
	        AD5.Modifier2 AS InvModifier5b ,
	        AD5.Modifier3 AS InvModifier5c ,
	        AD5.Modifier4 AS InvModifier5d ,
			B.BlankValue AS InvICD5,
			B.BlankValue AS InvDiagnosisPointer5,
	        AD5.Location AS InvPlaceOfService5,
			'2' AS InvTypeOfService5,
	        AD5.SuppInfo AS SupplementalInfo5,
	        AD5.Unit AS InvUnit5,
	        AD5.ExtendedAmount AS InvDetAmt5,
			AD5.RetailAmount AS InvRetailAmt5,
	        B.BlankValue AS InvDetAmt5Dollars,
			B.BlankValue AS InvDetAmt5Cents,
	        B.BlankValue AS InvDetAmt5bDollars,
			B.BlankValue AS InvDetAmt5bCents,
			AD5.DrOpCode AS DrOpCode5,
			DR5.NPINbr AS DoctorNPINbr5,


			AD6.LineNbr AS InvLineNbr6 ,
	        AD6.Date AS InvServiceDate6 ,
			B.BlankValue AS InvServiceDate6MM,
			B.BlankValue AS InvServiceDate6DD,
			B.BlankValue AS InvServiceDate6YY,
			B.BlankValue AS InvServiceDateTo6MM,
			B.BlankValue AS InvServiceDateTo6DD,
			B.BlankValue AS InvServiceDateTo6YY,
	        AD6.CPTCode AS InvCPT6,
	        AD6.Modifier AS InvModifier6,
	        AD6.Modifier2 AS InvModifier6b ,
	        AD6.Modifier3 AS InvModifier6c ,
	        AD6.Modifier4 AS InvModifier6d ,
			B.BlankValue AS InvICD6,
			B.BlankValue AS InvDiagnosisPointer6,
	        AD6.Location AS InvPlaceOfService6,
			'2' AS InvTypeOfService6,
	        AD6.SuppInfo AS SupplementalInfo6,
	        AD6.Unit AS InvUnit6,
	        AD6.ExtendedAmount AS InvDetAmt6,
			AD6.RetailAmount AS InvRetailAmt6,
	        B.BlankValue AS InvDetAmt6Dollars,
			B.BlankValue AS InvDetAmt6Cents,
	        B.BlankValue AS InvDetAmt6bDollars,
			B.BlankValue AS InvDetAmt6bCents,
			AD6.DrOpCode AS DrOpCode6,
			DR6.NPINbr AS DoctorNPINbr6,

			AD1.HeaderID AS InvDetHeaderID


	FROM	tblAcctDetail AS AD1
	LEFT OUTER JOIN tblAcctDetail AS AD2 ON AD2.HeaderID = AD1.HeaderID AND AD2.LineNbr=2
	LEFT OUTER JOIN tblAcctDetail AS AD3 ON AD3.HeaderID = AD1.HeaderID AND AD3.LineNbr=3
	LEFT OUTER JOIN tblAcctDetail AS AD4 ON AD4.HeaderID = AD1.HeaderID AND AD4.LineNbr=4
	LEFT OUTER JOIN tblAcctDetail AS AD5 ON AD5.HeaderID = AD1.HeaderID AND AD5.LineNbr=5
	LEFT OUTER JOIN tblAcctDetail AS AD6 ON AD6.HeaderID = AD1.HeaderID AND AD6.LineNbr=6
	LEFT OUTER JOIN tblDoctor AS DR1 ON AD1.DrOpCode=DR1.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR2 ON AD2.DrOpCode=DR2.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR3 ON AD3.DrOpCode=DR3.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR4 ON AD4.DrOpCode=DR4.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR5 ON AD5.DrOpCode=DR5.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR6 ON AD6.DrOpCode=DR6.DoctorCode
	LEFT OUTER JOIN tblBlank AS B ON 1=1
	WHERE AD1.LineNbr=1
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
PRINT N'Creating [dbo].[vwPDFInvDetData2]...';


GO
CREATE VIEW vwPDFInvDetData2
AS
	SELECT	
			AD7.LineNbr AS InvLineNbr7 ,
	        AD7.Date AS InvServiceDate7 ,
			B.BlankValue AS InvServiceDate7MM,
			B.BlankValue AS InvServiceDate7DD,
			B.BlankValue AS InvServiceDate7YY,
			B.BlankValue AS InvServiceDateTo7MM,
			B.BlankValue AS InvServiceDateTo7DD,
			B.BlankValue AS InvServiceDateTo7YY,
	        AD7.CPTCode AS InvCPT7,
	        AD7.Modifier AS InvModifier7,
	        AD7.Modifier2 AS InvModifier7b ,
	        AD7.Modifier3 AS InvModifier7c ,
	        AD7.Modifier4 AS InvModifier7d ,
			B.BlankValue AS InvICD7,
			B.BlankValue AS InvDiagnosisPointer7,
	        AD7.Location AS InvPlaceOfService7,
			'2' AS InvTypeOfService7,
	        AD7.SuppInfo AS SupplementalInfo7,
	        AD7.Unit AS InvUnit7,
	        AD7.ExtendedAmount AS InvDetAmt7,
			AD7.RetailAmount AS InvRetailAmt7,
	        B.BlankValue AS InvDetAmt7Dollars,
			B.BlankValue AS InvDetAmt7Cents,
	        B.BlankValue AS InvDetAmt7bDollars,
			B.BlankValue AS InvDetAmt7bCents,
			AD7.DrOpCode AS DrOpCode7,
			DR7.NPINbr AS DoctorNPINbr7,


			AD8.LineNbr AS InvLineNbr8 ,
	        AD8.Date AS InvServiceDate8 ,
			B.BlankValue AS InvServiceDate8MM,
			B.BlankValue AS InvServiceDate8DD,
			B.BlankValue AS InvServiceDate8YY,
			B.BlankValue AS InvServiceDateTo8MM,
			B.BlankValue AS InvServiceDateTo8DD,
			B.BlankValue AS InvServiceDateTo8YY,
	        AD8.CPTCode AS InvCPT8,
	        AD8.Modifier AS InvModifier8,
	        AD8.Modifier2 AS InvModifier8b ,
	        AD8.Modifier3 AS InvModifier8c ,
	        AD8.Modifier4 AS InvModifier8d ,
			B.BlankValue AS InvICD8,
			B.BlankValue AS InvDiagnosisPointer8,
	        AD8.Location AS InvPlaceOfService8,
			'2' AS InvTypeOfService8,
	        AD8.SuppInfo AS SupplementalInfo8,
	        AD8.Unit AS InvUnit8,
	        AD8.ExtendedAmount AS InvDetAmt8,
			AD8.RetailAmount AS InvRetailAmt8,
	        B.BlankValue AS InvDetAmt8Dollars,
			B.BlankValue AS InvDetAmt8Cents,
	        B.BlankValue AS InvDetAmt8bDollars,
			B.BlankValue AS InvDetAmt8bCents,
			AD8.DrOpCode AS DrOpCode8,
			DR8.NPINbr AS DoctorNPINbr8,


	        AD9.Date AS InvServiceDate9 ,
			B.BlankValue AS InvServiceDate9MM,
			B.BlankValue AS InvServiceDate9DD,
			B.BlankValue AS InvServiceDate9YY,
			AD9.LineNbr AS InvLineNbr9 ,
			B.BlankValue AS InvServiceDateTo9MM,
			B.BlankValue AS InvServiceDateTo9DD,
			B.BlankValue AS InvServiceDateTo9YY,
	        AD9.CPTCode AS InvCPT9,
	        AD9.Modifier AS InvModifier9,
	        AD9.Modifier2 AS InvModifier9b ,
	        AD9.Modifier3 AS InvModifier9c ,
	        AD9.Modifier4 AS InvModifier9d ,
			B.BlankValue AS InvICD9,
			B.BlankValue AS InvDiagnosisPointer9,
	        AD9.Location AS InvPlaceOfService9,
			'2' AS InvTypeOfService9,
	        AD9.SuppInfo AS SupplementalInfo9,
	        AD9.Unit AS InvUnit9,
	        AD9.ExtendedAmount AS InvDetAmt9,
			AD9.RetailAmount AS InvRetailAmt9,
	        B.BlankValue AS InvDetAmt9Dollars,
			B.BlankValue AS InvDetAmt9Cents,
	        B.BlankValue AS InvDetAmt9bDollars,
			B.BlankValue AS InvDetAmt9bCents,
			AD9.DrOpCode AS DrOpCode9,
			DR9.NPINbr AS DoctorNPINbr9,


			AD10.LineNbr AS InvLineNbr10 ,
	        AD10.Date AS InvServiceDate10 ,
			B.BlankValue AS InvServiceDate10MM,
			B.BlankValue AS InvServiceDate10DD,
			B.BlankValue AS InvServiceDate10YY,
			B.BlankValue AS InvServiceDateTo10MM,
			B.BlankValue AS InvServiceDateTo10DD,
			B.BlankValue AS InvServiceDateTo10YY,
	        AD10.CPTCode AS InvCPT10,
	        AD10.Modifier AS InvModifier10,
	        AD10.Modifier2 AS InvModifier10b ,
	        AD10.Modifier3 AS InvModifier10c ,
	        AD10.Modifier4 AS InvModifier10d ,
			B.BlankValue AS InvICD10,
			B.BlankValue AS InvDiagnosisPointer10,
	        AD10.Location AS InvPlaceOfService10,
			'2' AS InvTypeOfService10,
	        AD10.SuppInfo AS SupplementalInfo10,
	        AD10.Unit AS InvUnit10,
	        AD10.ExtendedAmount AS InvDetAmt10,
			AD10.RetailAmount AS InvRetailAmt10,
	        B.BlankValue AS InvDetAmt10Dollars,
			B.BlankValue AS InvDetAmt10Cents,
	        B.BlankValue AS InvDetAmt10bDollars,
			B.BlankValue AS InvDetAmt10bCents,
			AD10.DrOpCode AS DrOpCode10,
			DR10.NPINbr AS DoctorNPINbr10,


			AD11.LineNbr AS InvLineNbr11 ,
	        AD11.Date AS InvServiceDate11 ,
			B.BlankValue AS InvServiceDate11MM,
			B.BlankValue AS InvServiceDate11DD,
			B.BlankValue AS InvServiceDate11YY,
			B.BlankValue AS InvServiceDateTo11MM,
			B.BlankValue AS InvServiceDateTo11DD,
			B.BlankValue AS InvServiceDateTo11YY,
	        AD11.CPTCode AS InvCPT11,
	        AD11.Modifier AS InvModifier11,
	        AD11.Modifier2 AS InvModifier11b ,
	        AD11.Modifier3 AS InvModifier11c ,
	        AD11.Modifier4 AS InvModifier11d ,
			B.BlankValue AS InvICD11,
			B.BlankValue AS InvDiagnosisPointer11,
	        AD11.Location AS InvPlaceOfService11,
			'2' AS InvTypeOfService11,
	        AD11.SuppInfo AS SupplementalInfo11,
	        AD11.Unit AS InvUnit11,
	        AD11.ExtendedAmount AS InvDetAmt11,
			AD11.RetailAmount AS InvRetailAmt11,
	        B.BlankValue AS InvDetAmt11Dollars,
			B.BlankValue AS InvDetAmt11Cents,
	        B.BlankValue AS InvDetAmt11bDollars,
			B.BlankValue AS InvDetAmt11bCents,
			AD11.DrOpCode AS DrOpCode11,
			DR11.NPINbr AS DoctorNPINbr11,

			AD12.LineNbr AS InvLineNbr12 ,
	        AD12.Date AS InvServiceDate12 ,
			B.BlankValue AS InvServiceDate12MM,
			B.BlankValue AS InvServiceDate12DD,
			B.BlankValue AS InvServiceDate12YY,
			B.BlankValue AS InvServiceDateTo12MM,
			B.BlankValue AS InvServiceDateTo12DD,
			B.BlankValue AS InvServiceDateTo12YY,
	        AD12.CPTCode AS InvCPT12,
	        AD12.Modifier AS InvModifier12,
	        AD12.Modifier2 AS InvModifier12b ,
	        AD12.Modifier3 AS InvModifier12c ,
	        AD12.Modifier4 AS InvModifier12d ,
			B.BlankValue AS InvICD12,
			B.BlankValue AS InvDiagnosisPointer12,
	        AD12.Location AS InvPlaceOfService12,
			'2' AS InvTypeOfService12,
	        AD12.SuppInfo AS SupplementalInfo12,
	        AD12.Unit AS InvUnit12,
	        AD12.ExtendedAmount AS InvDetAmt12,
			AD12.RetailAmount AS InvRetailAmt12,
	        B.BlankValue AS InvDetAmt12Dollars,
			B.BlankValue AS InvDetAmt12Cents,
	        B.BlankValue AS InvDetAmt12bDollars,
			B.BlankValue AS InvDetAmt12bCents,
			AD12.DrOpCode AS DrOpCode12,
			DR12.NPINbr AS DoctorNPINbr12,

			AD1.HeaderID AS InvDetHeaderID


	FROM	tblAcctDetail AS AD1
	LEFT OUTER JOIN tblAcctDetail AS AD7 ON AD7.HeaderID = AD1.HeaderID AND AD7.LineNbr=7
	LEFT OUTER JOIN tblAcctDetail AS AD8 ON AD8.HeaderID = AD1.HeaderID AND AD8.LineNbr=8
	LEFT OUTER JOIN tblAcctDetail AS AD9 ON AD9.HeaderID = AD1.HeaderID AND AD9.LineNbr=9
	LEFT OUTER JOIN tblAcctDetail AS AD10 ON AD10.HeaderID = AD1.HeaderID AND AD10.LineNbr=10
	LEFT OUTER JOIN tblAcctDetail AS AD11 ON AD11.HeaderID = AD1.HeaderID AND AD11.LineNbr=11
	LEFT OUTER JOIN tblAcctDetail AS AD12 ON AD12.HeaderID = AD1.HeaderID AND AD12.LineNbr=12
	LEFT OUTER JOIN tblDoctor AS DR7 ON AD7.DrOpCode=DR7.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR8 ON AD8.DrOpCode=DR8.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR9 ON AD9.DrOpCode=DR9.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR10 ON AD10.DrOpCode=DR10.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR11 ON AD11.DrOpCode=DR11.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR12 ON AD12.DrOpCode=DR12.DoctorCode
	LEFT OUTER JOIN tblBlank AS B ON 1=1
	WHERE AD1.LineNbr=1
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
PRINT N'Creating [dbo].[vwPDFInvDetData3]...';


GO
CREATE VIEW vwPDFInvDetData3
AS
	SELECT	

			AD13.LineNbr AS InvLineNbr13 ,
	        AD13.Date AS InvServiceDate13 ,
			B.BlankValue AS InvServiceDate13MM,
			B.BlankValue AS InvServiceDate13DD,
			B.BlankValue AS InvServiceDate13YY,
			B.BlankValue AS InvServiceDateTo13MM,
			B.BlankValue AS InvServiceDateTo13DD,
			B.BlankValue AS InvServiceDateTo13YY,
	        AD13.CPTCode AS InvCPT13,
	        AD13.Modifier AS InvModifier13,
	        AD13.Modifier2 AS InvModifier13b ,
	        AD13.Modifier3 AS InvModifier13c ,
	        AD13.Modifier4 AS InvModifier13d ,
			B.BlankValue AS InvICD13,
			B.BlankValue AS InvDiagnosisPointer13,
	        AD13.Location AS InvPlaceOfService13,
			'2' AS InvTypeOfService13,
	        AD13.SuppInfo AS SupplementalInfo13,
	        AD13.Unit AS InvUnit13,
	        AD13.ExtendedAmount AS InvDetAmt13,
			AD13.RetailAmount AS InvRetailAmt13,
	        B.BlankValue AS InvDetAmt13Dollars,
			B.BlankValue AS InvDetAmt13Cents,
	        B.BlankValue AS InvDetAmt13bDollars,
			B.BlankValue AS InvDetAmt13bCents,
			AD13.DrOpCode AS DrOpCode13,
			DR13.NPINbr AS DoctorNPINbr13,


			AD14.LineNbr AS InvLineNbr14 ,
	        AD14.Date AS InvServiceDate14 ,
			B.BlankValue AS InvServiceDate14MM,
			B.BlankValue AS InvServiceDate14DD,
			B.BlankValue AS InvServiceDate14YY,
			B.BlankValue AS InvServiceDateTo14MM,
			B.BlankValue AS InvServiceDateTo14DD,
			B.BlankValue AS InvServiceDateTo14YY,
	        AD14.CPTCode AS InvCPT14,
	        AD14.Modifier AS InvModifier14,
	        AD14.Modifier2 AS InvModifier14b ,
	        AD14.Modifier3 AS InvModifier14c ,
	        AD14.Modifier4 AS InvModifier14d ,
			B.BlankValue AS InvICD14,
			B.BlankValue AS InvDiagnosisPointer14,
	        AD14.Location AS InvPlaceOfService14,
			'2' AS InvTypeOfService14,
	        AD14.SuppInfo AS SupplementalInfo14,
	        AD14.Unit AS InvUnit14,
	        AD14.ExtendedAmount AS InvDetAmt14,
			AD14.RetailAmount AS InvRetailAmt14,
	        B.BlankValue AS InvDetAmt14Dollars,
			B.BlankValue AS InvDetAmt14Cents,
	        B.BlankValue AS InvDetAmt14bDollars,
			B.BlankValue AS InvDetAmt14bCents,
			AD14.DrOpCode AS DrOpCode14,
			DR14.NPINbr AS DoctorNPINbr14,


			AD15.LineNbr AS InvLineNbr15 ,
	        AD15.Date AS InvServiceDate15 ,
			B.BlankValue AS InvServiceDate15MM,
			B.BlankValue AS InvServiceDate15DD,
			B.BlankValue AS InvServiceDate15YY,
			B.BlankValue AS InvServiceDateTo15MM,
			B.BlankValue AS InvServiceDateTo15DD,
			B.BlankValue AS InvServiceDateTo15YY,
	        AD15.CPTCode AS InvCPT15,
	        AD15.Modifier AS InvModifier15,
	        AD15.Modifier2 AS InvModifier15b ,
	        AD15.Modifier3 AS InvModifier15c ,
	        AD15.Modifier4 AS InvModifier15d ,
			B.BlankValue AS InvICD15,
			B.BlankValue AS InvDiagnosisPointer15,
	        AD15.Location AS InvPlaceOfService15,
			'2' AS InvTypeOfService15,
	        AD15.SuppInfo AS SupplementalInfo15,
	        AD15.Unit AS InvUnit15,
	        AD15.ExtendedAmount AS InvDetAmt15,
			AD15.RetailAmount AS InvRetailAmt15,
	        B.BlankValue AS InvDetAmt15Dollars,
			B.BlankValue AS InvDetAmt15Cents,
	        B.BlankValue AS InvDetAmt15bDollars,
			B.BlankValue AS InvDetAmt15bCents,
			AD15.DrOpCode AS DrOpCode15,
			DR15.NPINbr AS DoctorNPINbr15,


			AD16.LineNbr AS InvLineNbr16 ,
	        AD16.Date AS InvServiceDate16 ,
			B.BlankValue AS InvServiceDate16MM,
			B.BlankValue AS InvServiceDate16DD,
			B.BlankValue AS InvServiceDate16YY,
			B.BlankValue AS InvServiceDateTo16MM,
			B.BlankValue AS InvServiceDateTo16DD,
			B.BlankValue AS InvServiceDateTo16YY,
	        AD16.CPTCode AS InvCPT16,
	        AD16.Modifier AS InvModifier16,
	        AD16.Modifier2 AS InvModifier16b ,
	        AD16.Modifier3 AS InvModifier16c ,
	        AD16.Modifier4 AS InvModifier16d ,
			B.BlankValue AS InvICD16,
			B.BlankValue AS InvDiagnosisPointer16,
	        AD16.Location AS InvPlaceOfService16,
			'2' AS InvTypeOfService16,
	        AD16.SuppInfo AS SupplementalInfo16,
	        AD16.Unit AS InvUnit16,
	        AD16.ExtendedAmount AS InvDetAmt16,
			AD16.RetailAmount AS InvRetailAmt16,
	        B.BlankValue AS InvDetAmt16Dollars,
			B.BlankValue AS InvDetAmt16Cents,
	        B.BlankValue AS InvDetAmt16bDollars,
			B.BlankValue AS InvDetAmt16bCents,
			AD16.DrOpCode AS DrOpCode16,
			DR16.NPINbr AS DoctorNPINbr16,


			AD17.LineNbr AS InvLineNbr17 ,
	        AD17.Date AS InvServiceDate17 ,
			B.BlankValue AS InvServiceDate17MM,
			B.BlankValue AS InvServiceDate17DD,
			B.BlankValue AS InvServiceDate17YY,
			B.BlankValue AS InvServiceDateTo17MM,
			B.BlankValue AS InvServiceDateTo17DD,
			B.BlankValue AS InvServiceDateTo17YY,
	        AD17.CPTCode AS InvCPT17,
	        AD17.Modifier AS InvModifier17,
	        AD17.Modifier2 AS InvModifier17b ,
	        AD17.Modifier3 AS InvModifier17c ,
	        AD17.Modifier4 AS InvModifier17d ,
			B.BlankValue AS InvICD17,
			B.BlankValue AS InvDiagnosisPointer17,
	        AD17.Location AS InvPlaceOfService17,
			'2' AS InvTypeOfService17,
	        AD17.SuppInfo AS SupplementalInfo17,
	        AD17.Unit AS InvUnit17,
	        AD17.ExtendedAmount AS InvDetAmt17,
			AD17.RetailAmount AS InvRetailAmt17,
	        B.BlankValue AS InvDetAmt17Dollars,
			B.BlankValue AS InvDetAmt17Cents,
	        B.BlankValue AS InvDetAmt17bDollars,
			B.BlankValue AS InvDetAmt17bCents,
			AD17.DrOpCode AS DrOpCode17,
			DR17.NPINbr AS DoctorNPINbr17,


			AD18.LineNbr AS InvLineNbr18 ,
	        AD18.Date AS InvServiceDate18 ,
			B.BlankValue AS InvServiceDate18MM,
			B.BlankValue AS InvServiceDate18DD,
			B.BlankValue AS InvServiceDate18YY,
			B.BlankValue AS InvServiceDateTo18MM,
			B.BlankValue AS InvServiceDateTo18DD,
			B.BlankValue AS InvServiceDateTo18YY,
	        AD18.CPTCode AS InvCPT18,
	        AD18.Modifier AS InvModifier18,
	        AD18.Modifier2 AS InvModifier18b ,
	        AD18.Modifier3 AS InvModifier18c ,
	        AD18.Modifier4 AS InvModifier18d ,
			B.BlankValue AS InvICD18,
			B.BlankValue AS InvDiagnosisPointer18,
	        AD18.Location AS InvPlaceOfService18,
			'2' AS InvTypeOfService18,
	        AD18.SuppInfo AS SupplementalInfo18,
	        AD18.Unit AS InvUnit18,
	        AD18.ExtendedAmount AS InvDetAmt18,
			AD18.RetailAmount AS InvRetailAmt18,
	        B.BlankValue AS InvDetAmt18Dollars,
			B.BlankValue AS InvDetAmt18Cents,
	        B.BlankValue AS InvDetAmt18bDollars,
			B.BlankValue AS InvDetAmt18bCents,
			AD18.DrOpCode AS DrOpCode18,
			DR18.NPINbr AS DoctorNPINbr18,

			B.BlankValue AS InvICDDiagnosisPointer,
			AD1.HeaderID AS InvDetHeaderID


	FROM	tblAcctDetail AS AD1
	LEFT OUTER JOIN tblAcctDetail AS AD13 ON AD13.HeaderID = AD1.HeaderID AND AD13.LineNbr=13
	LEFT OUTER JOIN tblAcctDetail AS AD14 ON AD14.HeaderID = AD1.HeaderID AND AD14.LineNbr=14
	LEFT OUTER JOIN tblAcctDetail AS AD15 ON AD15.HeaderID = AD1.HeaderID AND AD15.LineNbr=15
	LEFT OUTER JOIN tblAcctDetail AS AD16 ON AD16.HeaderID = AD1.HeaderID AND AD16.LineNbr=16
	LEFT OUTER JOIN tblAcctDetail AS AD17 ON AD17.HeaderID = AD1.HeaderID AND AD17.LineNbr=17
	LEFT OUTER JOIN tblAcctDetail AS AD18 ON AD18.HeaderID = AD1.HeaderID AND AD18.LineNbr=18
	LEFT OUTER JOIN tblDoctor AS DR13 ON AD13.DrOpCode=DR13.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR14 ON AD14.DrOpCode=DR14.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR15 ON AD15.DrOpCode=DR15.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR16 ON AD16.DrOpCode=DR16.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR17 ON AD17.DrOpCode=DR17.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR18 ON AD18.DrOpCode=DR18.DoctorCode
	LEFT OUTER JOIN tblBlank AS B ON 1=1
	WHERE AD1.LineNbr=1
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
-- Issue 12079 - add med status options to combo
INSERT INTO tblRecordStatus  (Description, DateAdded, UserIDAdded, PublishOnWeb)
VALUES ('Awaiting Declaration', GETDATE(), 'TLyde', 1),
       ('Declaration Received', GETDATE(), 'TLyde', 1)

GO

-- Issue 12026 - add new security token and items to tblSetting for CCMSI
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded)
VALUES('CaseOverview', 'Case - Overview Info', GETDATE())
GO
INSERT INTO tblSetting(Name, Value)
VALUES('CCMSIBaseAPIURL', 'https://api.terraclaim.com/connect/vendors/test/'),
      ('CCMSIAPISecurityToken', '31031783bcb8466abfc45521a2fdcfe9')
GO

