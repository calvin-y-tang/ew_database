

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
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [IsNew] BIT CONSTRAINT [DF_tblCase_IsNew] DEFAULT ((1)) NOT NULL;


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
PRINT N'Altering [dbo].[tblCompany]...';


GO
ALTER TABLE [dbo].[tblCompany]
    ADD [DICOMHandlingPreference] INT NULL;


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
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [DateAdded]               DATETIME     NULL,
        [UserIDAdded]             VARCHAR (15) NULL,
        [DateEdited]              DATETIME     NULL,
        [UserIDEdited]            VARCHAR (15) NULL,
        [DICOMHandlingPreference] INT          NULL;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


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
PRINT N'Altering [dbo].[vw_WebCaseSummaryExt]...';


GO
ALTER VIEW vw_WebCaseSummaryExt

AS

SELECT
	--case
	tblCase.casenbr,
	tblCase.ExtCaseNbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	tblCase.dateofinjury2,
	tblCase.dateofinjury3,
	tblCase.dateofinjury4,
	tblCase.notes,
	tblCase.notes AS casenotes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.TransportationRequired,
	tblCase.InterpreterRequired,
	tblCase.LanguageID,
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	tblCase.InsuringCompany,

	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineefullname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.mobilephone,
	tblExaminee.workphone,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,

	(Case ISNULL(tblcase.EmployerID, 0)
        WHEN 0
        THEN tblExaminee.Employer  
		ELSE tblEmployer.Name  
		END) AS Employer,  

	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.TreatingPhysicianDiagnosis,

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

	tblExaminee.Country,
	tblExaminee.policynumber,

	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerContactFirstName  
		ELSE tblEmployerAddress.ContactFirst  
		END) AS EmployerContactFirstName,  
            
	(Case ISNULL(tblcase.EmployerID , 0)
        WHEN 0
        THEN tblExaminee.EmployerContactLastName  
		ELSE tblEmployerAddress.ContactLast  
		END) AS EmployerContactLastName,  

	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,
	tblExaminee.note AS StateDirected,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.description AS casetypedescription,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,
	tblClient.lastname + ', ' + tblClient.FirstName AS clientfullname,
	tblClient.phone1 AS ClientPhone,
	tblClient.email AS ClientEmail,
	tblClient.fax AS ClientFax,
	tblClient.notes AS ClientOffice,
	tblClient.Addr1 + ' ' + tblClient.Addr1 AS ClientAddress,
	tblClient.Phone1Ext AS ClientExt,
	

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix,

	--company
	tblCompany.extname AS InsCompanyName,
	tblCompany.addr1 AS InsCompanyAddress1,
	tblCompany.addr2 AS InsCompanyAddress2,
	tblCompany.city AS InsCompanyCity,
	tblCompany.state AS InsCompanyState,
	tblCompany.zip AS InsCompanyZip,

	--case manager
	tblRelatedParty.firstname AS CaseManagerFirstName,
	tblRelatedParty.lastname AS CaseManagerLastName,
	tblRelatedParty.address1 AS CaseManagerAddress1,
	tblRelatedParty.address2 AS CaseManagerAddress2,
	tblRelatedParty.city AS CaseManagerCity,
	tblRelatedParty.state AS CaseManagerState,
	tblRelatedParty.zip as CaseManagerZip,
	tblRelatedParty.companyname AS CaseManagerOffice,
	tblRelatedParty.phone as CaseManagerPhone,
	tblRelatedParty.fax as CaseManagerFax,
	tblRelatedParty.email as CaseManagerEmail,

	--language
	tblLanguage.Description as LanguageDescription

FROM tblCase
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
	LEFT OUTER  JOIN tblLanguage ON tblCase.LanguageID = tblLanguage.LanguageID
	LEFT OUTER JOIN tblCaseRelatedParty ON tblCase.casenbr = tblCaseRelatedParty.casenbr
	LEFT OUTER JOIN tblRelatedParty ON tblCaseRelatedParty.RPCode = tblRelatedParty.RPCode
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
    LEFT OUTER JOIN tblEmployer on tblcase.EmployerID = tblEmployer.EmployerID 
    LEFT OUTER JOIN tblEmployerAddress on tblcase.EmployerAddressID = tblEmployerAddress.EmployerAddressID
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
PRINT N'Altering [dbo].[vwRptProgressiveClosedCaseSummary]...';


GO
ALTER VIEW vwRptProgressiveClosedCaseSummary
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
 CT.Description AS CaseType,
 S.Description AS Service,
 Q.StatusDesc AS CaseStatus,
 
 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 IIF(C.PlaintiffAttorneyCode IS NOT NULL, PA.Company, '') AS AttorneyCompany,
 IIF(C.PlaintiffAttorneyCode IS NOT NULL, RTRIM(LTRIM(ISNULL(PA.FirstName,'') + ' ' + ISNULL(PA.LastName,''))), '') AS AttorneyName,
 ISNULL(C.DoctorName, (ISNULL(D.FirstName,'') + ' ' + ISNULL(D.MiddleInitial,'') + ' ' + ISNULL(D.LastName,''))) AS DoctorName,
 CA2.SpecialtyCode AS DoctorSpecialty,
 D.County,
 D.State,

 C.DateReceived,
 C.DateOfInjury,
 C.OrigApptTime,
 C.DateCanceled,

 AH.DocumentNbr AS InvoiceNbr,
 AH.DocumentTotal AS InvoiceAmt,
 IIF(C.NeedFurtherTreatment=1,'Positive','Negative') AS Result,
 IIF(C.IsReExam=1, 'Yes', 'No') AS [Re-Exam],

 A.ApptCount, A.ExamineeCanceled, A.ClientCanceled, A.NoShow,

 CL.CompanyCode,
 dbo.fnDateValue(C.DateCanceled) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblCCAddress AS PA ON C.PlaintiffAttorneyCode = PA.ccCode
 LEFT OUTER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr AND AH.DocumentType='IN'
 LEFT OUTER JOIN 
  (SELECT * FROM (SELECT CaseApptID, CaseNbr, DoctorCode, SpecialtyCode,
   RANK() OVER(PARTITION BY CaseNbr ORDER BY CaseApptID DESC) AS MaxCaseApptID
   FROM tblCaseAppt) AS CA3 WHERE CA3.MaxCaseApptID = 1)
   AS CA2 ON C.CaseNbr = CA2.CaseNbr
 LEFT OUTER JOIN tblDoctor AS D ON CA2.DoctorCode = D.DoctorCode
 LEFT OUTER JOIN
 (SELECT CA.CaseNbr,
  COUNT(CA.CaseApptID) AS ApptCount,
  SUM(IIF(CA.ApptStatusID IN (50,51) AND CA.CanceledByID IN (3,5), 1, 0)) AS ExamineeCanceled,
  SUM(IIF(CA.ApptStatusID IN (50,51) AND CA.CanceledByID IN (2), 1, 0)) AS ClientCanceled,
  SUM(IIF(CA.ApptStatusID IN (101), 1, 0)) AS NoShow
  FROM tblCaseAppt AS CA
  GROUP BY CA.CaseNbr
 ) AS A ON A.CaseNbr = C.CaseNbr
 WHERE 1=1
 AND S.EWServiceTypeID=1
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
PRINT N'Altering [dbo].[vwRptProgressiveIMESummary]...';


GO
ALTER VIEW vwRptProgressiveIMESummary
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,

 ISNULL(EE.LastName, '') + ', ' + ISNULL(EE.FirstName, '') AS ExamineeName,
 ISNULL(CL.LastName, '') +', ' + ISNULL(CL.FirstName, '') AS ClientName,
 C.DoctorSpecialty,
 L.County,

 C.DateReceived,
 C.DateOfInjury,
 C.OrigApptTime,
 C.RptFinalizedDate,
 C.RptSentDate,

 AH.DocumentNbr AS InvoiceNbr,
 AH.DocumentTotal AS InvoiceAmt,
 IIF(C.NeedFurtherTreatment = 1, 'Positive', 'Negative') AS Result,
 IIF(C.IsReExam=1, 'Yes', 'No') AS [Re-Exam],
 
 CL.CompanyCode,
 dbo.fnDateValue(C.RptSentDate) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr AND AH.DocumentType='IN'
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
 WHERE 1 = 1
 AND S.EWServiceTypeID = 1
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
PRINT N'Altering [dbo].[vwRptProgressivePeerSummary]...';


GO
ALTER VIEW vwRptProgressivePeerSummary
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
 CT.Description AS CaseType,
 S.Description AS Service,

 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 C.DoctorSpecialty,
 L.County,

 C.DateReceived,
 C.DateOfInjury,
 C.RptFinalizedDate,
 C.RptSentDate,

 AH.DocumentNbr AS InvoiceNbr,
 AH.DocumentTotal AS PeerFee,

 PB.BillAmount,
 PB.BillAmountApproved,

 CL.CompanyCode,
 dbo.fnDateValue(C.RptSentDate) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr AND AH.DocumentType='IN'
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 LEFT OUTER JOIN
 (SELECT CPB.CaseNbr, SUM(CPB.BillAmount) AS BillAmount, SUM(CPB.BillAmountApproved) AS BillAmountApproved FROM tblCasePeerBill AS CPB GROUP BY CPB.CaseNbr) AS PB ON PB.CaseNbr = C.CaseNbr
 WHERE 1=1
 AND (S.EWServiceTypeID=2 OR S.ServiceCode=520)
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
PRINT N'Altering [dbo].[vwRptProgressiveReExam]...';


GO
ALTER VIEW vwRptProgressiveReExam
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
 CT.Description AS CaseType,
 S.Description AS Service,
 Q.StatusDesc AS CaseStatus,

 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 CL.EmployeeNumber,
 C.DoctorSpecialty,

 C.DateReceived,
 C.DateOfInjury,
 C.ApptDate,
 C.OrigApptTime AS OrigApptDate,
 LC.ReExamNoticePrintedDate AS DateIMENotice,
 LC.RptFinalizedDate AS OriginalIMERptFinalizedDate, 

 IIF(C.IsReExam=1, 'Yes', 'No') AS [Re-Exam],
 IIF(C.IsAutoReExam=1, 'Yes', 'No') AS [AutoRe-Exam],

 CL.CompanyCode,
 dbo.fnDateValue(C.ApptDate) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblCase AS LC ON C.PreviousCaseNbr = LC.CaseNbr
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 WHERE 1=1
 AND S.EWServiceTypeID=1
 AND C.IsReExam=1
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
PRINT N'Altering [dbo].[vwRptProgressiveReferral]...';


GO
ALTER VIEW vwRptProgressiveReferral
AS
SELECT
 C.CaseNbr,
 CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
 CT.Description AS CaseType,
 S.Description AS Service,
 Q.StatusDesc AS CaseStatus,

 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 C.SReqSpecialty AS RequestedSpecialty,
 L.County,
 L.State,

 C.DateReceived,
 C.DateOfInjury,

 FZ.Name AS FeeZone,

 (SELECT TOP 1 Description FROM tblCaseDocuments AS CD WHERE (CD.CaseNbr=C.CaseNbr OR (CD.MasterCaseNbr=C.MasterCaseNbr AND CD.SharedDoc=1)) 
     AND Description LIKE '% EFF[ .]%' ORDER BY SeqNo DESC) AS LastEff,

 CL.CompanyCode,
 dbo.fnDateValue(C.DateReceived) AS FilterDate

 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 LEFT OUTER JOIN tblEWFeeZone AS FZ ON FZ.EWFeeZoneID = C.EWFeeZoneID
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 WHERE 1=1
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
PRINT N'Altering [dbo].[vwRptProgressiveRptWebLog]...';


GO

ALTER VIEW [dbo].[vwRptProgressiveRptWebLog]
AS
SELECT
C.CaseNbr,
CASE WHEN ISNULL(C.ClaimNbrExt,'') <> '' THEN C.ClaimNbr + '.' + C.ClaimNbrExt ELSE C.ClaimNbr END AS ClaimNumber,
EE.firstName + ' ' + EE.lastName AS Examinee,
CDT.Description AS DocType,
CD.Description AS DocDescrip,
POW.DateAdded AS DateUploaded,
CL.FirstName + ' ' + CL.LastName AS Client,
CL.EmployeeNumber AS ClientEmployeeNumber,
POW.DateViewed,
DATEDIFF(DAY, POW.DateAdded, POW.DateViewed) AS Days,
S.Description AS Service,
CT.Description AS ClaimType,
C.ApptDate,
C.DoctorSpecialty,
C.DoctorName,
C.DateOfInjury,

 CL.CompanyCode,
dbo.fnDateValue(POW.DateAdded) AS FilterDate

FROM tblCaseDocuments AS CD
INNER JOIN tblCaseDocType AS CDT ON CDT.CaseDocTypeID = CD.CaseDocTypeID
INNER JOIN tblPublishOnWeb AS POW ON POW.TableType='tblCaseDocuments' AND POW.TableKey=CD.SeqNo
INNER JOIN tblClient AS CL ON POW.UserType='CL' AND POW.UserCode=CL.ClientCode
INNER JOIN tblCase AS C ON C.CaseNbr = CD.CaseNbr
INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
WHERE CD.CaseDocTypeID=5 OR CD.Description LIKE '%Closed Letter%'
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
PRINT N'Altering [dbo].[proc_Info_Hartford_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

--
-- Hartford Main Query 
-- 

SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_HartfordInvoices') IS NOT NULL DROP TABLE ##tmp_HartfordInvoices
print 'Gather main data set ...'

DECLARE @serviceVarianceValue INT = 19
DECLARE @xml XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdLIst

SELECT
    ewf.[DBID],
	ah.HeaderId,
	ah.SeqNo,
	ah.DocumentNbr,
	ewf.GPFacility + '-' + CAST(ah.DocumentNbr AS Varchar(16)) as "InvoiceNo",
	ah.DocumentDate as "InvoiceDate",
	S.[Description] as [Service],
    CT.[Description] as CaseType,
    c.CaseNbr,
	c.ExtCaseNbr,
	c.SLARuleID,
	co.IntName,
	EFGS.BusUnitGroupName as BusUnit,
	APS.Name as ApptStatus,
	ISNULL(cli.LastName, '') + ', ' + ISNULL(cli.FirstName, '') as "HIGRequestor",
	isnull(SPL.PrimarySpecialty, isnull(CA.SpecialtyCode, C.DoctorSpecialty)) as "Specialty",	
	SPL.SubSpecialty AS "SubSpecialty",	
	ISNULL(d.lastname, '') + ', ' + ISNULL(d.firstname, '') as "ProviderName",
	CONVERT(CHAR(4), EWBL.EWBusLineID) as "LOB",
	C.ClaimNbr as "ClaimNumber",
	E.LastName as "ClaimantLastName",
	E.FirstName as "ClaimantFirstName",
	ISNULL(AH.ServiceState, C.Jurisdiction) as "ServiceState",
	s.EWServiceTypeID as "ServiceTypeID",
	S.Description as "ServiceType",
	EWBL.Name as "CoverageType",
	CONVERT(VARCHAR(32), 'NA') as "LitOrAppeal",
	C.DateOfInjury as "DOI",
	ISNULL(ca.datereceived, c.DateReceived) as "ReferralDate",
	ISNULL(ca.datereceived, c.DateReceived) as "DateReceived",
	ISNULL(ca.datereceived, c.DateReceived) as "DateScheduled",
	ISNULL(ca.ApptTime, c.ApptTime) as "ExamDate",
	ISNULL(c.RptSentDate, c.RptFinalizedDate) as "ReportDelivered",
	NULL as "TotalDays",
	IIF(ISNULL(C.TATServiceLifeCycle, '') <> '', C.TATServiceLifeCycle - @serviceVarianceValue, 0) as "ServiceVariance",
	CONVERT(CHAR(8), NULL) as "JurisTAT",
	CAST(ISNULL(NW.EWNetworkID, '0') AS CHAR(8)) as "InOutNetwork",
	ISNULL(LI.ExamFee, '') as "ExamFee",
	ISNULL(AH.DocumentTotal, '') as "InvoiceFee",
	CONVERT(VARCHAR(300), NULL) as PrimaryException,
	CONVERT(VARCHAR(32), NULL) as PrimaryDriver,
	CONVERT(VARCHAR(300), NULL) as SecondaryException,
	CONVERT(VARCHAR(32), NULL) as SecondaryDriver,
	CONVERT(VARCHAR(800), NULL) as Comments
INTO ##tmp_HartfordInvoices
FROM tblAcctHeader as AH
	inner join tblClient as cli on AH.ClientCode = cli.ClientCode
	inner join tblCase as C on AH.CaseNbr = C.CaseNbr	
	inner join tblOffice as O on C.OfficeCode = O.OfficeCode
	inner join tblServices as S on C.ServiceCode = S.ServiceCode
	left outer join tblEWNetwork as NW on C.EWNetworkID = NW.EWNetworkID
	left outer join tblEWServiceType as EWS on S.EWServiceTypeID = EWS.EWServiceTypeID
	left outer join tblCaseType as CT on C.CaseType = CT.Code
	left outer join tblEWBusLine as EWBL on CT.EWBusLineID = EWBL.EWBusLineID
	left outer join tblEWFacility as EWF on AH.EWFacilityID = EWF.EWFacilityID
	left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
	left outer join tblClient as CL on AH.ClientCode = CL.ClientCode
	left outer join tblCompany as CO on AH.CompanyCode = CO.CompanyCode
	left outer join tblEWParentCompany as EWPC on CO.ParentCompanyID = EWPC.ParentCompanyID
	left outer join tblEWFacilityGroupSummary as EFGS on AH.EWFacilityID = EFGS.EWFacilityID
	left outer join tblCaseAppt as CA on ISNULL(AH.CaseApptID, C.CaseApptID) = CA.CaseApptID
	left outer join tblApptStatus as APS on ISNULL(AH.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
	left outer join tblDoctor as D on ISNULL(CA.DoctorCode, C.DoctorCode) = D.DoctorCode
	left outer join tblSpecialty as SPL on ISNULL(CA.SpecialtyCode, C.DoctorSpecialty) = SPL.SpecialtyCode		  
	left join
		  (select
			 tAD.HeaderID,
			 SUM(tAD.ExtAmountUS) as ExamFee
		   from tblAcctHeader as tAH
			   inner join tblAcctDetail as tAD on (tAH.HeaderID = tAD.HeaderID)
			   inner join tblCase as tC on tAH.CaseNbr = tC.CaseNbr
			   left outer join tblFRCategory as tFRC on tC.CaseType = tFRC.CaseType and tAD.ProdCode = tFRC.ProductCode
			   left outer join tblEWFlashCategory as tEWFC on tFRC.EWFlashCategoryID = tEWFC.EWFlashCategoryID
		   where tEWFC.Mapping3 = 'FeeAmount'
		   group by tAD.HeaderID
		  ) LI on AH.HeaderID = LI.HeaderID
WHERE (AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate)
      AND (AH.DocumentType = 'IN')
      AND (AH.DocumentStatus = 'Final')
      AND (EWPC.ParentCompanyID = 30)
	  AND (AH.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND ((EWS.Mapping1 in ('IME', 'MRR', 'ADD')) or (S.ShortDesc = 'FCE'))      
ORDER BY EWF.GPFacility, AH.DocumentNbr

print 'Data retrieved'
set nocount off
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
PRINT N'Creating [dbo].[proc_PublishOnWeb_LoadByTableKeyTableTypeNoUserCode]...';


GO
CREATE PROCEDURE [proc_PublishOnWeb_LoadByTableKeyTableTypeNoUserCode]
(
	@TableKey int,
	@TableType varchar(50),
	@UserType varchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblPublishOnWeb]
	WHERE
		([TableKey] = @TableKey)
	AND 
		([TableType] = @TableType)
	AND 
		([UserType] = @UserType)

	SET @Err = @@Error

	RETURN @Err
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

-- Issue 10046 - add tokens to table
INSERT INTO tblMessageToken (Name, Description)
VALUES ('@ExamineeCertNbr@', NULL)
INSERT INTO tblMessageToken (Name, Description)
VALUES ('@AttorneyCertNbr@', NULL)
GO


--
-- Issue 11086 - data patch for new IsNew column - set all values to 0
UPDATE tblCase SET IsNew = 0 WHERE 1=1
