CREATE TABLE [dbo].[ISExtIntegration] (
    [ExtIntegrationID] INT            NOT NULL,
    [Name]             VARCHAR (25)   NULL,
    [Type]             VARCHAR (25)   NULL,
    [Active]           BIT            CONSTRAINT [DF_ISExtIntegration_Active] DEFAULT ((0)) NOT NULL,
    [SrcPath]          VARCHAR (256)  NULL,
    [DestPath]         VARCHAR (256)  NULL,
    [BackupDays]       INT            NULL,
    [CompanyID]        INT            NULL,
    [LastBatchNo]      INT            NULL,
    [LastBatchDate]    DATETIME       NULL,
    [NotifyEmail]      VARCHAR (140)  NULL,
    [Param]            VARCHAR (3072) NULL,
    CONSTRAINT [PK_ISExtIntegration] PRIMARY KEY CLUSTERED ([ExtIntegrationID] ASC)
);

