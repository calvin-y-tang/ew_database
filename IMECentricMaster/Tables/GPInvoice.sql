CREATE TABLE [dbo].[GPInvoice] (
    [PrimaryKey]         INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FormatVersion]      INT             NOT NULL,
    [ProcessedFlag]      BIT             NOT NULL,
    [ExportDate]         DATETIME        NOT NULL,
    [BatchNo]            VARCHAR (15)    NOT NULL,
    [GPCustomerID]       VARCHAR (15)    NOT NULL,
    [ClientID]           INT             NOT NULL,
    [DocumentNo]         VARCHAR (15)    NOT NULL,
    [DocumentDate]       DATETIME        NOT NULL,
    [DocumentTotal]      MONEY           NOT NULL,
    [DocumentTaxCode1]   VARCHAR (15)    NULL,
    [DocumentTaxCode2]   VARCHAR (15)    NULL,
    [DocumentTaxCode3]   VARCHAR (15)    NULL,
    [DocumentTaxAmount1] MONEY           NULL,
    [DocumentTaxAmount2] MONEY           NULL,
    [DocumentTaxAmount3] MONEY           NULL,
    [LineNo]             INT             NOT NULL,
    [LineCount]          INT             NOT NULL,
    [Taxable]            BIT             CONSTRAINT [DF_GPInvoice_Taxable] DEFAULT ((0)) NOT NULL,
    [Amount]             MONEY           NOT NULL,
    [Qty]                DECIMAL (10, 2) NOT NULL,
    [Descrip]            VARCHAR (70)    NULL,
    [GPGLAccount]        VARCHAR (16)    NOT NULL,
    [GPFacilityID]       VARCHAR (3)     NOT NULL,
    [GPNaturalAccount]   VARCHAR (5)     NOT NULL,
    [Examinee]           VARCHAR (50)    NULL,
    [ClaimNo]            VARCHAR (50)    NULL,
    [CaseNo]             VARCHAR (15)    NULL,
    [ServiceDate]        DATETIME        NULL,
    [RefNo]              VARCHAR (50)    NULL,
    [Service]            VARCHAR (20)    NULL,
    [ServiceAddress]     VARCHAR (50)    NULL,
    [ServiceCity]        VARCHAR (35)    NULL,
    [ServiceState]       VARCHAR (2)     NULL,
    [ServiceZip]         VARCHAR (10)    NULL,
    [SourceID]           INT             NULL,
    [ProcessingType]     INT             NULL,
    [RptFinalizedDate]   DATETIME        NULL,
    [ProductCode]        VARCHAR (30)    NULL,
    [Employer]           VARCHAR (70)    NULL,
    [EWBusLineID]        INT             NULL,
    [IsEInvoice]         BIT             NULL,
    [ReferralMethod]     INT             NULL,
    [Marketer]           VARCHAR (30)    NULL,
    [Plaintiff]          VARCHAR (200)   NULL,
    [Defendant]          VARCHAR (200)   NULL,
    [TaxTotal]           MONEY           NULL,
    [GPTermsID]          INT             NULL,
    [CaseDocID]          INT             NULL,
    [Market]             VARCHAR (30)    NULL,
    [RefGPCustomerID]    VARCHAR (15)    NULL,
    [RefClientID]        INT             NULL,
    [SalesRep]           VARCHAR (30)    NULL,
    [AccountMgr]         VARCHAR (30)    NULL,
    [Hierarchy]          VARCHAR (255)   NULL,
    [LOB]                VARCHAR (60)    NULL,
    [EWServiceTypeID]    INT             NULL,
    [Jurisdiction]       VARCHAR (5)     NULL,
    [DocumentTaxCode4]   VARCHAR (15)    NULL,
    [DocumentTaxCode5]   VARCHAR (15)    NULL,
    [DocumentTaxCode6]   VARCHAR (15)    NULL,
    [DocumentTaxCode7]   VARCHAR (15)    NULL,
    [DocumentTaxCode8]   VARCHAR (15)    NULL,
    [DocumentTaxAmount4] MONEY           NULL,
    [DocumentTaxAmount5] MONEY           NULL,
    [DocumentTaxAmount6] MONEY           NULL,
    [DocumentTaxAmount7] MONEY           NULL,
    [DocumentTaxAmount8] MONEY           NULL,
    [ClientRefNo2]       VARCHAR (50)    NULL,
    [ObjectID]           VARCHAR (30)    NULL,
    [InsuredName]        VARCHAR (100)   NULL,
    [CaseName]           VARCHAR (200)   NULL,
    [LitCaseNo]          VARCHAR (100)   NULL,
    [LocationName]       VARCHAR (100)   NULL,
    [LocationState]      VARCHAR (2)     NULL,
    [LocationType]       VARCHAR (30)    NULL,
    [ReleaseType]        VARCHAR (100)   NULL, 
    CONSTRAINT [PK_GPInvoice] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_GPInvoice_FormatVersionProcessedFlagDocumentTotal]
    ON [dbo].[GPInvoice]([FormatVersion] ASC, [ProcessedFlag] ASC, [DocumentTotal] ASC)
    INCLUDE([GPCustomerID], [DocumentNo], [Amount], [Qty], [GPFacilityID]);


GO
CREATE NONCLUSTERED INDEX [IX_GPInvoice_ProcessedFlagDocumentNoGPFacilityID]
    ON [dbo].[GPInvoice]([ProcessedFlag] ASC, [DocumentNo] ASC, [GPFacilityID] ASC)
    INCLUDE([PrimaryKey]);


GO
CREATE NONCLUSTERED INDEX [IX_GPInvoice_FormatVersionExportDate]
    ON [dbo].[GPInvoice]([FormatVersion] ASC, [ExportDate] ASC);

