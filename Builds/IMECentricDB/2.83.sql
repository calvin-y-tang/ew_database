ALTER TABLE [dbo].[tblExceptionDefEntity]
    ADD [Entity] VARCHAR (10) NULL;
GO

ALTER TABLE [dbo].[tblControl]
    ADD [SearchResultLimit] INT CONSTRAINT [DF_tblControl_SearchResultLimit] DEFAULT ((0)) NOT NULL;
GO
update tblcontrol set searchresultlimit = 5000
GO




ALTER TABLE [dbo].[tblEWTransDept]
    ADD [EWTimeZoneID] INT NULL;
GO



PRINT N'Creating [dbo].[tblServiceWorkflow]...';


GO
CREATE TABLE [dbo].[tblServiceWorkflow] (
    [ServiceWorkflowID]     INT          IDENTITY (1, 1) NOT NULL,
    [OfficeCode]            INT          NOT NULL,
    [CaseType]              INT          NOT NULL,
    [ServiceCode]           INT          NOT NULL,
    [UserIDAdded]           VARCHAR (15) NULL,
    [DateAdded]             DATETIME     NULL,
    [UserIDEdited]          VARCHAR (15) NULL,
    [DateEdited]            DATETIME     NULL,
    [ExamineeAddrReqd]      BIT          NOT NULL,
    [ExamineeSSNReqd]       BIT          NOT NULL,
    [AttorneyReqd]          BIT          NOT NULL,
    [DOIRqd]                BIT          NOT NULL,
    [ClaimNbrRqd]           BIT          NOT NULL,
    [JurisdictionRqd]       BIT          NOT NULL,
    [EmployerRqd]           BIT          NOT NULL,
    [TreatingPhysicianRqd]  BIT          NOT NULL,
    [CalcFrom]              VARCHAR (10) NULL,
    [DaysToForecastDate]    INT          NULL,
    [DaysToInternalDueDate] INT          NULL,
    [DaysToExternalDueDate] INT          NULL,
    CONSTRAINT [PK_tblServiceWorkflow] PRIMARY KEY CLUSTERED ([ServiceWorkflowID] ASC)
);


GO
PRINT N'Creating [dbo].[tblServiceWorkflowQueue]...';


GO
CREATE TABLE [dbo].[tblServiceWorkflowQueue] (
    [ServiceWorkflowQueueID] INT          IDENTITY (1, 1) NOT NULL,
    [ServiceWorkflowID]      INT          NOT NULL,
    [DateAdded]              DATETIME     NULL,
    [DateEdited]             DATETIME     NULL,
    [UserIDAdded]            VARCHAR (20) NULL,
    [UserIDEdited]           VARCHAR (20) NULL,
    [QueueOrder]             INT          NOT NULL,
    [StatusCode]             INT          NOT NULL,
    [NextStatus]             INT          NOT NULL,
    [CreateVoucher]          BIT          NOT NULL,
    [CreateInvoice]          BIT          NOT NULL,
    CONSTRAINT [PK_tblServiceWorkflowQueue] PRIMARY KEY CLUSTERED ([ServiceWorkflowQueueID] ASC)
);


GO
PRINT N'Creating [dbo].[tblServiceWorkflowQueueDocument]...';


GO
CREATE TABLE [dbo].[tblServiceWorkflowQueueDocument] (
    [ServiceWorkflowQueueDocumentID] INT          IDENTITY (1, 1) NOT NULL,
    [ServiceWorkflowQueueID]         INT          NOT NULL,
    [DateAdded]                      DATETIME     NULL,
    [UserIDAdded]                    VARCHAR (15) NULL,
    [DateEdited]                     DATETIME     NULL,
    [UserIDEdited]                   VARCHAR (15) NULL,
    [Document]                       VARCHAR (15) NOT NULL,
    [Attachment]                     VARCHAR (15) NULL,
    [ProcessOrder]                   INT          NULL,
    [PrintCopies]                    INT          NULL,
    [EmailDoctor]                    BIT          NULL,
    [EmailAttorney]                  BIT          NULL,
    [EmailClient]                    BIT          NULL,
    [FaxDoctor]                      BIT          NULL,
    [FaxAttorney]                    BIT          NULL,
    [FaxClient]                      BIT          NULL,
    [PublishOnWeb]                   BIT          NULL,
    [PublishedTo]                    VARCHAR (50) NULL,
    CONSTRAINT [PK_tblServiceWorkflowQueueDocument] PRIMARY KEY CLUSTERED ([ServiceWorkflowQueueDocumentID] ASC)
);


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_AttorneyReqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_AttorneyReqd] DEFAULT ((0)) FOR [AttorneyReqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_ClaimNbrRqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_ClaimNbrRqd] DEFAULT ((0)) FOR [ClaimNbrRqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_DOIRqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_DOIRqd] DEFAULT ((0)) FOR [DOIRqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_EmployerRqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_EmployerRqd] DEFAULT ((0)) FOR [EmployerRqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_ExamineeAddrReqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_ExamineeAddrReqd] DEFAULT ((0)) FOR [ExamineeAddrReqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_ExamineeSSNReqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_ExamineeSSNReqd] DEFAULT ((0)) FOR [ExamineeSSNReqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_JurisdictionRqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_JurisdictionRqd] DEFAULT ((0)) FOR [JurisdictionRqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflow_TreatingPhysicianRqd]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflow]
    ADD CONSTRAINT [DF_tblServiceWorkflow_TreatingPhysicianRqd] DEFAULT ((0)) FOR [TreatingPhysicianRqd];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflowQueue_CreateInvoice]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflowQueue]
    ADD CONSTRAINT [DF_tblServiceWorkflowQueue_CreateInvoice] DEFAULT ((0)) FOR [CreateInvoice];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflowQueue_CreateVoucher]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflowQueue]
    ADD CONSTRAINT [DF_tblServiceWorkflowQueue_CreateVoucher] DEFAULT ((0)) FOR [CreateVoucher];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflowQueueDocument_PrintCopies]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflowQueueDocument]
    ADD CONSTRAINT [DF_tblServiceWorkflowQueueDocument_PrintCopies] DEFAULT ((0)) FOR [PrintCopies];


GO
PRINT N'Creating [dbo].[DF_tblServiceWorkflowQueueDocument_PublishOnWeb]...';


GO
ALTER TABLE [dbo].[tblServiceWorkflowQueueDocument]
    ADD CONSTRAINT [DF_tblServiceWorkflowQueueDocument_PublishOnWeb] DEFAULT ((0)) FOR [PublishOnWeb];


GO
PRINT N'Creating [dbo].[vwServiceWorkflow]...';


GO
CREATE VIEW vwServiceWorkflow
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
        WFQ.QueueCount,
        CT.Description AS CaseTypeDesc,
        CT.Status AS CaseTypeStatus,
        S.Description AS ServiceDesc,
        S.Status AS ServiceStatus,
        S.ApptBased,
        S.ShowLegalTabOnCase,
        O.Description AS OfficeDesc,
        O.Status AS OfficeStatus
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
PRINT N'Creating [dbo].[vwServiceWorkflowQueue]...';


GO
CREATE VIEW vwServiceWorkflowQueue
AS
    SELECT
        WFQ.ServiceWorkflowQueueID,
        WFQ.ServiceWorkflowID,
        WFQ.DateAdded,
        WFQ.DateEdited,
        WFQ.UserIDAdded,
        WFQ.UserIDEdited,
        WFQ.QueueOrder,
        WFQ.StatusCode,
        WFQ.NextStatus,
        WFQ.CreateVoucher,
        WFQ.CreateInvoice,
        WF.OfficeCode,
        WF.CaseType,
        WF.ServiceCode,
        WF.CaseTypeDesc,
        WF.CaseTypeStatus,
        WF.ServiceDesc,
        WF.ServiceStatus,
        WF.OfficeDesc,
        WF.OfficeStatus,
        Q.DisplayOrder,
        Q.StatusDesc AS QueueDesc,
        Q.ShortDesc,
        WFQD.DocCount
    FROM
        tblServiceWorkflowQueue AS WFQ
    INNER JOIN vwServiceWorkflow AS WF ON WF.ServiceWorkflowID=WFQ.ServiceWorkflowID
    INNER JOIN tblQueues AS Q ON Q.StatusCode=WFQ.StatusCode
    LEFT OUTER JOIN (
                     SELECT
                        ServiceWorkflowQueueID,
                        COUNT(ServiceWorkflowQueueDocumentID) AS DocCount
                     FROM
                        tblServiceWorkflowQueueDocument
                     GROUP BY
                        ServiceWorkflowQueueID
                    ) AS WFQD ON WFQD.ServiceWorkflowQueueID=WFQ.ServiceWorkflowQueueID
GO
PRINT N'Creating [dbo].[vwServiceWorkflowQueueDocument]...';


GO
CREATE VIEW vwServiceWorkflowQueueDocument
AS
    SELECT
        WFQD.ServiceWorkflowQueueDocumentID,
        WFQ.ServiceWorkflowQueueID,
        WF.ServiceWorkflowID,
        WF.ServiceCode,
        WF.CaseType,
        WF.OfficeCode,
        WFQ.StatusCode,
        WFQD.Document,
        WFQD.Attachment,
        WFQD.ProcessOrder,
        WFQD.PrintCopies,
        WFQD.EmailDoctor,
        WFQD.EmailAttorney,
        WFQD.EmailClient,
        WFQD.FaxDoctor,
        WFQD.FaxAttorney,
        WFQD.FaxClient
    FROM
        tblServiceWorkflowQueueDocument AS WFQD
    INNER JOIN tblServiceWorkflowQueue AS WFQ ON WFQ.ServiceWorkflowQueueID=WFQD.ServiceWorkflowQueueID
    INNER JOIN tblServiceWorkflow AS WF ON WF.ServiceWorkflowID=WFQ.ServiceWorkflowID
GO

UPDATE tblControl SET DBVersion='2.83'
GO