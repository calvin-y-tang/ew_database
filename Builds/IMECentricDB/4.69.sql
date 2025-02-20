

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
PRINT N'Altering [dbo].[tblRecordHistory]...';


GO
ALTER TABLE [dbo].[tblRecordHistory]
    ADD [INLineNbr] INT NULL,
        [VOLineNbr] INT NULL;


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
PRINT N'Creating [dbo].[tblRecordHistory].[IX_tblRecordHistory_CaseNbr_INLineNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblRecordHistory_CaseNbr_INLineNbr]
    ON [dbo].[tblRecordHistory]([CaseNbr] ASC, [INLineNbr] ASC);


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
PRINT N'Creating [dbo].[tblRecordHistory].[IX_tblRecordHistory_CaseNbr_VOLineNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblRecordHistory_CaseNbr_VOLineNbr]
    ON [dbo].[tblRecordHistory]([CaseNbr] ASC, [VOLineNbr] ASC);


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
PRINT N'Creating [dbo].[tblLogChangeTracking]...';


GO
IF OBJECT_ID('dbo.tblLogChangeTracking', 'U') IS NOT NULL
BEGIN
	ALTER TABLE dbo.tblLogChangeTracking
		ADD [Msg] VARCHAR(512) NULL
END
ELSE
BEGIN
CREATE TABLE [dbo].[tblLogChangeTracking] (
    [LogChangeTrackingID] INT           IDENTITY (1, 1) NOT NULL,
    [HostName]            VARCHAR (128) NULL,
    [HostIPAddr]          VARCHAR (16)  NULL,
    [AppName]             VARCHAR (128) NULL,
    [TableName]           VARCHAR (128) NULL,
    [ColumnName]          VARCHAR (128) NULL,
    [TablePkID]           INT           NULL,
    [OldValue]            VARCHAR (256) NULL,
    [NewValue]            VARCHAR (256) NULL,
    [ModifeDate]          DATETIME      NULL,
    [Msg]                 VARCHAR (512) NULL,
    CONSTRAINT [PK_tblLogChangeTracking] PRIMARY KEY CLUSTERED ([LogChangeTrackingID] ASC)
)
END


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
PRINT N'Creating [dbo].[tblCase_Log_AfterInsert_TRG]...';


GO

CREATE TRIGGER [dbo].[tblCase_Log_AfterInsert_TRG] 
  ON [dbo].[tblCase]
AFTER INSERT
AS
BEGIN    
    SET NOCOUNT ON 
	IF EXISTS (SELECT 1 FROM inserted WHERE MarketerCode IS NOT NULL)
    BEGIN
    INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
    SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCase', 'MarketerCode', 
               I.CaseNbr, NULL, I.MarketerCode, GetDate(), 'Added By :' + I.UserIDAdded
         FROM inserted i
        WHERE i.MarketerCode IS NOT NULL;
  END
END
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
PRINT N'Creating [dbo].[tblCase_Log_AfterUpdate_TRG]...';


GO

CREATE TRIGGER [dbo].[tblCase_Log_AfterUpdate_TRG] 
  ON [dbo].[tblCase]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT OFF
	  IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON i.CaseNbr = d.CaseNbr       
    )
    BEGIN	
	INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
    SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCase', 'MarketerCode', 
               I.CaseNbr, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM INSERTED AS I	  
                   JOIN  deleted AS D
					ON I.CaseNbr = D.CaseNbr
   END	
END
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
PRINT N'Creating [dbo].[tblClient_Log_AfterInsert_TRG]...';


GO

CREATE TRIGGER [dbo].[tblClient_Log_AfterInsert_TRG] 
  ON [dbo].[tblClient]
AFTER INSERT
AS
BEGIN    
    SET NOCOUNT ON 
	IF EXISTS (SELECT 1 FROM inserted WHERE MarketerCode IS NOT NULL)
    BEGIN
   INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
        SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblClient', 'MarketerCode', 
               I.ClientCode, NULL, I.MarketerCode, GetDate(), 'Added By :' + I.UserIDAdded
         FROM inserted i
        WHERE i.MarketerCode IS NOT NULL;
	END				
END
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
PRINT N'Creating [dbo].[tblClient_Log_AfterUpdate_TRG]...';


GO

CREATE TRIGGER [dbo].[tblClient_Log_AfterUpdate_TRG]
    ON [dbo].[tblClient]
AFTER UPDATE
AS
BEGIN    
     SET NOCOUNT ON     
	  IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON i.ClientCode = d.ClientCode
    )
    BEGIN
    	 INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
     SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblClient', 'MarketerCode', 
               I.ClientCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.ClientCode = D.ClientCode   
	END				
END
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
PRINT N'Creating [dbo].[tblCompany_Log_AfterInsert_TRG]...';


GO

CREATE TRIGGER [dbo].[tblCompany_Log_AfterInsert_TRG] 
  ON [dbo].[tblCompany]
AFTER INSERT
AS
BEGIN    
    SET NOCOUNT ON 
	IF EXISTS (SELECT 1 FROM inserted WHERE MarketerCode IS NOT NULL)
    BEGIN
   INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
        SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCompany', 'MarketerCode', 
               I.CompanyCode, NULL, I.MarketerCode, GetDate(), 'Added By :' + I.UserIDAdded
         FROM inserted i
        WHERE i.MarketerCode IS NOT NULL;    
	END	
END
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
PRINT N'Creating [dbo].[tblCompany_Log_AfterUpdate_TRG]...';


GO

CREATE TRIGGER [dbo].[tblCompany_Log_AfterUpdate_TRG]
    ON [dbo].[tblCompany]
AFTER UPDATE
AS
BEGIN    
    SET NOCOUNT ON    
	  IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN deleted d ON i.CompanyCode = d.CompanyCode     		
    )
    BEGIN
        INSERT INTO tblLogChangeTracking(HostName, HostIPAddr, AppName, TableName, ColumnName, TablePkID, OldValue, NewValue, ModifeDate, Msg)
        SELECT HOST_NAME(), CONVERT(VARCHAR(16), CONNECTIONPROPERTY('client_net_address')), APP_NAME(), 'tblCompany', 'MarketerCode', 
               I.CompanyCode, D.MarketerCode, I.MarketerCode, GetDate(), 'Changed By :' + I.UserIDEdited
          FROM DELETED AS D
                    INNER JOIN INSERTED AS I ON I.CompanyCode = D.CompanyCode    
	END				
END
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
PRINT N'Creating [dbo].[tblDoctor_InsteadOfDelete_TRG]...';


GO



CREATE TRIGGER [dbo].[tblDoctor_InsteadOfDelete_TRG]
    ON [dbo].[tblDoctor]
    INSTEAD OF DELETE
    AS
    BEGIN
        INSERT INTO tblLog
        SELECT GETDATE(), 3, '[IMECentricEW].[dbo].[tblDoctor]', 'Delete of tblDoctor record', 'The doctor record is not allowed to be deleted. (' + CONVERT(NVARCHAR(12), D.[DoctorCode]) + ')', NULL, user_name(), NULL
        FROM Deleted D

        DECLARE @topRowDoctorId INT = (SELECT TOP(1) [DoctorCode] FROM Deleted)
        DECLARE @exceptionText NVARCHAR(max) = 'The doctor record is not allowed to be deleted. (' + CONVERT(NVARCHAR(12), @topRowDoctorId) + ')'

        --Valid exeption range is 50000 to 2147483647. Story # is 14741 + 50000 = 64741
        --;THROW 64741, @exceptionText, 1
    END
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
			 c.AddlClaimNbrs, 

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
			CL.City AS ClientCity ,
			CL.[State] AS ClientState ,
			CL.Zip AS ClientZip ,
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
			PA.City AS PAttorneyCity ,
			PA.Zip As PAttorneyZip ,

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
            INNER JOIN vwtblExaminee AS EE ON EE.chartNbr = C.chartNbr
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

-- Sprint 145

-- IMEC-14733 - adding BR to give the option to choose the zip file import method
INSERT INTO tblBusinessRule (BusinessRuleID, Name, Category, Descrip, IsActive, EventID, AllowOverride, Param1Desc, BrokenRuleAction)
VALUES (207, 'DPSResultFileImportMethod', 'Case', 'DPS - Result File Import method: (1) info from tblDPSResultFileConfig or (2) info from JSON returned', 1, 1015, 0, 'RsltFileImportMthdID', 0)

--Sprint 145
-- IMEC 14830  Qoute Rules Processing Order 

UPDATE tblQuoteRule
SET Jurisdiction= null
WHERE Jurisdiction = ''
