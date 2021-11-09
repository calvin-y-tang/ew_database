CREATE TABLE [dbo].[EWBulkBilling] (
    [BulkBillingID]        INT            NOT NULL,
    [Descrip]              VARCHAR (25)   NULL,
    [CreateInvDocument]    BIT            NULL,
    [AutoPrint]            BIT            NULL,
    [EDIExportToGPFirst]   BIT            CONSTRAINT [DF_EWBulkBilling_EDIExportToGPFirst] DEFAULT ((0)) NULL,
    [EDIExportAutoBatch]   BIT            CONSTRAINT [DF_EWBulkBilling_EDIExportAutoBatch] DEFAULT ((0)) NULL,
    [UseEDIExport]         BIT            NULL,
    [EDIExportFormat]      VARCHAR (32)   NULL,
    [EDIExportType]        VARCHAR (32)   NULL,
    [EDIERPCaseRequired]   BIT            NULL,
    [EDIRequireAttachment] BIT            CONSTRAINT [DF_EWBulkBilling_EDIRequireAttachment] DEFAULT ((0)) NULL,
    [EDICustomParam]       VARCHAR (1024) NULL,
    [EDIShowClaimLookup]   BIT            CONSTRAINT [DF_EWBulkBilling_EDIShowClaimLookup] DEFAULT ((0)) NULL,
    [Param]                VARCHAR (1024) NULL,
    CONSTRAINT [PK_EWBulkBilling] PRIMARY KEY CLUSTERED ([BulkBillingID] ASC)
);

