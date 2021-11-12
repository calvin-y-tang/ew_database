CREATE TABLE [dbo].[GPInvoiceAdjustment] (
    [PrimaryKey]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SourceID]           INT          NULL,
    [FormatVersion]      INT          NOT NULL,
    [ProcessedFlag]      BIT          NOT NULL,
    [ExportDate]         DATETIME     NOT NULL,
    [AdjNo]              VARCHAR (13) NOT NULL,
    [AdjDate]            DATETIME     NOT NULL,
    [DocumentNo]         VARCHAR (15) NULL,
    [GPFacilityID]       VARCHAR (3)  NOT NULL,
    [GPNaturalAccount]   VARCHAR (5)  NOT NULL,
    [GPGLAccount]        VARCHAR (16) NOT NULL,
    [GPCustomerID]       VARCHAR (15) NOT NULL,
    [ClientID]           INT          NOT NULL,
    [ClaimNo]            VARCHAR (50) NULL,
    [CaseNo]             VARCHAR (15) NULL,
    [Examinee]           VARCHAR (50) NULL,
    [BatchNo]            VARCHAR (15) NOT NULL,
    [TaxTotal]           MONEY        NULL,
    [AdjAmount]          MONEY        NOT NULL,
    [ReasonCode]         INT          NULL,
    [Comment]            VARCHAR (30) NULL,
    [Employer]           VARCHAR (70) NULL,
    [DocumentTaxCode1]   VARCHAR (15) NULL,
    [DocumentTaxCode2]   VARCHAR (15) NULL,
    [DocumentTaxCode3]   VARCHAR (15) NULL,
    [DocumentTaxCode4]   VARCHAR (15) NULL,
    [DocumentTaxCode5]   VARCHAR (15) NULL,
    [DocumentTaxCode6]   VARCHAR (15) NULL,
    [DocumentTaxCode7]   VARCHAR (15) NULL,
    [DocumentTaxCode8]   VARCHAR (15) NULL,
    [DocumentTaxAmount1] MONEY        NULL,
    [DocumentTaxAmount2] MONEY        NULL,
    [DocumentTaxAmount3] MONEY        NULL,
    [DocumentTaxAmount4] MONEY        NULL,
    [DocumentTaxAmount5] MONEY        NULL,
    [DocumentTaxAmount6] MONEY        NULL,
    [DocumentTaxAmount7] MONEY        NULL,
    [DocumentTaxAmount8] MONEY        NULL,
    CONSTRAINT [PK_GPInvoiceAdjustment] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GPInvoiceAdjustment_FormatVersionProcessedFlagAdjNoGPFacilityIDAdjAmount]
    ON [dbo].[GPInvoiceAdjustment]([FormatVersion] ASC, [ProcessedFlag] ASC, [AdjNo] ASC, [GPFacilityID] ASC, [AdjAmount] ASC);

