CREATE TABLE [dbo].[AcctAdjustment] (
    [AdjID]             INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SourceID]          INT             NULL,
    [AdjNo]             VARCHAR (15)    NULL,
    [AdjDate]           DATETIME        NULL,
    [DocumentType]      VARCHAR (2)     NULL,
    [HeaderID]          INT             NULL,
    [EWFacilityID]      INT             NULL,
    [EWLocationID]      INT             NULL,
    [CompanyID]         INT             NULL,
    [ClientID]          INT             NULL,
    [DoctorID]          INT             NULL,
    [ClaimNo]           VARCHAR (50)    NULL,
    [EWBusLineID]       INT             NULL,
    [EWFlashCategoryID] INT             NULL,
    [CaseNo]            VARCHAR (15)    NULL,
    [Examinee]          VARCHAR (50)    NULL,
    [BatchNo]           INT             NULL,
    [TaxTotal]          MONEY           NULL,
    [AdjAmount]         MONEY           NULL,
    [MonetaryUnit]      INT             NULL,
    [ExchangeRate]      DECIMAL (15, 7) NULL,
    [AdjAmountUS]       MONEY           NULL,
    [User]              VARCHAR (25)    NULL,
    [Marketer]          VARCHAR (30)    NULL,
    [Office]            VARCHAR (15)    NULL,
    [ReasonCode]        INT             NULL,
    [GLNaturalAccount]  VARCHAR (5)     NULL,
    [Comment]           VARCHAR (30)    NULL,
    [GPExportStatus]    INT             NULL,
    [ProcessingType]    INT             NULL,
    [Employer]          VARCHAR (70)    NULL,
    [TaxCode1]          VARCHAR (10)    NULL,
    [TaxCode2]          VARCHAR (10)    NULL,
    [TaxCode3]          VARCHAR (10)    NULL,
    [TaxCode4]          VARCHAR (10)    NULL,
    [TaxCode5]          VARCHAR (10)    NULL,
    [TaxCode6]          VARCHAR (10)    NULL,
    [TaxCode7]          VARCHAR (10)    NULL,
    [TaxCode8]          VARCHAR (10)    NULL,
    [TaxAmount1]        MONEY           NULL,
    [TaxAmount2]        MONEY           NULL,
    [TaxAmount3]        MONEY           NULL,
    [TaxAmount4]        MONEY           NULL,
    [TaxAmount5]        MONEY           NULL,
    [TaxAmount6]        MONEY           NULL,
    [TaxAmount7]        MONEY           NULL,
    [TaxAmount8]        MONEY           NULL,
    CONSTRAINT [PK_AcctAdjustment] PRIMARY KEY CLUSTERED ([AdjID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_AcctAdjustment]
    ON [dbo].[AcctAdjustment]([HeaderID] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_AcctAdjustment_AdjDateEWFacilityIDDocumentType]
    ON [dbo].[AcctAdjustment]([AdjDate] ASC, [EWFacilityID] ASC, [DocumentType] ASC);


GO
CREATE NONCLUSTERED INDEX [AdjNo_DocumentType_EWFacilityID]
    ON [dbo].[AcctAdjustment]([AdjNo] ASC, [DocumentType] ASC, [EWFacilityID] ASC);

