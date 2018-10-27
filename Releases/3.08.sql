PRINT N'Dropping [dbo].[tblAcctMargin].[IX_tblAcctMargin_DocumentDateDocumentTypeEWFacilityIDParentCompanyIDEWBusLineIDEWServiceID]...';


GO
DROP INDEX [IX_tblAcctMargin_DocumentDateDocumentTypeEWFacilityIDParentCompanyIDEWBusLineIDEWServiceID]
    ON [dbo].[tblAcctMargin];


GO
PRINT N'Dropping [dbo].[tblConfirmationResult].[IX_tblConfirmationResult_ResultCode]...';


GO
DROP INDEX [IX_tblConfirmationResult_ResultCode]
    ON [dbo].[tblConfirmationResult];


GO
PRINT N'Dropping [dbo].[tblLogUsage].[IdxtblLogUsage_BY_DateAddedModuleName]...';


GO
DROP INDEX [IdxtblLogUsage_BY_DateAddedModuleName]
    ON [dbo].[tblLogUsage];


GO
PRINT N'Dropping [dbo].[DF_tblControl_MinMaintenanceAccessLevel]...';


GO
ALTER TABLE [dbo].[tblControl] DROP CONSTRAINT [DF_tblControl_MinMaintenanceAccessLevel];


GO
PRINT N'Altering [dbo].[tblConfirmationList]...';


GO
ALTER TABLE [dbo].[tblConfirmationList]
    ADD [TargetCallTime] DATETIME NULL;


GO
PRINT N'Altering [dbo].[tblConfirmationMessage]...';


GO
ALTER TABLE [dbo].[tblConfirmationMessage] ALTER COLUMN [Description] VARCHAR (35) NULL;


GO
ALTER TABLE [dbo].[tblConfirmationMessage]
    ADD [Message]    NVARCHAR (1000) NULL,
        [LanguageID] INT             NULL;


GO
PRINT N'Altering [dbo].[tblConfirmationSetup]...';


GO
ALTER TABLE [dbo].[tblConfirmationSetup]
    ADD [ConfirmationSystemID] INT          NULL,
        [Name]                 VARCHAR (20) NULL,
        [MinCallsPerHr]        INT          NULL,
        [RetryPeriodMins]      INT          NULL,
        [SubmitIntervalMins]   INT          NULL,
        [TransferPhone]        VARCHAR (15) NULL;


GO
PRINT N'Altering [dbo].[tblDocument]...';


GO
ALTER TABLE [dbo].[tblDocument]
    ADD [CMSBox11] VARCHAR (30) NULL;


GO
PRINT N'Altering [dbo].[tblDPSBundle]...';


GO
ALTER TABLE [dbo].[tblDPSBundle] ALTER COLUMN [FolderID] INT NULL;


GO
ALTER TABLE [dbo].[tblDPSBundle]
    ADD [WorkBundleDesc] VARCHAR (30) NULL;


GO
PRINT N'Altering [dbo].[tblDPSBundleCaseDocument]...';


GO
ALTER TABLE [dbo].[tblDPSBundleCaseDocument]
    ADD [Filename] VARCHAR (20) NULL;


GO
PRINT N'Altering [dbo].[tblState]...';


GO
ALTER TABLE [dbo].[tblState]
    ADD [DateAdded]   DATETIME     NULL,
        [UserIDAdded] VARCHAR (30) NULL;


GO
PRINT N'Creating [dbo].[tblAddressAbbreviation]...';


GO
CREATE TABLE [dbo].[tblAddressAbbreviation] (
    [PrimaryKey]   INT          IDENTITY (1, 1) NOT NULL,
    [Abbreviation] VARCHAR (10) NULL,
    [FullForm]     VARCHAR (30) NULL,
    CONSTRAINT [PK_tblAddressAbbreviation] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblConfirmationExtMessage]...';


GO
CREATE TABLE [dbo].[tblConfirmationExtMessage] (
    [PrimaryKey]            INT           IDENTITY (1, 1) NOT NULL,
    [ConfirmationSystemID]  INT           NOT NULL,
    [ExtMessageID]          VARCHAR (30)  NULL,
    [MasterExtMessageID]    VARCHAR (30)  NULL,
    [ExtDescription]        VARCHAR (100) NULL,
    [ConfirmationMessageID] INT           NOT NULL,
    [ExtLanguageKey]        VARCHAR (10)  NULL,
    [NextAction]            VARCHAR (60)  NULL,
    [VMAction]              VARCHAR (60)  NULL,
    [Key1Action]            VARCHAR (60)  NULL,
    [Key2Action]            VARCHAR (60)  NULL,
    [Key3Action]            VARCHAR (60)  NULL,
    [Key4Action]            VARCHAR (60)  NULL,
    [Key5Action]            VARCHAR (60)  NULL,
    [Key6Action]            VARCHAR (60)  NULL,
    [Key7Action]            VARCHAR (60)  NULL,
    [Key8Action]            VARCHAR (60)  NULL,
    [Key9Action]            VARCHAR (60)  NULL,
    [Key0Action]            VARCHAR (60)  NULL,
    [TimeoutIntervalSec]    INT           NULL,
    CONSTRAINT [PK_tblConfirmationExtMessage] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblConfirmationExtMessage].[IX_U_tblConfirmationExtMessage_ConfirmationSystemIDExtMessageID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblConfirmationExtMessage_ConfirmationSystemIDExtMessageID]
    ON [dbo].[tblConfirmationExtMessage]([ConfirmationSystemID] ASC, [ExtMessageID] ASC);


GO
PRINT N'Creating [dbo].[tblConfirmationExtResult]...';


GO
CREATE TABLE [dbo].[tblConfirmationExtResult] (
    [PrimaryKey]           INT          IDENTITY (1, 1) NOT NULL,
    [ConfirmationSystemID] INT          NOT NULL,
    [ExtResultCode]        VARCHAR (20) NULL,
    [ConfirmationResultID] INT          NOT NULL,
    [MaxRetriesPerDay]     INT          NULL,
    [IncludeParams]        VARCHAR (50) NULL,
    CONSTRAINT [PK_tblConfirmationExtResult] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblConfirmationExtResult].[IX_tblConfirmationExtResult_ConfirmationSystemIDExtResultCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblConfirmationExtResult_ConfirmationSystemIDExtResultCode]
    ON [dbo].[tblConfirmationExtResult]([ConfirmationSystemID] ASC, [ExtResultCode] ASC);


GO
PRINT N'Creating [dbo].[tblAcctMargin].[IX_tblAcctMargin_DocumentDateDocumentTypeEWFacilityIDParentCompanyIDEWBusLineIDEWServiceTypeID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctMargin_DocumentDateDocumentTypeEWFacilityIDParentCompanyIDEWBusLineIDEWServiceTypeID]
    ON [dbo].[tblAcctMargin]([DocumentDate] ASC, [DocumentType] ASC, [EWFacilityID] ASC, [ParentCompanyID] ASC, [EWBusLineID] ASC, [EWServiceTypeID] ASC)
    INCLUDE([AmountUS], [CaseCount]);


GO
PRINT N'Creating [dbo].[tblLogUsage].[IX_tblLogUsage_DateAddedModuleName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblLogUsage_DateAddedModuleName]
    ON [dbo].[tblLogUsage]([DateAdded] ASC, [ModuleName] ASC);


GO
PRINT N'Creating [dbo].[DF_tblControl_MaintenanceAccessLevel]...';


GO
ALTER TABLE [dbo].[tblControl]
    ADD CONSTRAINT [DF_tblControl_MaintenanceAccessLevel] DEFAULT ((0)) FOR [MaintenanceAccessLevel];


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
			 ELSE '.' + C.ClaimNbrExt
			 END )AS ClaimNbrWExt , 

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
			B.BlankValue AS CMSBox4 ,										--doc override
			B.BlankValue AS CMSBox7Address ,								--doc override
			B.BlankValue AS CMSBox7City ,									--doc override
			B.BlankValue AS CMSBox7State ,									--doc override
			B.BlankValue AS CMSBox7Zip ,									--doc override
			B.BlankValue AS CMSBox7AreaCode ,								--doc override
			B.BlankValue AS CMSBox7PhoneNumber ,							--doc override
			B.BlankValue AS CMSBox10aYes ,									--doc override
			B.BlankValue AS CMSBox10bNo ,									--doc override
			B.BlankValue AS CMSBox10bState ,								--doc override
			B.BlankValue AS CMSBox10cNo ,									--doc override

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
PRINT N'Creating [dbo].[proc_EDIDetermination]...';


GO
CREATE PROCEDURE [dbo].[proc_EDIDetermination]
(
@CaseNbr INT,
@ChangeProcessEDI BIT OUTPUT 
)
AS
DECLARE @Jurisdiction VARCHAR(2)
DECLARE @ParentCompany INT
BEGIN
	SET @ParentCompany = ( SELECT ParentCompanyID FROM tblCase AS c
		INNER JOIN tblCompany as co on c.CompanyCode = co.CompanyCode
		WHERE c.CaseNbr = @CaseNbr)
	IF(@ParentCompany = 44)
		BEGIN
			SET @Jurisdiction = (SELECT Jurisdiction FROM  tblCase
								WHERE CaseNbr = @CaseNbr)
			IF(@Jurisdiction = 'CA')
				BEGIN
					SET @ChangeProcessEDI = (SELECT Top 1 Count(s.ServiceCode) AS SkipEDI FROM tblCase AS c
						INNER JOIN tblServices AS s ON c.ServiceCode = s.ServiceCode
						WHERE c.CaseNbr = @CaseNbr AND (s.Description = 'QME' OR s.Description = 'AME'))
				END
		END
	ELSE IF(@ParentCompany = 87)
		BEGIN
			SET @ChangeProcessEDI = (SELECT TOP 1 Count(OfficeCode) AS SkipEDI FROM tblCase
							WHERE CaseNbr = @CaseNbr AND OfficeCode In (13,14,38))
		END
	ELSE
		BEGIN
			SET @ChangeProcessEDI = 0
		END

    RETURN @ChangeProcessEDI
END
GO






PRINT N'Dropping [dbo].[PK_tblConfirmationResultCode]...';


GO
ALTER TABLE [dbo].[tblConfirmationResult] DROP CONSTRAINT [PK_tblConfirmationResultCode];


GO
PRINT N'Dropping [dbo].[PK_tblTATField]...';


GO
ALTER TABLE [dbo].[tblDataField] DROP CONSTRAINT [PK_tblTATField];


GO
PRINT N'Creating [dbo].[PK_tblConfirmationResult]...';


GO
ALTER TABLE [dbo].[tblConfirmationResult]
    ADD CONSTRAINT [PK_tblConfirmationResult] PRIMARY KEY CLUSTERED ([ConfirmationResultID] ASC);


GO
PRINT N'Creating [dbo].[PK_tblDataField]...';


GO
ALTER TABLE [dbo].[tblDataField]
    ADD CONSTRAINT [PK_tblDataField] PRIMARY KEY CLUSTERED ([DataFieldID] ASC);


GO





UPDATE tblControl SET DBVersion='3.08'
GO