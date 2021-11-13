
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
PRINT N'Altering [dbo].[tblSLARuleDetail]...';


GO
ALTER TABLE [dbo].[tblSLARuleDetail]
    ADD [Network]       INT          NULL,
        [Amount]        MONEY        NULL,
        [Priority]      INT          NULL,
        [Responsiblity] VARCHAR (50) NULL,
        [NextAction]    VARCHAR (50) NULL;


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
PRINT N'Creating [dbo].[tblOfficeState]...';


GO
CREATE TABLE [dbo].[tblOfficeState] (
    [OfficeCode]  INT          NOT NULL,
    [State]       VARCHAR (2)  NOT NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    [DateAdded]   DATETIME     NULL,
    CONSTRAINT [PK_tblOfficeState] PRIMARY KEY CLUSTERED ([OfficeCode] ASC, [State] ASC)
);


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
            S.Description AS ServiceDesc, 
			C.ExtCaseNbr, 
			ISNULL(BCOM.ParentCompanyID, COM.ParentCompanyID) AS ParentCompanyID,
			ServType.Name As ServiceTypDesc,
			S.EWServiceTypeID
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
			LEFT OUTER JOIN tblEWServiceType AS ServType ON ServType.EWServiceTypeID = S.EWServiceTypeID
    WHERE   ( AT.StatusCode <> 20 )
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
PRINT N'Altering [dbo].[vwAcctMonitorDetail]...';


GO
ALTER VIEW vwAcctMonitorDetail
AS
    SELECT  AT.StatusCode ,
            IIF(C.Priority <> 'Normal', 1, 0) AS Rush ,
            IIF(ISNULL(C.Priority, 'Normal') = 'Normal', 1, 0) AS Normal ,
            C.MarketerCode ,
            C.DoctorLocation ,
            AT.DrOpCode AS DoctorCode ,
            C.CompanyCode ,
            C.OfficeCode ,
            C.SchedulerCode ,
            C.QARep ,
            C.ServiceCode ,
            C.CaseType ,
			Q.FunctionCode,
			Q.FormToOpen,
			Q.StatusDesc,
			Q.DisplayOrder,
			ISNULL(BillCompany.ParentCompanyID, Company.ParentCompanyID) AS ParentCompanyID,
			ST.EWServiceTypeID
    FROM    tblAcctingTrans AS AT
				INNER JOIN tblCase AS C ON AT.CaseNbr = C.CaseNbr
				INNER JOIN tblQueues AS Q ON Q.StatusCode = AT.StatusCode
				INNER JOIN tblCompany AS Company ON Company.CompanyCode = C.CompanyCode
				LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
				LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
				LEFT OUTER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
				LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = S.EWServiceTypeID
    WHERE   AT.StatusCode <> 20;
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
            C.CompanyCode ,
            C.OfficeCode ,
            C.QARep ,
			C.CaseType ,
			C.ServiceCode ,
			C.ReExam ,
			C.ReExamProcessed ,
			C.ReExamDate, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID,
			Serv.EWServiceTypeID,
			ServType.Name
    FROM    tblCase AS C
				INNER JOIN tblCompany ON tblCompany.CompanyCode = C.CompanyCode
				LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
				LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
				LEFT OUTER JOIN tblServices AS Serv ON Serv.ServiceCode = C.ServiceCode
				LEFT OUTER JOIN tblEWServiceType AS ServType ON ServType.EWServiceTypeID = Serv.EWServiceTypeID
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
		C.ExtCaseNbr , 

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
		CH.ID, 
		ISNULL(BillCompany.ParentCompanyID, COM.ParentCompanyID) AS ParentCompanyID,
		ST.Name As ServiceTypDesc,
		S.EWServiceTypeID
FROM    tblCase AS C
        INNER JOIN tblQueues AS Q ON C.Status = Q.StatusCode
        INNER JOIN tblServices AS S ON C.ServiceCode = S.ServiceCode
        INNER JOIN tblClient AS CL ON C.ClientCode = CL.ClientCode
        LEFT OUTER JOIN tblCompany AS COM ON COM.CompanyCode = CL.CompanyCode
        LEFT OUTER JOIN tblDoctor AS D ON C.DoctorCode = D.DoctorCode
        LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation = L.LocationCode
        LEFT OUTER JOIN tblExaminee AS EE ON C.ChartNbr = EE.ChartNbr
		LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
		LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
		LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = S.EWServiceTypeID
        INNER JOIN tblCaseHistory AS CH ON CH.CaseNbr = C.CaseNbr
WHERE   CH.FollowUpDate IS NOT NULL
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
PRINT N'Altering [dbo].[vwCaseMonitorDetail]...';


GO
ALTER VIEW vwCaseMonitorDetail
AS
    SELECT
		C.CaseNbr,
        C.Status AS StatusCode,
        IIF(C.Priority<>'Normal', 1, 0) AS Rush,
        IIF(ISNULL(C.Priority, 'Normal')='Normal', 1, 0) AS Normal,
        C.MarketerCode,
        C.DoctorLocation,
        C.DoctorCode,
        C.CompanyCode,
        C.OfficeCode,
        C.SchedulerCode,
        C.QARep,
        C.ServiceCode,
        C.CaseType,
		C.DateAdded,
		C.ApptDate,
        Q.FunctionCode,
        Q.FormToOpen,
        Q.StatusDesc,
        Q.DisplayOrder, 
		ISNULL(BillCompany.ParentCompanyID, Company.ParentCompanyID) AS ParentCompanyID,
		ST.Name As ServiceTypDesc,
		SE.EWServiceTypeID
    FROM
        tblCase AS C
			INNER JOIN tblQueues AS Q ON Q.StatusCode=C.Status
			INNER JOIN tblCompany AS Company ON Company.CompanyCode = C.CompanyCode
			LEFT OUTER JOIN tblServices AS SE ON C.ServiceCode = SE.ServiceCode
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = SE.EWServiceTypeID
    WHERE
        C.Status NOT IN (8, 9, -100)
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
            OP.CompanyName ,
            OP.OPSubType ,
            tblCase.SchedulerCode ,
            tblCase.CompanyCode ,
            tblCase.QARep ,
            tblCaseOtherParty.OPCode ,
            tblCase.PanelNbr ,
            tblCase.DoctorName ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID,
			ST.Name As ServiceTypDesc,
			tblServices.EWServiceTypeID
    FROM    tblCaseOtherParty
            INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblDoctor OP ON tblCaseOtherParty.OPCode = OP.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
			INNER JOIN tblCompany ON tblCompany.CompanyCode = tblCase.CompanyCode
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = tblServices.EWServiceTypeID
    WHERE   ( tblCaseOtherParty.Status = 'Open' );
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
            DATEDIFF(day, tblCase.DateEdited, GETDATE()) AS DSE ,
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
            tblLocation.Zip AS LocationZip , 
			tblCase.ExtCaseNbr, 
			tblCase.AwaitingScheduling,
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID, 
			tblCase.Jurisdiction, 
			CaseType.ShortDesc AS CaseTypeDesc,
			tblServices.EWServiceTypeID,
			tblEWServiceType.Name As ServiceTypDesc
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
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT OUTER JOIN tblCaseType AS CaseType ON CaseType.Code = tblCase.CaseType
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
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
PRINT N'Altering [dbo].[vwCaseWebReservedAppts]...';


GO
ALTER VIEW vwCaseWebReservedAppts
AS
    SELECT 
            tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + ', ' + tblClient.FirstName AS ClientName ,
            tblCompany.IntName AS CompanyName ,
            tblCase.MarketerCode ,
            tblCase.QARep ,
            tblCase.SchedulerCode ,
            tblCase.Priority ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr + ' ' + ISNULL(tblCase.ClaimNbrExt, '') AS ClaimNbr,
            tblLocation.Location ,
            tblCase.ApptSelect ,
            tblCase.ServiceCode ,
            tblQueues.StatusDesc ,
            tblCase.UserIDAdded ,
            tblServices.ShortDesc AS Service ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            DATEDIFF(day, tblCase.LastStatuschg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
			DBTS.StartTime,
            DBTD.ScheduleDate ,
            DBTD.DoctorCode ,
            DBTD.LocationCode AS doctorLocation,
            tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName, ' ') AS DoctorName ,
			ApptReq.CaseApptRequestStatusID,

            tblqueues.FunctionCode ,
            tblCase.Casetype ,
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID, 
			tblCase.Jurisdiction, 
			CaseType.ShortDesc AS CaseTypeDesc,
			tblEWServiceType.Name As ServiceTypDesc,
			tblServices.EWServiceTypeID
    FROM    tblCase
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
			INNER JOIN tblCaseApptRequest AS ApptReq ON tblCase.CaseNbr = ApptReq.CaseNbr
            LEFT JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
            LEFT JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
			LEFT JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT JOIN tblCaseType AS CaseType ON CaseType.Code = tblCase.CaseType
			LEFT JOIN tblDoctorBlockTimeSlot AS DBTS ON ApptReq.CaseApptRequestID = DBTS.CaseApptRequestID
			LEFT JOIN tblDoctorBlockTimeDay AS DBTD ON DBTS.DoctorBlockTimeDayID = DBTD.DoctorBlockTimeDayID
            LEFT JOIN tblLocation ON DBTD.LocationCode = tblLocation.LocationCode
            LEFT JOIN tblDoctor ON DBTD.DoctorCode = tblDoctor.DoctorCode
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
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
			CaseEnv.DateImported,
			tblServices.EWServiceTypeID
	  FROM tblCaseEnvelope AS CaseEnv
				LEFT OUTER JOIN tblCase ON tblCase.CaseNbr = CaseEnv.CaseNbr 
				LEFT OUTER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
				LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
				LEFT OUTER JOIN tblServices ON tblServices.ServiceCode = tblCase.ServiceCode
				LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
	WHERE CaseEnv.IsCertifiedMail = 1 AND CaseEnv.DateImported IS NOT NULL  AND ([AddressedToEntity] = 'EE' OR [AddressedToEntity] = 'AT')
	GROUP BY CaseEnv.CaseNbr, tblCase.CertMailNbr, tblCase.CertMailNbr2, CaseEnv.DateAcknowledged, 
		tblCase.OfficeCode, tblCase.CaseType, tblCompany.CompanyCode, tblCase.DoctorCode, 
		tblCase.DoctorLocation, tblCase.MarketerCode, tblCompany.ParentCompanyID, tblCase.QARep, 
		tblCase.SchedulerCode, tblCase.ServiceCode, CaseEnv.DateImported, tblServices.EWServiceTypeID
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
PRINT N'Altering [dbo].[vwEDIExportSummary]...';


GO
ALTER VIEW vwEDIExportSummary
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
            -- tblCompany.BulkBillingID ,
			ISNULL(tblAcctHeader.BulkBillingID, tblCompany.BulkBillingID) AS BulkBillingID,
            tblAcctHeader.EDISubmissionCount ,
            tblAcctHeader.EDISubmissionDateTime , 
			tblCase.ExtCaseNbr, 
			tblCompany.ParentCompanyID,
			tblEWServiceType.Name As ServiceTypDesc,
			tblServices.EWServiceTypeID
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
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
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
            tblAcctHeader.EDISubmissionDateTime , 
			tblCase.ExtCaseNbr, 
			tblCompany.ParentCompanyID,
			tblEWServiceType.Name As ServiceTypDesc,
			tblServices.EWServiceTypeID
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
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
    WHERE   ( tblAcctingTrans.StatusCode <> 20 )
            AND ( tblAcctHeader.BatchNbr IS NULL )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
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
	   C.ApptTime,
	   C.CaseApptID,
	   CD.SeqNo,
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
	   CDT.Description AS DocType,
	   ST.Name As ServiceTypDesc,
	   SE.EWServiceTypeID
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
 LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = SE.EWServiceTypeID
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
PRINT N'Altering [dbo].[vwMedicalRecordsDue]...';


GO

ALTER VIEW [dbo].[vwMedicalRecordsDue]
AS
SELECT C.CaseNbr,
       C.ExtCaseNbr,
       CO.IntName AS CompanyName,
       ISNULL(EE.LastName, '') + ', ' + ISNULL(EE.FirstName, '') AS ExamineeName,
	   CASE WHEN ISNULL(DR.LastName,'') <> '' THEN DR.LastName + ', ' + ISNULL(DR.FirstName, '') ELSE '' END AS DoctorName,
	   LO.Location,
       C.DoctorLocation,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
       C.ApptDate,
	   SE.[Description] AS ServiceDesc,
       C.ClientCode,
       C.Status,
       C.DoctorCode,
       CL.CompanyCode,
       C.OfficeCode,
	   C.CaseType,
	   C.ServiceCode,
	   C.ExternalDueDate,
	   C.DateMedsRecd,
	   C.DrMedRecsDueDate,
	   C.InternalDueDate,
	   C.DrChartSelect,
	   C.DateDrChart,
	   C.DateEdited,
       C.UserIDEdited,
	   C.LastStatusChg,
       DATEDIFF(DAY, GETDATE(), C.DrMedRecsDueDate) AS DaysTillDue,
       DATEDIFF(day, C.LastStatuschg, GETDATE()) AS IQ ,
       DATEDIFF(DAY, c.DateEdited, GETDATE()) AS DSE ,
	   ISNULL(BillCompany.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   Q.StatusDesc,
	   Q.FunctionCode,
	   ST.Name As ServiceTypDesc,
	   SE.EWServiceTypeID
 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 INNER JOIN tblServices AS SE ON SE.ServiceCode = C.ServiceCode
 INNER JOIN tblQueues AS Q ON Q.StatusCode=C.Status
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = C.DoctorCode
 LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
 LEFT OUTER JOIN tblLocation AS LO ON LO.LocationCode = C.DoctorLocation
 LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = SE.EWServiceTypeID
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
	   C.NotaryRequiredCheckedDate,
	   ST.Name As ServiceTypDesc,
	   SE.EWServiceTypeID
 FROM tblCase AS C
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 INNER JOIN tblServices AS SE ON SE.ServiceCode = C.ServiceCode
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = C.DoctorCode
 LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
 LEFT OUTER JOIN tblLocation AS LO ON LO.LocationCode = C.DoctorLocation
 LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = SE.EWServiceTypeID
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
PRINT N'Altering [dbo].[vwQuoteApproval]...';


GO
ALTER VIEW [dbo].[vwQuoteApproval]
AS
SELECT AQ.AcctQuoteID,
       AQ.CaseNbr,
       AQ.QuoteType,
       C.ExtCaseNbr,
       C.ClaimNbr,
       CO.IntName AS CompanyName,
       ISNULL(CL.FirstName, '') + ' ' + ISNULL(CL.LastName, '') AS ClientName,
       ISNULL(EE.FirstName, '') + ' ' + ISNULL(EE.LastName, '') AS ExamineeName,
       ISNULL(DR.LastName, '') + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       CT.ShortDesc AS CaseTypeDesc,
       S.ShortDesc AS ServiceDesc,
       C.ApptDate,
       QS.Description AS QuoteStatus,
       DATEDIFF(DAY, AQ.QuoteDate, GETDATE()) AS DaysOutstanding,
       QS.IsClosed,
       C.DoctorLocation,
       C.ClientCode,
       C.MarketerCode,
       C.SchedulerCode,
       C.QARep,
       C.Status,
       C.DoctorCode,
       C.DateAdded,
       CL.CompanyCode,
       C.OfficeCode,
       C.CaseType,
       C.ServiceCode,
       ISNULL(BCO.ParentCompanyID, CO.ParentCompanyID) AS ParentCompanyID,
	   ST.Name As ServiceTypDesc,
	   S.EWServiceTypeID
 FROM tblAcctQuote AS AQ
 INNER JOIN tblQuoteStatus AS QS ON QS.QuoteStatusID = AQ.QuoteStatusID
 INNER JOIN tblCase AS C ON C.CaseNbr = AQ.CaseNbr
 INNER JOIN tblExaminee AS EE ON EE.ChartNbr = C.ChartNbr
 INNER JOIN tblCaseType AS CT ON CT.Code = C.CaseType
 INNER JOIN tblServices AS S ON S.ServiceCode = C.ServiceCode
 INNER JOIN tblClient AS CL ON CL.ClientCode = C.ClientCode
 INNER JOIN tblCompany AS CO ON CO.CompanyCode = CL.CompanyCode
 LEFT OUTER JOIN tblClient AS BCL ON BCL.ClientCode = C.BillClientCode
 LEFT OUTER JOIN tblCompany AS BCO ON BCO.CompanyCode = BCL.CompanyCode
 LEFT OUTER JOIN tblDoctor AS DR ON DR.DoctorCode = AQ.DoctorCode
 LEFT OUTER JOIN tblEWServiceType AS ST ON ST.EWServiceTypeID = S.EWServiceTypeID
 WHERE QS.IsClosed=0
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
            DATEDIFF(DAY, tblCase.DateEdited, GETDATE()) AS DSE ,
            tblCase.LastStatusChg ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS doctorname ,
            tblCase.PanelNbr ,
            tblQueues.FunctionCode ,
            tblCase.ServiceCode ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID,
			ISNULL(tblCaseAppt.ApptAttendance, '') as ApptAttendance,
			tblEWServiceType.Name As ServiceTypDesc,
			tblServices.EWServiceTypeID
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
			LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
                                       AND tblUser.UserType = 'SC'
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
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
PRINT N'Altering [dbo].[vwStatusNew]...';


GO
ALTER VIEW vwStatusNew
AS
    SELECT DISTINCT
            tblCase.casenbr
           ,tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename
           ,tblCase.DoctorName
           ,tblClient.lastname + ', ' + tblClient.firstname AS clientname
           ,tblCase.MarketerCode AS MarketerName
           ,tblCompany.intname AS CompanyName
           ,tblCase.priority
           ,tblCase.ApptDate
           ,tblCase.Status
           ,tblCase.DateAdded
           ,tblCase.DoctorCode
           ,tblCase.MarketerCode
           ,tblQueues.StatusDesc
           ,tblServices.shortdesc AS Service
           ,tblCase.doctorlocation
           ,tblClient.companycode
           ,tblCase.servicecode
           ,tblCase.QARep
           ,tblCase.schedulercode
           ,tblCase.officecode
           ,tblCase.PanelNbr
           ,'ViewCase' AS FunctionCode
           ,tblCase.casetype
		   ,tblCase.ExtCaseNbr
		   ,ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID 
		   ,tblEWServiceType.Name As ServiceTypDesc
		   ,tblServices.EWServiceTypeID
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.clientcode = tblCase.clientcode
            INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            INNER JOIN tblServices ON tblServices.servicecode = tblCase.servicecode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblQueues ON tblQueues.statuscode = tblCase.status
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
			LEFT OUTER JOIN tblEWServiceType ON tblEWServiceType.EWServiceTypeID = tblServices.EWServiceTypeID
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
PRINT N'Creating [dbo].[vwDoctorSearchResultNew]...';


GO
CREATE VIEW [dbo].[vwDoctorSearchResultNew]
AS
SELECT DSR.PrimaryKey,
	   DSR.SessionID,
       DSR.DoctorCode,
       DSR.LocationCode,
       DSR.SchedCode,
       DSR.Selected,
       DSR.Proximity,
	   IIF(DSR.Proximity=9999, '?', CAST(FORMAT(DSR.Proximity, '#.0')  AS VARCHAR)) AS ProximityString,
       REPLACE(DSR.SpecialtyCodes, ', ', CHAR(13) + CHAR(10)) AS SpecialtyCodes,

       ISNULL(CONVERT(VARCHAR, BTD.ScheduleDate, 101), 'Call for Appt') AS FirstAvail,
       BTD.ScheduleDate AS Date,
       BTS.StartTime,

       DR.LastName + ', ' + ISNULL(DR.FirstName, '') AS DoctorName,
       DR.Prepaid,
       DR.Status,
       DR.Credentials,
       DR.Notes,
       L.Location,
       L.City,
       L.State,
       L.Phone,
       L.County,
	   DSR.DisplayScore,
	   DSR.DoctorRank

FROM tblDoctorSearchResult AS DSR
	INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
    INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
    INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
	LEFT OUTER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeSlotID=DSR.SchedCode
	LEFT OUTER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorBlockTimeDayID=BTS.DoctorBlockTimeDayID
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
PRINT N'Altering [dbo].[spDoctorSearch]...';


GO
ALTER PROCEDURE [dbo].[spDoctorSearch]
(
	@SessionID AS VARCHAR(50) = NULL,

    @StartDate AS DATETIME,
    @PanelExam AS BIT = NULL,

    @DoctorCode AS INT = NULL,
    @ProvTypeCode AS INT = NULL,
	@IncludeInactiveDoctor AS BIT = NULL,
    @Degree AS VARCHAR(50) = NULL,
    @RequirePracticingDoctors AS BIT = NULL,
    @RequireLicencedInExamState AS BIT = NULL,
    @RequireBoardCertified AS BIT = NULL,

    @LocationCode AS INT = NULL,
    @City AS VARCHAR(50) = NULL,
    @State AS VARCHAR(2) = NULL,
    @Vicinity AS VARCHAR(50) = NULL,
    @County AS VARCHAR(50) = NULL,

	@Proximity AS INT = NULL,
	@ProximityZip AS VARCHAR(10) = NULL,

    @KeyWordIDs AS VARCHAR(100) = NULL,
    @Specialties AS VARCHAR(200) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL,
	
	@FirstName AS VARCHAR(50) = NULL,
	@LastName AS VARCHAR(50) = NULL,
	@UserID AS VARCHAR(15) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(200)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT
	DECLARE @AvgMargin AS DECIMAL(8, 2)
	DECLARE @MaxCaseCount AS DECIMAL(8, 2)

	--Defalt Values
	SET @tmpSessionID = ISNULL(@SessionID, NEWID())

	IF @ParentCompanyID IS NOT NULL
	BEGIN
		IF @RequirePracticingDoctors IS NULL
			(SELECT @RequirePracticingDoctors = RequirePracticingDoctor FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
		IF @RequireBoardCertified IS NULL
			(SELECT @RequireBoardCertified = RequireCertification FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
	END

	--Format delimited list
	SET @lstSpecialties = ';;' + @Specialties
	SET @lstKeywordIDs = ';;' + REPLACE(@KeyWordIDs, ' ', '')
	
	
	--Calculate parameter geography data
	IF (@ProximityZip IS NOT NULL)
	BEGIN
		SET @geoEE = geography::STGeomFromText((SELECT TOP 1 'POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')' FROM tblZipCode AS Z WHERE Z.sZip=@ProximityZip ORDER BY Z.kIndex) ,4326)
		IF (SELECT TOP 1 DistanceUofM FROM tblIMEData)='Miles'
			SET @distanceConv = 1609.344
		ELSE
			SET @distanceConv = 1000
	END

	--Clear data from last search
	DELETE FROM tblDoctorSearchResult WHERE SessionID=@tmpSessionID


	--Set Differrent SQL String for Panel Search
	IF ISNULL(@PanelExam,0) = 1
	BEGIN
		SET @strDrSchCol = ' DS.SchedCode,'
		SET @strDrSchFrom = ' INNER JOIN tblDoctorSchedule AS DS ON DS.DoctorCode = DL.DoctorCode AND DS.LocationCode = DL.LocationCode AND DS.Status=''Open'' AND DS.StartTime>=@_StartDate '
	END
	ELSE

		SET @strDrSchCol = '(SELECT TOP 1 SchedCode FROM tblDoctorSchedule AS DS WHERE DS.DoctorCode=DL.DoctorCode AND DS.LocationCode=DL.LocationCode AND DS.date >= dbo.fnDateValue(@_StartDate) AND DS.Status = ''Open'' ORDER BY DS.date) AS SchedCode,'

--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
    Proximity
)
SELECT
	@_tmpSessionID AS SessionID,
	DR.DoctorCode,
    L.LocationCode,
	' + @strDrSchCol + '
	ISNULL(L.GeoData.STDistance(@_geoEE)/@_distanceConv,9999) AS Proximity

FROM 
    tblDoctor AS DR
    INNER JOIN tblDoctorLocation AS DL
        ON DL.DoctorCode = DR.DoctorCode
	INNER JOIN tblLocation AS L
        ON L.LocationCode = DL.LocationCode
' + @strDrSchFrom


--Set WHERE clause string
	SET @strWhere ='WHERE DR.OPType = ''DR'''

	IF ISNULL(@IncludeInactiveDoctor,0)=0
		SET @strWhere = @strWhere + ' AND (DR.Status = ''Active'' AND DL.Status = ''Active'')'
	IF @OfficeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorOffice WHERE OfficeCode=@_OfficeCode)'

	IF @DoctorCode IS NOT NULL
		 SET @strWhere = @strWhere + ' AND @_DoctorCode = DR.DoctorCode'
	IF @ProvTypeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_ProvTypeCode = DR.ProvTypeCode'
	IF ISNULL(@Degree,'')<>''
		SET @strWhere = @strWhere + ' AND @_Degree = DR.Credentials'

	IF ISNULL(@FirstName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.FirstName LIKE @_FirstName'
	IF ISNULL(@LastName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.LastName LIKE @_LastName'

	IF ISNULL(@RequirePracticingDoctors,0)=1
		SET @strWhere = @strWhere + ' AND DR.PracticingDoctor = 1'
	IF ISNULL(@RequireLicencedInExamState,0)=1
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 11 AND State = @_State)'
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2 AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'
	IF @Specialties IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorSpecialty WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID)'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode)'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode)'

	IF @LocationCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_LocationCode = L.LocationCode'
	IF ISNULL(@City,'')<>''
		SET @strWhere = @strWhere + ' AND @_City = L.City'
	IF ISNULL(@State,'')<>''
		SET @strWhere = @strWhere + ' AND @_State = L.State'
	IF ISNULL(@County,'')<>''
		SET @strWhere = @strWhere + ' AND @_County = L.County'
	IF ISNULL(@Vicinity,'')<>''
		SET @strWhere = @strWhere + ' AND @_Vicinity = L.Vicinity'

	IF @Proximity IS NOT NULL
		SET @strWhere = @strWhere + ' AND L.GeoData.STDistance(@_geoEE)/@_distanceConv<=@_Proximity'

	SET @strSQL = @strSQL + @strWhere
	PRINT @strSQL
	EXEC sp_executesql @strSQL,
		  N'@_tmpSessionID VARCHAR(50),
			@_geoEE GEOGRAPHY,
			@_distanceConv FLOAT,
			@_StartDate DATETIME ,
			@_DoctorCode INT ,
			@_LocationCode INT ,
			@_City VARCHAR(50) ,
			@_State VARCHAR(2) ,
			@_Vicinity VARCHAR(50) ,
			@_County VARCHAR(50) ,
			@_Degree VARCHAR(50) ,
			@_lstKeyWordIDs VARCHAR(100) ,
			@_lstSpecialties VARCHAR(200) ,
			@_PanelExam BIT ,
			@_ProvTypeCode INT ,		
			@_EWAccreditationID INT,	
			@_IncludeInactiveDoctor BIT,	
			@_RequirePracticingDoctors BIT,
			@_RequireLicencedInExamState BIT,
			@_RequireBoardCertified BIT,	
			@_OfficeCode INT,			
			@_ParentCompanyID INT,	
			@_CompanyCode INT,		
			@_ClientCode INT,			
			@_Proximity INT,
			@_FirstName VARCHAR(50),
			@_LastName VARCHAR(50)
			',
			@_tmpSessionID = @tmpSessionID,
			@_geoEE = @geoEE,
			@_distanceConv = @distanceConv,
			@_StartDate = @StartDate,
			@_DoctorCode = @DoctorCode,
			@_LocationCode = @LocationCode,
			@_City = @City,
			@_State = @State,
			@_Vicinity = @Vicinity,
			@_County = @County,
			@_Degree = @Degree,
			@_lstKeyWordIDs = @lstKeywordIDs ,
			@_lstSpecialties = @lstSpecialties,
			@_PanelExam = @PanelExam,
			@_ProvTypeCode = @ProvTypeCode,		
			@_EWAccreditationID = @EWAccreditationID,	
			@_IncludeInactiveDoctor = @IncludeInactiveDoctor,
			@_RequirePracticingDoctors = @RequirePracticingDoctors,
			@_RequireLicencedInExamState = @RequireLicencedInExamState,
			@_RequireBoardCertified = @RequireBoardCertified,
			@_OfficeCode = @OfficeCode,
			@_ParentCompanyID = @ParentCompanyID,
			@_CompanyCode = @CompanyCode,
			@_ClientCode = @ClientCode,
			@_Proximity = @Proximity,
			@_FirstName = @FirstName,
			@_LastName = @LastName
	SET @returnValue = @@ROWCOUNT

	--Remove results for access restrictions
	IF (SELECT RestrictToFavorites FROM tblUser WHERE UserID = ISNULL(@UserID,'')) = 1
        DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND LocationCode NOT IN 
            (SELECT DISTINCT L.LocationCode
                FROM tblUser AS U
                INNER JOIN tblUserOffice AS UO ON UO.UserID = U.UserID
                INNER JOIN tblOfficeState AS OS ON OS.OfficeCode = UO.OfficeCode
                INNER JOIN tblLocation AS L ON L.State = OS.State
                WHERE U.UserID = ISNULL(@UserID,''))


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,2,'')),'')
		 FROM tblDoctorSearchResult AS DSR
		 WHERE DSR.SessionID=@tmpSessionID
		SET QUOTED_IDENTIFIER ON
	END

	--Get Doctor Margin
	UPDATE DSR SET DSR.CaseCount=stats.CaseCount, DSR.AvgMargin=stats.AvgMargin
	 FROM tblDoctorSearchResult AS DSR
	 INNER JOIN
		(
		 SELECT DM.DoctorCode, AVG(DM.Margin) AS AvgMargin, SUM(DM.CaseCount) AS CaseCount
		 FROM tblDoctorMargin AS DM
		 WHERE (@ParentCompanyID IS NULL OR DM.ParentCompanyID=@ParentCompanyID)
		  AND (@EWBusLineID IS NULL OR DM.EWBusLineID=@EWBusLineID)
		  AND (@EWServiceTypeID IS NULL OR DM.EWServiceTypeID=@EWServiceTypeID)
		  AND (@Specialties IS NULL OR PATINDEX('%;;' + DM.SpecialtyCode + ';;%', @lstSpecialties)>0)
		 GROUP BY DM.DoctorCode
		) AS stats ON stats.DoctorCode = DSR.DoctorCode
	 WHERE DSR.SessionID=@tmpSessionID

	 -- Calculate DisplayScore
	SELECT 
		@AvgMargin = MAX(AvgMargin), 
		@MaxCaseCount = CAST(MAX(CaseCount) AS DECIMAL(8, 2)) 
	FROM tblDoctorSearchResult 
	WHERE SessionID = @tmpSessionID
	GROUP BY SessionID

	UPDATE DSR SET DSR.DisplayScore =
	   IIF(L.InsideDr=1, W.BlockTime, 0) +
	   IIF(@AvgMargin=0, 0, DSR.AvgMargin/@AvgMargin * W.AverageMargin) +
	   IIF(@MaxCaseCount=0, 0, DSR.CaseCount/@MaxCaseCount * W.CaseCount) +
	   (6-ISNULL(DR.SchedulePriority,5))/5.0 * W.SchedulePriority +
	   IIF(DR.ReceiveMedRecsElectronically=1, W.ReceiveMedRecsElectronically, 0)
	FROM tblDoctorSearchResult AS DSR
		INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
		INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
		INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
		WHERE DSR.SessionID = @tmpSessionID

	 -- Calculate DoctorRank 
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DoctorRank1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DisplayScore DESC, DoctorCode) AS DoctorRank1
		                 FROM tblDoctorSearchResult
					  WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey
		WHERE DSR.SessionID=@tmpSessionID


	-- Recalculate doctor ranking so that the same doctor has the same ranking
     UPDATE DSR 
           SET DSR.DoctorRank = T1.DoctorRankMin
           FROM tblDoctorSearchResult AS DSR
                     INNER JOIN (SELECT PrimaryKey, DoctorCode, MIN(DoctorRank)OVER(PARTITION BY DoctorCode) AS DoctorRankMin 
                                    FROM tblDoctorSearchResult
                                    WHERE SessionID = @tmpSessionID) AS T1 ON t1.PrimaryKey = DSR.PrimaryKey
           WHERE DSR.SessionID = @tmpSessionID


	-- The ranking created above has gaps in numbering - take gaps out.
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DRk1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DoctorRank) AS DRk1 FROM tblDoctorSearchResult
		WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey


	--If SessionID is given, return the number of rows instead of the actual data
	IF @SessionID IS NOT NULL
		RETURN @returnValue
	ELSE
		SELECT * FROM tblDoctorSearchResult WHERE SessionID=@SessionID
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
PRINT N'Altering [dbo].[spDoctorSearchNew]...';


GO
ALTER PROCEDURE [dbo].[spDoctorSearchNew]
(
	@SessionID AS VARCHAR(50) = NULL,

    @StartDate AS DATETIME,
    @PanelExam AS BIT = NULL,

    @DoctorCode AS INT = NULL,
    @ProvTypeCode AS INT = NULL,
	@IncludeInactiveDoctor AS BIT = NULL,
    @Degree AS VARCHAR(50) = NULL,
    @RequirePracticingDoctors AS BIT = NULL,
    @RequireLicencedInExamState AS BIT = NULL,
    @RequireBoardCertified AS BIT = NULL,

    @LocationCode AS INT = NULL,
    @City AS VARCHAR(50) = NULL,
    @State AS VARCHAR(2) = NULL,
    @Vicinity AS VARCHAR(50) = NULL,
    @County AS VARCHAR(50) = NULL,

	@Proximity AS INT = NULL,
	@ProximityZip AS VARCHAR(10) = NULL,

    @KeyWordIDs AS VARCHAR(100) = NULL,
    @Specialties AS VARCHAR(200) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL,
	
	@FirstName AS VARCHAR(50) = NULL,
	@LastName AS VARCHAR(50) = NULL,
	@UserID AS VARCHAR(15) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(200)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT
	DECLARE @AvgMargin AS DECIMAL(8, 2)
	DECLARE @MaxCaseCount AS DECIMAL(8, 2)

	--Defalt Values
	SET @tmpSessionID = ISNULL(@SessionID, NEWID())

	IF @ParentCompanyID IS NOT NULL
	BEGIN
		IF @RequirePracticingDoctors IS NULL
			(SELECT @RequirePracticingDoctors = RequirePracticingDoctor FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
		IF @RequireBoardCertified IS NULL
			(SELECT @RequireBoardCertified = RequireCertification FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
	END

	--Format delimited list
	SET @lstSpecialties = ';;' + @Specialties
	SET @lstKeywordIDs = ';;' + REPLACE(@KeyWordIDs, ' ', '')


	--Calculate parameter geography data
	IF (@ProximityZip IS NOT NULL)
	BEGIN
		SET @geoEE = geography::STGeomFromText((SELECT TOP 1 'POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')' FROM tblZipCode AS Z WHERE Z.sZip=@ProximityZip ORDER BY Z.kIndex) ,4326)
		IF (SELECT TOP 1 DistanceUofM FROM tblIMEData)='Miles'
			SET @distanceConv = 1609.344
		ELSE
			SET @distanceConv = 1000
	END

	--Clear data from last search
	DELETE FROM tblDoctorSearchResult WHERE SessionID=@tmpSessionID


	--Set Differrent SQL String for Panel Search
	IF ISNULL(@PanelExam,0) = 1
		BEGIN
			SET @strDrSchCol = ' BTS.DoctorBlockTimeSlotID AS SchedCode,' +
							   ' ROW_NUMBER() OVER (PARTITION BY BTS.DoctorBlockTimeDayID, BTS.StartTime ORDER BY BTS.DoctorBlockTimeSlotID) AS DisplayScore,'
			SET @strDrSchFrom = ' INNER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTD.ScheduleDate>=@_StartDate ' +
								' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID AND BTS.DoctorBlockTimeSlotStatusID=10'
		END
	ELSE
		SET @strDrSchCol = '(SELECT TOP 1 BTS.DoctorBlockTimeSlotID AS SchedCode FROM tblDoctorBlockTimeDay AS BTD ' +
						   ' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID' +
						   ' WHERE BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTS.DoctorBlockTimeSlotStatusID=10' +
						   ' AND BTD.ScheduleDate >= dbo.fnDateValue(@_StartDate) ORDER BY BTD.ScheduleDate) AS SchedCode,' +
						   ' 1 AS DisplayScore,'


--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
	DisplayScore,
    Proximity
)
SELECT
	@_tmpSessionID AS SessionID,
	DR.DoctorCode,
    L.LocationCode,
	' + @strDrSchCol + '
	ISNULL(L.GeoData.STDistance(@_geoEE)/@_distanceConv,9999) AS Proximity

FROM 
    tblDoctor AS DR
    INNER JOIN tblDoctorLocation AS DL
        ON DL.DoctorCode = DR.DoctorCode
	INNER JOIN tblLocation AS L
        ON L.LocationCode = DL.LocationCode
' + @strDrSchFrom


--Set WHERE clause string
	SET @strWhere ='WHERE DR.OPType = ''DR'''

	IF ISNULL(@IncludeInactiveDoctor,0)=0
		SET @strWhere = @strWhere + ' AND (DR.Status = ''Active'' AND DL.Status = ''Active'')'
	IF @OfficeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorOffice WHERE OfficeCode=@_OfficeCode)'

	IF @DoctorCode IS NOT NULL
		 SET @strWhere = @strWhere + ' AND @_DoctorCode = DR.DoctorCode'
	IF @ProvTypeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_ProvTypeCode = DR.ProvTypeCode'
	IF ISNULL(@Degree,'')<>''
		SET @strWhere = @strWhere + ' AND @_Degree = DR.Credentials'

	IF ISNULL(@FirstName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.FirstName LIKE @_FirstName'
	IF ISNULL(@LastName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.LastName LIKE @_LastName'

	IF ISNULL(@RequirePracticingDoctors,0)=1
		SET @strWhere = @strWhere + ' AND DR.PracticingDoctor = 1'
	IF ISNULL(@RequireLicencedInExamState,0)=1
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 11 AND State = @_State)'
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2 AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'
	IF @Specialties IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorSpecialty WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID)'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode)'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode)'

	IF @LocationCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_LocationCode = L.LocationCode'
	IF ISNULL(@City,'')<>''
		SET @strWhere = @strWhere + ' AND @_City = L.City'
	IF ISNULL(@State,'')<>''
		SET @strWhere = @strWhere + ' AND @_State = L.State'
	IF ISNULL(@County,'')<>''
		SET @strWhere = @strWhere + ' AND @_County = L.County'
	IF ISNULL(@Vicinity,'')<>''
		SET @strWhere = @strWhere + ' AND @_Vicinity = L.Vicinity'

	IF @Proximity IS NOT NULL
		SET @strWhere = @strWhere + ' AND L.GeoData.STDistance(@_geoEE)/@_distanceConv<=@_Proximity'

	SET @strSQL = @strSQL + @strWhere
	PRINT @strSQL
	EXEC sp_executesql @strSQL,
		  N'@_tmpSessionID VARCHAR(50),
			@_geoEE GEOGRAPHY,
			@_distanceConv FLOAT,
			@_StartDate DATETIME ,
			@_DoctorCode INT ,
			@_LocationCode INT ,
			@_City VARCHAR(50) ,
			@_State VARCHAR(2) ,
			@_Vicinity VARCHAR(50) ,
			@_County VARCHAR(50) ,
			@_Degree VARCHAR(50) ,
			@_lstKeyWordIDs VARCHAR(100) ,
			@_lstSpecialties VARCHAR(200) ,
			@_PanelExam BIT ,
			@_ProvTypeCode INT ,		
			@_EWAccreditationID INT,	
			@_IncludeInactiveDoctor BIT,	
			@_RequirePracticingDoctors BIT,
			@_RequireLicencedInExamState BIT,
			@_RequireBoardCertified BIT,	
			@_OfficeCode INT,			
			@_ParentCompanyID INT,	
			@_CompanyCode INT,		
			@_ClientCode INT,			
			@_Proximity INT,
			@_FirstName VARCHAR(50),
			@_LastName VARCHAR(50)
			',
			@_tmpSessionID = @tmpSessionID,
			@_geoEE = @geoEE,
			@_distanceConv = @distanceConv,
			@_StartDate = @StartDate,
			@_DoctorCode = @DoctorCode,
			@_LocationCode = @LocationCode,
			@_City = @City,
			@_State = @State,
			@_Vicinity = @Vicinity,
			@_County = @County,
			@_Degree = @Degree,
			@_lstKeyWordIDs = @lstKeywordIDs ,
			@_lstSpecialties = @lstSpecialties,
			@_PanelExam = @PanelExam,
			@_ProvTypeCode = @ProvTypeCode,		
			@_EWAccreditationID = @EWAccreditationID,	
			@_IncludeInactiveDoctor = @IncludeInactiveDoctor,
			@_RequirePracticingDoctors = @RequirePracticingDoctors,
			@_RequireLicencedInExamState = @RequireLicencedInExamState,
			@_RequireBoardCertified = @RequireBoardCertified,
			@_OfficeCode = @OfficeCode,
			@_ParentCompanyID = @ParentCompanyID,
			@_CompanyCode = @CompanyCode,
			@_ClientCode = @ClientCode,
			@_Proximity = @Proximity,
			@_FirstName = @FirstName,
			@_LastName = @LastName
	SET @returnValue = @@ROWCOUNT
	
	--Use only the first row of the same start time (DisplayScore was set to 1 during INSERT)
	DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND ISNULL(DisplayScore,0)<>1

	--Remove results for access restrictions
	IF (SELECT RestrictToFavorites FROM tblUser WHERE UserID = ISNULL(@UserID,'')) = 1
		DELETE FROM tblDoctorSearchResult WHERE SessionID = @tmpSessionID AND LocationCode NOT IN 
			(SELECT DISTINCT L.LocationCode
				FROM tblUser AS U
				INNER JOIN tblUserOffice AS UO ON UO.UserID = U.UserID
				INNER JOIN tblOfficeState AS OS ON OS.OfficeCode = UO.OfficeCode
				INNER JOIN tblLocation AS L ON L.State = OS.State
				WHERE U.UserID = ISNULL(@UserID,''))


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,2,'')),'')
		 FROM tblDoctorSearchResult AS DSR
		 WHERE DSR.SessionID=@tmpSessionID
		SET QUOTED_IDENTIFIER ON
	END

	--Get Doctor Margin
	UPDATE DSR SET DSR.CaseCount=stats.CaseCount, DSR.AvgMargin=stats.AvgMargin
	 FROM tblDoctorSearchResult AS DSR
	 INNER JOIN
		(
		 SELECT DM.DoctorCode, AVG(DM.Margin) AS AvgMargin, SUM(DM.CaseCount) AS CaseCount
		 FROM tblDoctorMargin AS DM
		 WHERE (@ParentCompanyID IS NULL OR DM.ParentCompanyID=@ParentCompanyID)
		  AND (@EWBusLineID IS NULL OR DM.EWBusLineID=@EWBusLineID)
		  AND (@EWServiceTypeID IS NULL OR DM.EWServiceTypeID=@EWServiceTypeID)
		  AND (@Specialties IS NULL OR PATINDEX('%;;' + DM.SpecialtyCode + ';;%', @lstSpecialties)>0)
		 GROUP BY DM.DoctorCode
		) AS stats ON stats.DoctorCode = DSR.DoctorCode
	 WHERE DSR.SessionID=@tmpSessionID

	 -- Calculate DisplayScore
	UPDATE tblDoctorSearchResult SET DisplayScore = NULL
		WHERE SessionID = @tmpSessionID

	SELECT 
		@AvgMargin = MAX(AvgMargin), 
		@MaxCaseCount = CAST(MAX(CaseCount) AS DECIMAL(8, 2)) 
	FROM tblDoctorSearchResult 
	WHERE SessionID = @tmpSessionID
	GROUP BY SessionID

	UPDATE DSR SET DSR.DisplayScore =
	   IIF(L.InsideDr=1, W.BlockTime, 0) +
	   IIF(@AvgMargin=0, 0, DSR.AvgMargin/@AvgMargin * W.AverageMargin) +
	   IIF(@MaxCaseCount=0, 0, DSR.CaseCount/@MaxCaseCount * W.CaseCount) +
	   (6-ISNULL(DR.SchedulePriority,5))/5.0 * W.SchedulePriority +
	   IIF(DR.ReceiveMedRecsElectronically=1, W.ReceiveMedRecsElectronically, 0)
	FROM tblDoctorSearchResult AS DSR
		INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
		INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
		INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
		WHERE DSR.SessionID = @tmpSessionID

	 -- Calculate DoctorRank 
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DoctorRank1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DisplayScore DESC, DoctorCode) AS DoctorRank1
		                 FROM tblDoctorSearchResult
					  WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey
		WHERE DSR.SessionID=@tmpSessionID


	-- Recalculate doctor ranking so that the same doctor has the same ranking
     UPDATE DSR 
           SET DSR.DoctorRank = T1.DoctorRankMin
           FROM tblDoctorSearchResult AS DSR
                     INNER JOIN (SELECT PrimaryKey, DoctorCode, MIN(DoctorRank)OVER(PARTITION BY DoctorCode) AS DoctorRankMin 
                                    FROM tblDoctorSearchResult
                                    WHERE SessionID = @tmpSessionID) AS T1 ON t1.PrimaryKey = DSR.PrimaryKey
           WHERE DSR.SessionID = @tmpSessionID


	-- The ranking created above has gaps in numbering - take gaps out.
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DRk1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DoctorRank) AS DRk1 FROM tblDoctorSearchResult
		WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey


	--If SessionID is given, return the number of rows instead of the actual data
	IF @SessionID IS NOT NULL
		RETURN @returnValue
	ELSE
		SELECT * FROM tblDoctorSearchResult WHERE SessionID=@SessionID
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
INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc,
    DateAdded
)
VALUES
(   'SLAMonitor',
    'SLA Monitor',
    GETDATE()
    )

GO