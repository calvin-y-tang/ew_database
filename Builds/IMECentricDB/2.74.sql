PRINT N'Dropping [dbo].[tblAcctDetail].[IdxtblAcctDetail_BY_DocumentNbrDocumentTypeLineNbr]...';


GO
DROP INDEX [IdxtblAcctDetail_BY_DocumentNbrDocumentTypeLineNbr]
    ON [dbo].[tblAcctDetail];


GO
PRINT N'Dropping [dbo].[tblAcctingTrans].[IdxtblAcctingTrans_BY_documentnbrtype]...';


GO
DROP INDEX [IdxtblAcctingTrans_BY_documentnbrtype]
    ON [dbo].[tblAcctingTrans];


GO
PRINT N'Dropping [dbo].[vwAcctingSummaryWithSecurity]...';


GO
DROP VIEW [dbo].[vwAcctingSummaryWithSecurity];


GO
PRINT N'Dropping [dbo].[vwBMCCaseExport]...';


GO
DROP VIEW [dbo].[vwBMCCaseExport];


GO
PRINT N'Dropping [dbo].[vwCaseMonitor]...';


GO
DROP VIEW [dbo].[vwCaseMonitor];


GO
PRINT N'Dropping [dbo].[vwEDIExportSummaryWithSecurity]...';


GO
DROP VIEW [dbo].[vwEDIExportSummaryWithSecurity];


GO
PRINT N'Dropping [dbo].[vwExportSummaryWithSecurity]...';


GO
DROP VIEW [dbo].[vwExportSummaryWithSecurity];


GO
PRINT N'Dropping [dbo].[vwlabel]...';


GO
DROP VIEW [dbo].[vwlabel];


GO
PRINT N'Dropping [dbo].[vwpaneltest]...';


GO
DROP VIEW [dbo].[vwpaneltest];


GO
PRINT N'Dropping [dbo].[vwscheduler]...';


GO
DROP VIEW [dbo].[vwscheduler];


GO
PRINT N'Dropping [dbo].[vwservicequeues]...';


GO
DROP VIEW [dbo].[vwservicequeues];


GO
PRINT N'Dropping [dbo].[s_ShrinkSpecificDatabaseLog]...';


GO
DROP PROCEDURE [dbo].[s_ShrinkSpecificDatabaseLog];


GO
PRINT N'Dropping [dbo].[spBMCBillingHistoryExport]...';


GO
DROP PROCEDURE [dbo].[spBMCBillingHistoryExport];


GO
PRINT N'Dropping [dbo].[spBMCNetProfitExport]...';


GO
DROP PROCEDURE [dbo].[spBMCNetProfitExport];


GO
PRINT N'Dropping [dbo].[spFrmMainForm]...';


GO
DROP PROCEDURE [dbo].[spFrmMainForm];


GO
PRINT N'Altering [dbo].[tblAcctDetail]...';


GO
ALTER TABLE [dbo].[tblAcctDetail] DROP COLUMN [DocumentNbr], COLUMN [DocumentType];


GO
PRINT N'Altering [dbo].[tblAcctHeader]...';


GO
ALTER TABLE [dbo].[tblAcctHeader] DROP COLUMN [RelatedDocumentNbr];


GO
PRINT N'Altering [dbo].[tblAcctingTrans]...';


GO
ALTER TABLE [dbo].[tblAcctingTrans] DROP COLUMN [DocumentAmount], COLUMN [DocumentDate], COLUMN [DocumentNbr];


GO
PRINT N'Altering [dbo].[tblCaseTrans]...';


GO
ALTER TABLE [dbo].[tblCaseTrans] DROP COLUMN [DocumentNbr];


GO
PRINT N'Altering [dbo].[tblClaimInfo]...';


GO


ALTER TABLE [dbo].[tblClaimInfo] DROP COLUMN [InvoiceNbr];


GO
PRINT N'Altering [dbo].[tblDoctor]...';


GO
ALTER TABLE [dbo].[tblDoctor]
    ADD [TXMTaxID]         VARCHAR (11) NULL,
        [SORMTaxID]        VARCHAR (11) NULL,
        [TXMProviderName]  VARCHAR (70) NULL,
        [SORMProviderName] VARCHAR (70) NULL;


GO
PRINT N'Altering [dbo].[tblGPInvoice]...';


GO
ALTER TABLE [dbo].[tblGPInvoice] DROP COLUMN [InvoiceNbr];


GO
PRINT N'Altering [dbo].[tblGPInvoiceEDIStatus]...';


GO
ALTER TABLE [dbo].[tblGPInvoiceEDIStatus] DROP COLUMN [InvoiceNbr];


GO
PRINT N'Altering [dbo].[tblGPVoucher]...';


GO
ALTER TABLE [dbo].[tblGPVoucher] DROP COLUMN [VoucherNbr];


GO
PRINT N'Altering [dbo].[tblInvoiceAttachments]...';


GO
ALTER TABLE [dbo].[tblInvoiceAttachments] DROP COLUMN [DocumentNbr], COLUMN [DocumentType];


GO
PRINT N'Altering [dbo].[tblRecordsObtainment]...';


GO
ALTER TABLE [dbo].[tblRecordsObtainment] DROP COLUMN [InvoiceNbr];


GO
PRINT N'Altering [dbo].[fnGetCaseDocumentPath]...';


GO
ALTER FUNCTION [dbo].[fnGetCaseDocumentPath]
(
  @caseNbr INT,			
  @docType VARCHAR(32)	
)
RETURNS @documentInfo TABLE
(
	DocumentPath VarChar(500),
	FolderID INT,
	SubFolder VarChar(32)
)
AS
BEGIN
	DECLARE @path VARCHAR(500)	
	DECLARE @folderID INT
	DECLARE @subFolder VARCHAR(32)
	IF (@docType = 'invoice' or @docType = 'voucher') 
	BEGIN
		-- accounting document folder
		SELECT @path = tblEWFolderDef.PathName 
			+ RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr),
			@folderID = tblEWFolderDef.FolderID,
			@subFolder = RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr) + '\'		
		  FROM tblCase
				LEFT OUTER JOIN tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
				INNER JOIN tblIMEData on ISNULL(tblOffice.IMECode, 1) = tblIMEData.IMECode
				INNER JOIN tblEWFolderDef on tblIMEData.AcctDocFolderID = tblEWFolderDef.FolderID
		  WHERE CaseNbr = @caseNbr 
			AND CaseNbr IS NOT NULL		
	END
	ELSE
	BEGIN
		-- case document folder
		SELECT @path = tblEWFolderDef.PathName 
			+ RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr),
			@folderID = tblEWFolderDef.FolderID,
			@subFolder = RTRIM(YEAR(tblCase.DateAdded))
			+ '-'
			+ RIGHT('0' + RTRIM(MONTH(tblCase.DateAdded)), 2)
			+ '\' + CONVERT(VARCHAR, @caseNbr) + '\'		
		  FROM tblCase
				LEFT OUTER JOIN tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
				INNER JOIN tblIMEData on ISNULL(tblOffice.IMECode, 1) = tblIMEData.IMECode
				INNER JOIN tblEWFolderDef on tblIMEData.CaseDocFolderID = tblEWFolderDef.FolderID
		  WHERE CaseNbr = @caseNbr 
			AND CaseNbr IS NOT NULL
	END	
	INSERT @documentInfo
		SELECT	@path as DocumentPath,
				@folderID as FolderID, 
				@subFolder as SubFolder
	RETURN
END
GO
PRINT N'Refreshing [dbo].[vwInvoiceAttachmentGuidance]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwInvoiceAttachmentGuidance]';


GO
PRINT N'Refreshing [dbo].[vwLibertyExport]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwLibertyExport]';


GO
PRINT N'Refreshing [dbo].[vwPDFInvDetData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwPDFInvDetData]';


GO
PRINT N'Refreshing [dbo].[vw_EDIFileAttachments]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_EDIFileAttachments]';


GO
PRINT N'Refreshing [dbo].[vwAcctDocuments]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwAcctDocuments]';


GO
PRINT N'Altering [dbo].[vwAcctingSummary]...';


GO
ALTER VIEW vwAcctingSummary
AS
    Select 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,
            DateDIFF(day, AT.lastStatusChg, GETDate()) AS IQ ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,

            AT.blnSelect AS billedSelect ,
            C.ApptSelect ,
            C.drchartSelect ,
            C.inqaSelect ,
            C.inTransSelect ,
            C.awaitTransSelect ,
            C.chartprepSelect ,
            C.ApptrptsSelect ,
            C.miscSelect ,
            C.voucherSelect ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			C.PanelNbr ,
            C.OfficeCode ,
            C.ServiceCode ,
            C.Notes ,

            C.QARep ,
            C.LastStatusChg ,
            C.CaseType,
			C.Status AS CaseStatusCode ,
            C.Priority ,
            C.MasterSubCase ,

            C.MarketerCode ,
            C.SchedulerCode ,
            C.RequestedDoc ,
            C.InvoiceDate ,
            C.InvoiceAmt ,
            C.DateDrChart ,
            C.TransReceived ,
            C.ShownoShow ,
            C.TransCode ,
            C.rptStatus ,

            C.DateAdded ,
            C.DateEdited ,
            C.UserIDEdited ,
            C.UserIDAdded ,

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END
              ELSE Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '')
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END AS DrOpName ,

            COM.CompanyCode ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
			ATL.LocationCode AS DoctorLocation ,
            ATL.Location AS Location ,

            CT.Description AS CaseTypeDesc ,
			CaseQ.StatusDesc AS CaseStatusDesc ,
            tblApptStatus.Name AS Result ,
            ATQ.StatusDesc ,
            ATQ.FunctionCode ,
            S.Description AS ServiceDesc

    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation AS ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
GO
PRINT N'Refreshing [dbo].[vwAcctRegisterTax]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vwAcctRegisterTax]';


GO
PRINT N'Altering [dbo].[vwDocumentAccting]...';


GO
ALTER VIEW vwDocumentAccting
AS
    SELECT  tblCase.CaseNbr ,
            tblCase.ClaimNbr ,

            tblAcctingTrans.SeqNO ,
            AH.DocumentNbr ,
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
			tblCase.CertMailNbr2 ,
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
			tblDoctor.DrMedRecsInDays AS DrMedRecsInDays ,

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

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
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

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
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

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
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
			tblOffice.ShortDesc AS OfficeShortDesc ,
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
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = tblAcctingTrans.SeqNO

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
PRINT N'Altering [dbo].[vwExportSummary]...';


GO
ALTER VIEW vwExportSummary
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.BatchNbr IS NULL )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO
PRINT N'Altering [dbo].[vwCaseHistoryFollowUp]...';


GO
ALTER VIEW vwCaseHistoryFollowUp
AS
SELECT  C.CaseNbr ,
        C.DoctorName ,
        C.ApptDate ,
        C.ClaimNbr ,

		C.DoctorCode ,
		C.SchedulerCode ,
		C.OfficeCode ,
		C.MarketerCode ,
		CL.CompanyCode ,
		C.ClientCode ,
		C.DoctorLocation ,
		C.QARep ,
		C.CaseType ,
		C.ServiceCode ,

        EE.LastName + ', ' + EE.FirstName AS ExamineeName ,
        CL.LastName + ', ' + CL.FirstName AS ClientName ,
        COM.IntName AS CompanyName ,
        L.Location ,

        S.ShortDesc AS Service ,
        Q.ShortDesc AS Status ,

        CH.EventDate ,
        CH.Eventdesc ,
        CH.UserID ,
        CH.OtherInfo ,
        CH.FollowUpDate ,
		CH.ID
FROM    tblCase AS C
        INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
        INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
        INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
        LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
        LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
        LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
        LEFT OUTER JOIN tblExaminee AS EE ON C.ChartNbr = EE.ChartNbr
        INNER JOIN tblCaseHistory AS CH ON CH.CaseNbr = C.CaseNbr
WHERE   CH.FollowUpDate IS NOT NULL
GO
PRINT N'Altering [dbo].[vwCaseOpenServices]...';


GO
ALTER VIEW vwCaseOpenServices
AS
    SELECT  tblCase.CaseNbr ,
            tblCaseOtherParty.DueDate ,
            tblCaseOtherParty.Status ,
            tblCase.OfficeCode ,
            tblCase.DoctorLocation ,
            tblCase.MarketerCode ,
            tblCase.DoctorCode ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblCaseOtherParty.UserIDResponsible ,
            tblCase.ApptDate ,
            tblServices.ShortDesc AS service ,
            tblServices.ServiceCode ,
            tblDoctor_1.CompanyName ,
            tblDoctor_1.OPSubType ,
            tblCase.SchedulerCode ,
            tblCompany.CompanyCode ,
            tblCase.QARep ,
            tblCaseOtherParty.OPCode ,
            tblCase.PanelNbr ,
            tblCase.DoctorName ,
            tblCase.CaseType
    FROM    tblCaseOtherParty
            INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblDoctor tblDoctor_1 ON tblCaseOtherParty.OPCode = tblDoctor_1.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
    WHERE   ( tblCaseOtherParty.Status = 'Open' );
GO
PRINT N'Altering [dbo].[vwCaseSummary]...';


GO
ALTER VIEW vwCaseSummary
AS
    SELECT 
            tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblUser.LastName + ', ' + tblUser.FirstName AS SchedulerName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.INQASelect ,
            tblCase.INTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.transReceived ,
            tblTranscription.TransCompany ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.MiscSelect ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.VoucherAmt ,
            tblCase.VoucherDate ,
            tblCase.OfficeCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            DATEDIFF(day, tblCase.LastStatuschg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            tblCase.PanelNbr ,
            tblCase.CommitDate ,
            tblCase.MasterSubCase ,
            tblCase.MasterCaseNbr ,
            tblCase.CertMailNbr ,
            tblCase.WebNotifyEmail ,
            tblCase.PublishOnWeb ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS DoctorName ,
            tblCase.Datemedsrecd ,
            tblCase.sInternalCaseNbr ,
            tblCase.DoctorSpecialty ,
            tblCase.USDDate1 ,
            tblqueues.FunctionCode ,
            tblCase.Casetype ,
            tblCase.ForecastDate ,
            tblCase.ExternalDueDate ,
            tblCase.InternalDueDate ,
			tblCase.ReExam ,
			tblCase.ReExamDate ,
			tblCase.ReExamProcessed,
			tblCase.ReExamNoticePrinted,
            tblCase.DateCompleted ,
            tblCase.DateCanceled ,
            tblCase.EWReferralType ,
            tblCase.EWReferralEWFacilityID ,
            tblCase.ClaimNbrExt ,
            tblLocation.Addr1 AS LocationAddr1 ,
            tblLocation.Addr2 AS LocationAddr2 ,
            tblLocation.City AS LocationCity ,
            tblLocation.State AS LocationState ,
            tblLocation.Zip AS LocationZip
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.transCode = tblTranscription.transCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
GO
PRINT N'Altering [dbo].[vwCaseSummaryWithSecurity]...';


GO
ALTER VIEW vwCaseSummaryWithSecurity
AS
	--This view is merged with vwCaseSummary.
	--Do not use this one view. Use vwCaseSummary instead.
	--This view will be removed.
	SELECT * FROM vwCaseSummary
GO
PRINT N'Altering [dbo].[vwDoctorExportColumns]...';


GO
 
ALTER VIEW vwDoctorExportColumns
AS
SELECT DISTINCT 
              tblDoctor.LastName, tblDoctor.FirstName, tblDoctor.middleinitial, tblDoctor.Credentials AS degree, tblDoctor.Prefix, 
               tblDoctor.Status, tblDoctor.Addr1 AS Address1, tblDoctor.Addr2 AS Address2, tblDoctor.City, tblDoctor.State, tblDoctor.Zip, 
               tblDoctor.Phone, tblDoctor.PhoneExt AS Extension, tblDoctor.FaxNbr AS Fax, tblDoctor.EmailAddr AS Email, tblDoctor.OPType, 
               tblSpecialty.Description AS Specialty, tblOffice.Description AS Office, tblOffice.OfficeCode, tblDoctor.DoctorCode, 
               tblProviderType.Description AS ProviderType, tblDoctor.USDvarchar1, tblDoctor.USDvarchar2, tblDoctor.USDDate1, tblDoctor.USDDate2, 
               tblDoctor.USDint1, tblDoctor.USDint2, tblDoctor.USDmoney1, tblDoctor.USDmoney2, tblDoctor.USDDate3, tblDoctor.USDDate4, 
               tblDoctor.USDvarchar3, tblDoctor.USDDate5, tblDoctor.USDDate6, tblDoctor.USDDate7, tblDoctor.licenseNbr, tblDoctor.WCNbr, 
			   tblDoctor.DrMedRecsInDays
FROM  tblDoctor LEFT OUTER JOIN
               tblProviderType ON tblDoctor.ProvTypeCode = tblProviderType.ProvTypeCode LEFT OUTER JOIN
               tblOffice RIGHT OUTER JOIN
               tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON 
               tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode LEFT OUTER JOIN
               tblSpecialty INNER JOIN
               tblDoctorSpecialty ON tblSpecialty.SpecialtyCode = tblDoctorSpecialty.SpecialtyCode ON 
               tblDoctor.DoctorCode = tblDoctorSpecialty.DoctorCode
WHERE (tblDoctor.OPType = 'DR')
GO
PRINT N'Altering [dbo].[vwDocument]...';


GO
ALTER VIEW vwDocument
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
            tblCase.CertMailNbr2 ,
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
			tblDoctor.DrMedRecsInDays AS DrMedRecsInDays ,

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

            RTRIM(LTRIM(ISNULL(tblCCAddress_2.firstName,'') + ' ' + ISNULL(tblCCAddress_2.lastName,''))) AS PAttorneyName ,
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

            RTRIM(LTRIM(ISNULL(tblCCAddress_1.firstName,'') + ' ' + ISNULL(tblCCAddress_1.lastName,''))) AS DAttorneyName ,
            'Dear ' + ISNULL(tblCCAddress_1.firstName, '') + ' ' + ISNULL(tblCCAddress_1.lastName, '') AS DAttorneysalutation ,
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

            RTRIM(LTRIM(ISNULL(tblCCAddress_3.firstName,'') + ' ' + ISNULL(tblCCAddress_3.lastName,''))) AS DParaLegalName ,
            'Dear ' + ISNULL(tblCCAddress_3.firstName, '') + ' ' + ISNULL(tblCCAddress_3.lastName, '') AS DParaLegalsalutation ,
            tblCCAddress_3.Company AS DParaLegalCompany ,
            tblCCAddress_3.Address1 AS DParaLegalAddr1 ,
            tblCCAddress_3.Address2 AS DParaLegalAddr2 ,
            tblCCAddress_3.City + ', ' + tblCCAddress_3.State + '  '
            + tblCCAddress_3.Zip AS DParaLegalCityStateZip ,
            tblCCAddress_3.Phone + ' ' + ISNULL(tblCCAddress_3.PhoneExtension,'') AS DParaLegalPhone ,
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
			tblOffice.ShortDesc AS OfficeShortDesc ,
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
PRINT N'Altering [dbo].[vwStatusAppt]...';


GO
ALTER VIEW vwStatusAppt
AS
    SELECT  tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblClient.LastName + ', ' + tblClient.FirstName AS clientname ,
            tblUser.LastName + ', ' + tblUser.FirstName AS schedulername ,
            tblCompany.IntName AS companyname ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS clientemail ,
            tblClient.Fax AS clientfax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.InQASelect ,
            tblCase.InTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.TransReceived ,
            tblTranscription.TransCompany ,
            tblServices.ShortDesc AS service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblCase.QARep ,
            DATEDIFF(DAY, tblCase.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS doctorname ,
            tblCase.PanelNbr ,
            tblQueues.FunctionCode ,
            tblCase.ServiceCode ,
            tblCase.CaseType
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
                                       AND tblUser.UserType = 'SC'
GO
PRINT N'Altering [dbo].[vwStatusNew]...';


GO
ALTER VIEW vwStatusNew
AS
    SELECT DISTINCT
            tblCase.casenbr
           ,tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename
           ,CASE WHEN tblcase.panelnbr IS NULL
                 THEN tbldoctor.lastname + ', '
                      + ISNULL(tbldoctor.firstname, ' ')
                 ELSE tblcase.doctorname
            END AS doctorname
           ,tblClient.lastname + ', ' + tblClient.firstname AS clientname
           ,ISNULL(Scheduler.LastName,'') + CASE WHEN ISNULL(Scheduler.LastName,'')='' OR ISNULL(Scheduler.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Scheduler.FirstName, '') AS schedulername
           ,ISNULL(Marketer.LastName,'') + CASE WHEN ISNULL(Marketer.LastName,'')='' OR ISNULL(Marketer.FirstName, '')='' THEN '' ELSE ', ' END + ISNULL(Marketer.FirstName, '') AS marketername
           ,tblCompany.intname AS companyname
           ,tblCase.priority
           ,tblCase.ApptDate
           ,tblCase.status
           ,tblCase.dateadded
           ,tblCase.requesteddoc
           ,tblCase.doctorcode
           ,tblCase.marketercode
           ,tblQueues.statusdesc
           ,tblServices.shortdesc AS service
           ,tblCase.doctorlocation
           ,tblClient.companycode
           ,tblCase.servicecode
           ,tblCase.QARep
           ,tblCase.schedulercode
           ,tblCase.officecode
           ,tblCase.PanelNbr
           ,'ViewCase' AS FunctionCode
           ,tblCase.casetype
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.clientcode = tblCase.clientcode
            INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            INNER JOIN tblServices ON tblServices.servicecode = tblCase.servicecode
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblUser AS Scheduler ON tblCase.schedulercode = Scheduler.UserID
            LEFT OUTER JOIN tblUser AS Marketer ON Marketer.UserID = tblCase.marketercode
            LEFT OUTER JOIN tblQueues ON tblQueues.statuscode = tblCase.status
GO
PRINT N'Altering [dbo].[vwCase]...';


GO
ALTER VIEW vwCase
AS
    SELECT  CaseNbr ,
            DoctorLocation ,
            C.ClientCode ,
            C.MarketerCode ,
            SchedulerCode ,
            C.Status ,
            DoctorCode ,
            C.DateAdded ,
            ApptDate ,
            CL.CompanyCode ,
            OfficeCode ,
            C.QARep ,
			C.CaseType ,
			C.ServiceCode ,
			C.ReExam ,
			C.ReExamProcessed ,
			C.ReExamDate
    FROM    tblCase AS C
            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
GO
PRINT N'Altering [dbo].[vwCaseMonitorDetail]...';


GO
ALTER VIEW vwCaseMonitorDetail
AS
    SELECT  C.Status AS StatusCode,
            IIF(C.Priority <> 'Normal', 1, 0) AS Rush ,
            IIF(ISNULL(C.Priority, 'Normal') = 'Normal', 1, 0) AS Normal ,
            C.MarketerCode ,
            C.DoctorLocation ,
            C.DoctorCode ,
            CL.CompanyCode ,
            C.OfficeCode ,
            C.SchedulerCode ,
            C.QARep ,
            C.ServiceCode ,
            C.CaseType
    FROM    tblCase AS C
            INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
    WHERE   C.Status <> 8
            AND C.Status <> 9;
GO
PRINT N'Altering [dbo].[vwClaimNbrCheck]...';


GO
ALTER VIEW [dbo].[vwClaimNbrCheck]
AS
SELECT     dbo.tblCase.claimnbr, dbo.tblCase.ClaimNbrExt, dbo.tblCase.DoctorName, dbo.tblSpecialty.description AS Specialty, 
                      dbo.tblQueues.statusdesc AS Status, dbo.tblCaseType.description AS CaseType, dbo.tblServices.description AS Service, dbo.tblOffice.ShortDesc
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblSpecialty ON dbo.tblCase.doctorspecialty = dbo.tblSpecialty.specialtycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode INNER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code INNER JOIN
                      dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode LEFT OUTER JOIN
                         dbo.tblOffice ON dbo.tblCase.OfficeCode = dbo.tblOffice.OfficeCode
GO
PRINT N'Creating [dbo].[vwAcctingParam]...';


GO
CREATE VIEW vwAcctingParam
AS
    SELECT 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			C.PanelNbr ,
            C.OfficeCode ,
            C.ServiceCode ,
            C.Notes ,

            EE.lastName + ', ' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + ', ' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '') + ', '
                          + ISNULL(ATDr.firstName, '')
                   END
              ELSE Case AT.DrOpType
                     WHEN 'OP' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '')
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                WHEN 'OP' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '') + ', '
                     + ISNULL(ATDr.firstName, '')
            END AS DrOpName ,

            COM.CompanyCode ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
			ATL.LocationCode AS DoctorLocation ,
            ATL.Location AS Location ,

			C.BillingNote ,
            COM.Notes AS CompanyNotes ,
            CL.Notes AS ClientNotes ,
            ATDr.Notes AS DoctorNotes ,
			ATDr.DrAcctingNote ,

            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc

    FROM    tblCase AS C
            INNER JOIN tblAcctingTrans AS AT ON C.CaseNbr = AT.CaseNbr
			INNER JOIN tblQueues AS CaseQ ON C.Status = CaseQ.StatusCode
            INNER JOIN tblQueues AS ATQ ON AT.StatusCode = ATQ.StatusCode
            INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
            INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType

            INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
            INNER JOIN tblClient AS BCL ON ISNULL(C.BillClientCode, C.ClientCode)=BCL.ClientCode
			LEFT OUTER JOIN tblAcctHeader AS AH ON AH.SeqNo = AT.SeqNO
            LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode 
            LEFT OUTER JOIN tblCompany AS BCOM ON BCL.CompanyCode=BCOM.CompanyCode
            LEFT OUTER JOIN tblLocation AS ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
GO
PRINT N'Creating [dbo].[vwAcctMonitorDetail]...';


GO
CREATE VIEW vwAcctMonitorDetail
AS
    SELECT  AT.StatusCode ,
            IIF(C.Priority <> 'Normal', 1, 0) AS Rush ,
            IIF(ISNULL(C.Priority, 'Normal') = 'Normal', 1, 0) AS Normal ,
            C.MarketerCode ,
            C.DoctorLocation ,
            AT.DrOpCode AS DoctorCode ,
            CL.CompanyCode ,
            C.OfficeCode ,
            C.SchedulerCode ,
            C.QARep ,
            C.ServiceCode ,
            C.CaseType
    FROM    tblAcctingTrans AS AT
            INNER JOIN tblCase AS C ON AT.CaseNbr = C.CaseNbr
            INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
    WHERE   AT.StatusCode <> 20;
GO
PRINT N'Creating [dbo].[vwEDIExportSummary]...';


GO
CREATE VIEW vwEDIExportSummary
AS
    SELECT  tblCase.CaseNbr ,
			tblAcctingTrans.SeqNO ,
			tblAcctHeader.HeaderID ,
            tblAcctHeader.DocumentType ,
            tblAcctHeader.DocumentNbr ,
            tblAcctingTrans.StatusCode ,
            tblAcctHeader.EDIBatchNbr ,
            tblAcctHeader.EDIStatus ,
            tblAcctHeader.EDILastStatusChg ,
            tblAcctHeader.EDIRejectedMsg ,
            tblQueues.StatusDesc ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblAcctingTrans.DrOpType ,
            CASE ISNULL(tblCase.PanelNbr, 0)
              WHEN 0
              THEN CASE tblAcctingTrans.DrOpType
                     WHEN 'DR'
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN ''
                     THEN ISNULL(tblDoctor.LastName, '') + ', '
                          + ISNULL(tblDoctor.FirstName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
              ELSE CASE tblAcctingTrans.DrOpType
                     WHEN 'DR' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN '' THEN ISNULL(tblCase.DoctorName, '')
                     WHEN 'OP' THEN tblDoctor.CompanyName
                   END
            END AS DoctorName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblClient.Email AS AdjusterEmail ,
            tblClient.Fax AS AdjusterFax ,
            tblCase.MarketerCode ,
            tblCase.UserIDAdded ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.INBatchSelect ,
            tblAcctHeader.VOBatchSelect ,
            tblAcctHeader.TaxCode ,
            tblAcctHeader.TaxTotal ,
            tblAcctHeader.DocumentTotal ,
            tblAcctHeader.DocumentStatus ,
            tblCase.ClientCode ,
            tblCase.DoctorCode ,
            tblAcctHeader.BatchNbr ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblClient.CompanyCode ,
            tblCase.QARep ,
            tblCase.PanelNbr ,
            DATEDIFF(DAY, tblAcctingTrans.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.MasterSubCase ,
            tblqueues_1.StatusDesc AS CaseStatus ,
            tblQueues.FunctionCode ,
            tblServices.ShortDesc AS Service ,
            tblCase.ServiceCode ,
            tblCase.CaseType ,
            tblCase.InputSourceID ,
            tblCompany.BulkBillingID ,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime
    FROM    tblAcctHeader
            INNER JOIN tblAcctingTrans ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
            INNER JOIN tblCase ON tblAcctHeader.CaseNbr = tblCase.CaseNbr
            LEFT OUTER JOIN tblCompany ON tblAcctHeader.CompanyCode = tblCompany.CompanyCode
            LEFT OUTER JOIN tblClient ON tblAcctHeader.ClientCode = tblClient.ClientCode
            INNER JOIN tblQueues ON tblAcctingTrans.StatusCode = tblQueues.StatusCode
            INNER JOIN tblQueues tblqueues_1 ON tblCase.Status = tblqueues_1.StatusCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO
PRINT N'Altering [dbo].[proc_Doctor_GetApptCount]...';


GO


ALTER PROCEDURE [proc_Doctor_GetApptCount]

@DoctorCode varchar(20) = NULL,
@LocationCode varchar(20) = NULL,
@ApptDate varchar(20)

AS

SET NOCOUNT ON
DECLARE @Err int
 
SELECT COUNT(*) AS ApptCnt FROM tblDoctorSchedule 
INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25
INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
WHERE tblDoctorSchedule.date = @ApptDate
AND tblDoctorSchedule.DoctorCode = COALESCE(@DoctorCode, tblDoctorSchedule.DoctorCode) 
AND tblDoctorSchedule.LocationCode = COALESCE(@LocationCode, tblDoctorSchedule.LocationCode)  
AND tblDoctorSchedule.status = 'open'
  
SET @Err = @@Error
RETURN @Err
GO
PRINT N'Altering [dbo].[proc_GetDoctorLocationsAndSchedule]...';


GO


ALTER PROCEDURE [dbo].[proc_GetDoctorLocationsAndSchedule]

@DoctorCode int = NULL,
@ApptDate datetime = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT tblLocation.locationcode, 
  tblLocation.location, 
  tblLocation.location as locname, 
  tblLocation.addr1 + '  ' + tblLocation.city + '  ' + tblLocation.state + ' ' + ISNULL(tblLocation.zip, '') as locaddress,
  ISNULL(tblLocation.County, '') + ' County ' as loccounty
  FROM tbllocation
  INNER JOIN tblDoctorLocation ON tblLocation.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1
  INNER JOIN tblDoctor ON tblDoctorLocation.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode
  INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25
  WHERE tblLocation.insidedr = 1
  AND tblDoctor.DoctorCode = COALESCE(@DoctorCode,tblDoctor.DoctorCode) 
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 

 SET @Err = @@Error

 RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetDoctorLocationsAndScheduleWithSpec]...';


GO


ALTER PROCEDURE [dbo].[proc_GetDoctorLocationsAndScheduleWithSpec]

@LocationCode int = NULL,
@ApptDate datetime = NULL

AS
BEGIN

 SET NOCOUNT ON
 DECLARE @Err int

 SELECT DISTINCT tblDoctor.doctorcode, 
  ISNULL(tblDoctor.prefix, '') + ' ' + tblDoctor.firstname + ' ' + tblDoctor.lastname + ' ' + ISNULL(tblDoctor.credentials,'') as doctorname, 
  tblSpecialty.description specialty 
  FROM tblDoctor 
  INNER JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode 
  INNER JOIN tblDoctorSchedule ON tblDoctor.doctorcode = tblDoctorSchedule.doctorcode AND tblDoctorSchedule.status = 'open'
  INNER JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode 
  INNER JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode AND tblDoctorLocation.PublishOnWeb = 1
  INNER JOIN tblDoctorOffice ON tblDoctor.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25
  INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
  AND tblDoctorLocation.locationcode = COALESCE(@LocationCode,tblDoctorLocation.locationcode)
  AND tblDoctorSchedule.date = COALESCE(@ApptDate,tblDoctorSchedule.date) 
  AND tblDoctor.publishonweb = 1

 SET @Err = @@Error

 RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetFirstAvailApptByDoctor]...';


GO


ALTER PROCEDURE [proc_GetFirstAvailApptByDoctor]

@DoctorCode int

AS

SELECT top 1 CONVERT(VARCHAR(10), date, 110) + ' ' + CONVERT(VARCHAR(5), starttime, 114) startime 
 FROM tblDoctorSchedule 
 INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25 
 INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
 INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
 INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
 WHERE date >= getdate() 
 AND tblDoctorSchedule.doctorcode = @DoctorCode  
 AND tblDoctorSchedule.status = 'open' 
 ORDER BY date, starttime
GO
PRINT N'Altering [dbo].[proc_GetFirstAvailApptByLocation]...';


GO


ALTER PROCEDURE [proc_GetFirstAvailApptByLocation]

@LocationCode int

AS

SELECT top 1 CONVERT(VARCHAR(10), date, 110) + ' ' + CONVERT(VARCHAR(5), starttime, 114) startime 
 FROM tblDoctorSchedule 
 INNER JOIN tblDoctorOffice ON tblDoctorSchedule.doctorcode = tblDoctorOffice.doctorcode AND tblDoctorOffice.officecode = 25
 INNER JOIN tblDoctorLocation ON tblDoctorSchedule.locationcode = tblDoctorLocation.locationcode AND tblDoctorLocation.PublishOnWeb = 1 
 INNER JOIN tblLocation ON tblDoctorSchedule.locationcode = tblLocation.locationcode AND tblLocation.insidedr = 1
 INNER JOIN tblDoctor ON tblDoctorSchedule.doctorcode = tblDoctor.doctorcode AND tblDoctor.publishonweb = 1
 WHERE date >= getdate() 
 AND tblDoctorSchedule.LocationCode = @LocationCode  
 AND tblDoctorSchedule.status = 'open' 
 ORDER BY date, starttime
GO
PRINT N'Altering [dbo].[spAttorneyCases]...';


GO

-- 01/08/2015 - JAP - Issue 2176. Create new SP to source the AttorneyCases form.
ALTER PROCEDURE [dbo].[spAttorneyCases]
     @AttorneyCode AS INTEGER
AS
     SELECT 
          CaseNbr, 
          SUBSTRING(AttyTypes, 1, LEN(AttyTypes) - 1) AS AttorneyTypes,
          ExamineeName,
          ApptDate, 
          Description,
          ClientCode,
          ClientName,
          CompanyCode,
          IntName,
          Location, 
          DoctorCode, 
          StatusDesc, 
          DoctorName, 
          PlaintiffAttorneyCode, 
          DefenseAttorneyCode, 
          DefParaLegal, 
	  ShortDesc 
     FROM 
          (SELECT 
               dbo.tblCase.casenbr,  
               dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineeName, 
               dbo.tblCase.ApptDate, 
               dbo.tblCaseType.description, 
               dbo.tblCase.clientcode, 
               dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, 
               dbo.tblClient.companycode, 
               dbo.tblCompany.intname, 
               dbo.tblLocation.location, 
               dbo.tblDoctor.doctorcode, 
               dbo.tblQueues.statusdesc, 
               dbo.tblCase.DoctorName,
               -- @AttorneyCode AS AttrnyCode,
               dbo.tblCase.PlaintiffAttorneyCode, 
               dbo.tblCase.DefenseAttorneyCode, 
               dbo.tblCase.DefParaLegal, 
               CASE 
                    WHEN dbo.tblCase.PlaintiffAttorneyCode IS NOT NULL AND dbo.tblCase.PlaintiffAttorneyCode = @AttorneyCode
                    THEN 'PA,' 
                    ELSE '' 
               END 
               +
               CASE 
                    WHEN dbo.tblCase.DefenseAttorneyCode IS NOT NULL AND dbo.tblCase.DefenseAttorneyCode = @AttorneyCode 
                    THEN 'DA,' 
                    ELSE '' 
               END 
               +
               CASE 
                    WHEN dbo.tblCase.DefParaLegal IS NOT NULL AND dbo.tblCase.DefParaLegal = @AttorneyCode
                    THEN 'DP,' 
                    ELSE '' 
               END  
               +
               CASE 
                    WHEN dbo.tblExamineeCC.ccCode IS NOT NULL AND dbo.tblExamineeCC.ccCode = @AttorneyCode
                    THEN 'CC,' 
                    ELSE '' 
               END AS AttyTypes, 
	       dbo.tbloffice.ShortDesc 
          FROM 
               dbo.tblCase 
                    INNER JOIN dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr
                    INNER JOIN dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode
                    INNER JOIN dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    LEFT OUTER JOIN dbo.tblExamineeCC ON dbo.tblCase.chartnbr = dbo.tblExamineeCC.chartnbr AND dbo.tblExamineeCC.ccCode = @AttorneyCode
                    LEFT OUTER JOIN dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode 
                    LEFT OUTER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    LEFT OUTER JOIN dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode 
	            LEFT OUTER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
          WHERE 
               dbo.tblCase.PlaintiffAttorneyCode = @AttorneyCode 
            OR dbo.tblCase.DefenseAttorneyCode = @AttorneyCode
            OR dbo.tblCase.DefParaLegal = @AttorneyCode
			OR dbo.tblExamineeCC.ccCode = @AttorneyCode
          ) AS CaseListForAttorney
GO
PRINT N'Altering [dbo].[spClientCases]...';


GO

ALTER  PROCEDURE [dbo].[spClientCases]
@clientcode as integer
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr,  'C' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName, dbo.tbloffice.ShortDesc 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN 
					 dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
WHERE dbo.tblcase.clientcode = @clientcode
UNION
SELECT     TOP 100 PERCENT dbo.tblCase.casenbr,  'B' as ClientType, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName, dbo.tbloffice.ShortDesc 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN 
					  dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
WHERE dbo.tblcase.billclientcode = @clientcode
ORDER BY dbo.tblCase.ApptDate DESC
GO
PRINT N'Altering [dbo].[spCompanyCases]...';


GO
ALTER  PROCEDURE [dbo].[spCompanyCases]
@companycode as integer
AS SELECT     TOP 100 PERCENT dbo.tblCase.casenbr, dbo.tblExaminee.lastname + ', ' + dbo.tblExaminee.firstname AS examineename, dbo.tblCase.ApptDate, 
                      dbo.tblCaseType.description, dbo.tblCase.clientcode, dbo.tblClient.lastname + ', ' + dbo.tblClient.firstname AS clientname, dbo.tblClient.companycode, 
                      dbo.tblCompany.intname, dbo.tblLocation.location, dbo.tblDoctor.doctorcode, dbo.tblQueues.statusdesc, dbo.tblCase.DoctorName, dbo.tblOffice.ShortDesc 
FROM         dbo.tblCase INNER JOIN
                      dbo.tblExaminee ON dbo.tblCase.chartnbr = dbo.tblExaminee.chartnbr INNER JOIN
                      dbo.tblClient ON dbo.tblCase.clientcode = dbo.tblClient.clientcode INNER JOIN
                      dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode INNER JOIN
                      dbo.tblQueues ON dbo.tblCase.status = dbo.tblQueues.statuscode LEFT OUTER JOIN
                      dbo.tblLocation ON dbo.tblCase.doctorlocation = dbo.tblLocation.locationcode LEFT OUTER JOIN
                      dbo.tblDoctor ON dbo.tblCase.doctorcode = dbo.tblDoctor.doctorcode LEFT OUTER JOIN
                      dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code LEFT OUTER JOIN 
					  dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
WHERE dbo.tblcompany.companycode = @companycode
ORDER BY dbo.tblCase.ApptDate DESC
GO
PRINT N'Altering [dbo].[spDoctorCases]...';


GO
ALTER PROC spDoctorCases
    @doctorCode AS INTEGER
AS 
    SELECT TOP 100 PERCENT
            tblCase.CaseNbr ,
            tblExaminee.lastname + ', ' + tblExaminee.firstname AS ExamineeName ,
            tblCase.ApptDate ,
            tblDoctor.lastname + ', ' + tblDoctor.firstname AS DoctorName ,
            tblCase.ClientCode ,
            tblClient.lastname + ', ' + tblClient.firstname AS ClientName ,
            tblClient.CompanyCode ,
            tblCompany.IntName ,
            tblLocation.Location ,
            @doctorCode AS DoctorCode ,
            tblQueues.StatusDesc, 
			tbloffice.ShortDesc
    FROM    tblCase
            INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
            INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
            INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode
            INNER JOIN tblDoctor ON tblDoctor.DoctorCode = @doctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.doctorlocation = tblLocation.locationcode 
			LEFT OUTER JOIN dbo.tblOffice ON dbo.tblCase.officecode = dbo.tblOffice.officecode 
    WHERE   tblCase.DoctorCode = @doctorcode
            OR tblCase.PanelNbr IN ( SELECT PanelNbr
                                     FROM   tblCasePanel
                                     WHERE  DoctorCode = @doctorCode )
    ORDER BY tblCase.apptdate DESC
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_Insert]...';


GO
ALTER PROCEDURE [proc_CaseDocuments_Insert]
(
	@casenbr int,
	@document varchar(20),
	@type varchar(20) = NULL,
	@reporttype varchar(20) = NULL,
	@description varchar(200) = NULL,
	@sfilename varchar(200) = NULL,
	@dateadded datetime,
	@useridadded varchar(20) = NULL,
	@PublishOnWeb bit = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@seqno int = NULL output,
	@PublishedTo varchar(50) = NULL,
	@Viewed bit,
	@FileMoved bit,
	@FileSize int,
	@Source varchar(15),
	@FolderID int,
	@SubFolder varchar(32)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseDocuments]
	(
		[casenbr],
		[document],
		[type],
		[reporttype],
		[description],
		[sfilename],
		[dateadded],
		[useridadded],
		[PublishOnWeb],
		[dateedited],
		[useridedited],
		[PublishedTo],
		[Viewed],
		[FileMoved],
		[FileSize],
		[Source],
		[FolderID],
		[SubFolder]
	)
	VALUES
	(
		@casenbr,
		@document,
		@type,
		@reporttype,
		@description,
		@sfilename,
		@dateadded,
		@useridadded,
		@PublishOnWeb,
		@dateedited,
		@useridedited,
		@PublishedTo,
		@Viewed,
		@FileMoved,
		@FileSize,
		@Source,
		@FolderID,
		@SubFolder
	)

	SET @Err = @@Error

	SELECT @seqno = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseDocuments_Update]...';


GO
ALTER PROCEDURE [proc_CaseDocuments_Update]
(
	@casenbr int,
	@document varchar(20),
	@type varchar(20) = NULL,
	@reporttype varchar(20) = NULL,
	@description varchar(200) = NULL,
	@sfilename varchar(200) = NULL,
	@dateadded datetime,
	@useridadded varchar(20) = NULL,
	@PublishOnWeb bit = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@seqno int,
	@PublishedTo varchar(50) = NULL,
	@Viewed bit,
	@FileMoved bit,
	@FileSize int,
	@Source varchar(15),
	@FolderID int,
	@SubFolder varchar(32)
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCaseDocuments]
	SET
		[casenbr] = @casenbr,
		[document] = @document,
		[type] = @type,
		[reporttype] = @reporttype,
		[description] = @description,
		[sfilename] = @sfilename,
		[dateadded] = @dateadded,
		[useridadded] = @useridadded,
		[PublishOnWeb] = @PublishOnWeb,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[PublishedTo] = @PublishedTo,
		[Viewed] = @Viewed,
		[FileMoved] = @FileMoved,
		[FileSize] = @FileSize,
		[Source] = @Source,
		[FolderID] = @FolderID,
		[SubFolder] = @SubFolder
	WHERE
		[seqno] = @seqno


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_CaseVerifyAccessNP]...';


GO
ALTER PROCEDURE [proc_CaseVerifyAccessNP] 

@caseNbr int,
@ewwebuserid int

AS 

SELECT TOP 1 CaseNbr FROM tblCase 
WHERE 
(
ClientCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID IN (SELECT WebuserID from tblWebUser where ewwebuserid = @ewwebuserid)) 
OR
BillClientCode IN (SELECT UserCode FROM tblWebUserAccount WHERE WebUserID IN (SELECT WebuserID from tblWebUser where ewwebuserid = @ewwebuserid)) 
)
AND tblCase.PublishOnWeb = 1 
AND tblCase.CaseNbr = @caseNbr
GO
PRINT N'Altering [dbo].[proc_IMEException]...';


GO
ALTER PROCEDURE proc_IMEException
    @ExceptionID INT ,
    @OfficeCode INT ,
    @CaseTypeCode INT ,
    @ServiceCode INT ,
    @StatusCode INT ,
    @EnterLeave INT ,
    @CaseNbr INT
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @Err INT;

    SELECT  ED.* ,
            ISNULL(C.CaseNbr, -1) AS CaseNbr ,
            CL.ClientCode ,
            CO.ParentCompanyID ,
            CL.CompanyCode ,
            C.DoctorCode ,
            C.PlaintiffAttorneyCode ,
            C.DefenseAttorneyCode ,
            C.DefParaLegal ,
            BCL.ClientCode AS BillClientCode ,
            BCO.ParentCompanyID AS BillParentCompanyID ,
            BCL.CompanyCode AS BillCompanyCode
    FROM    tblExceptionDefinition AS ED
            LEFT OUTER JOIN tblCase AS C ON C.CaseNbr = @CaseNbr
            LEFT OUTER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
            LEFT OUTER JOIN tblCompany AS CO ON CL.CompanyCode = CO.CompanyCode
            LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = ISNULL(C.BillClientCode, C.ClientCode)
            LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
    WHERE   ED.Status = 'Active' AND ED.ExceptionID = @ExceptionID
			AND
			( ED.Entity = 'CS'
                OR ( ED.Entity = 'PC'
                    AND ( CO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                        
                    OR  BCO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = 'CO'
                    AND ( CL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                        
                    OR  BCL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = 'CL'
                    AND ( CL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                       
                    OR  BCL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = 'DR'
                    AND ( C.DoctorCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
                    )
                OR ( ED.Entity = 'AT'
                    AND ( C.PlaintiffAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            OR C.DefenseAttorneyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        )
                    )
            )
            AND ( ED.AllOffice = 1
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = C.OfficeCode )
				    OR ED.ExceptionDefID IN (SELECT ExceptionDefID FROM tblExceptionDefOffice WHERE OfficeCode = @OfficeCode )
                )
            AND ( ED.CaseTypeCode = -1
                    OR ED.CaseTypeCode = @CaseTypeCode
                )
            AND ( ED.ServiceCode = -1
                    OR ED.ServiceCode = @ServiceCode
                )
            AND ( ( ED.StatusCode = -1
                    AND ( ED.ExceptionID <> 18
                            OR ISNULL(ED.StatusCodeValue, 1) = @EnterLeave
                        )
                    )
                    OR ( ED.StatusCode = @StatusCode
                        AND ED.StatusCodeValue = @EnterLeave
                        )
                )

    SET @Err = @@Error;

    RETURN @Err;
END;
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
            description,
            sfilename,
            dateadded,
            useridadded,
            PublishOnWeb,
            dateedited,
            useridedited,
            seqno,
            PublishedTo,
            Source,
            FileSize,
            Pages,
			FolderID,
			SubFolder
    FROM    dbo.tblCaseDocuments
    WHERE   ( casenbr = @casenbr )
            AND ( type <> 'Report' )
    ORDER BY dateadded DESC
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[spCaseHistory]...';


GO
ALTER PROCEDURE dbo.spCaseHistory
    @iCaseNbr INT ,
    @sSort VARCHAR(10) ,
    @sIncludeExclude VARCHAR(1) ,
    @sTypes VARCHAR(120) ,
    @blnNoAccting INT ,
    @blnExamineeReimb int
AS
    DECLARE @sSelectStmt NVARCHAR(2000) ,
        @sCaseNbr AS NVARCHAR(10) ,
        @WhereClause AS NVARCHAR(500) ,
        @NoAccting AS NVARCHAR(100) ,
		@ExamineeReimb as NVARCHAR(100)
    SET NOCOUNT ON
    SET @sCaseNbr = CAST(@iCaseNbr AS VARCHAR(10))

    IF @blnNoAccting = 1
        BEGIN
            SET @NoAccting = ' and (CH.type is null or CH.type <> ''Acct'')  '
        END
    ELSE
        BEGIN
            SET @NoAccting = ''
        END
	IF @blnExamineeReimb = 1
        BEGIN
            SET @ExamineeReimb = ' and (CH.type is null or CH.type <> ''ExamineeReimb'')  '
        END
    ELSE
        BEGIN
            SET @ExamineeReimb = ''
        END
    IF @sIncludeExclude = ''  -- select everything
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr 
        END
    IF @sIncludeExclude = 'A'  -- include all records for this case
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr 
        END

    IF @sIncludeExclude = 'I'  -- only include certain types
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr + ' and (CH.type in (' + @stypes
                + '))' 
        END
    IF @sIncludeExclude = 'E'  -- only exclude certain types
        BEGIN
            SET @WhereClause = 'where CH.CaseNbr = '
                + @sCaseNbr
                + ' and (CH.type is null or CH.type not in ('
                + @sTypes + '))' 
        END
    SET @sSelectStmt = 'SELECT TOP 100 PERCENT CH.CaseNbr, CH.EventDate, CH.EventDesc, CH.UserID, CH.Highlight, '
        + 'CH.otherinfo, CH.type, CH.status, '
        + 'CASE WHEN CH.type = ''StatChg'' THEN cast(isnull(CH.duration / 24, DATEDIFF(day, C.laststatuschg, '
        + 'GETDATE())) AS decimal(6, 1)) END AS IQ, CH.ID, C.LastStatusChg, CH.Duration, '
        + 'CH.PublishOnWeb, CH.PublishedTo, CH.UserIDEdited '
        + 'FROM tblCaseHistory AS CH INNER JOIN tblCase AS C ON CH.CaseNbr = C.CaseNbr '
        + @WhereClause + @NoAccting + @ExamineeReimb 
        + ' ORDER BY CH.EventDate ' + @sSort 

--print @sselectstmt
    EXEC Sp_executesql @sSelectStmt
GO
PRINT N'Altering [dbo].[spCaseReports]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [dbo].[spCaseReports] ( @casenbr integer )
AS 
    SELECT TOP 100 PERCENT
            casenbr,
            document,
            type,
            description,
            sfilename,
            dateadded,
            useridadded,
            reporttype,
            PublishOnWeb,
            dateedited,
            useridedited,
            seqno,
            PublishedTo,
            Source,
            FileSize,
            Pages,
			FolderID,
			SubFolder
    FROM    dbo.tblCaseDocuments
    WHERE   ( casenbr = @casenbr )
            AND ( type = 'Report' )
    ORDER BY dateadded DESC
GO
PRINT N'Creating [dbo].[web_GetCaseDocumentPath]...';


GO
CREATE PROCEDURE [dbo].[web_GetCaseDocumentPath]
 @CaseNbr int,
 @DocType varchar(25) 
AS

BEGIN

	select * from [fnGetCaseDocumentPath](@CaseNbr, @DocType)

END
GO


UPDATE tblDoctor SET DrMedRecsInDays = 0
GO

insert into tbluserfunction 
values ('ExamineeReimbursement', 'Accounting - Examinee Reimbursement')
Go

INSERT INTO tblUserFunction
VALUES ('CompanySetWebNotification', 'Company - Set Web Notification' );
GO

UPDATE tblControl SET DBVersion='2.74'
GO
