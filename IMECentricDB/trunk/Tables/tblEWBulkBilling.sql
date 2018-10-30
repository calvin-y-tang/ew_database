CREATE TABLE [dbo].[tblEWBulkBilling] (
    [BulkBillingID]        INT            NOT NULL,
    [Descrip]              VARCHAR (25)   NULL,
    [CreateInvDocument]    BIT            NULL,
    [AutoPrint]            BIT            NULL,
    [UseEDIExport]         BIT            NULL,
    [EDIExportFormat]      VARCHAR (32)   NULL,
    [EDIExportType]        VARCHAR (32)   NULL,
    [EDIExportToGPFirst]   BIT            CONSTRAINT [DF_tblEWBulkBilling_EDIExportToGPFirst] DEFAULT ((0)) NULL,
    [EDIExportAutoBatch]   BIT            CONSTRAINT [DF_tblEWBulkBilling_EDIExportAutoBatch] DEFAULT ((0)) NULL,
    [EDIERPCaseRequired]   BIT            NULL,
    [EDIRequireAttachment] BIT            CONSTRAINT [DF_tblEWBulkBilling_EDIRequireAttachment] DEFAULT ((0)) NULL,
    [EDICustomParam]       VARCHAR (1024) NULL,
    [EDIShowClaimLookup]   BIT            CONSTRAINT [DF_tblEWBulkBilling_EDIShowClaimLookup] DEFAULT ((0)) NULL,
    [Param] VARCHAR(1024) NULL, 
	[EDITransmitNote] BIT NULL,
    CONSTRAINT [PK_tblEWBulkBilling] PRIMARY KEY CLUSTERED ([BulkBillingID] ASC)
);

