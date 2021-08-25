CREATE TABLE [dbo].[tblCaseTrans] (
    [CaseNbr]              INT             NOT NULL,
    [LineNbr]              INT             NOT NULL,
    [Type]                 VARCHAR (2)     NOT NULL,
    [Date]                 DATETIME        NULL,
    [ProdCode]             INT             NULL,
    [CPTCode]              VARCHAR (20)    NULL,
    [LongDesc]             VARCHAR (1000)  NULL,
    [unit]                 NUMERIC (18, 2) NULL,
    [unitAmount]           MONEY           NULL,
    [extendedAmount]       MONEY           NULL,
    [Taxable]              BIT             NULL,
    [DateAdded]            DATETIME        NULL,
    [UserIDAdded]          VARCHAR (20)    NULL,
    [DateEdited]           DATETIME        NULL,
    [UserIDEdited]         VARCHAR (20)    NULL,
    [DrOPCode]             INT             NULL,
    [DrOPType]             VARCHAR (5)     NULL,
    [SeqNo]                INT             IDENTITY (1, 1) NOT NULL,
    [LineItemType]         VARCHAR (10)    NULL,
    [Location]             VARCHAR (10)    NULL,
    [UnitOfMeasureCode]    VARCHAR (5)     NULL,
    [CreateInvoiceVoucher] BIT             CONSTRAINT [DF_tblCaseTrans_CreateInvoiceVoucher] DEFAULT ((0)) NULL,
    [HeaderID]             INT             NULL,
    [FeeCode]              INT             NULL,
	[FeeCodeSource]        INT             NULL,
    [FSDetailID]           INT             NULL,
	[FeeScheduleName]      VARCHAR(100)    NULL,
	[RptFSSource]          INT             NULL,
    [RptFSGroupID]         INT             NULL,
    [RptFSDetailID]        INT             NULL,
    [RptFeeAmt]            MONEY           NULL,
    CONSTRAINT [PK_TblCaseTrans] PRIMARY KEY CLUSTERED ([SeqNo] ASC) WITH (FILLFACTOR = 90)
);




GO
CREATE NONCLUSTERED INDEX [IX_tblCaseTrans_CaseNbr]
    ON [dbo].[tblCaseTrans]([CaseNbr] ASC);

