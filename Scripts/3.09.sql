PRINT N'Dropping [dbo].[PK_tblDPSBundleCaseDocument]...';


GO
ALTER TABLE [dbo].[tblDPSBundleCaseDocument] DROP CONSTRAINT [PK_tblDPSBundleCaseDocument];


GO
PRINT N'Creating [dbo].[PK_tblDPSBundleCaseDocument]...';


GO
ALTER TABLE [dbo].[tblDPSBundleCaseDocument]
    ADD CONSTRAINT [PK_tblDPSBundleCaseDocument] PRIMARY KEY CLUSTERED ([DPSBundleID] ASC, [CaseDocID] ASC);


GO
PRINT N'Dropping [dbo].[tblConfirmationExtMessage]...';


GO
DROP TABLE [dbo].[tblConfirmationExtMessage];


GO
PRINT N'Dropping [dbo].[tblConfirmationExtResult]...';


GO
DROP TABLE [dbo].[tblConfirmationExtResult];


GO
PRINT N'Altering [dbo].[tblConfirmationMessage]...';


GO
ALTER TABLE [dbo].[tblConfirmationMessage] DROP COLUMN [LanguageID];


GO
ALTER TABLE [dbo].[tblConfirmationMessage] ALTER COLUMN [ExtMessageID] VARCHAR (30) NULL;


GO
ALTER TABLE [dbo].[tblConfirmationMessage]
    ADD [ConfirmationSystemID] INT          CONSTRAINT [DF_tblConfirmationMessage_ConfirmationSystemID] DEFAULT ((1)) NOT NULL,
        [MasterExtMessageID]   VARCHAR (30) NULL,
        [ExtLanguageKey]       VARCHAR (10) NULL,
        [NextAction]           VARCHAR (60) NULL,
        [VMAction]             VARCHAR (60) NULL,
        [Key1Action]           VARCHAR (60) NULL,
        [Key2Action]           VARCHAR (60) NULL,
        [Key3Action]           VARCHAR (60) NULL,
        [Key4Action]           VARCHAR (60) NULL,
        [Key5Action]           VARCHAR (60) NULL,
        [Key6Action]           VARCHAR (60) NULL,
        [Key7Action]           VARCHAR (60) NULL,
        [Key8Action]           VARCHAR (60) NULL,
        [Key9Action]           VARCHAR (60) NULL,
        [Key0Action]           VARCHAR (60) NULL,
        [TimeoutIntervalSec]   INT          NULL;


GO
PRINT N'Creating [dbo].[tblConfirmationMessage].[IX_U_tblConfirmationMessage_ConfirmationSystemIDExtMessageID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblConfirmationMessage_ConfirmationSystemIDExtMessageID]
    ON [dbo].[tblConfirmationMessage]([ConfirmationSystemID] ASC, [ExtMessageID] ASC);


GO
PRINT N'Altering [dbo].[tblConfirmationResult]...';


GO
ALTER TABLE [dbo].[tblConfirmationResult] ALTER COLUMN [ResultCode] VARCHAR (20) NULL;


GO
ALTER TABLE [dbo].[tblConfirmationResult]
    ADD [ConfirmationSystemID] INT          CONSTRAINT [DF_tblConfirmationResult_ConfirmationSystemID] DEFAULT ((1)) NOT NULL,
        [MaxRetriesPerDay]     INT          NULL,
        [IncludeParams]        VARCHAR (50) NULL;


GO
PRINT N'Creating [dbo].[tblConfirmationResult].[IX_tblConfirmationResult_ConfirmationSystemIDExtResultCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblConfirmationResult_ConfirmationSystemIDExtResultCode]
    ON [dbo].[tblConfirmationResult]([ConfirmationSystemID] ASC, [ResultCode] ASC);


GO
PRINT N'Altering [dbo].[tblConfirmationSetup]...';


GO
ALTER TABLE [dbo].[tblConfirmationSetup] ALTER COLUMN [ConfirmationSystemID] INT NOT NULL;

ALTER TABLE [dbo].[tblConfirmationSetup] ALTER COLUMN [Password] VARCHAR (50) NULL;

ALTER TABLE [dbo].[tblConfirmationSetup] ALTER COLUMN [Username] VARCHAR (50) NULL;


GO
PRINT N'Creating [dbo].[DF_tblConfirmationSetup_ConfirmationSystemID]...';


GO
ALTER TABLE [dbo].[tblConfirmationSetup]
    ADD CONSTRAINT [DF_tblConfirmationSetup_ConfirmationSystemID] DEFAULT ((1)) FOR [ConfirmationSystemID];


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









INSERT INTO tblsetting (Name, Value) Values ('UseARViewer', 'True')
GO



UPDATE tblState 
   SET DateAdded = GetDate(), 
       UserIDAdded = 'admin'
GO
UPDATE tblState 
   SET StateCode = LTRIM(RTRIM(StateCode)), 
       StateName = LTRIM(RTRIM(StateName))
GO


UPDATE tblExaminee SET sex = 'Male' WHERE sex IN ('m','mle','malw', 'mm', 'amale', 'malae')
GO
UPDATE tblExaminee SET sex = 'Female' WHERE sex in ('f','femake','femael', 'femlae', 'femle', 'fenake','feml')
GO
UPDATE tblExaminee SET sex = '' WHERE sex not in ('Male','Female')
GO


 Insert into tblUserFunction 
 values 
 ('ARLedgerAccess', 'AR Ledger - Access'),
 ('ARLedgerDistributeGridInvoice', 'AR Ledger Distribute Grid/Invoices')

GO







UPDATE tblControl SET DBVersion='3.09'
GO
