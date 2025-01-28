PRINT N'Dropping [dbo].[tblAcctingTrans].[IX_tblAcctingTrans_StatusCode]...';


GO
DROP INDEX [IX_tblAcctingTrans_StatusCode]
    ON [dbo].[tblAcctingTrans];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_DateAddedOfficeCodeStatus]...';


GO
DROP INDEX [IX_tblCase_DateAddedOfficeCodeStatus]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCodeStatus]...';


GO
DROP INDEX [IX_tblCase_OfficeCodeStatus]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_ApptDate]...';


GO
DROP INDEX [IX_tblCase_ApptDate]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCodeReExamReExamProcessedReExamDateClientCode]...';


GO
DROP INDEX [IX_tblCase_OfficeCodeReExamReExamProcessedReExamDateClientCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCodeStatusDateReceived]...';


GO
DROP INDEX [IX_tblCase_OfficeCodeStatusDateReceived]
    ON [dbo].[tblCase];


GO
PRINT N'Creating [dbo].[tblAcctingTrans].[IX_tblAcctingTrans_StatusCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctingTrans_StatusCode]
    ON [dbo].[tblAcctingTrans]([StatusCode] ASC)
    INCLUDE([CaseNbr]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_DateAddedOfficeCodeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateAddedOfficeCodeStatus]
    ON [dbo].[tblCase]([DateAdded] ASC, [OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation], [MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode], [CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatus]
    ON [dbo].[tblCase]([OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation], [MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode], [CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_ApptDateOfficeCodeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_ApptDateOfficeCodeStatus]
    ON [dbo].[tblCase]([ApptDate] ASC, [OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation], [MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode], [CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_DateReceivedOfficeCodeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateReceivedOfficeCodeStatus]
    ON [dbo].[tblCase]([DateReceived] ASC, [OfficeCode] ASC, [Status] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation], [MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode], [CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeReExamReExamProcessedReExamDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeReExamReExamProcessedReExamDate]
    ON [dbo].[tblCase]([OfficeCode] ASC, [ReExam] ASC, [ReExamProcessed] ASC, [ReExamDate] ASC)
    INCLUDE([ChartNbr], [CompanyCode], [ClientCode], [DoctorCode], [DoctorLocation], [MarketerCode], [SchedulerCode], [QARep], [Priority], [CaseType], [ServiceCode], [CaseNbr], [ExtCaseNbr], [Jurisdiction], [EWReferralType], [InputSourceID], [ApptTime], [ForecastDate]);


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
			Q.DisplayOrder
    FROM    tblAcctingTrans AS AT
            INNER JOIN tblCase AS C ON AT.CaseNbr = C.CaseNbr
			INNER JOIN tblQueues AS Q ON Q.StatusCode = AT.StatusCode
    WHERE   AT.StatusCode <> 20;
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
            OfficeCode ,
            C.QARep ,
			C.CaseType ,
			C.ServiceCode ,
			C.ReExam ,
			C.ReExamProcessed ,
			C.ReExamDate
    FROM    tblCase AS C
GO
PRINT N'Altering [dbo].[vwCaseMonitorDetail]...';


GO
ALTER VIEW vwCaseMonitorDetail
AS
    SELECT
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
        Q.DisplayOrder
    FROM
        tblCase AS C
    INNER JOIN tblQueues AS Q ON Q.StatusCode=C.Status
    WHERE
        C.Status NOT IN (8, 9, -100)
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
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.clientcode = tblCase.clientcode
            INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            INNER JOIN tblServices ON tblServices.servicecode = tblCase.servicecode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblQueues ON tblQueues.statuscode = tblCase.status
GO



UPDATE tblControl SET DBVersion='2.97'
GO
