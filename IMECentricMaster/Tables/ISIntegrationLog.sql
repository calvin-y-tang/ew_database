CREATE TABLE [dbo].[ISIntegrationLog] (
    [IntegrationLogID]     INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IntegrationID]        INT          NOT NULL,
    [TaskName]             VARCHAR (10) NULL,
    [ProcessID]            VARCHAR (50) NULL,
    [ProcessDate]          DATETIME     NOT NULL,
    [ProcessDateCompleted] DATETIME     NULL,
    [BatchNo]              INT          NULL,
    [BatchFileDate]        DATETIME     NULL,
    [Result]               TEXT         NULL,
    [ErrorCount]           INT          CONSTRAINT [DF_ISIntegrationLog_ErrorCount] DEFAULT ((0)) NOT NULL,
    [CompanyCount]         INT          CONSTRAINT [DF_ISIntegrationLog_CompanyCount] DEFAULT ((0)) NOT NULL,
    [ClientCount]          INT          CONSTRAINT [DF_ISIntegrationLog_ClientCount] DEFAULT ((0)) NOT NULL,
    [DoctorCount]          INT          CONSTRAINT [DF_ISIntegrationLog_DoctorCount] DEFAULT ((0)) NOT NULL,
    [InvoiceCount]         INT          CONSTRAINT [DF_ISIntegrationLog_InvoiceCount] DEFAULT ((0)) NOT NULL,
    [VoucherCount]         INT          CONSTRAINT [DF_ISIntegrationLog_VoucherCount] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ISIntegrationLog] PRIMARY KEY CLUSTERED ([IntegrationLogID] ASC)
);

