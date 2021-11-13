PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [NotaryRequired]            BIT           CONSTRAINT [DF_tblCase_NotaryRequired] DEFAULT ((0)) NOT NULL,
        [NotaryRequiredCheckedDate] SMALLDATETIME NULL,
        [ReExamNoticePrintedDate]   DATETIME      NULL,
        [PreviousCaseNbr]           INT           NULL;


GO
PRINT N'Altering [dbo].[tblCaseEnvelope]...';


GO
ALTER TABLE [dbo].[tblCaseEnvelope]
    ADD [ImportFileName] VARCHAR (255) NULL;


GO
PRINT N'Altering [dbo].[tblDocument]...';


GO
ALTER TABLE [dbo].[tblDocument]
    ADD [IsEnvelopeReady]         BIT          CONSTRAINT [DF_tblDocument_IsEnvelopeReady] DEFAULT ((0)) NOT NULL,
        [NotifyTo]                VARCHAR (50) NULL,
        [ExcludeFromPortalWidget] VARCHAR (50) NULL;


GO
PRINT N'Altering [dbo].[tblPublishOnWeb]...';


GO
ALTER TABLE [dbo].[tblPublishOnWeb]
    ADD [UseWidget]  BIT      CONSTRAINT [DF_tblPublishOnWeb_UseWidget] DEFAULT (1) NOT NULL,
        [DateViewed] DATETIME NULL;


GO
PRINT N'Altering [dbo].[tblServiceWorkflow]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD [InternalDueDateType]  INT CONSTRAINT [DF_tblServiceWorkflow_InternalDueDateType] DEFAULT 1 NOT NULL,
        [ExternalDueDateType]  INT CONSTRAINT [DF_tblServiceWorkflow_ExternalDueDateType] DEFAULT 1 NOT NULL,
        [DoctorRptDueDateType] INT CONSTRAINT [DF_tblServiceWorkflow_DoctorRptDueDateType] DEFAULT 1 NOT NULL,
        [ForecastDateType]     INT CONSTRAINT [DF_tblServiceWorkflow_ForecastDateType] DEFAULT 1 NOT NULL;


GO
PRINT N'Altering [dbo].[tblWebReferral]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD [WebReferralFormName] VARCHAR (255) NULL;


GO
PRINT N'Altering [dbo].[vwServiceWorkflow]...';


GO
ALTER VIEW [dbo].[vwServiceWorkflow]
AS
    SELECT
        WF.ServiceWorkflowID,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.UserIDAdded,
        WF.DateAdded,
        WF.UserIDEdited,
        WF.DateEdited,
        WF.ExamineeAddrReqd,
        WF.ExamineeSSNReqd,
        WF.AttorneyReqd,
        WF.DOIRqd,
        WF.ClaimNbrRqd,
        WF.JurisdictionRqd,
        WF.EmployerRqd,
        WF.TreatingPhysicianRqd,
        WF.CalcFrom,
        WF.DaysToForecastDate,
        WF.DaysToInternalDueDate,
        WF.DaysToExternalDueDate,
		WF.DaysToDoctorRptDueDate,
		WF.InternalDueDateType,
		WF.ExternalDueDateType,
		WF.DoctorRptDueDateType,
		WF.ForecastDateType,
        WFQ.QueueCount,
        CT.Description AS CaseTypeDesc,
        CT.Status AS CaseTypeStatus,
        S.Description AS ServiceDesc,
        S.Status AS ServiceStatus,
        S.ApptBased,
        S.ShowLegalTabOnCase,
        O.Description AS OfficeDesc,
        O.Status AS OfficeStatus,
		WF.UsePeerBill,
		S.ProdCode, 
		CT.EWBusLineID
    FROM
        tblServiceWorkflow AS WF
    INNER JOIN tblCaseType AS CT ON WF.CaseType=CT.Code
    INNER JOIN tblServices AS S ON S.ServiceCode=WF.ServiceCode
    INNER JOIN tblOffice AS O ON O.OfficeCode=WF.OfficeCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowID,
                        COUNT(ServiceWorkflowQueueID) AS QueueCount
                     FROM
                        tblServiceWorkflowQueue
                     GROUP BY
                        ServiceWorkflowID
                    ) AS WFQ ON WFQ.ServiceWorkflowID=WF.ServiceWorkflowID
GO
PRINT N'Creating [dbo].[vwNotaryApproval]...';


GO
CREATE VIEW [dbo].[vwNotaryApproval]
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
PRINT N'Creating [dbo].[vwRptProgressiveClosedCaseSummary]...';


GO
CREATE VIEW vwRptProgressiveClosedCaseSummary
AS
SELECT
 C.CaseNbr,
 C.ClaimNbr,
 CT.Description AS CaseType,
 S.Description AS Service,
 Q.StatusDesc AS CaseStatus,
 
 ISNULL(EE.LastName,'') + ', ' + ISNULL(EE.FirstName,'') AS ExamineeName,
 ISNULL(CL.LastName,'') + ', ' + ISNULL(CL.FirstName,'') AS ClientName,
 IIF(C.PlaintiffAttorneyCode IS NOT NULL, PA.Company, '') AS AttorneyCompany,
 IIF(C.PlaintiffAttorneyCode IS NOT NULL, RTRIM(LTRIM(ISNULL(PA.FirstName,'') + ' ' + ISNULL(PA.LastName,''))), '') AS AttorneyName,
 C.DoctorName,
 C.DoctorSpecialty,
 L.County,
 L.State,

 C.DateReceived,
 C.DateOfInjury,
 C.OrigApptTime,
 C.DateCanceled,
 C.RptFinalizedDate,
 C.RptSentDate,

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
 LEFT OUTER JOIN tblLocation AS L ON C.DoctorLocation=L.LocationCode
 LEFT OUTER JOIN tblCCAddress AS PA ON C.PlaintiffAttorneyCode = PA.ccCode
 LEFT OUTER JOIN tblAcctHeader AS AH ON AH.CaseNbr = C.CaseNbr AND AH.DocumentType='IN'
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
PRINT N'Creating [dbo].[vwRptProgressiveIMESummary]...';


GO
CREATE VIEW vwRptProgressiveIMESummary
AS
SELECT
 C.CaseNbr,
 C.ClaimNbr,

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
PRINT N'Creating [dbo].[vwRptProgressivePeerSummary]...';


GO
CREATE VIEW vwRptProgressivePeerSummary
AS
SELECT
 C.CaseNbr,
 C.ClaimNbr,
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
PRINT N'Creating [dbo].[vwRptProgressiveReExam]...';


GO
CREATE VIEW vwRptProgressiveReExam
AS
SELECT
 C.CaseNbr,
 C.ClaimNbr,
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
PRINT N'Creating [dbo].[vwRptProgressiveReferral]...';


GO
CREATE VIEW vwRptProgressiveReferral
AS
SELECT
 C.CaseNbr,
 C.ClaimNbr,
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
 AND S.EWServiceTypeID=1
GO
PRINT N'Altering [dbo].[proc_IMECase_Insert]...';


GO
ALTER PROCEDURE [proc_IMECase_Insert]
(
	@casenbr int = NULL output,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@dateofinjury2 datetime = NULL,
	@dateofinjury3 datetime = NULL,
	@dateofinjury4 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@AttorneyNote text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@reportverbal bit = NULL,
	@TransCode int = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@DoctorName varchar(100) = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@reccode int = NULL,
	@Jurisdiction varchar(5) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@HearingDate smalldatetime = NULL,
	@laststatuschg datetime = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@DateReceived datetime = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL,
	@BillingNote text = NULL,
	@AllowMigratingClaim bit = NULL,
	@InsuringCompany varchar(100) = NULL,
	@AwaitingScheduling datetime = NULL,
	@DateAcknowledged datetime = NULL,
	@VenueID int = NULL
	)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCase]
	(
		[chartnbr],
		[doctorlocation],
		[clientcode],
		[marketercode],
		[schedulercode],
		[priority],
		[status],
		[casetype],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited],
		[schedcode],
		[ApptDate],
		[Appttime],
		[ApptMadeDate],
		[claimnbr],
		[dateofinjury],
		[dateofinjury2],
		[dateofinjury3],
		[dateofinjury4],
		[calledinby],
		[notes],
		[AttorneyNote],
		[schedulenotes],
		[requesteddoc],
		[reportverbal],
		[TransCode],
		[plaintiffattorneycode],
		[defenseattorneycode],
		[commitdate],
		[servicecode],
		[issuecode],
		[doctorcode],
		[DoctorName],
		[WCBNbr],
		[specialinstructions],
		[sreqspecialty],
		[doctorspecialty],
		[reccode],
		[Jurisdiction],
		[officecode],
		[QARep],
		[photoRqd],
		[CertifiedMail],
		[HearingDate],
		[laststatuschg],
		[PublishOnWeb],
		[WebNotifyEmail],
		[DateReceived],
		[ClaimNbrExt],
		[InterpreterRequired],
		[TransportationRequired],
		[LanguageID],
		[InputSourceID],
		[ReqEWAccreditationID],
		[ApptStatusId],
		[CaseApptId],
		[BillingNote],
		[AllowMigratingClaim],
		[InsuringCompany],
		[AwaitingScheduling],
		[DateAcknowledged],
		[VenueID]
	)
	VALUES
	(
		@chartnbr,
		@doctorlocation,
		@clientcode,
		@marketercode,
		@schedulercode,
		@priority,
		@status,
		@casetype,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited,
		@schedcode,
		@ApptDate,
		@Appttime,
		@ApptMadeDate,
		@claimnbr,
		@dateofinjury,
		@dateofinjury2,
		@dateofinjury3,
		@dateofinjury4,
		@calledinby,
		@notes,
		@AttorneyNote,
		@schedulenotes,
		@requesteddoc,
		@reportverbal,
		@TransCode,
		@plaintiffattorneycode,
		@defenseattorneycode,
		@commitdate,
		@servicecode,
		@issuecode,
		@doctorcode,
		@DoctorName,
		@WCBNbr,
		@specialinstructions,
		@sreqspecialty,
		@doctorspecialty,
		@reccode,
		@Jurisdiction,
		@officecode,
		@QARep,
		@photoRqd,
		@CertifiedMail,
		@HearingDate,
		@laststatuschg,
		@PublishOnWeb,
		@WebNotifyEmail,
		@DateReceived,
		@ClaimNbrExt,
		@InterpreterRequired,
		@TransportationRequired,
		@LanguageID,
		@InputSourceID,
		@ReqEWAccreditationID,
		@ApptStatusId,
		@CaseApptId,
		@BillingNote,
		@AllowMigratingClaim,
		@InsuringCompany,
		@AwaitingScheduling,
		@DateAcknowledged,
		@VenueID
	)

	SET @Err = @@Error

	SELECT @casenbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_IMECase_Update]...';


GO
ALTER PROCEDURE [proc_IMECase_Update]
(
	@casenbr int,
	@chartnbr int = NULL,
	@doctorlocation varchar(10) = NULL,
	@clientcode int = NULL,
	@marketercode varchar(15) = NULL,
	@schedulercode varchar(15) = NULL,
	@priority varchar(15) = NULL,
	@status int = NULL,
	@casetype int = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@schedcode int = NULL,
	@ApptDate datetime = NULL,
	@Appttime datetime = NULL,
	@ApptMadeDate datetime = NULL,
	@claimnbr varchar(50) = NULL,
	@dateofinjury datetime = NULL,
	@dateofinjury2 datetime = NULL,
	@dateofinjury3 datetime = NULL,
	@dateofinjury4 datetime = NULL,
	@calledinby varchar(50) = NULL,
	@notes text = NULL,
	@AttorneyNote text = NULL,
	@schedulenotes text = NULL,
	@requesteddoc varchar(50) = NULL,
	@reportverbal bit = NULL,
	@TransCode int = NULL,
	@plaintiffattorneycode int = NULL,
	@defenseattorneycode int = NULL,
	@commitdate datetime = NULL,
	@servicecode int = NULL,
	@issuecode int = NULL,
	@doctorcode int = NULL,
	@DoctorName varchar(100) = NULL,
	@WCBNbr varchar(50) = NULL,
	@specialinstructions text = NULL,
	@sreqspecialty varchar(50) = NULL,
	@doctorspecialty varchar(50) = NULL,
	@reccode int = NULL,
	@Jurisdiction varchar(5) = NULL,
	@officecode int = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@CertifiedMail bit = NULL,
	@HearingDate smalldatetime = NULL,
	@laststatuschg datetime = NULL,
	@PublishOnWeb bit = NULL,
	@WebNotifyEmail varchar(200) = NULL,
	@DateReceived datetime = NULL,
	@ClaimNbrExt varchar(50) = NULL,
	@InterpreterRequired bit = NULL,
	@TransportationRequired bit = NULL,
	@LanguageID int = NULL,
	@InputSourceID int = NULL,
	@ReqEWAccreditationID int = NULL,
	@ApptStatusId int = NULL,
	@CaseApptId int = NULL,
	@BillingNote text = NULL,
	@InsuringCompany varchar(100) = NULL,
	@AwaitingScheduling datetime,
	@DateAcknowledged datetime = NULL,
	@VenueID int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCase]
	SET
		[chartnbr] = @chartnbr,
		[doctorlocation] = @doctorlocation,
		[clientcode] = @clientcode,
		[marketercode] = @marketercode,
		[schedulercode] = @schedulercode,
		[priority] = @priority,
		[status] = @status,
		[casetype] = @casetype,
		[dateadded] = @dateadded,
		[dateedited] = @dateedited,
		[useridadded] = @useridadded,
		[useridedited] = @useridedited,
		[schedcode] = @schedcode,
		[ApptDate] = @ApptDate,
		[Appttime] = @Appttime,
		[ApptMadeDate] = @ApptMadeDate,
		[claimnbr] = @claimnbr,
		[dateofinjury] = @dateofinjury,
		[dateofinjury2] = @dateofinjury2,
		[dateofinjury3] = @dateofinjury3,
		[dateofinjury4] = @dateofinjury4,
		[calledinby] = @calledinby,
		[notes] = @notes,
		[AttorneyNote] = @AttorneyNote,
		[schedulenotes] = @schedulenotes,
		[requesteddoc] = @requesteddoc,
		[reportverbal] = @reportverbal,
		[TransCode] = @TransCode,
		[plaintiffattorneycode] = @plaintiffattorneycode,
		[defenseattorneycode] = @defenseattorneycode,
		[commitdate] = @commitdate,
		[servicecode] = @servicecode,
		[issuecode] = @issuecode,
		[doctorcode] = @doctorcode,
		[DoctorName] = @DoctorName,
		[WCBNbr] = @WCBNbr,
		[specialinstructions] = @specialinstructions,
		[sreqspecialty] = @sreqspecialty,
		[doctorspecialty] = @doctorspecialty,
		[reccode] = @reccode,
		[Jurisdiction] = @Jurisdiction,
		[officecode] = @officecode,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[CertifiedMail] = @CertifiedMail,
		[HearingDate] = @HearingDate,
		[laststatuschg] = @laststatuschg,
		[PublishOnWeb] = @PublishOnWeb,
		[WebNotifyEmail] = @WebNotifyEmail,
		[DateReceived] = @DateReceived,
		[ClaimNbrExt] = @ClaimNbrExt,
		[InterpreterRequired] = @InterpreterRequired,
		[TransportationRequired] = @TransportationRequired,
		[LanguageID] = @LanguageID,
		[InputSourceID] = @InputSourceID,
		[ReqEWAccreditationID] = @ReqEWAccreditationID,
		[ApptStatusId] = @ApptStatusId,
		[CaseApptId] = @CaseApptId,
		[BillingNote] = @BillingNote,
		[InsuringCompany] = @InsuringCompany,
		[AwaitingScheduling] = @AwaitingScheduling,
		[DateAcknowledged] = @DateAcknowledged,
		[VenueID] = @VenueID
	WHERE
		[casenbr] = @casenbr


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_Examinee_Insert]...';


GO
ALTER PROCEDURE [proc_Examinee_Insert]
(
	@chartnbr int = NULL output,
	@lastname varchar(50) = NULL,
	@firstname varchar(50) = NULL,
	@middleinitial varchar(5) = NULL,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@phone1 varchar(15) = NULL,
	@phone2 varchar(15) = NULL,
	@SSN varchar(15) = NULL,
	@sex varchar(10) = NULL,
	@DOB datetime = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@note text = NULL,
	@prefix varchar(10) = NULL,
	@fax varchar(15) = NULL,
	@email varchar(50) = NULL,
	@insured varchar(50) = NULL,
	@employer varchar(70) = NULL,
	@treatingphysician varchar(70) = NULL,
	@InsuredAddr1 varchar(70) = NULL,
	@InsuredCity varchar(70) = NULL,
	@InsuredState varchar(5) = NULL,
	@InsuredZip varchar(10) = NULL,
	@InsuredPhone varchar(15) = NULL,
	@InsuredPhoneExt varchar(10) = NULL,
	@InsuredFax varchar(15) = NULL,
	@InsuredEmail varchar(70) = NULL,
	@TreatingPhysicianAddr1 varchar(70) = NULL,
	@TreatingPhysicianCity varchar(70) = NULL,
	@TreatingPhysicianState varchar(5) = NULL,
	@TreatingPhysicianZip varchar(10) = NULL,
	@TreatingPhysicianPhone varchar(15) = NULL,
	@TreatingPhysicianPhoneExt varchar(10) = NULL,
	@TreatingPhysicianFax varchar(15) = NULL,
	@TreatingPhysicianEmail varchar(70) = NULL,
	@TreatingPhysicianDiagnosis varchar(70) = NULL,
	@EmployerAddr1 varchar(70) = NULL,
	@EmployerCity varchar(70) = NULL,
	@EmployerState varchar(5) = NULL,
	@EmployerZip varchar(10) = NULL,
	@EmployerPhone varchar(15) = NULL,
	@EmployerPhoneExt varchar(10) = NULL,
	@EmployerFax varchar(15) = NULL,
	@EmployerEmail varchar(70) = NULL,
	@policynumber varchar(70) = NULL,
	@EmployerContactFirstName varchar(50) = NULL,
	@EmployerContactLastName varchar(50) = NULL,
	@County varchar(50) = NULL,
	@MobilePhone varchar(15) = NULL,
	@WorkPhone varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblExaminee]
	(
		[lastname],
		[firstname],
		[middleinitial],
		[addr1],
		[addr2],
		[city],
		[state],
		[zip],
		[phone1],
		[phone2],
		[SSN],
		[sex],
		[DOB],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited],
		[note],
		[prefix],
		[fax],
		[email],
		[insured],
		[employer],
		[treatingphysician],
		[InsuredAddr1],
		[InsuredCity],
		[InsuredState],
		[InsuredZip],
		[InsuredPhone],
		[InsuredPhoneExt],
		[InsuredFax],
		[InsuredEmail],
		[TreatingPhysicianAddr1],
		[TreatingPhysicianCity],
		[TreatingPhysicianState],
		[TreatingPhysicianZip],
		[TreatingPhysicianPhone],
		[TreatingPhysicianPhoneExt],
		[TreatingPhysicianFax],
		[TreatingPhysicianEmail],
		[TreatingPhysicianDiagnosis],
		[EmployerAddr1],
		[EmployerCity],
		[EmployerState],
		[EmployerZip],
		[EmployerPhone],
		[EmployerPhoneExt],
		[EmployerFax],
		[EmployerEmail],
		[policynumber],
		[EmployerContactFirstName],
		[EmployerContactLastName],
		[County],
		[MobilePhone],
		[WorkPhone]
	)
	VALUES
	(
		@lastname,
		@firstname,
		@middleinitial,
		@addr1,
		@addr2,
		@city,
		@state,
		@zip,
		@phone1,
		@phone2,
		@SSN,
		@sex,
		@DOB,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited,
		@note,
		@prefix,
		@fax,
		@email,
		@insured,
		@employer,
		@treatingphysician,
		@InsuredAddr1,
		@InsuredCity,
		@InsuredState,
		@InsuredZip,
		@InsuredPhone,
		@InsuredPhoneExt,
		@InsuredFax,
		@InsuredEmail,
		@TreatingPhysicianAddr1,
		@TreatingPhysicianCity,
		@TreatingPhysicianState,
		@TreatingPhysicianZip,
		@TreatingPhysicianPhone,
		@TreatingPhysicianPhoneExt,
		@TreatingPhysicianFax,
		@TreatingPhysicianEmail,
		@TreatingPhysicianDiagnosis,
		@EmployerAddr1,
		@EmployerCity,
		@EmployerState,
		@EmployerZip,
		@EmployerPhone,
		@EmployerPhoneExt,
		@EmployerFax,
		@EmployerEmail,
		@policynumber,
		@EmployerContactFirstName,
		@EmployerContactLastName,
		@County,
		@MobilePhone,
		@WorkPhone
	)

	SET @Err = @@Error

	SELECT @chartnbr = SCOPE_IDENTITY()

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_Examinee_Update]...';


GO
ALTER PROCEDURE [proc_Examinee_Update]
(
	@chartnbr int,
	@lastname varchar(50) = NULL,
	@firstname varchar(50) = NULL,
	@middleinitial varchar(5) = NULL,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@phone1 varchar(15) = NULL,
	@phone2 varchar(15) = NULL,
	@SSN varchar(15) = NULL,
	@sex varchar(10) = NULL,
	@DOB datetime = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL,
	@note text = NULL,
	@prefix varchar(10) = NULL,
	@fax varchar(15) = NULL,
	@email varchar(50) = NULL,
	@insured varchar(50) = NULL,
	@employer varchar(70) = NULL,
	@treatingphysician varchar(70) = NULL,
	@InsuredAddr1 varchar(70) = NULL,
	@InsuredCity varchar(70) = NULL,
	@InsuredState varchar(5) = NULL,
	@InsuredZip varchar(10) = NULL,
	@InsuredPhone varchar(15) = NULL,
	@InsuredPhoneExt varchar(10) = NULL,
	@InsuredFax varchar(15) = NULL,
	@InsuredEmail varchar(70) = NULL,
	@TreatingPhysicianAddr1 varchar(70) = NULL,
	@TreatingPhysicianCity varchar(70) = NULL,
	@TreatingPhysicianState varchar(5) = NULL,
	@TreatingPhysicianZip varchar(10) = NULL,
	@TreatingPhysicianPhone varchar(15) = NULL,
	@TreatingPhysicianPhoneExt varchar(10) = NULL,
	@TreatingPhysicianFax varchar(15) = NULL,
	@TreatingPhysicianEmail varchar(70) = NULL,
	@TreatingPhysicianDiagnosis varchar(70) = NULL,
	@EmployerAddr1 varchar(70) = NULL,
	@EmployerCity varchar(70) = NULL,
	@EmployerState varchar(5) = NULL,
	@EmployerZip varchar(10) = NULL,
	@EmployerPhone varchar(15) = NULL,
	@EmployerPhoneExt varchar(10) = NULL,
	@EmployerFax varchar(15) = NULL,
	@EmployerEmail varchar(70) = NULL,
	@policynumber varchar(70) = NULL,
	@EmployerContactFirstName varchar(50) = NULL,
	@EmployerContactLastName varchar(50) = NULL,
	@County varchar(50) = NULL,
	@MobilePhone varchar(15) = NULL,
	@WorkPhone varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblExaminee]
	SET
		[lastname] = @lastname,
		[firstname] = @firstname,
		[middleinitial] = @middleinitial,
		[addr1] = @addr1,
		[addr2] = @addr2,
		[city] = @city,
		[state] = @state,
		[zip] = @zip,
		[phone1] = @phone1,
		[phone2] = @phone2,
		[SSN] = @SSN,
		[sex] = @sex,
		[DOB] = @DOB,
		[dateadded] = @dateadded,
		[dateedited] = @dateedited,
		[useridadded] = @useridadded,
		[useridedited] = @useridedited,
		[note] = @note,
		[prefix] = @prefix,
		[fax] = @fax,
		[email] = @email,
		[insured] = @insured,
		[employer] = @employer,
		[treatingphysician] = @treatingphysician,
		[InsuredAddr1] = @InsuredAddr1,
		[InsuredCity] = @InsuredCity,
		[InsuredState] = @InsuredState,
		[InsuredZip] = @InsuredZip,
		[InsuredPhone] = @InsuredPhone,
		[InsuredPhoneExt] = @InsuredPhoneExt,
		[InsuredFax] = @InsuredFax,
		[InsuredEmail] = @InsuredEmail,
		[TreatingPhysicianAddr1] = @TreatingPhysicianAddr1,
		[TreatingPhysicianCity] = @TreatingPhysicianCity,
		[TreatingPhysicianState] = @TreatingPhysicianState,
		[TreatingPhysicianZip] = @TreatingPhysicianZip,
		[TreatingPhysicianPhone] = @TreatingPhysicianPhone,
		[TreatingPhysicianPhoneExt] = @TreatingPhysicianPhoneExt,
		[TreatingPhysicianFax] = @TreatingPhysicianFax,
		[TreatingPhysicianEmail] = @TreatingPhysicianEmail,
		[TreatingPhysicianDiagnosis] = @TreatingPhysicianDiagnosis,
		[EmployerAddr1] = @EmployerAddr1,
		[EmployerCity] = @EmployerCity,
		[EmployerState] = @EmployerState,
		[EmployerZip] = @EmployerZip,
		[EmployerPhone] = @EmployerPhone,
		[EmployerPhoneExt] = @EmployerPhoneExt,
		[EmployerFax] = @EmployerFax,
		[EmployerEmail] = @EmployerEmail,
		[policynumber] = @policynumber,
		[EmployerContactFirstName] = @EmployerContactFirstName,
		[EmployerContactLastName] = @EmployerContactLastName,
		[County] = @County,
		[MobilePhone] = @MobilePhone,
		[WorkPhone] = @WorkPhone
	WHERE
		[chartnbr] = @chartnbr


	SET @Err = @@Error


	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetLanguageComboItems]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO

ALTER PROCEDURE [proc_GetLanguageComboItems]

AS

SELECT DISTINCT * from tblLanguage ORDER BY Description
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[proc_CaseDocuments_LoadByCaseNbrProgressive]...';


GO
CREATE PROCEDURE [proc_CaseDocuments_LoadByCaseNbrProgressive]

@CaseNbr int,
@WebUserID int = NULL

AS

SELECT DISTINCT tblCaseDocuments.*, tblPublishOnWeb.PublishasPDF, ISNULL(tblPublishOnWeb.Viewed, 0) DocViewed, tblCaseDocType.Description as DocTypeDesc
	FROM tblCaseDocuments
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey 
			AND (tblPublishOnWeb.TableType = 'tblCaseDocuments')
			AND (tblPublishOnWeb.PublishOnWeb = 1)
			AND (tblPublishOnWeb.CaseNbr = @CaseNbr)
			AND (tblPublishOnWeb.UserType = 'CL')
		INNER JOIN tblCaseDocType on isnull(tblCaseDocuments.CaseDocTypeID,1) = tblCaseDocType.CaseDocTypeID

ORDER BY tblCaseDocuments.DateAdded DESC
GO
PRINT N'Creating [dbo].[proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCountProgressive]...';


GO
CREATE PROCEDURE [proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCountProgressive]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT COUNT(tblCaseDocuments.seqno)
	FROM tblCaseDocuments
	INNER JOIN tblCase ON tblCaseDocuments.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey
		WHERE tblPublishOnWeb.TableType = 'tblCaseDocuments'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblPublishOnWeb.UseWidget = 1)
		AND (tblCase.Status NOT IN (8,9))
GO
PRINT N'Creating [dbo].[proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive]...';


GO
CREATE PROCEDURE [proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseDocuments.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename,
	tblPublishOnWeb.PublishasPDF, tblCaseDocType.Description AS doctypedesc
	FROM tblCaseDocuments
		INNER JOIN tblCase ON tblCaseDocuments.casenbr = tblCase.Casenbr
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblPublishOnWeb ON tblCaseDocuments.seqno = tblPublishOnWeb.TableKey
		LEFT JOIN tblCaseDocType on tblCaseDocuments.CaseDocTypeID = tblCaseDocType.CaseDocTypeID
	WHERE (tblPublishOnWeb.TableType = 'tblCaseDocuments')
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblPublishOnWeb.UseWidget = 1)
		AND (tblCase.Status NOT IN (8,9))
GO
PRINT N'Creating [dbo].[proc_CaseHistory_LoadByCaseNbrProgressive]...';


GO
CREATE PROCEDURE [proc_CaseHistory_LoadByCaseNbrProgressive]

@CaseNbr int,
@WebUserID int = NULL,
@IsAdmin bit = 0

AS

IF @IsAdmin = 1
	BEGIN
		SELECT DISTINCT *
		FROM tblCaseHistory 
		WHERE tblCaseHistory.casenbr = @CaseNbr AND tblCaseHistory.PublishOnWeb = 1
	END
ELSE
	BEGIN
		SELECT DISTINCT * FROM tblCaseHistory 
			INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey 
				AND (tblPublishOnWeb.TableType = 'tblCaseHistory')
				AND (tblPublishOnWeb.PublishOnWeb = 1)
				AND (tblPublishOnWeb.UserType = 'CL')
				AND (tblPublishOnWeb.PublishOnWeb = 1)
				WHERE (tblCaseHistory.casenbr = @CaseNbr)
			ORDER BY tblCaseHistory.DateAdded DESC
	END
GO
PRINT N'Creating [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewed]...';


GO
CREATE PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewed]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT tblCaseHistory.*, claimnbr, tblExaminee.firstname + ' ' + tblExaminee.lastname AS examineename
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey
		WHERE tblPublishOnWeb.TableType = 'tblCaseHistory'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblCase.Status NOT IN (8,9))
GO
PRINT N'Creating [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewedCount]...';


GO
CREATE PROCEDURE [dbo].[proc_CaseHistory_LoadByWebUserIDAndViewedCount]

@LastLoginDate datetime,
@UserCode int,
@UserType char(2)

AS

SELECT DISTINCT COUNT(tblCaseHistory.id)
	FROM tblCaseHistory
	INNER JOIN tblCase ON tblCaseHistory.casenbr = tblCase.Casenbr
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblPublishOnWeb ON tblCaseHistory.id = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCaseHistory'
		WHERE tblPublishOnWeb.TableType = 'tblCaseHistory'
		AND (tblPublishOnWeb.PublishOnWeb = 1)
		AND (tblPublishOnWeb.UserCode = @UserCode)
		AND (tblPublishOnWeb.UserType = @UserType)
		AND (ISNULL(tblPublishOnWeb.Viewed, 0) = 0)
		AND (tblCase.Status NOT IN (8,9))
GO
PRINT N'Creating [dbo].[proc_GetActiveCasesProgressive]...';


GO
CREATE PROCEDURE [proc_GetActiveCasesProgressive]
@WebUserID int

AS 

SELECT DISTINCT
	COUNT(DISTINCT tblCase.CaseNbr) AS NbrofCases, 
	tblWebQueues.statuscode AS WebStatus, 
	tblWebQueues.description AS WebDescription, 
	tblWebQueues.displayorder
FROM tblCase
	INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode 
	INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode 
	INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey 
		AND tblPublishOnWeb.tabletype = 'tblCase'
		AND tblPublishOnWeb.PublishOnWeb = 1 
	INNER JOIN tblWebUser ON tblPublishOnWeb.UserCode = tblWebUser.IMECentricCode 
		AND tblPublishOnWeb.UserType = tblWebUser.UserType	
		AND tblWebUser.WebUserID = @WebUserID
WHERE (tblCase.status NOT IN (8,9))
GROUP BY 
	tblWebQueues.statuscode, 
	tblWebQueues.description, 
	tblWebQueues.displayorder
ORDER BY 
	tblWebQueues.displayorder
GO
PRINT N'Creating [dbo].[proc_GetApptCountByCase]...';


GO
CREATE PROCEDURE [proc_GetApptCountByCase]
(
	@CaseNbr int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT COUNT(*) 
		FROM tblCaseAppt 
			WHERE CaseNbr = @CaseNbr 
				AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetReferralSearchProgressive]...';


GO
CREATE PROCEDURE [proc_GetReferralSearchProgressive]

@CompanyCode int

AS

SET NOCOUNT OFF
DECLARE @Err int

	SELECT DISTINCT
		tblWebQueues.statuscode,
		tblCase.casenbr,
		tblCase.ExtCaseNbr,
		tblCase.DoctorName AS provider,
		CONVERT(varchar(20), tblCase.ApptDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, tblCase.ApptTime),7)  ApptDate,
		(SELECT COUNT(*) FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1) AS ApptCount,
		tblCase.chartnbr,
		tblCase.doctorspecialty as Specialty,
		tblServices.shortdesc AS service,
		tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename,
		tblExaminee.lastname,
		tblExaminee.firstname,
		tblWebQueues.description AS WebStatus,
		tblQueues.WebStatusCode,
		tblWebQueues.statuscode,
		tblCase.claimnbr,
		ISNULL(NULLIF(tblCase.sinternalcasenbr,''),tblCase.casenbr) AS webcontrolnbr
		FROM tblCase
		INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
		INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
		INNER JOIN tblWebQueues ON tblQueues.WebStatusCode = tblWebQueues.statuscode
		INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
		INNER JOIN tblclient on tblCase.clientcode = tblClient.clientcode
		INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
		INNER JOIN tblPublishOnWeb ON tblCase.casenbr = tblPublishOnWeb.tablekey
			AND tblPublishOnWeb.tabletype = 'tblCase'
			AND tblPublishOnWeb.PublishOnWeb = 1
			AND tblPublishOnWeb.UserType = 'CL'

	WHERE tblCase.ClientCode IN (SELECT ClientCode FROM tblClient WHERE tblClient.CompanyCode = @CompanyCode)

SET @Err = @@Error
RETURN @Err
GO
PRINT N'Creating [dbo].[proc_GetReferralSummaryNewProgressive]...';


GO
CREATE PROCEDURE [dbo].[proc_GetReferralSummaryNewProgressive]

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
		tblCase.doctorspecialty,
		(SELECT COUNT(*) FROM tblCaseAppt WHERE CaseNbr = tblCase.CaseNbr AND ISNULL(tblCaseAppt.CanceledByID, 0) <> 1) AS ApptCount,
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
		INNER JOIN tblWebUser ON tblPublishOnWeb.UserCode = tblWebUser.IMECentricCode
			AND tblPublishOnWeb.UserType = tblWebUser.UserType
			AND tblWebUser.WebUserID = @WebUserID
		WHERE (tblWebQueues.statuscode = @WebStatus)
		AND (tblCase.status NOT IN (8,9))

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetVenueComboItems]...';


GO
CREATE PROCEDURE [proc_GetVenueComboItems]

@State varchar(2)

AS

SELECT * FROM tblVenue WHERE State = @State ORDER BY County
GO

PRINT N'Creating [dbo].[proc_LoadCaseSearchProgressive]...';


GO
CREATE PROCEDURE [proc_LoadCaseSearchProgressive] 
(
	@ClaimNbr varchar(50),
	@LastName varchar(50),
	@CompanyCode int
)
AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @strSQL nvarchar(2000)
	DECLARE @modulo as NVARCHAR(5) = '%'

    SET @StrSQL = 'SELECT TOP 50 * FROM tblCase INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ' +
		'WHERE (tblCase.ClientCode IN (SELECT ClientCode FROM tblClient WHERE CompanyCode = ' + CAST(@CompanyCode AS VARCHAR(20)) + ')) '

		IF LEN(@ClaimNbr) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblCase.ClaimNbr LIKE ''' + @modulo + @ClaimNbr + @modulo + ''') '
		END 

		IF LEN(@LastName) > 0
		BEGIN
			SET @StrSQL = @StrSQL + 'AND (tblExaminee.LastName LIKE ''' + @modulo + @LastName + @modulo + ''') '
		END 

        SET @StrSQL = @StrSQL + ' ORDER BY tblCase.DateAdded DESC, tblCase.ClaimNbr, tblExaminee.LastName'

		PRINT @StrSQL
		
		BEGIN
			EXEC SP_EXECUTESQL @StrSQL
		END

	SET @Err = @@Error

	RETURN @Err
END
GO










PRINT N'Creating [dbo].[proc_Info_Hartford_MgtRpt_InitData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_InitData]
AS

--
-- Hartford Data Initialization
--

SET NOCOUNT ON 

-- Drop and create temp tables
IF OBJECT_ID('tempdb..##tmp_HartfordOfficeMap') IS NOT NULL DROP TABLE ##tmp_HartfordOfficeMap
IF OBJECT_ID('tempdb..##tmp_HartfordSpecialtyMap') IS NOT NULL DROP TABLE ##tmp_HartfordSpecialtyMap
IF OBJECT_ID('tempdb..##tmp_HartfordSubSpecialtyMap') IS NOT NULL DROP TABLE ##tmp_HartfordSubSpecialtyMap

-- Create Office Mapping Table
CREATE TABLE ##tmp_HartfordOfficeMap (
	Id INT NOT NULL Primary Key Identity (1,1),
	CurrentOfficeName VarChar(64),
	NewOfficeName VarChar(64),
	IsLawOffice bit 
)

-- Create Specialty Mapping Table
CREATE TABLE ##tmp_HartfordSpecialtyMap (
	Id INT NOT NULL Primary Key Identity (1,1),	
	CurrentSpecialtyName VarChar(64) NULL,
	NewSpecialtyName VarChar(64) NOT NULL
)

-- Create Sub-Specialty Mapping Table
create table ##tmp_HartfordSubSpecialtyMap (
	Id INT NOT NULL Primary Key Identity (1,1),	
	CurrentSpecialtyName VarChar(64) NULL,
	NewSpecialtyName VarChar(64) NOT NULL
)

-- Insert data into Office Mapping
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Linda S Baumann Law Offices - NJ East Windsor','PL-Northeast', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford Life and Disability - FL Maitland (CAR)','GB East', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse Specialized Unit (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - MD Hunt Valley (SEWCCC)','SEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - FL Lake Mary (SEWCCC)','SEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - TX Houston (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - TX San Antonio (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Diana Lee Khachaturian','PL-Central', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('John A. Hauser Law Offices - CA Brea','PL-Western', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CA Sacramento (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CA Rancho Cordova (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford Life and Disability - CA Sacramento','GB West	', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Law Office of Timothy Farley - OR Lake Oswego','PL-Western	', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - OR Lake Oswego (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - AZ Phoenix (WWCCC)','WWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Law Office of Timothy Farley - WA Seattle','PL-Western', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - AZ Phoenix (PL - Western)','PL - Western', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - IL Aurora (CWCCC)','CWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CT Hartford (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - NY Syracuse Remote (NEWCCC)','NEWCCC', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - CT Windsor (PL - Northeast)','PL - Northeast', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Stewart H. Friedman - NY Garden City','PL-Northeast', 1)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('The Hartford - ID Boise','The Hartford - ID Boise', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Hartford Underwriters Insurance Company - TX San Antonio','Hartford Underwriters Insurance Company - TX San Antonio', 0)
INSERT INTO ##tmp_HartfordOfficeMap VALUES ('Hartford Underwriters Insurance Company - KY Lexington','Hartford Underwriters Insurance Company - KY Lexington', 0)

-- Insert Data into Specialty Mapping
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Acupuncture', 'Acupuncture	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Allergy & Immunology', 'Allergy 	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Anesthesiology', 'Anesthesiology	')
-- INSERT INTO ##tmp_HartfordSpecialtyMap VALUES (0, '', 'Bariatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Cardiology', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Cardiovascular Surgery', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Chiropractic Medicine', 'Chiropractic Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Dentistry', 'Dentistry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Dermatology', 'Dermatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Emergency Medicine', 'Emergency Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Endocrinology', 'Endocrinology 	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('', 'FAA Aviation Medical Examiner	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Family Medicine', 'Family Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Gastroenterology', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Gastroenterology - Pediatrics', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Geriatric Medicine - Family Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Geriatric Medicine - Internal Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Hematology', 'Hematology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Hepatology', 'Hepatology	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('', 'Immunology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Infectious Disease', 'Infectious Disease	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Internal Medicine', 'Internal Medicine	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('', 'Low Vision	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Nephrology', 'Nephrology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurological Surgery', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuro-ophthalmology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropharmacology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neurophysiology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychiatry', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychiatry - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuropsychology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Neuroradiology', 'Neurology')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Obstetrics & Gynecology', 'Obstetrics/Gynecology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Occupational Medicine', 'Occupational Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Oncology', 'Oncology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Ophthalmology', 'Ophthalmology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Oncology', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Surgery', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Orthopaedic Surgery - Pediatrics', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Otolaryngology', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Otolaryngology - Pediatrics', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Anesthesiology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Neurology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pain Medicine - Physical Medicine & Rehabilitation', 'Pain Management	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Physical Medicine & Rehabilitation', 'Physical Medicine & Rehabilitation	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Physical Therapy', 'Physical Therapy	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Podiatry', 'Podiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Preventive Medicine', 'Preventative Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry - Forensic', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychiatry - Pediatrics', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Psychology', 'Psychology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Pulmonary Disease', 'Pulmonology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Rheumatology', 'Rheumatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Family Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Internal Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Sleep Medicine - Otolaryngology', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Spine Surgery - Neurological Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Spine Surgery - Orthopaedic Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Toxicology - Aerospace Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Toxicology - Emergency Medicine', 'Toxicology	')
--INSERT INTO ##tmp_HartfordSpecialtyMap VALUES (0, '', 'Transplant Hepatology	')
INSERT INTO ##tmp_HartfordSpecialtyMap VALUES ('Urology', 'Urology	')


-- Insert Data into Sub-Specialty Mapping
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Acupuncture', 'Acupuncture	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Allergy & Immunology', 'Allergy 	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Anesthesiology', 'Anesthesiology	')
-- INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES (0, '', 'Bariatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Cardiology', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Cardiovascular Surgery', 'Cardiovascular Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Chiropractic Medicine', 'Chiropractic Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Dentistry', 'Dentistry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Dermatology', 'Dermatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Emergency Medicine', 'Emergency Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Endocrinology', 'Endocrinology 	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('', 'FAA Aviation Medical Examiner	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Family Medicine', 'Family Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Gastroenterology', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Gastroenterology - Pediatrics', 'Gastroenterology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Geriatric Medicine - Family Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Geriatric Medicine - Internal Medicine', 'Geriatric Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Hematology', 'Hematology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Hepatology', 'Hepatology	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('', 'Immunology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Infectious Disease', 'Infectious Disease	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Internal Medicine', 'Internal Medicine	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('', 'Low Vision	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Nephrology', 'Nephrology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurological Surgery', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuro-ophthalmology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropharmacology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neurophysiology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychiatry', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychiatry - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuropsychology - Pediatrics', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Neuroradiology', 'Neurology')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Obstetrics & Gynecology', 'Obstetrics/Gynecology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Occupational Medicine', 'Occupational Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Oncology', 'Oncology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Ophthalmology', 'Ophthalmology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Oncology', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Surgery', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Orthopaedic Surgery - Pediatrics', 'Orthopaedics	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Otolaryngology', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Otolaryngology - Pediatrics', 'Otolaryngology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Anesthesiology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Neurology', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pain Medicine - Physical Medicine & Rehabilitation', 'Pain Management	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Physical Medicine & Rehabilitation', 'Physical Medicine & Rehabilitation	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Physical Therapy', 'Physical Therapy	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Podiatry', 'Podiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Preventive Medicine', 'Preventative Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry - Forensic', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychiatry - Pediatrics', 'Psychiatry	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Psychology', 'Psychology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Pulmonary Disease', 'Pulmonology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Rheumatology', 'Rheumatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Family Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Internal Medicine', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Sleep Medicine - Otolaryngology', 'Sleep Medicine	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Spine Surgery - Neurological Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Spine Surgery - Orthopaedic Surgery', 'Surgery	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Toxicology - Aerospace Medicine', 'Toxicology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Toxicology - Emergency Medicine', 'Toxicology	')
--INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES (0, '', 'Transplant Hepatology	')
INSERT INTO ##tmp_HartfordSubSpecialtyMap VALUES ('Urology', 'Urology	')

print 'Temp tables created'

SET NOCOUNT OFF
GO
PRINT N'Creating [dbo].[proc_Info_Hartford_MgtRpt_PatchData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_PatchData]
AS

--
-- Hartford Data patching 
--

set nocount on 

Print 'Fixing up Company Names'

-- fix up the Company Names 
UPDATE hi SET hi.IntName = isnull(hm.NewOfficeName, hi.IntName), hi.LitOrAppeal = IIF(hm.IsLawOffice = 1, 'Litigation', 'NA')
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordOfficeMap as hm on hi.IntName = hm.CurrentOfficeName

Print 'Fixing up Specialties and Sub-Specialties'
-- fix up the specialities
UPDATE hi SET hi.Specialty = isnull(sm.NewSpecialtyName, hi.Specialty)
	from ##tmp_HartfordInvoices as hi
	left outer join ##tmp_HartfordSpecialtyMap as sm on hi.Specialty = sm.CurrentSpecialtyName

-- fix up the sub-specialities
UPDATE hi SET hi.SubSpecialty = isnull(ssm.NewSpecialtyName, hi.SubSpecialty)
	from ##tmp_HartfordInvoices as hi
 	left outer join ##tmp_HartfordSubSpecialtyMap as ssm on hi.SubSpecialty = ssm.CurrentSpecialtyName
	
Print 'Fixing up Service Types'
UPDATE hi SET hi.ServiceType = CASE 
								WHEN hi.ServiceType like '%Independent Medical%' THEN 'IME'								
								WHEN hi.ServiceType like '%Doctor%' THEN 'FCE'
								WHEN hi.ServiceType like '%IME%' THEN 'IME'								
								WHEN hi.ServiceType like '%FCE%' THEN 'Addendum - FCE'								
								WHEN hi.ServiceType like '%Review%' THEN 'MRR'
								WHEN hi.ServiceType like '%Re-Eval%' THEN 'Addendum - IME'
								WHEN hi.ServiceType like '%Addendum%' THEN 'Addendum - IME'
								ELSE hi.ServiceType 
							  END
FROM ##tmp_HartfordInvoices as hi

Print 'Fixing up Line of Business'
UPDATE hi SET hi.LOB = CASE hi.LOB
						WHEN '1' THEN 'PL'
						WHEN '2' THEN 'PL'
						WHEN '3' THEN 'P&C'
						WHEN '4' THEN 'GBC'
						WHEN '5' THEN 'PL'
						ELSE ''
                       END
FROM ##tmp_HartfordInvoices as hi


Print 'Fixing up Coverage Types'
UPDATE hi SET hi.CoverageType = CASE 
									WHEN hi.CoverageType = 'Workers Comp' THEN 'WC'
									WHEN hi.CoverageType like '%auto%' THEN 'Auto'
									WHEN hi.CoverageType = 'Liability' THEN 'Auto'
									WHEN hi.CoverageType = 'Disability' THEN 'LTD'									
									ELSE 'Other'
								END
from ##tmp_HartfordInvoices as hi

Print 'Fixing up Network and Juris TAT'
UPDATE hi SET hi.InOutNetwork = CASE 
									WHEN hi.InOutNetwork = '1' THEN 'Out'
									WHEN hi.InOutNetwork = '2' THEN 'In'
									ELSE ''
								END,
		      hi.JurisTAT = CASE 
								WHEN hi.ServiceVariance > 0 THEN 'No'
								ELSE 'Yes'				
		                    END			  
FROM ##tmp_HartfordInvoices as hi

Print 'Set Service Variance to NULL (per the spec)'
UPDATE hi SET ServiceVariance = NULL 
  FROM ##tmp_HartfordInvoices as hi
  
Print 'Getting Exception Data'
UPDATE hi SET hi.PrimaryException = CASE 
									WHEN (SRD.DisplayOrder = 1 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
									ELSE ''
								 END,
			  hi.SecondaryException = CASE
									WHEN (SRD.DisplayOrder = 2 AND CSRD.SLAExceptionID IS NOT NULL) THEN ISNULL(SE.ExternalCode, '') 
								    ELSE ''
								 END,
			  Comments = ISNULL(Comments, '') + ISNULL(SE.Descrip + ' ', '')

FROM ##tmp_HartfordInvoices as hi
	LEFT OUTER JOIN tblSLARule as SR on hi.SLARuleID = SR.SLARuleID
	LEFT OUTER JOIN tblSLARuleDetail as SRD on SR.SLARuleID = SRD.SLARuleID
	LEFT OUTER JOIN tblCaseSLARuleDetail as CSRD ON (hi.CaseNbr = CSRD.CaseNbr AND SRD.SLARuleDetailID = CSRD.SLARuleDetailID)
	LEFT OUTER JOIN tblSLAException as SE ON CSRD.SLAExceptionID = SE.SLAExceptionID
	

Print 'Update Primary and Secondary Exceptions'
UPDATE hi SET PrimaryDriver = CASE 
									WHEN hi.PrimaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.PrimaryException = 'CL' THEN 'Provider'
									WHEN hi.PrimaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.PrimaryException = 'NS' THEN 'Claimant'
									WHEN hi.PrimaryException = 'SA' THEN 'Provider'
									WHEN hi.PrimaryException = 'SR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'AR' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'C' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.PrimaryException = 'NA' THEN 'NA'
                                 END,
				SecondaryDriver = CASE 
									WHEN hi.SecondaryException = 'ATTY' THEN 'Attorney'
									WHEN hi.SecondaryException = 'CL' THEN 'Provider'
									WHEN hi.SecondaryException = 'J' THEN 'Jurisdictional'
									WHEN hi.SecondaryException = 'NS' THEN 'Claimant'
									WHEN hi.SecondaryException = 'SA' THEN 'Provider'
									WHEN hi.SecondaryException = 'SR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'AR' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'C' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'EXT' THEN 'Referral Source'
									WHEN hi.SecondaryException = 'NA' THEN 'NA'
                                 END
FROM ##tmp_HartfordInvoices as hi

-- return file result set
select * 
	from ##tmp_HartfordInvoices

set nocount off
GO
PRINT N'Creating [dbo].[proc_Info_Hartford_MgtRpt_QueryData]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt_QueryData]
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
	CAST(ISNULL(NW.EWNetworkID, '0') AS CHAR(2)) as "InOutNetwork",
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


PRINT N'Creating [dbo].[proc_Info_Hartford_MgtRpt]...';


GO
CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
	EXEC [dbo].[proc_Info_Hartford_MgtRpt_InitData]
	EXEC [dbo].[proc_Info_Hartford_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList
	EXEC [dbo].[proc_Info_Hartford_MgtRpt_PatchData]
GO








-- Issue 7104 - some new items used to imlement the "Envelope Formatting verified" check
INSERT INTO  tblUserFunction (FunctionCode, FunctionDesc, DateAdded) 
VALUES ('DocEditEnvelopeReady', 'Documents - Modify Envelope Setting', GetDate())
GO
-- TODO: fill in a semi-colon delimited list of office codes that you want to enable the setting for
INSERT INTO tblSetting (Name, Value)
VALUES('EnvelopeDocFormatOffices', ';24;28;')
GO 

-- Issue 7475 - create new EDI Power User group
INSERT INTO tblUserGroup VALUES ('0-EDIPowerUser', '0 - EDI Power User')
GO
-- Issue 7475 - create new security token
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc, DateAdded) Values('ResubmitEDIBatch', 'EDI - Resubmit EDI Batch', getdate())
GO
-- Issue 7475 - add token to group
INSERT INTO tblGroupFunction VALUES ('0-EDIPowerUser', 'ResubmitEDIBatch')
GO


-- Issue 7566 - New text fields and bookmark for progressive
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@ProgressiveClaimantNotes@','') 
 
INSERT INTO tblMessageToken (Name,Description) 
VALUES ('@ProgressiveInsuranceNotes@','') 
Go  





INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc,
    DateAdded
)
VALUES
(   'RptProgressiveRpts',       -- FunctionCode - varchar(30)
    'Report - Progressive Reports',       -- FunctionDesc - varchar(50)
    GETDATE() -- DateAdded - date
)
GO






UPDATE C SET C.ReExamNoticePrintedDate=CD.DateAdded
 FROM tblCase AS C
 INNER JOIN tblOffice AS O ON O.OfficeCode = C.OfficeCode
 INNER JOIN tblIMEData AS I ON I.IMECode = O.IMECode
 INNER JOIN tblCaseDocuments AS CD ON CD.CaseNbr = C.CaseNbr AND CD.Document = I.ReExamNoticeDocument
 WHERE C.ReExamNoticePrinted=1
GO


UPDATE C SET C.PreviousCaseNbr=(SELECT TOP 1 LC.CaseNbr FROM tblCase AS LC WHERE C.MasterCaseNbr=LC.MasterCaseNbr AND C.CaseNbr>LC.CaseNbr ORDER BY LC.CaseNbr DESC)
 FROM tblCase AS C
 WHERE C.IsReExam=1
GO






UPDATE tblControl SET DBVersion='3.37'
GO