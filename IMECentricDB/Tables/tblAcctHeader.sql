CREATE TABLE [dbo].[tblAcctHeader] (
    [DocumentNbr]           INT             NOT NULL,
    [DocumentDate]          DATETIME        NULL,
    [DocumentType]          VARCHAR (10)    NOT NULL,
    [DocumentStatus]        VARCHAR (10)    CONSTRAINT [DF_tblAcctHeader_DocumentStatus] DEFAULT ('Draft') NULL,
    [TaxCode]               VARCHAR (10)    NULL,
    [Address]               VARCHAR (512)   NULL,
    [Terms]                 VARCHAR (20)    NULL,
    [ClaimNbr]              VARCHAR (50)    NULL,
    [Client]                VARCHAR (50)    NULL,
    [ClientAcctKey]         VARCHAR (20)    NULL,
    [CaseNbr]               INT             NULL,
    [Examinee]              VARCHAR (50)    NULL,
    [Doctor]                VARCHAR (100)   NULL,
    [ApptDate]              DATETIME        NULL,
    [Finalized]             DATETIME        NULL,
    [UserIDFinalized]       VARCHAR (20)    NULL,
    [BatchNbr]              INT             NULL,
    [ExportDate]            DATETIME        NULL,
    [TaxTotal]              MONEY           NULL,
    [DocumentTotal]         MONEY           NULL,
    [DateAdded]             DATETIME        NULL,
    [UserIDAdded]           VARCHAR (20)    NULL,
    [DateEdited]            DATETIME        NULL,
    [UserIDEdited]          VARCHAR (20)    NULL,
    [INBatchSelect]         BIT             CONSTRAINT [DF_TblAcctHeader_INBatchSelect] DEFAULT (0) NULL,
    [VOBatchSelect]         BIT             CONSTRAINT [DF_TblAcctHeader_VOBatchSelect] DEFAULT (0) NULL,
    [Message]               VARCHAR (255)   NULL,
    [ClientrefNbr]          VARCHAR (50)    NULL,
    [DocumentCode]          VARCHAR (15)    NULL,
    [OfficeCode]            INT             NULL,
    [DrOpCode]              INT             NULL,
    [DrOpType]              VARCHAR (5)     NULL,
    [TaxCode1]              VARCHAR (10)    NULL,
    [TaxCode2]              VARCHAR (10)    NULL,
    [TaxCode3]              VARCHAR (10)    NULL,
    [TaxAmount1]            MONEY           NULL,
    [TaxAmount2]            MONEY           NULL,
    [TaxAmount3]            MONEY           NULL,
    [FeeCode]               INT             NULL,
    [SeqNo]                 INT             NULL,
    [CompanyCode]           INT             NULL,
    [ClientCode]            INT             NULL,
    [EWFacilityID]          INT             NULL,
    [EWLocationID]          INT             NULL,
    [HCAIDocumentNumber]    VARCHAR (60)    NULL,
    [HCAIBatchNumber]       INT             NULL,
    [HCAIInsurerID]         VARCHAR (50)    NULL,
    [HCAIBranchID]          VARCHAR (50)    NULL,
    [EDIBatchNbr]           INT             NULL,
    [MonetaryUnit]          INT             NULL,
    [ExchangeRate]          DECIMAL (15, 7) NULL,
    [DocumentTotalUS]       MONEY           NULL,
    [ServiceAddress]        VARCHAR (50)    NULL,
    [ServiceCity]           VARCHAR (35)    NULL,
    [ServiceState]          VARCHAR (2)     NULL,
    [ServiceZip]            VARCHAR (10)    NULL,
    [EDILastStatusChg]      DATETIME        NULL,
    [EDIStatus]             VARCHAR (16)    NULL,
    [EDIRejectedMsg]        VARCHAR (256)   NULL,
    [CaseApptID]            INT             NULL,
    [ApptStatusID]          INT             NULL,
    [CaseDocID]             INT             NULL,
    [EDISubmissionCount]    INT             NULL,
    [EDISubmissionDateTime] DATETIME        NULL,
    [FeeExplanation]        VARCHAR (90)    NULL,
    [IsEInvoice]            BIT             NULL,
    [HeaderID]              INT             IDENTITY (1, 1) NOT NULL,
    [RelatedInvHeaderID]    INT             NULL,
    [BulkBillingID]         INT             NULL,
    [FeeCodeSource]         INT             NULL,
    [TaxOfficeCode]         INT             NULL,
    [TaxCode4]              VARCHAR (10)    NULL,
    [TaxCode5]              VARCHAR (10)    NULL,
    [TaxCode6]              VARCHAR (10)    NULL,
    [TaxCode7]              VARCHAR (10)    NULL,
    [TaxCode8]              VARCHAR (10)    NULL,
    [TaxAmount4]            MONEY           NULL,
    [TaxAmount5]            MONEY           NULL,
    [TaxAmount6]            MONEY           NULL,
    [TaxAmount7]            MONEY           NULL,
    [TaxAmount8]            MONEY           NULL,
    [TaxHandling]           INT             NULL,
    CONSTRAINT [PK_tblAcctHeader] PRIMARY KEY CLUSTERED ([HeaderID] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_SeqNo]
    ON [dbo].[tblAcctHeader]([SeqNo] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_DocumentNbrDocumentTypeEWFacilityID]
    ON [dbo].[tblAcctHeader]([DocumentNbr] ASC, [DocumentType] ASC, [EWFacilityID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_DocumentTypeDocumentStatusDocumentDate]
    ON [dbo].[tblAcctHeader]([DocumentType] ASC, [DocumentStatus] ASC, [DocumentDate] ASC)
    INCLUDE([CaseNbr], [CompanyCode], [HeaderID]);


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_CaseNbr]
    ON [dbo].[tblAcctHeader]([CaseNbr] ASC);


GO


CREATE INDEX [IX_tblAcctHeader_CaseDocID] ON [dbo].[tblAcctHeader] ([CaseDocID])

GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_EWFacilityID]
    ON [dbo].[tblAcctHeader]([EWFacilityID] ASC)
    INCLUDE([DocumentNbr], [CaseDocID]);


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctHeader_DocumentTypeDocumentStatusCompanyCode]
    ON [dbo].[tblAcctHeader]([DocumentType] ASC, [DocumentStatus] ASC, [CompanyCode] ASC)
    INCLUDE([DocumentNbr], [DocumentDate], [CaseNbr], [DocumentTotal], [DocumentCode], [ClientCode], [EWFacilityID], [BulkBillingID]);

