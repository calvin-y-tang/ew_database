PRINT N'Dropping [dbo].[DF_tblCaseAppt_ApptConfirmed]...';


GO
ALTER TABLE [dbo].[tblCaseAppt] DROP CONSTRAINT [DF_tblCaseAppt_ApptConfirmed];


GO
PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt] DROP COLUMN [ApptConfirmed], COLUMN [ApptConfirmedDate];


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [ApptConfirmedByExaminee] BIT      CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByExaminee] DEFAULT 0 NOT NULL,
        [DateConfirmedByExaminee] DATETIME NULL,
        [ApptConfirmedByAttorney] BIT      CONSTRAINT [DF_tblCaseAppt_ApptConfirmedByAttorney] DEFAULT 0 NOT NULL,
        [DateConfirmedByAttorney] DATETIME NULL;


GO
PRINT N'Altering [dbo].[tblConfirmationSetup]...';


GO
ALTER TABLE [dbo].[tblConfirmationSetup]
    ADD [SMSShortCodeNumber] VARCHAR (5) NULL;


GO
PRINT N'Altering [dbo].[vwConfirmationResultsReport]...';


GO
ALTER VIEW vwConfirmationResultsReport
AS 
		SELECT  
		c.Office, 
		c.ExtCaseNbr AS 'Case Nbr', 
		FORMAT(c.ApptTime,'MM-dd-yy') AS 'Appt',
		c.ExamineefirstName + ' ' + c.ExamineelastName AS Examinee, 
		ISNULL(c.PAttorneyCompany,'') AS 'Attorney Firm', 
		ISNULL(c.pAttorneyfirstName, '') + ISNULL(c.pAttorneylastName, '') AS Attorney, 
		c.Company, 
		ct.ShortDesc AS 'Case Type', 
		s.ShortDesc AS Service, 
		cl.ContactType AS 'Contact Type', 
		IIF(cl.ContactMethod=1,'Phone','Text') AS 'Contact Method', 
		cl.Phone,  
		FORMAT(cl.TargetCallTime,'M-d-yy h:mmtt') AS 'Call Target Time', 
		FORMAT(cl.ContactedDateTime,'M-d-yy h:mmtt') AS 'Actual Call Date Time', 
		cl.NbrOfCallAttempts AS 'Nbr Attempts', 
		cr.Description AS 'Call Result', 
		IIF(ca.apptConfirmedByExaminee=1 OR ca.apptConfirmedByAttorney=1, 'Yes','No') AS Confirmed,
		c.officeCode,
		cl.StartDate,
		cs.Name AS StatusDescription,
		d.FirstName + ' ' + d.LastName AS 'Doctor Name',
		l.Location AS 'Exam Location',		
		CONVERT(date, cb.DateBatchPrepared) AS SentDate
	FROM tblconfirmationlist AS cl
	LEFT OUTER JOIN tblconfirmationresult AS cr ON cr.confirmationresultid = cl.confirmationresultid
	INNER JOIN tblcaseappt AS ca ON ca.caseapptid = cl.CaseApptID
	INNER JOIN vwdocument AS c ON c.casenbr = ca.CaseNbr
	INNER JOIN tblServices AS s ON c.servicecode = s.servicecode
	INNER JOIN tblCaseType AS ct ON c.casetype = ct.code
	INNER JOIN tblConfirmationStatus AS cs ON cl.ConfirmationStatusID = cs.ConfirmationStatusID
	LEFT OUTER JOIN tblConfirmationBatch AS cb ON cl.BatchNbr = cb.BatchNbr
	LEFT OUTER JOIN tblDoctor AS d ON ca.DoctorCode = d.DoctorCode
	INNER JOIN tblLocation AS l ON ca.LocationCode = l.LocationCode
	WHERE (cl.Selected = 1) 
	AND (cl.ConfirmationStatusID IN (NULL,3,4,5,112))
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
			O.BillingProviderNonNPINbr AS OfficeBillingProviderNonNPINbr,
			ISNULL(IIF ( C.PanelNbr > 0, 99999, D.NPINbr),99999) AS DoctorNPINbr99999

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
GO
PRINT N'Altering [dbo].[vwPDFDoctorData]...';


GO
ALTER VIEW vwPDFDoctorData
AS
    SELECT  DoctorCode ,
			LTRIM(RTRIM(ISNULL(firstName,'') + ' ' + ISNULL(lastName,'') + ' ' + ISNULL(credentials,''))) AS DoctorFullName ,
			[Credentials] AS DoctorDegree ,

            NPINbr AS DoctorNPINbr ,
			B.BlankValue AS	DoctorWALINbr ,
            LicenseNbr AS DoctorLicense ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B' END AS DoctorLicenseQualID ,
			CASE WHEN ISNULL(LicenseNbr,'')='' THEN '' ELSE '0B ' + LicenseNbr END AS DoctorLicenseWithQualPrefix ,
			LEFT(LicenseNbr, 2) + RIGHT(LicenseNbr, 2) AS TexasDoctorLicenseType ,
            
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
			Phone AS DoctorCorrespPhoneNumber , 

			TXMTaxID AS DoctorTXMTaxID , 
			SORMTaxID AS DoctorSORMTaxID , 
			TXMProviderName AS DoctorTXMProviderName , 
			SORMProviderName AS DoctorSORMProviderName 

    FROM    tblDoctor
			LEFT OUTER JOIN tblBlank AS B ON 1=1
GO
PRINT N'Altering [dbo].[proc_EDIDetermination]...';


GO
ALTER PROCEDURE [dbo].[proc_EDIDetermination]
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
							WHERE CaseNbr = @CaseNbr AND OfficeCode In (13,14))
		END
	ELSE
		BEGIN
			SET @ChangeProcessEDI = 0
		END

    RETURN @ChangeProcessEDI
END
GO

UPDATE tblControl SET DBVersion='3.15'
GO
