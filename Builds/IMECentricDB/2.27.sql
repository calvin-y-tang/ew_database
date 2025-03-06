
ALTER TABLE tblBlank
 ALTER COLUMN BlankValueLong VARCHAR(300)
GO

ALTER VIEW vwPDFDoctorData
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

			B.BlankValueLong AS DoctorCorrespFullAddress ,

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

ALTER VIEW vwPDFLocationData
AS
    SELECT  LocationCode ,
			ExtName AS ServiceLocationName ,
            Addr1 AS ServiceLocationAddr1 ,
            Addr2 AS ServiceLocationAddr2 ,
            City AS ServiceLocationCity ,
            State AS ServiceLocationState ,
            Zip AS ServiceLocationZip ,
            City + ', ' + State + '  ' + Zip AS ServiceLocationCityStateZip ,

			B.BlankValueLong AS ServiceLocationFullAddress ,
			B.BlankValueLong AS ServiceLocationAddress ,

            Phone AS ServiceLocationPhone ,
            Phone AS ServiceLocationPhoneAreaCode ,
            Phone AS ServiceLocationPhoneNumber ,
            Fax AS ServiceLocationFax
    FROM    tblLocation
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO

DROP VIEW vwPDFOverride
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


UPDATE tblControl SET DBVersion='2.27'
GO
