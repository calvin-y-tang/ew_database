CREATE TABLE [dbo].[GPVoucher] (
    [PrimaryKey]         INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FormatVersion]      INT             NOT NULL,
    [ProcessedFlag]      BIT             NOT NULL,
    [ExportDate]         DATETIME        NOT NULL,
    [BatchNo]            VARCHAR (15)    NOT NULL,
    [GPVendorID]         VARCHAR (15)    NOT NULL,
    [DocumentNo]         VARCHAR (15)    NOT NULL,
    [DocumentDate]       DATETIME        NOT NULL,
    [DocumentTotal]      MONEY           NOT NULL,
    [DocumentTaxCode1]   VARCHAR (10)    NULL,
    [DocumentTaxCode2]   VARCHAR (10)    NULL,
    [DocumentTaxCode3]   VARCHAR (10)    NULL,
    [DocumentTaxAmount1] MONEY           NULL,
    [DocumentTaxAmount2] MONEY           NULL,
    [DocumentTaxAmount3] MONEY           NULL,
    [LineNo]             INT             NOT NULL,
    [LineCount]          INT             NOT NULL,
    [Taxable]            BIT             CONSTRAINT [DF_GPVoucher_Taxable] DEFAULT ((0)) NOT NULL,
    [Amount]             MONEY           NOT NULL,
    [Qty]                DECIMAL (10, 2) NOT NULL,
    [Descrip]            VARCHAR (70)    NULL,
    [GPGLAccount]        VARCHAR (16)    NOT NULL,
    [GPFacilityID]       VARCHAR (3)     NOT NULL,
    [GPNaturalAccount]   VARCHAR (5)     NOT NULL,
    [Examinee]           VARCHAR (50)    NULL,
    [ClaimNo]            VARCHAR (50)    NULL,
    [CaseNo]             VARCHAR (15)    NOT NULL,
    [ServiceDate]        DATETIME        NULL,
    [InvoiceNo]          VARCHAR (15)    NULL,
    [RefNo]              VARCHAR (50)    NULL,
    [Service]            VARCHAR (20)    NULL,
    [SourceID]           INT             NULL,
    [CheckNo]            VARCHAR (20)    NULL,
    [ProcessingType]     INT             NULL,
    [ProductCode]        VARCHAR (30)    NULL,
    [Employer]           VARCHAR (70)    NULL,
    [EWBusLineID]        INT             NULL,
    [Comment]            VARCHAR (30)    NULL,
    [LOB]                VARCHAR (60)    NULL,
    CONSTRAINT [PK_GPVoucher] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GPVoucher_GPVendorIDDocumentNo]
    ON [dbo].[GPVoucher]([GPVendorID] ASC, [DocumentNo] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_GPVoucher_ProcessedFlagDocumentNoGPFacilityID]
    ON [dbo].[GPVoucher]([ProcessedFlag] ASC, [DocumentNo] ASC, [GPFacilityID] ASC)
    INCLUDE([PrimaryKey]);


GO
CREATE NONCLUSTERED INDEX [IX_GPVoucher_FormatVersionExportDate]
    ON [dbo].[GPVoucher]([FormatVersion] ASC, [ExportDate] ASC);

