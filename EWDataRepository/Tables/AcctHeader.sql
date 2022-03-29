CREATE TABLE [dbo].[AcctHeader] (
    [HeaderID]         INT             IDENTITY (1, 1) NOT NULL,
    [SourceID]         INT             NULL,
    [DocumentType]     VARCHAR (2)     NULL,
    [DocumentNo]       VARCHAR (15)    NULL,
    [DocumentDate]     DATETIME        NULL,
    [InvoiceNo]        VARCHAR (15)    NULL,
    [ServiceDate]      DATETIME        NULL,
    [EWFacilityID]     INT             NULL,
    [EWLocationID]     INT             NULL,
    [CompanyID]        INT             NULL,
    [ClientID]         INT             NULL,
    [DoctorID]         INT             NULL,
    [ClaimNo]          VARCHAR (50)    NULL,
    [EWBusLineID]      INT             NULL,
    [CaseNo]           VARCHAR (15)    NULL,
    [Examinee]         VARCHAR (50)    NULL,
    [BatchNo]          INT             NULL,
    [TaxTotal]         MONEY           NULL,
    [DocumentTotal]    MONEY           NULL,
    [MonetaryUnit]     INT             NULL,
    [ExchangeRate]     DECIMAL (15, 7) NULL,
    [DocumentTotalUS]  MONEY           NULL,
    [User]             VARCHAR (25)    NULL,
    [Marketer]         VARCHAR (30)    NULL,
    [Office]           VARCHAR (15)    NULL,
    [GPExportStatus]   INT             NULL,
    [ServiceAddress]   VARCHAR (50)    NULL,
    [ServiceCity]      VARCHAR (35)    NULL,
    [ServiceState]     VARCHAR (3)     NULL,
    [ServiceZip]       VARCHAR (10)    NULL,
    [RptFinalizedDate] DATETIME        NULL,
    [ProcessingType]   INT             NULL,
    [CheckNo]          VARCHAR (20)    NULL,
    [Jurisdiction]     VARCHAR (5)     NULL,
    [Employer]         VARCHAR (70)    NULL,
    [ClientRefNo]      VARCHAR (20)    NULL,
    [IsEInvoice]       BIT             NULL,
    [ReferralMethod]   INT             NULL,
    [Plaintiff]        VARCHAR (200)   NULL,
    [Defendant]        VARCHAR (200)   NULL,
    [Comment]          VARCHAR (30)    NULL,
    [RefCompanyID]     INT             NULL,
    [RefClientID]      INT             NULL,
    [SalesRep]         VARCHAR (30)    NULL,
    [AccountMgr]       VARCHAR (30)    NULL,
    [Hierarchy]        VARCHAR (255)   NULL,
    [Service]          VARCHAR (50)    NULL,
    [LOB]              VARCHAR (60)    NULL,
    [TaxCode1]         VARCHAR (15)    NULL,
    [TaxCode2]         VARCHAR (15)    NULL,
    [TaxCode3]         VARCHAR (15)    NULL,
    [TaxCode4]         VARCHAR (15)    NULL,
    [TaxCode5]         VARCHAR (15)    NULL,
    [TaxCode6]         VARCHAR (15)    NULL,
    [TaxCode7]         VARCHAR (15)    NULL,
    [TaxCode8]         VARCHAR (15)    NULL,
    [TaxAmount1]       MONEY           NULL,
    [TaxAmount2]       MONEY           NULL,
    [TaxAmount3]       MONEY           NULL,
    [TaxAmount4]       MONEY           NULL,
    [TaxAmount5]       MONEY           NULL,
    [TaxAmount6]       MONEY           NULL,
    [TaxAmount7]       MONEY           NULL,
    [TaxAmount8]       MONEY           NULL,
    [CaseDocID]        INT             NULL,
	[ClientRefNo2]     VARCHAR (50)    NULL,
    CONSTRAINT [PK_AcctHeader] PRIMARY KEY CLUSTERED ([HeaderID] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [IX_AcctHeader_DocumentDate]
    ON [dbo].[AcctHeader]([DocumentDate] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_AcctHeader_EWFacilityIDDocumentTypeDocumentNo]
    ON [dbo].[AcctHeader]([EWFacilityID] ASC, [DocumentType] ASC, [DocumentNo] ASC);

