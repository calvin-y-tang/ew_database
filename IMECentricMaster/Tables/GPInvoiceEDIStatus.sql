CREATE TABLE [dbo].[GPInvoiceEDIStatus] (
    [PrimaryKey]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SourceID]         INT           NULL,
    [FormatVersion]    INT           NOT NULL,
    [ProcessedFlag]    BIT           NOT NULL,
    [ExportDate]       DATETIME      NOT NULL,
    [GPCustomerID]     VARCHAR (15)  NOT NULL,
    [ClientID]         INT           NOT NULL,
    [GPFacilityID]     VARCHAR (3)   NULL,
    [DocumentNo]       VARCHAR (15)  NOT NULL,
    [EDIStatus]        VARCHAR (15)  NULL,
    [EDINote]          VARCHAR (250) NULL,
    [ClientContractNo] INT           NULL,
    [ClientName]       VARCHAR (100) NULL,
    [ICN]              VARCHAR (32)  NULL,
    CONSTRAINT [PK_GPInvoiceEDIStatus] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GPInvoiceEDIStatus_FormatVersionExportDate]
    ON [dbo].[GPInvoiceEDIStatus]([FormatVersion] ASC, [ExportDate] ASC);

