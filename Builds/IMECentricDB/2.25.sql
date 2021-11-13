CREATE VIEW vwPDFStaticData
AS
	SELECT	B.BlankValue AS CurrentDate ,
			--B.BlankValue AS CurrentTime ,
			--B.BlankValue AS CurrentDateTime ,

			'Yes' AS Checked ,
			'No' AS Unchecked ,

			'' AS Blank
	FROM	tblBlank AS B
GO

CREATE VIEW vwPDFCaseData
AS
    SELECT  C.CaseNbr ,
			C.PanelNbr ,
            C.ClaimNbr ,
            C.Jurisdiction ,
            C.WCBNbr ,
            
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


			B.BlankValue AS ProblemList ,
            
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
            EE.Employer ,
            EE.EmployerAddr1 ,
            EE.EmployerCity ,
            EE.EmployerState ,
            EE.EmployerZip ,
			B.BlankValue AS EmployerFullAddress ,

            EE.EmployerPhone ,
            EE.EmployerPhone AS EmployerPhoneAreaCode ,
            EE.EmployerPhone AS EmployerPhoneNumber ,

            EE.EmployerFax ,
            EE.EmployerEmail ,

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
GO

CREATE VIEW vwPDFDoctorData
AS
    SELECT  DoctorCode ,
			LTRIM(RTRIM(ISNULL(firstName,'') + ' ' + ISNULL(lastName,'') + ' ' + ISNULL(credentials,''))) AS DoctorFullName ,
			[Credentials] AS DoctorDegree ,

            NPINbr AS DoctorNPINbr ,
			B.BlankValue AS	DoctorWALINbr ,
            LicenseNbr AS DoctorLicense ,
            
			Addr1 AS DoctorCorrespAddr1 ,
            Addr2 AS DoctorCorrespAddr2 ,
            City + ', ' + State + '  ' + Zip AS DoctorCorrespCityStateZip ,

			B.BlankValue AS DoctorCorrespFullAddress ,

			USDVarchar1 AS DoctorUSDVarchar1 ,
			USDVarchar2 AS DoctorUSDVarchar2 ,
			USDText1 AS DoctorUSDText1 ,
			USDText2 AS DoctorUSDText2 ,

            
			Phone + ' ' + ISNULL(PhoneExt, '') AS DoctorCorrespPhone ,
			Phone AS DoctorCorrespPhoneAreaCode ,
			Phone AS DoctorCorrespPhoneNumber
    FROM    tblDoctor
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO

CREATE VIEW vwPDFLocationData
AS
    SELECT  LocationCode ,
			ExtName AS ServiceLocationName ,
            Addr1 AS ServiceLocationAddr1 ,
            Addr2 AS ServiceLocationAddr2 ,
            City AS ServiceLocationCity ,
            State AS ServiceLocationState ,
            Zip AS ServiceLocationZip ,
            City + ', ' + State + '  ' + Zip AS ServiceLocationCityStateZip ,

			B.BlankValue AS ServiceLocationFullAddress ,
			B.BlankValue AS ServiceLocationAddress ,

            Phone AS ServiceLocationPhone ,
            Phone AS ServiceLocationPhoneAreaCode ,
            Phone AS ServiceLocationPhoneNumber ,
            Fax AS ServiceLocationFax
    FROM    tblLocation
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO

CREATE VIEW vwPDFInvData
AS
    SELECT  AH.CaseNbr AS InvCaseNbr ,
            AT.ApptDate AS InvApptDate,
            AT.ApptTime AS InvApptTime,
            AT.DrOpCode AS InvDoctorCode ,
            AT.DoctorLocation AS InvLocationCode ,
			AH.CompanyCode AS InvCompanyCode ,

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
			 ISNULL(FRemit.City, '') + ', ' + ISNULL(FRemit.State, '') + ' ' + ISNULL(FRemit.Zip, '')
			ELSE
			  ISNULL(FRemit.RemitCity, '') + ', ' + ISNULL(FRemit.RemitState, '') + ' ' + ISNULL(FRemit.RemitZip, '')
			END AS BillingProviderCityStateZip ,

			CO.ExtName AS InvCoExtName,
            
			CL.BillAddr1 AS InvClBillAddr1,
            CL.BillAddr2 AS InvClBillAddr2,
            CL.BillCity AS InvClBillCity ,
            CL.BillState AS InvClBillState ,
            CL.BillZip AS InvClBillZip ,
            CL.Addr1 AS InvClAddr1 ,
            CL.Addr2 AS InvClAddr2 ,
            CL.City AS InvClCity ,
            CL.State AS InvClState ,
            CL.Zip AS InvClZip ,
			
			B.BlankValueLong AS Payor

    FROM    tblAcctHeader AS AH
            LEFT OUTER JOIN tblAcctingTrans AS AT ON AT.DocumentNbr = AH.DocumentNbr AND AT.Type = AH.DocumentType
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = AH.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CO.CompanyCode = AH.CompanyCode
            LEFT OUTER JOIN tblEWFacility AS F ON F.EWFacilityID = AH.EWFacilityID
			LEFT OUTER JOIN tblEWFacility AS FRemit ON ISNULL(CO.InvRemitEWFacilityID, ISNULL(F.InvRemitEWFacilityID, AH.EWFacilityID))=FRemit.EWFacilityID
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO

CREATE VIEW vwPDFInvDetData
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
	        B.BlankValue AS InvDetAmt1Dollars,
			B.BlankValue AS InvDetAmt1Cents,
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
	        B.BlankValue AS InvDetAmt2Dollars,
			B.BlankValue AS InvDetAmt2Cents,
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
	        B.BlankValue AS InvDetAmt3Dollars,
			B.BlankValue AS InvDetAmt3Cents,
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
	        B.BlankValue AS InvDetAmt4Dollars,
			B.BlankValue AS InvDetAmt4Cents,
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
	        B.BlankValue AS InvDetAmt5Dollars,
			B.BlankValue AS InvDetAmt5Cents,
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
	        B.BlankValue AS InvDetAmt6Dollars,
			B.BlankValue AS InvDetAmt6Cents,
			AD6.DrOpCode AS DrOpCode6,
			DR6.NPINbr AS DoctorNPINbr6,

			B.BlankValue AS InvICDDiagnosisPointer,
			AD1.DocumentNbr AS InvDetDocumentNbr,
			AD1.DocumentType AS InvDetDocumentType

	FROM	tblAcctDetail AS AD1
	LEFT OUTER JOIN tblAcctDetail AS AD2 ON AD2.DocumentNbr = AD1.DocumentNbr AND AD2.DocumentType = AD1.DocumentType AND AD2.LineNbr=2
	LEFT OUTER JOIN tblAcctDetail AS AD3 ON AD3.DocumentNbr = AD1.DocumentNbr AND AD3.DocumentType = AD1.DocumentType AND AD3.LineNbr=3
	LEFT OUTER JOIN tblAcctDetail AS AD4 ON AD4.DocumentNbr = AD1.DocumentNbr AND AD4.DocumentType = AD1.DocumentType AND AD4.LineNbr=4
	LEFT OUTER JOIN tblAcctDetail AS AD5 ON AD5.DocumentNbr = AD1.DocumentNbr AND AD5.DocumentType = AD1.DocumentType AND AD5.LineNbr=5
	LEFT OUTER JOIN tblAcctDetail AS AD6 ON AD6.DocumentNbr = AD1.DocumentNbr AND AD6.DocumentType = AD1.DocumentType AND AD6.LineNbr=6
	LEFT OUTER JOIN tblDoctor AS DR1 ON AD1.DrOpCode=DR1.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR2 ON AD2.DrOpCode=DR2.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR3 ON AD3.DrOpCode=DR3.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR4 ON AD4.DrOpCode=DR4.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR5 ON AD5.DrOpCode=DR5.DoctorCode
	LEFT OUTER JOIN tblDoctor AS DR6 ON AD6.DrOpCode=DR6.DoctorCode
	LEFT OUTER JOIN tblBlank AS B ON 1=1
	WHERE AD1.LineNbr=1
GO


CREATE VIEW vwPDFOverride
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
			'%CMSBox24JNonNPINbr1%' AS PrimaryDoctorNonNPINbr1,
			'%CMSBox24JNonNPINbr2%' AS PrimaryDoctorNonNPINbr2,
			'%CMSBox24JNonNPINbr3%' AS PrimaryDoctorNonNPINbr3,
			'%CMSBox24JNonNPINbr4%' AS PrimaryDoctorNonNPINbr4,
			'%CMSBox24JNonNPINbr5%' AS PrimaryDoctorNonNPINbr5,
			'%CMSBox24JNonNPINbr6%' AS PrimaryDoctorNonNPINbr6,

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

			'%Checked%' AS CMSBox1Other ,
			--'%ExamineeNameLFMI%' AS CMSBox2 ,	
			--'%ExamineeDOBMM%' AS CMSBox3MM ,
			--'%ExamineeDOBDD%' AS CMSBox3DD ,
			--'%ExamineeDOBYYYY%' AS CMSBox3YYYY ,
			--'%ExamineeSexM%' AS CMSBox3M ,
			--'%ExamineeSexF%' AS CMSBox3F ,
			--'%ExamineeAddress%' AS CMSBox5Address ,
			--'%ExamineeCity%' AS CMSBox5City ,
			--'%ExamineeState%' AS CMSBox5State ,
			--'%ExamineeZip%' AS CMSBoxZip ,
			--'%ExamineePhoneAreaCode%' AS CMSBox5AreaCode ,
			--'%ExamineePhoneNumber%' AS CMSBox5PhoneNumber ,
			'%Checked%' AS CMSBox6Other ,

			B.BlankValue AS CMSBox10aYes ,									--doc override

			--'%ClaimNbr%' AS CMSBox11 ,

			--'%AuthorizedSignature%' AS CMSBox12Signature ,
			--'%AuthorizedSignatureDate%' AS CMSBox12SignatureDate ,
			--'%AssignmentSignature%' AS CMSBox13 ,
			
			--'%InjuryCurrentDateMM%' AS CMSBox14MM ,
			--'%InjuryCurrentDateDD%' AS CMSBox14DD ,
			--'%InjuryCurrentDateYYYY%' AS CMSBox14YYYY ,

			B.BlankValue AS CMSBox17 ,										--doc override
			B.BlankValue AS CMSBox17a ,										--doc override
			B.BlankValue AS CMSBox17b ,										--doc override
			
			B.BlankValue AS CMSBox19 ,										--doc override (Need to confirm default value or WCBNbr?)	

			B.BlankValue AS CMSBox23 ,										--inv override
			B.BlankValue AS CMSBox24JNonNPINbr ,							--doc and inv override (to populate tblClaimInfo)

			--'%InvServiceDate1MM%' AS CMSBox24AMMLine1,
			--'%InvServiceDate1DD%' AS CMSBox24ADDLine1,
			--'%InvServiceDate1YY%' AS CMSBox24AYYLine1,
			--'%InvServiceDateTo1MM%' AS CMSBox24AToMMLine1,
			--'%InvServiceDateTo1DD%' AS CMSBox24AToDDLine1,
			--'%InvServiceDateTo1YY%' AS CMSBox24AToYYLine1,
			--'%InvPlaceOfService1%' AS CMSBox24BLine1,
			--'%InvCPT1%' AS CMSBox24DCPTLine1,
			--'%InvModifier1%' AS CMSBox24DModifierALine1,
			--'%InvModifier1b%' AS CMSBox24DModifierBLine1,
			--'%InvModifier1c%' AS CMSBox24DModifierCLine1,
			--'%InvModifier1d%' AS CMSBox24DModifierDLine1,
			--'%InvDiagnosisPointer1%' AS CMSBox24ELine1,
			--'%InvDetAmt1Dollars%' AS CMSBox24FDollarsLine1,
			--'%InvDetAmt1Cents%' AS CMSBox24FCentsLine1,
			--'%InvUnit1%' AS CMSBox24GLine1,
			B.BlankValue AS CMSBox24JNonNPILine1 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine1 ,								--doc override
			--'%SupplementalInfo1%' AS CMSBox24SuppInfoLine1,

			--'%InvServiceDate2MM%' AS CMSBox24AMMLine2,
			--'%InvServiceDate2DD%' AS CMSBox24ADDLine2,
			--'%InvServiceDate2YY%' AS CMSBox24AYYLine2,
			--'%InvServiceDateTo2MM%' AS CMSBox24AToMMLine2,
			--'%InvServiceDateTo2DD%' AS CMSBox24AToDDLine2,
			--'%InvServiceDateTo2YY%' AS CMSBox24AToYYLine2,
			--'%InvPlaceOfService2%' AS CMSBox24BLine2,
			--'%InvCPT2%' AS CMSBox24DCPTLine2,
			--'%InvModifier2%' AS CMSBox24DModifierALine2,
			--'%InvModifier2b%' AS CMSBox24DModifierBLine2,
			--'%InvModifier2c%' AS CMSBox24DModifierCLine2,
			--'%InvModifier2d%' AS CMSBox24DModifierDLine2,
			--'%InvDiagnosisPointer2%' AS CMSBox24ELine2,
			--'%InvDetAmt2Dollars%' AS CMSBox24FDollarsLine2,
			--'%InvDetAmt2Cents%' AS CMSBox24FCentsLine2,
			--'%InvUnit2%' AS CMSBox24GLine2,
			B.BlankValue AS CMSBox24JNonNPILine2 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine2 ,								--doc override
			--'%SupplementalInfo2%' AS CMSBox24SuppInfoLine2,

			--'%InvServiceDate3MM%' AS CMSBox24AMMLine3,
			--'%InvServiceDate3DD%' AS CMSBox24ADDLine3,
			--'%InvServiceDate3YY%' AS CMSBox24AYYLine3,
			--'%InvServiceDateTo3MM%' AS CMSBox24AToMMLine3,
			--'%InvServiceDateTo3DD%' AS CMSBox24AToDDLine3,
			--'%InvServiceDateTo3YY%' AS CMSBox24AToYYLine3,
			--'%InvPlaceOfService3%' AS CMSBox24BLine3,
			--'%InvCPT3%' AS CMSBox24DCPTLine3,
			--'%InvModifier3%' AS CMSBox24DModifierALine3,
			--'%InvModifier3b%' AS CMSBox24DModifierBLine3,
			--'%InvModifier3c%' AS CMSBox24DModifierCLine3,
			--'%InvModifier3d%' AS CMSBox24DModifierDLine3,
			--'%InvDiagnosisPointer3%' AS CMSBox24ELine3,
			--'%InvDetAmt3Dollars%' AS CMSBox24FDollarsLine3,
			--'%InvDetAmt3Cents%' AS CMSBox24FCentsLine3,
			--'%InvUnit3%' AS CMSBox24GLine3,
			B.BlankValue AS CMSBox24JNonNPILine3 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine3 ,								--doc override
			--'%SupplementalInfo3%' AS CMSBox24SuppInfoLine3,

			--'%InvServiceDate4MM%' AS CMSBox24AMMLine4,
			--'%InvServiceDate4DD%' AS CMSBox24ADDLine4,
			--'%InvServiceDate4YY%' AS CMSBox24AYYLine4,
			--'%InvServiceDateTo4MM%' AS CMSBox24AToMMLine4,
			--'%InvServiceDateTo4DD%' AS CMSBox24AToDDLine4,
			--'%InvServiceDateTo4YY%' AS CMSBox24AToYYLine4,
			--'%InvPlaceOfService4%' AS CMSBox24BLine4,
			--'%InvCPT4%' AS CMSBox24DCPTLine4,
			--'%InvModifier4%' AS CMSBox24DModifierALine4,
			--'%InvModifier4b%' AS CMSBox24DModifierBLine4,
			--'%InvModifier4c%' AS CMSBox24DModifierCLine4,
			--'%InvModifier4d%' AS CMSBox24DModifierDLine4,
			--'%InvDiagnosisPointer4%' AS CMSBox24ELine4,
			--'%InvDetAmt4Dollars%' AS CMSBox24FDollarsLine4,
			--'%InvDetAmt4Cents%' AS CMSBox24FCentsLine4,
			--'%InvUnit4%' AS CMSBox24GLine4,
			B.BlankValue AS CMSBox24JNonNPILine4 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine4 ,								--doc override
			--'%SupplementalInfo4%' AS CMSBox24SuppInfoLine4,

			--'%InvServiceDate5MM%' AS CMSBox24AMMLine5,
			--'%InvServiceDate5DD%' AS CMSBox24ADDLine5,
			--'%InvServiceDate5YY%' AS CMSBox24AYYLine5,
			--'%InvServiceDateTo5MM%' AS CMSBox24AToMMLine5,
			--'%InvServiceDateTo5DD%' AS CMSBox24AToDDLine5,
			--'%InvServiceDateTo5YY%' AS CMSBox24AToYYLine5,
			--'%InvPlaceOfService5%' AS CMSBox24BLine5,
			--'%InvCPT5%' AS CMSBox24DCPTLine5,
			--'%InvModifier5%' AS CMSBox24DModifierALine5,
			--'%InvModifier5b%' AS CMSBox24DModifierBLine5,
			--'%InvModifier5c%' AS CMSBox24DModifierCLine5,
			--'%InvModifier5d%' AS CMSBox24DModifierDLine5,
			--'%InvDiagnosisPointer5%' AS CMSBox24ELine5,
			--'%InvDetAmt5Dollars%' AS CMSBox24FDollarsLine5,
			--'%InvDetAmt5Cents%' AS CMSBox24FCentsLine5,
			--'%InvUnit5%' AS CMSBox24GLine5,
			B.BlankValue AS CMSBox24JNonNPILine5 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine5 ,								--doc override
			--'%SupplementalInfo5%' AS CMSBox24SuppInfoLine5,

			--'%InvServiceDate6MM%' AS CMSBox24AMMLine6,
			--'%InvServiceDate6DD%' AS CMSBox24ADDLine6,
			--'%InvServiceDate6YY%' AS CMSBox24AYYLine6,
			--'%InvServiceDateTo6MM%' AS CMSBox24AToMMLine6,
			--'%InvServiceDateTo6DD%' AS CMSBox24AToDDLine6,
			--'%InvServiceDateTo6YY%' AS CMSBox24AToYYLine6,
			--'%InvPlaceOfService6%' AS CMSBox24BLine6,
			--'%InvCPT6%' AS CMSBox24DCPTLine6,
			--'%InvModifier6%' AS CMSBox24DModifierALine6,
			--'%InvModifier6b%' AS CMSBox24DModifierBLine6,
			--'%InvModifier6c%' AS CMSBox24DModifierCLine6,
			--'%InvModifier6d%' AS CMSBox24DModifierDLine6,
			--'%InvDiagnosisPointer6%' AS CMSBox24ELine6,
			--'%InvDetAmt6Dollars%' AS CMSBox24FDollarsLine6,
			--'%InvDetAmt6Cents%' AS CMSBox24FCentsLine6,
			--'%InvUnit6%' AS CMSBox24GLine6,
			B.BlankValue AS CMSBox24JNonNPILine6 ,							--doc override
			B.BlankValue AS CMSBox24JNPILine6 ,								--doc override
			--'%SupplementalInfo6%' AS CMSBox24SuppInfoLine6,

			B.BlankValue AS CMSBox25,
			--'%Checked%' AS CMSBox25EIN,
			--'%DocumentNbr%' AS CMSBox26,

			B.BlankValue AS CMSBox27Yes ,									--doc override

			--'%InvoiceAmtDollars%' AS CMSBox28Dollars,
			--'%InvoiceAmtCents%' AS CMSBox28Cents,
			--'%InvoicePaymentCreditAmtDollars%' AS CMSBox29Dollars,
			--'%InvoicePaymentCreditAmtCents%' AS CMSBox29Cents,
			--'%InvoiceBalanceDueDollars%' AS CMSBox30Dollars,
			--'%InvoiceBalanceDueCents%' AS CMSBox30Cents,

			B.BlankValueLong AS CMSBox31Line1 ,								--doc and inv override
			B.BlankValue AS CMSBox31Line2 ,									--doc and inv override
			'%CurrentDate%' AS CMSBox31Date,

			'%ServiceLocationName%' AS CMSBox32Line1,
			'%ServiceLocationAddress%' AS CMSBox32Line2,
			'%ServiceLocationCityStateZip%' AS CMSBox32Line3,
			B.BlankValue AS CMSBox32a ,										--doc override
			B.BlankValue AS CMSBox32b ,										--doc and inv override

			B.BlankValue AS CMSBox33Line1 ,									--doc override
			B.BlankValue AS CMSBox33Line2 ,									--doc override
			B.BlankValue AS CMSBox33Line3 ,									--doc override
			B.BlankValue AS CMSBox33AreaCode,								--doc override
			B.BlankValue AS CMSBox33PhoneNumber,							--doc override
			B.BlankValue AS CMSBox33a ,										--doc override
			B.BlankValue AS CMSBox33b										--doc and inv override

	FROM	tblBlank AS B
GO


DROP VIEW vwDocument
GO
CREATE VIEW vwDocument
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ClaimNbr ,

            tblApptStatus.Name AS ApptStatus ,

            tblCase.ApptDate ,
            tblCase.Appttime ,
            tblCase.CaseApptID ,
            tblCase.ApptStatusID ,

            tblCase.DoctorCode ,
            tblCase.DoctorLocation ,


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

            tblExaminee.Employer ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,

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

			--tblCase.ICDCodeA AS ICD9Code ,
			--tblCase.ICDCodeB AS ICD9Code2 ,
			--tblCase.ICDCodeC AS ICD9Code3 ,
			--tblCase.ICDCodeD AS ICD9Code4 ,
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

            tblCCAddress_2.firstName + ' ' + tblCCAddress_2.lastName AS PAttorneyName ,
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

            tblCCAddress_1.firstName + ' ' + tblCCAddress_1.lastName AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' '
            + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
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

            tblCCAddress_3.firstName + ' ' + tblCCAddress_3.lastName AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' '
            + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,
                                                '') AS DParaLegalPhone ,
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
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany

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
GO

DROP VIEW vwDocumentAccting
GO
CREATE VIEW vwDocumentAccting
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ClaimNbr ,

            tblAcctingTrans.SeqNO ,
            tblAcctingTrans.DocumentNbr ,
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

            tblExaminee.Employer ,
            tblExaminee.EmployerAddr1 ,
            tblExaminee.EmployerCity ,
            tblExaminee.EmployerState ,
            tblExaminee.EmployerZip ,
            tblExaminee.EmployerPhone ,
            tblExaminee.EmployerPhoneExt ,
            tblExaminee.EmployerFax ,
            tblExaminee.EmployerEmail ,
            tblExaminee.EmployerContactLastName ,
            tblExaminee.EmployerContactFirstName ,

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

			--tblCase.ICDCodeA AS ICD9Code ,
			--tblCase.ICDCodeB AS ICD9Code2 ,
			--tblCase.ICDCodeC AS ICD9Code3 ,
			--tblCase.ICDCodeD AS ICD9Code4 ,
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

            tblCCAddress_2.firstName + ' ' + tblCCAddress_2.lastName AS PAttorneyName ,
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

            tblCCAddress_1.firstName + ' ' + tblCCAddress_1.lastName AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' '
            + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
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

            tblCCAddress_3.firstName + ' ' + tblCCAddress_3.lastName AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' '
            + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,
                                                '') AS DParaLegalPhone ,
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
            tblOffice.USDvarchar1 AS OfficeUSDVarChar1 ,
            tblOffice.USDvarchar2 AS OfficeUSDVarChar2 ,

            tblLanguage.Description AS Language ,

            tblTranscription.TransCompany

    FROM    tblCase
            INNER JOIN tblExaminee ON tblExaminee.chartnbr = tblCase.chartnbr
            INNER JOIN tblOffice ON tblOffice.officeCode = tblCase.officeCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.Casetype = tblCaseType.Code
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statusCode
            INNER JOIN tblAcctingTrans ON tblCase.casenbr = tblAcctingTrans.casenbr
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
GO


UPDATE tblControl SET DBVersion='2.25'
GO
