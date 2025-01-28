SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping [dbo].[proc_tblUserAnnouncementUpdate]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblUserAnnouncementUpdate]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblUserAnnouncementUpdate]
GO
PRINT N'Dropping [dbo].[proc_tblUserAnnouncementInsert]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblUserAnnouncementInsert]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblUserAnnouncementInsert]
GO
PRINT N'Dropping [dbo].[proc_tblUserAnnouncementDelete]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblUserAnnouncementDelete]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblUserAnnouncementDelete]
GO
PRINT N'Dropping [dbo].[proc_tblUploadDocumentsInsert]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblUploadDocumentsInsert]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblUploadDocumentsInsert]
GO
PRINT N'Dropping [dbo].[proc_tblDistributionListUpdate]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblDistributionListUpdate]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblDistributionListUpdate]
GO
PRINT N'Dropping [dbo].[proc_tblDistributionListInsert]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblDistributionListInsert]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblDistributionListInsert]
GO
PRINT N'Dropping [dbo].[proc_tblDistributionListDelete]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblDistributionListDelete]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblDistributionListDelete]
GO
PRINT N'Dropping [dbo].[proc_tblCaseNotesInsert]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblCaseNotesInsert]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblCaseNotesInsert]
GO
PRINT N'Dropping [dbo].[proc_tblAnnouncementUpdate]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblAnnouncementUpdate]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblAnnouncementUpdate]
GO
PRINT N'Dropping [dbo].[proc_tblAnnouncementInsert]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblAnnouncementInsert]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblAnnouncementInsert]
GO
PRINT N'Dropping [dbo].[proc_tblAnnouncementDelete]'
GO
IF OBJECT_ID(N'[dbo].[proc_tblAnnouncementDelete]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_tblAnnouncementDelete]
GO
PRINT N'Dropping [dbo].[proc_EWWebUser_Update]'
GO
IF OBJECT_ID(N'[dbo].[proc_EWWebUser_Update]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_EWWebUser_Update]
GO
PRINT N'Dropping [dbo].[proc_Announcement_Update]'
GO
IF OBJECT_ID(N'[dbo].[proc_Announcement_Update]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_Announcement_Update]
GO
PRINT N'Dropping [dbo].[proc_Announcement_LoadByPrimaryKey]'
GO
IF OBJECT_ID(N'[dbo].[proc_Announcement_LoadByPrimaryKey]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_Announcement_LoadByPrimaryKey]
GO
PRINT N'Dropping [dbo].[proc_Announcement_LoadAll]'
GO
IF OBJECT_ID(N'[dbo].[proc_Announcement_LoadAll]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_Announcement_LoadAll]
GO
PRINT N'Dropping [dbo].[proc_Announcement_Insert]'
GO
IF OBJECT_ID(N'[dbo].[proc_Announcement_Insert]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_Announcement_Insert]
GO
PRINT N'Dropping [dbo].[proc_Announcement_Delete]'
GO
IF OBJECT_ID(N'[dbo].[proc_Announcement_Delete]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_Announcement_Delete]
GO




PRINT N'Dropping constraints from [dbo].[tblDoctorSchedule]'
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PK_tblDoctorSchedule]', 'PK') AND parent_object_id = OBJECT_ID(N'[dbo].[tblDoctorSchedule]', 'U'))
ALTER TABLE [dbo].[tblDoctorSchedule] DROP CONSTRAINT [PK_tblDoctorSchedule]
GO
PRINT N'Altering [dbo].[tblCompany]'
GO
IF COL_LENGTH(N'[dbo].[tblCompany]', N'CreateCvrLtr') IS NULL
ALTER TABLE [dbo].[tblCompany] ADD[CreateCvrLtr] [bit] NOT NULL CONSTRAINT [DF_tblCompany_CreateCvrLtr] DEFAULT ((0))
IF COL_LENGTH(N'[dbo].[tblCompany]', N'SpecialReqNotes') IS NULL
ALTER TABLE [dbo].[tblCompany] ADD[SpecialReqNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
PRINT N'Altering [dbo].[tblClient]'
GO
IF COL_LENGTH(N'[dbo].[tblClient]', N'CreateCvrLtr') IS NULL
ALTER TABLE [dbo].[tblClient] ADD[CreateCvrLtr] [bit] NOT NULL CONSTRAINT [DF_tblClient_CreateCvrLtr] DEFAULT ((0))
IF COL_LENGTH(N'[dbo].[tblClient]', N'SpecialReqNotes') IS NULL
ALTER TABLE [dbo].[tblClient] ADD[SpecialReqNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
PRINT N'Altering [dbo].[tblCase]'
GO
IF COL_LENGTH(N'[dbo].[tblCase]', N'CreateCvrLtr') IS NULL
ALTER TABLE [dbo].[tblCase] ADD[CreateCvrLtr] [bit] NOT NULL CONSTRAINT [DF_tblCase_CreateCvrLtr] DEFAULT ((0))
GO
PRINT N'Altering [dbo].[tblDoctor]'
GO
IF COL_LENGTH(N'[dbo].[tblDoctor]', N'QANotes') IS NULL
ALTER TABLE [dbo].[tblDoctor] ADD[QANotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
IF COL_LENGTH(N'[dbo].[tblDoctor]', N'MedRecordReqNotes') IS NULL
ALTER TABLE [dbo].[tblDoctor] ADD[MedRecordReqNotes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
IF COL_LENGTH(N'[dbo].[tblDoctor]', N'DrAcctingNote') IS NULL
ALTER TABLE [dbo].[tblDoctor] ADD[DrAcctingNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
PRINT N'Creating [dbo].[tblExceptionDefOffice]'
GO
IF OBJECT_ID(N'[dbo].[tblExceptionDefOffice]', 'U') IS NULL
CREATE TABLE [dbo].[tblExceptionDefOffice]
(
[ExceptionDefID] [int] NOT NULL,
[OfficeCode] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_tblExceptionDefOffice] on [dbo].[tblExceptionDefOffice]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_tblExceptionDefOffice' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefOffice]'))
ALTER TABLE [dbo].[tblExceptionDefOffice] ADD CONSTRAINT [PK_tblExceptionDefOffice] PRIMARY KEY CLUSTERED  ([ExceptionDefID], [OfficeCode])
GO
PRINT N'Creating [dbo].[tblExceptionDefEntity]'
GO
IF OBJECT_ID(N'[dbo].[tblExceptionDefEntity]', 'U') IS NULL
CREATE TABLE [dbo].[tblExceptionDefEntity]
(
[ExceptionDefID] [int] NOT NULL,
[IMECentricCode] [int] NOT NULL
)
GO
PRINT N'Creating primary key [PK_tblExceptionDefEntity] on [dbo].[tblExceptionDefEntity]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_tblExceptionDefEntity' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefEntity]'))
ALTER TABLE [dbo].[tblExceptionDefEntity] ADD CONSTRAINT [PK_tblExceptionDefEntity] PRIMARY KEY CLUSTERED  ([ExceptionDefID], [IMECentricCode])
GO
PRINT N'Creating [dbo].[tblCompanyCPTCode]'
GO
IF OBJECT_ID(N'[dbo].[tblCompanyCPTCode]', 'U') IS NULL
CREATE TABLE [dbo].[tblCompanyCPTCode]
(
[CompanyCode] [int] NOT NULL,
[ProdCode] [int] NOT NULL,
[CPTCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPTCodeNoShow] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPTCodeCancel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
PRINT N'Creating primary key [PK_tblCompanyCPTCode] on [dbo].[tblCompanyCPTCode]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_tblCompanyCPTCode' AND object_id = OBJECT_ID(N'[dbo].[tblCompanyCPTCode]'))
ALTER TABLE [dbo].[tblCompanyCPTCode] ADD CONSTRAINT [PK_tblCompanyCPTCode] PRIMARY KEY CLUSTERED  ([CompanyCode], [ProdCode])
GO
PRINT N'Creating [dbo].[tblProductCPTCode]'
GO
IF OBJECT_ID(N'[dbo].[tblProductCPTCode]', 'U') IS NULL
CREATE TABLE [dbo].[tblProductCPTCode]
(
[ProdCode] [int] NOT NULL,
[StateCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CPTCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPTCodeNoShow] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CPTCodeCancel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
PRINT N'Creating primary key [PK_tblProductCPTCode] on [dbo].[tblProductCPTCode]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_tblProductCPTCode' AND object_id = OBJECT_ID(N'[dbo].[tblProductCPTCode]'))
ALTER TABLE [dbo].[tblProductCPTCode] ADD CONSTRAINT [PK_tblProductCPTCode] PRIMARY KEY CLUSTERED  ([ProdCode], [StateCode])
GO
PRINT N'Creating primary key [PK_tblDoctorSchedule] on [dbo].[tblDoctorSchedule]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'PK_tblDoctorSchedule' AND object_id = OBJECT_ID(N'[dbo].[tblDoctorSchedule]'))
ALTER TABLE [dbo].[tblDoctorSchedule] ADD CONSTRAINT [PK_tblDoctorSchedule] PRIMARY KEY CLUSTERED  ([SchedCode])
GO





PRINT N'Dropping constraints from [dbo].[tblExceptionDefinition]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'DisplayMessage' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_DisplayMessage]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] DROP CONSTRAINT [DF_tblExceptionDefinition_DisplayMessage]
GO
PRINT N'Dropping constraints from [dbo].[tblExceptionDefinition]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'RequireComment' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_RequireComment]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] DROP CONSTRAINT [DF_tblExceptionDefinition_RequireComment]
GO
PRINT N'Dropping constraints from [dbo].[tblExceptionDefinition]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EmailMessage' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EmailMessage]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] DROP CONSTRAINT [DF_tblExceptionDefinition_EmailMessage]
GO
PRINT N'Dropping constraints from [dbo].[tblExceptionDefinition]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EditEmail' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EditEmail]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] DROP CONSTRAINT [DF_tblExceptionDefinition_EditEmail]
GO
PRINT N'Dropping constraints from [dbo].[tblExceptionDefinition]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'GenerateDocument' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_GenerateDocument]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] DROP CONSTRAINT [DF_tblExceptionDefinition_GenerateDocument]
GO
PRINT N'Dropping constraints from [dbo].[tblExceptionDefinition]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EmailScheduler' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EmailScheduler]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] DROP CONSTRAINT [DF_tblExceptionDefinition_EmailScheduler]
GO
PRINT N'Dropping constraints from [dbo].[tblExceptionDefinition]'
GO
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EmailQA' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EmailQA]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] DROP CONSTRAINT [DF_tblExceptionDefinition_EmailQA]
GO
PRINT N'Dropping [dbo].[vwClientDefaults]'
GO
IF OBJECT_ID(N'[dbo].[vwClientDefaults]', 'V') IS NOT NULL
DROP VIEW [dbo].[vwClientDefaults]
GO
PRINT N'Dropping [dbo].[vwAcctingSummary]'
GO
IF OBJECT_ID(N'[dbo].[vwAcctingSummary]', 'V') IS NOT NULL
DROP VIEW [dbo].[vwAcctingSummary]
GO
PRINT N'Dropping [dbo].[vwExportSummary]'
GO
IF OBJECT_ID(N'[dbo].[vwExportSummary]', 'V') IS NOT NULL
DROP VIEW [dbo].[vwExportSummary]
GO
PRINT N'Dropping [dbo].[proc_IMEException]'
GO
IF OBJECT_ID(N'[dbo].[proc_IMEException]', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[proc_IMEException]
GO
PRINT N'Creating [dbo].[vwClientDefaults]'
GO
IF OBJECT_ID(N'[dbo].[vwClientDefaults]', 'V') IS NULL
EXEC sp_executesql N'CREATE VIEW [dbo].[vwClientDefaults]
AS
    SELECT  tblClient.marketercode AS clientmarketer ,
            dbo.tblCompany.intname ,
			ISNULL(dbo.tblCompany.EWCompanyID, 0) AS EWCompanyID, 
            dbo.tblClient.reportphone ,
            dbo.tblClient.priority ,
            dbo.tblClient.clientcode ,
            dbo.tblClient.fax ,
            dbo.tblClient.email ,
            dbo.tblClient.phone1 ,
            dbo.tblClient.documentemail AS emailclient ,
            dbo.tblClient.documentfax AS faxclient ,
            dbo.tblClient.documentmail AS mailclient ,
            ISNULL(dbo.tblClient.casetype, tblCompany.CaseType) AS CaseType ,
            dbo.tblClient.feeschedule ,
            dbo.tblCompany.credithold ,
            dbo.tblCompany.preinvoice ,
            dbo.tblClient.billaddr1 ,
            dbo.tblClient.billaddr2 ,
            dbo.tblClient.billcity ,
            dbo.tblClient.billstate ,
            dbo.tblClient.billzip ,
            dbo.tblClient.billattn ,
            dbo.tblClient.ARKey ,
            dbo.tblClient.addr1 ,
            dbo.tblClient.addr2 ,
            dbo.tblClient.city ,
            dbo.tblClient.state ,
            dbo.tblClient.zip ,
            dbo.tblClient.firstname + '' '' + dbo.tblClient.lastname AS clientname ,
            dbo.tblClient.prefix AS clientprefix ,
            dbo.tblClient.suffix AS clientsuffix ,
            dbo.tblClient.lastname ,
            dbo.tblClient.firstname ,
            dbo.tblClient.billfax ,
            dbo.tblClient.QARep ,
            ISNULL(dbo.tblClient.photoRqd, tblCompany.photoRqd) AS photoRqd ,
            dbo.tblClient.CertifiedMail ,
            dbo.tblClient.PublishOnWeb ,
            dbo.tblClient.UseNotificationOverrides ,
            dbo.tblClient.CSR1 ,
            dbo.tblClient.CSR2 ,
            dbo.tblClient.AutoReschedule ,
            dbo.tblClient.DefOfficeCode ,
            ISNULL(dbo.tblClient.marketercode, tblCompany.marketercode) AS marketer ,
            dbo.tblCompany.Jurisdiction ,
			      dbo.tblClient.CreateCvrLtr|dbo.tblCompany.CreateCvrLtr As CreateCvrLtr
    FROM    dbo.tblClient
            INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode


'
GO
PRINT N'Creating [dbo].[vwAcctingSummary]'
GO
IF OBJECT_ID(N'[dbo].[vwAcctingSummary]', 'V') IS NULL
EXEC sp_executesql N'CREATE VIEW [dbo].[vwAcctingSummary]
AS
    SELECT 
            AT.SeqNO ,
            AT.StatusCode ,
            AT.Type ,
            AT.DrOpType ,
            AT.ApptStatusID ,
            AT.CaseApptID ,
            --DateDIFF(day, AT.lastStatusChg, GETDate()) AS IQ ,

            AT.ApptTime ,
            ISNULL(AT.ApptDate, C.ApptDate) AS ApptDate ,

			AH.HeaderID ,
            AH.DocumentNbr ,
            AH.DocumentDate ,
			AH.DocumentTotal AS DocumentAmount ,
			AH.DocumentStatus ,

            C.CaseNbr ,
			C.ClaimNbr ,
            C.ClientCode ,
			--C.PanelNbr ,
            C.OfficeCode ,
            C.Notes ,
            --C.QARep ,
            --C.LastStatusChg ,
            C.BillingNote ,
   --         C.CaseType,
			--C.Status AS CaseStatusCode ,
   --         C.Priority ,
   --         C.MasterSubCase ,

            --C.MarketerCode ,
            --C.SchedulerCode ,
            --C.RequestedDoc ,
            --C.InvoiceDate ,
            --C.InvoiceAmt ,
            --C.DateDrChart ,
            --C.TransReceived ,
            C.ServiceCode ,
            --C.ShownoShow ,
            --C.TransCode ,
            --C.rptStatus ,

            --C.DateAdded ,
            --C.DateEdited ,
            --C.UserIDEdited ,
            --C.UserIDAdded ,

            EE.lastName + '', '' + EE.firstName AS examineeName ,
            COM.intName AS CompanyName ,
            CL.lastName + '', '' + CL.firstName AS ClientName ,

            Case ISNULL(C.panelNbr, 0)
              WHEN 0
              THEN Case AT.DrOpType
                     WHEN ''OP'' THEN ATDr.CompanyName
                     ELSE ISNULL(ATDr.lastName, '''') + '', ''
                          + ISNULL(ATDr.firstName, '''')
                   END
              ELSE Case AT.DrOpType
                     WHEN ''OP'' THEN ATDr.CompanyName
                     ELSE ISNULL(C.DoctorName, '''')
                   END
            END AS DoctorName ,
            Case AT.DrOpType
                WHEN ''OP'' THEN ATDr.CompanyName
				ELSE ISNULL(ATDr.lastName, '''') + '', ''
                     + ISNULL(ATDr.firstName, '''')
            END AS DrOpName ,


            COM.CompanyCode ,
            COM.Notes AS CompanyNotes ,
            BCOM.CompanyCode AS BillCompanyCode ,
            CL.Email AS adjusterEmail ,
            CL.Fax AS adjusterFax ,
            CL.Notes AS ClientNotes ,
            ATDr.DoctorCode ,
            ATDr.CompanyName AS otherPartyName ,
            ATDr.Notes AS DoctorNotes ,
			      ATDr.DrAcctingNote , 
            ISNULL(ATL.LocationCode, CaseL.LocationCode) AS DoctorLocation ,
            ISNULL(ATL.Location, CaseL.Location) AS Location ,

   --         ATQ.StatusDesc ,
			--CaseQ.StatusDesc AS CaseStatusDesc ,
            CT.Description AS CaseTypeDesc ,
            S.Description AS ServiceDesc ,
            --tblApptStatus.Name AS Result ,


            --AT.blnSelect AS billedSelect ,
            --C.ApptSelect ,
            --C.drchartSelect ,
            --C.inqaSelect ,
            --C.inTransSelect ,
            --C.awaitTransSelect ,
            --C.chartprepSelect ,
            --C.ApptrptsSelect ,
            --C.miscSelect ,
            --C.voucherSelect
			0 AS LastCol
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
            LEFT OUTER JOIN tblLocation AS CaseL ON C.DoctorLocation = CaseL.LocationCode
            LEFT OUTER JOIN tblLocation ATL ON AT.DoctorLocation = ATL.LocationCode
            LEFT OUTER JOIN tblDoctor AS ATDr ON AT.DrOpCode = ATDr.DoctorCode
            LEFT OUTER JOIN tblExaminee AS EE ON C.chartNbr = EE.chartNbr
            LEFT OUTER JOIN tblApptStatus ON AT.ApptStatusID = tblApptStatus.ApptStatusID
    WHERE   ( AT.StatusCode <> 20 )
'
GO
PRINT N'Creating [dbo].[vwExportSummary]'
GO
IF OBJECT_ID(N'[dbo].[vwExportSummary]', 'V') IS NULL
EXEC sp_executesql N'CREATE VIEW [dbo].[vwExportSummary]
AS
	SELECT  tblCase.casenbr ,
			TblAcctHeader.documenttype ,
			TblAcctHeader.HeaderID , 
			tblAcctHeader.RelatedInvHeaderID ,
			TblAcctHeader.documentnbr ,
			tblacctingtrans.statuscode ,
			TblAcctHeader.HCAIBranchID ,
			TblAcctHeader.HCAIInsurerID ,
			TblAcctHeader.Message ,
			tblQueues.statusdesc ,
			tblExaminee.lastname + '', '' + tblExaminee.firstname AS examineename ,
			tblacctingtrans.DrOpType ,
			CASE ISNULL(tblcase.panelnbr, 0)
			  WHEN 0
			  THEN CASE tblacctingtrans.droptype
					 WHEN ''DR''
					 THEN ISNULL(tbldoctor.lastname, '''') + '', ''
						  + ISNULL(tbldoctor.firstname, '''')
					 WHEN ''''
					 THEN ISNULL(tbldoctor.lastname, '''') + '', ''
						  + ISNULL(tbldoctor.firstname, '''')
					 WHEN '''' THEN ISNULL(tblcase.doctorname, '''')
					 WHEN ''OP'' THEN tbldoctor.companyname
				   END
			  ELSE CASE tblacctingtrans.droptype
					 WHEN ''DR'' THEN ISNULL(tblcase.doctorname, '''')
					 WHEN '''' THEN ISNULL(tblcase.doctorname, '''')
					 WHEN ''OP'' THEN tbldoctor.companyname
				   END
			END AS doctorname ,
			tblClient.lastname + '', '' + tblClient.firstname AS clientname ,
			tblCompany.intname AS companyname ,
			tblCase.priority ,
			tblCase.ApptDate ,
			tblCase.dateadded ,
			tblCase.claimnbr ,
			tblCase.doctorlocation ,
			tblCase.Appttime ,
			tblCase.dateedited ,
			tblCase.useridedited ,
			tblcase.schedulenotes ,
			tblClient.email AS adjusteremail ,
			tblClient.fax AS adjusterfax ,
			tblCase.marketercode ,
			tblCase.useridadded ,
			TblAcctHeader.documentdate ,
			TblAcctHeader.INBatchSelect ,
			TblAcctHeader.VOBatchSelect ,
			TblAcctHeader.taxcode ,
			TblAcctHeader.taxtotal ,
			TblAcctHeader.documenttotal ,
			TblAcctHeader.documentstatus ,
			tblCase.clientcode ,
			tblCase.doctorcode ,
			TblAcctHeader.batchnbr ,
			tblCase.officecode ,
			tblCase.schedulercode ,
			tblClient.companycode ,
			tblCase.QARep ,
			tblCase.PanelNbr ,
			DATEDIFF(day, tblacctingtrans.laststatuschg, GETDATE()) AS IQ ,
			tblCase.mastersubcase ,
			tblqueues_1.statusdesc AS CaseStatus ,
			tblacctingtrans.SeqNO
	FROM    tblCase
			INNER JOIN tblacctingtrans ON tblCase.casenbr = tblacctingtrans.casenbr
			INNER JOIN tblQueues ON tblacctingtrans.statuscode = tblQueues.statuscode
			INNER JOIN tblQueues tblqueues_1 ON tblcase.status = tblQueues_1.statuscode
			INNER JOIN TblAcctHeader ON tblAcctHeader.SeqNo = tblAcctingTrans.SeqNO
			LEFT OUTER JOIN tblDoctor ON tblacctingtrans.DrOpCode = tblDoctor.doctorcode
			LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
			LEFT OUTER JOIN tblCompany
			INNER JOIN tblClient ON tblCompany.companycode = tblClient.companycode ON tblCase.clientcode = tblClient.clientcode
	WHERE   ( tblacctingtrans.statuscode <> 20 )
			AND ( TblAcctHeader.batchnbr IS NULL )
			AND ( TblAcctHeader.documentstatus = ''Final'' )
'
GO
PRINT N'Altering [dbo].[tblExceptionDefinition]'
GO
IF COL_LENGTH(N'[dbo].[tblExceptionDefinition]', N'AllOffice') IS NULL
ALTER TABLE [dbo].[tblExceptionDefinition] ADD[AllOffice] [bit] NOT NULL CONSTRAINT [DF_tblExceptionDefinition_AllOffice] DEFAULT ((0))
GO
UPDATE [dbo].[tblExceptionDefinition] SET [DisplayMessage]=((0)) WHERE [DisplayMessage] IS NULL
UPDATE [dbo].[tblExceptionDefinition] SET [RequireComment]=((0)) WHERE [RequireComment] IS NULL
UPDATE [dbo].[tblExceptionDefinition] SET [EmailMessage]=((0)) WHERE [EmailMessage] IS NULL
UPDATE [dbo].[tblExceptionDefinition] SET [EditEmail]=((0)) WHERE [EditEmail] IS NULL
UPDATE [dbo].[tblExceptionDefinition] SET [GenerateDocument]=((0)) WHERE [GenerateDocument] IS NULL
UPDATE [dbo].[tblExceptionDefinition] SET [EmailScheduler]=((0)) WHERE [EmailScheduler] IS NULL
UPDATE [dbo].[tblExceptionDefinition] SET [EmailQA]=((0)) WHERE [EmailQA] IS NULL
UPDATE [dbo].[tblExceptionDefinition] SET [UseBillingEntity]=((0)) WHERE [UseBillingEntity] IS NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [IMECentricCode] [int] NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [DisplayMessage] [bit] NOT NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [RequireComment] [bit] NOT NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [EmailMessage] [bit] NOT NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [EditEmail] [bit] NOT NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [GenerateDocument] [bit] NOT NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [EmailScheduler] [bit] NOT NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [EmailQA] [bit] NOT NULL
GO
ALTER TABLE [dbo].[tblExceptionDefinition] ALTER COLUMN [UseBillingEntity] [bit] NOT NULL
GO
PRINT N'Creating [dbo].[proc_IMEException]'
GO
IF OBJECT_ID(N'[dbo].[proc_IMEException]', 'P') IS NULL
EXEC sp_executesql N'CREATE PROCEDURE [dbo].[proc_IMEException]
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
    WHERE   ED.Status = ''Active'' AND ED.ExceptionID = @ExceptionID
			AND
			( ED.Entity = ''CS''
                OR ( ED.Entity = ''PC''
                    AND ( CO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                        )
                    OR ( BCO.ParentCompanyID IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = ''CO''
                    AND ( CL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                        )
                    OR ( BCL.CompanyCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = ''CL''
                    AND ( CL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                            AND ISNULL(ED.UseBillingEntity, 0) = 0
                        )
                    OR ( BCL.ClientCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID)
                        AND ISNULL(ED.UseBillingEntity, 0) = 1
                        )
                    )
                OR ( ED.Entity = ''DR''
                    AND ( C.DoctorCode IN (SELECT IMECentricCode FROM tblExceptionDefEntity WHERE ExceptionDefID=ED.ExceptionDefID) )
                    )
                OR ( ED.Entity = ''AT''
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
END;'
GO
PRINT N'Adding constraints to [dbo].[tblExceptionDefinition]'
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'DisplayMessage' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_DisplayMessage]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_DisplayMessage] DEFAULT ((0)) FOR [DisplayMessage]
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'RequireComment' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_RequireComment]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_RequireComment] DEFAULT ((0)) FOR [RequireComment]
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EmailMessage' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EmailMessage]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_EmailMessage] DEFAULT ((0)) FOR [EmailMessage]
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EditEmail' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EditEmail]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_EditEmail] DEFAULT ((0)) FOR [EditEmail]
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'GenerateDocument' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_GenerateDocument]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_GenerateDocument] DEFAULT ((0)) FOR [GenerateDocument]
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EmailScheduler' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EmailScheduler]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_EmailScheduler] DEFAULT ((0)) FOR [EmailScheduler]
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'EmailQA' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_EmailQA]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_EmailQA] DEFAULT ((0)) FOR [EmailQA]
GO
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = N'UseBillingEntity' AND object_id = OBJECT_ID(N'[dbo].[tblExceptionDefinition]', 'U') AND default_object_id = OBJECT_ID(N'[dbo].[DF_tblExceptionDefinition_UseBillingEntity]', 'D'))
ALTER TABLE [dbo].[tblExceptionDefinition] ADD CONSTRAINT [DF_tblExceptionDefinition_UseBillingEntity] DEFAULT ((0)) FOR [UseBillingEntity]
GO




UPDATE tblCase SET CreateCvrLtr = 0
UPDATE tblClient SET CreateCvrLtr = 0
UPDATE tblCompany SET CreateCvrLtr = 0
GO


INSERT INTO tblExceptionDefOffice
        ( ExceptionDefID, OfficeCode )
SELECT DISTINCT ExceptionDefID, OfficeCode
 FROM tblExceptionDefinition
 INNER JOIN tblOffice ON 1=1
 ORDER BY ExceptionDefID, OfficeCode
GO

INSERT INTO tblExceptionDefEntity
        ( ExceptionDefID, IMECentricCode )
SELECT DISTINCT ExceptionDefID, IMECentricCode
 FROM tblExceptionDefinition
 WHERE ISNULL(IMECentricCode,-1)<>-1
GO

UPDATE tblExceptionDefinition SET IMECentricCode=NULL
UPDATE tblExceptionDefinition SET UseBillingEntity=ISNULL(UseBillingEntity,0) WHERE UseBillingEntity IS NULL
GO

UPDATE tblExceptionList SET Description='Case Cancellation with a Pre-Invoice Client' WHERE ExceptionID=2
UPDATE tblExceptionList SET Description='Case Cancellation with a Pre-Pay Doctor' WHERE ExceptionID=3
GO




UPDATE tblControl SET DBVersion='2.72'
GO