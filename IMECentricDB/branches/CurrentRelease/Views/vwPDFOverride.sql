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
