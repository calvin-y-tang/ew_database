PRINT N'Altering [dbo].[tblCase]...';
GO
ALTER TABLE [dbo].[tblCase]
    ADD [MMIReachedStatus] VARCHAR (3) NULL
GO

DROP TABLE [dbo].[tblWebReferralForm]
GO
DROP TABLE [dbo].[tblWebReferralFormRule]
GO
CREATE TABLE [dbo].[tblWebReferralForm] (
    [WebReferralFormID] INT          IDENTITY (1, 1) NOT NULL,
    [FormKey]           VARCHAR (50) NOT NULL,
    [Description]       VARCHAR (50) NOT NULL,
    [UseQuestionEngine] BIT          NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [UserIDAdded]       VARCHAR (15) NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDEdited]      VARCHAR (15) NULL,
    CONSTRAINT [PK_tblWebReferralForms] PRIMARY KEY CLUSTERED ([WebReferralFormID] ASC) ON [PRIMARY]
) ON [PRIMARY];
GO
CREATE TABLE [dbo].[tblWebReferralFormRule] (
    [WebReferralFormRuleID] INT         IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]          INT         NULL,
    [CaseType]              INT         NULL,
    [Jurisdiction]          VARCHAR (2) NULL,
    [ParentCompanyID]       INT         NULL,
    [CompanyCode]           INT         NULL,
    [EWServiceTypeID]       INT         NULL,
    [ServiceCode]           INT         NULL,
    [WebReferralFormID]     INT         NULL,
    CONSTRAINT [PK_tblWebReferralFormRule] PRIMARY KEY CLUSTERED ([WebReferralFormRuleID] ASC) ON [PRIMARY]
) ON [PRIMARY];
GO






GO
PRINT N'Creating [dbo].[tblServicesJurisdictions]...';


GO
CREATE TABLE [dbo].[tblServicesJurisdictions] (
    [StateCode]    VARCHAR (2)  NOT NULL,
    [ServiceCode]  INT          NOT NULL,
    [DateEdited]   DATETIME     NULL,
    [UserIDEdited] VARCHAR (30) NULL,
    [Country]      VARCHAR (50) NULL,
    [DateAdded]    DATETIME     NULL,
    [UserIDAdded]  VARCHAR (30) NULL,
    CONSTRAINT [PK_tblServicesJuirsdiction] PRIMARY KEY CLUSTERED ([ServiceCode] ASC, [StateCode] ASC)
);


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
GO
PRINT N'Altering [dbo].[vwClientDefaults]...';


GO
ALTER VIEW vwClientDefaults
AS
   SELECT  CL.marketercode AS ClientMarketer ,
            COM.IntName ,
		  ISNULL(COM.EWCompanyID, 0) AS EWCompanyID, 
            CL.ReportPhone ,
            CL.Priority ,
            CL.ClientCode ,
            CL.fax ,
            CL.email ,
            CL.phone1 ,
            CL.documentemail AS EmailClient ,
            CL.documentfax AS FaxClient ,
            CL.documentmail AS MailClient ,
            ISNULL(CL.casetype, COM.CaseType) AS CaseType ,
            CL.feeschedule ,
            COM.credithold ,
            COM.preinvoice ,
            CL.billaddr1 ,
            CL.billaddr2 ,
            CL.billcity ,
            CL.billstate ,
            CL.billzip ,
            CL.billattn ,
            CL.ARKey ,
            CL.addr1 ,
            CL.addr2 ,
            CL.city ,
            CL.state ,
            CL.zip ,
            CL.firstname + ' ' + CL.lastname AS clientname ,
            CL.prefix AS clientprefix ,
            CL.suffix AS clientsuffix ,
            CL.lastname ,
            CL.firstname ,
            CL.billfax ,
            CL.QARep ,
            ISNULL(CL.photoRqd, COM.photoRqd) AS photoRqd ,
            CL.CertifiedMail ,
            CL.PublishOnWeb ,
            CL.UseNotificationOverrides ,
            CL.CSR1 ,
            CL.CSR2 ,
            CL.AutoReschedule ,
            CLO.OfficeCode AS DefOfficeCode ,
            ISNULL(CL.marketercode, COM.marketercode) AS marketer ,
            COM.Jurisdiction ,
		  CL.CreateCvrLtr|COM.CreateCvrLtr As CreateCvrLtr, 
		  ISNULL(PC.RequireInOutNetwork, 0) AS RequireInOutNetwork,
			COM.ParentCompanyID,
			PC.Name As EWParentCompanyName
    FROM    tblClient AS CL
            INNER JOIN tblCompany AS COM ON CL.companycode = COM.companycode
			LEFT OUTER JOIN tblClientOffice AS CLO ON CLO.ClientCode = CL.ClientCode AND CLO.IsDefault=1
		  INNER JOIN tblEWParentCompany AS PC ON PC.ParentCompanyID = COM.ParentCompanyID
GO
PRINT N'Creating [dbo].[vwSLURequirementDetails_Verizon]...';


GO
CREATE VIEW [dbo].[vwSLURequirementDetails_Verizon]
	AS 

	SELECT 
		ct.Code, 
		s.StateCode, 
		pe.ParentEmployer, 
		pe.EWParentEmployerID,
		pc.ParentCompanyID, 
		st.Name,
		c.IntName
		FROM 
			tblCaseType AS ct, tblState AS s, 
			tblEWParentEmployer AS pe, 
			tblEWParentCompany AS pc, 
			tblEWServiceType AS st,
			tblCompany AS c
			WHERE 
				ct.Code = 140 AND 
				s.StateCode in ('NY') AND 
				pe.EWParentEmployerID = 1 AND 
				pc.ParentCompanyID = 44 AND 
				st.Name = 'IME' AND
				c.IntName Like '%Verizon%'
GO
PRINT N'Altering [dbo].[proc_GetMMISummaryNew]...';


GO
DROP PROCEDURE [dbo].[proc_GetMMISummaryNew]
GO
CREATE PROCEDURE [dbo].[proc_GetMMISummaryNew]

@WebUserID int,
@FromDate datetime,
@ToDate datetime

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.dateadded,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		tblCase.claimnbr,
		tblCase.MMIReachedStatus,
		tblCase.MMITreatmentWeeks,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr,
		(SELECT TOP 1 ApptTime FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND tblCaseAppt.ApptStatusID = 100 ORDER BY ApptTime DESC) AS ApptDate
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblCase.ApptDate >= @FromDate)
		AND (tblCase.ApptDate <= @ToDate)
		AND (tblCase.status <> 0)
		AND (tblCase.ApptDate IS NOT NULL)
		AND (tblCase.MMIReached IS NOT NULL)
		AND (tblCase.MMITreatmentWeeks IS NOT NULL)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetReferralSummaryNew]...';


GO
DROP PROCEDURE [dbo].[proc_GetReferralSummaryNew]
GO
CREATE PROCEDURE [dbo].[proc_GetReferralSummaryNew]

@WebStatus varchar(50),
@WebUserID int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT DISTINCT TOP 100 PERCENT
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.dateadded,
		tblExaminee.lastname +  ', ' + tblExaminee.firstname AS examineename,
		tblClient.lastname + ', ' + tblClient.firstname AS clientname,
		tblCompany.intname AS companyname,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		tblCase.claimnbr,
		tblCase.MMIReachedStatus,
		tblCase.MMITreatmentWeeks,
		tblServices.description AS service,
		tblCase.DoctorName AS provider,
		tblWebQueues.description AS WebStatus,
		tblWebQueues.statuscode,
		tblQueues.statuscode AS QueueStatusCode,
		tblQueues.StatusDesc,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
		LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
		INNER JOIN tblWebUserAccount ON tblPublishOnWeb.UserCode = tblWebUserAccount.UserCode
			AND tblPublishOnWeb.UserType = tblWebUserAccount.UserType
			AND tblWebUserAccount.WebUserID = @WebUserID
		WHERE (tblWebQueues.statuscode = @WebStatus)
		AND (tblCase.status <> 0)

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetPublishOnWebRecordsByCaseNbr]...';


GO
ALTER PROCEDURE [proc_GetPublishOnWebRecordsByCaseNbr]

@CaseNbr int,
@UserCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	select tblDoctor.CompanyName as 'UserType', publishid, tblPublishOnWeb.PublishOnWeb, firstname, lastname, tableKey AS CaseNbr, DoctorCode as UserCode from tblPublishOnWeb
	inner join tblDoctor on tblPublishOnWeb.UserCode = tblDoctor.DoctorCode and tblPublishOnWeb.UserType = 'OP' and tblPublishOnWeb.PublishOnWeb = 1
	where tablekey = @CaseNbr and tabletype = 'tblCase' and tblPublishOnWeb.UserCode <> @UserCode
	union
	select tblDoctor.CompanyName as 'UserType', publishid, tblPublishOnWeb.PublishOnWeb, firstname, lastname, tableKey AS CaseNbr, DoctorCode as UserCode from tblPublishOnWeb
	inner join tblDoctor on tblPublishOnWeb.UserCode = tblDoctor.DoctorCode and tblPublishOnWeb.UserType = 'DR' and tblPublishOnWeb.PublishOnWeb = 1
	where tablekey = @CaseNbr and tabletype = 'tblCase' and tblPublishOnWeb.UserCode <> @UserCode

	ORDER BY LastName, Firstname

	SET @Err = @@Error

	RETURN @Err
END
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
		    tblCaseDocuments.CaseDocTypeID
    FROM    dbo.tblCaseDocuments
    WHERE   ( casenbr = @casenbr )
            AND ( type <> 'Report' )
    ORDER BY dateadded DESC
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO





UPDATE tblEmployer 
SET EWParentEmployerID = (SELECT EWParentEmployerID 
FROM tblEWParentEmployer WHERE ParentEmployer = 'Verizon') 
WHERE [Name] LIKE '%Verizon%'
GO

INSERT INTO tblSetting ([Name], [Value]) VALUES ('VerizonSLUTolerance', '25')
GO

SET IDENTITY_INSERT tblCaseDocType ON;
INSERT INTO tblCaseDocType (CaseDocTypeID,ShortDesc,Description,TypeCategory, PublishOnWeb)
VALUES(17, 'Email', 'Email Message', 'Document', 0);
SET IDENTITY_INSERT tblCaseDocType OFF;
GO

INSERT  INTO tblUserFunction
        ( FunctionCode ,
          FunctionDesc 
        )
        SELECT  'CaseAttachMultiDocs' ,
                'Case - Attach Multiple Documents'
        WHERE   NOT EXISTS ( SELECT functionCode
                             FROM   tblUserFunction
                             WHERE  functionCode = 'CaseAttachMultiDocs' )
GO

-- Issue 6125 - data conversion from original MMIReached to newly added column
UPDATE tblCase 
   SET MMIReachedStatus = CASE MMIReached 
							WHEN 0 THEN 'No'
							WHEN 1 THEN 'Yes'
						  END 
 WHERE MMIReached IS NOT NULL
 GO 



UPDATE tblControl SET DBVersion='3.17'
GO
