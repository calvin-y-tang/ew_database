

GO

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
    ADD [NotarySent] BIT CONSTRAINT [DF_tblCase_NotarySent] DEFAULT ((0)) NOT NULL;


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
PRINT N'Altering [dbo].[tblCaseHistory]...';


GO
ALTER TABLE [dbo].[tblCaseHistory]
    ADD [ExceptionAlert] BIT CONSTRAINT [DF_tblCaseHistory_ExceptionAlert] DEFAULT ((0)) NOT NULL;


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
PRINT N'Altering [dbo].[tblExceptionDefinition]...';


GO
ALTER TABLE [dbo].[tblExceptionDefinition]
    ADD [CreateCHAlert] BIT            CONSTRAINT [DF_tblExceptionDefinition_CreateCHAlert] DEFAULT ((0)) NOT NULL,
        [CHEventDesc]   VARCHAR (50)   NULL,
        [CHOtherInfo]   VARCHAR (3000) NULL;


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
PRINT N'Altering [dbo].[tblReferralAssignmentRule]...';


GO
ALTER TABLE [dbo].[tblReferralAssignmentRule]
    ADD [ServiceCode] INT NULL;


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
PRINT N'Altering [dbo].[vwCertifiedMailCases]...';


GO
ALTER VIEW [dbo].[vwCertifiedMailCases]
AS 
	SELECT 
			MAX(IIF(CaseEnv.AddressedToEntity='EE', CaseEnv.CaseEnvelopeID, 0)) AS EECaseEnvelopeID,
			MAX(IIF(CaseEnv.AddressedToEntity='AT', CaseEnv.CaseEnvelopeID, 0)) AS ATCaseEnvelopeID, 
			CaseEnv.CaseNbr AS CaseNbr, 
			tblCase.CertMailNbr AS ExamineeCertMailNbr, 
			tblCase.CertMailNbr2 AS AttorneyCertMailNbr,
			CaseEnv.DateAcknowledged AS DateAcknowledged, 
			-- columns needed for dynamic WHERE clause that is created in client code
			tblCase.OfficeCode AS OfficeCode, 
			tblCase.CaseType AS CaseType, 
			tblCompany.CompanyCode AS CompanyCode,
			tblCase.DoctorCode AS DoctorCode,
			tblCase.DoctorLocation AS DoctorLocation,
			tblCase.MarketerCode AS MarketerCode, 
			tblCompany.ParentCompanyID AS ParentCompanyID, 
			tblCase.QARep AS QARep,
			tblCase.SchedulerCode AS SchedulerCode, 
			tblCase.ServiceCode AS ServiceCode,
			CaseEnv.DateImported
	  FROM tblCaseEnvelope AS CaseEnv
				LEFT OUTER JOIN tblCase ON tblCase.CaseNbr = CaseEnv.CaseNbr 
				LEFT OUTER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
				LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
	WHERE CaseEnv.IsCertifiedMail = 1 AND CaseEnv.DateImported IS NOT NULL  AND ([AddressedToEntity] = 'EE' OR [AddressedToEntity] = 'AT')
	GROUP BY CaseEnv.CaseNbr, tblCase.CertMailNbr, tblCase.CertMailNbr2, CaseEnv.DateAcknowledged, 
		tblCase.OfficeCode, tblCase.CaseType, tblCompany.CompanyCode, tblCase.DoctorCode, 
		tblCase.DoctorLocation, tblCase.MarketerCode, tblCompany.ParentCompanyID, tblCase.QARep, 
		tblCase.SchedulerCode, tblCase.ServiceCode, CaseEnv.DateImported
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
PRINT N'Altering [dbo].[vwFileManagerAttachedDocument]...';


GO

ALTER VIEW [dbo].[vwFileManagerAttachedDocument]
AS
SELECT C.CaseNbr,
       C.ExtCaseNbr,
       C.ClaimNbr,
       CO.IntName AS CompanyName,
       ISNULL(EE.FirstName, '') + ' ' + ISNULL(EE.LastName, '') AS ExamineeName,
       --ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
	   CASE WHEN ISNULL(DR.LastName,'') <> '' THEN DR.LastName + ', ' + ISNULL(DR.FirstName, '') ELSE '' END AS DoctorName,
       C.ApptDate,
	   SE.[Description] AS ServiceDesc,
       C.DoctorLocation,
	   LO.Location,
       C.ClientCode,
       C.Status,
       C.DoctorCode,
       CL.CompanyCode,
       C.OfficeCode,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
	   C.CaseType,
	   C.ServiceCode,
	   CD.Description AS DocDescrip,
	   CD.UserIDAdded,
	   CD.DateAdded AS DateAttached,
	   CD.Source,
	   ISNULL(BillCompany.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   Q.StatusDesc,
	   CDT.Description AS DocType
 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 INNER JOIN tblServices AS SE ON SE.ServiceCode = C.ServiceCode
 INNER JOIN tblCaseDocuments AS CD ON CD.CaseNbr = C.CaseNbr
 INNER JOIN tblCaseDocType AS CDT On CDT.CaseDocTypeID = CD.CaseDocTypeID
 INNER JOIN tblQueues AS Q ON Q.StatusCode=C.Status
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = C.DoctorCode
 LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
 LEFT OUTER JOIN tblLocation AS LO ON LO.LocationCode = C.DoctorLocation
 WHERE CD.Source='FileMgr'
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
PRINT N'Altering [dbo].[vwNotaryApproval]...';


GO
ALTER VIEW [dbo].[vwNotaryApproval]
AS
SELECT C.CaseNbr,
       C.ExtCaseNbr,
       C.ClaimNbr,
       CO.IntName AS CompanyName,
       ISNULL(EE.FirstName, '') + ' ' + ISNULL(EE.LastName, '') AS ExamineeName,
       ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       C.ApptDate,
	   SE.[Description] AS ServiceDesc,
       DATEDIFF(DAY, C.NotaryRequiredCheckedDate, GETDATE()) AS DaysInQueue, -- IQ  days in queue
       C.DoctorLocation,
	   LO.Location,
       C.ClientCode,
       C.Status,
       C.DoctorCode,
       CL.CompanyCode,
       C.OfficeCode,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
	   C.CaseType,
	   C.ServiceCode ,
	   ISNULL(BillCompany.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   C.NotaryRequired,
	   CASE WHEN C.NotarySent = 1 THEN 'Y' ELSE 'N' END AS NotarySent,
	   C.NotaryRequiredCheckedDate
 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 INNER JOIN tblServices AS SE ON SE.ServiceCode = C.ServiceCode
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = C.DoctorCode
 LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
 LEFT OUTER JOIN tblLocation AS LO ON LO.LocationCode = C.DoctorLocation
 WHERE C.NotaryRequired = 1
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
