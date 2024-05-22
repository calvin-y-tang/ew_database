CREATE TABLE [dbo].[tblAcctDetail] (
    [LineNbr]                INT             NOT NULL,
    [Date]                   DATETIME        NULL,
    [ProdCode]               INT             NULL,
    [CPTCode]                VARCHAR (20)    NULL,
    [LongDesc]               VARCHAR (1000)  NULL,
    [Unit]                   NUMERIC (10, 2) NULL,
    [UnitAmount]             MONEY           NULL,
    [ExtendedAmount]         MONEY           NULL,
    [Taxable]                BIT             NULL,
    [DateAdded]              DATETIME        NULL,
    [UserIDAdded]            VARCHAR (20)    NULL,
    [DateEdited]             DATETIME        NULL,
    [UserIDEdited]           VARCHAR (20)    NULL,
    [Modifier]               VARCHAR (15)    NULL,
    [Type]                   VARCHAR (10)    NULL,
    [Location]               VARCHAR (10)    NULL,
    [DrOPCode]               INT             NULL,
    [GLAcct]                 VARCHAR (50)    NULL,
    [Modifier2]              VARCHAR (15)    NULL,
    [Modifier3]              VARCHAR (15)    NULL,
    [Modifier4]              VARCHAR (15)    NULL,
    [SuppInfo]               VARCHAR (100)   NULL,
    [UnitOfMeasureCode]      VARCHAR (5)     NULL,
    [HCAIProviderOccupation] VARCHAR (50)    NULL,
    [ExtAmountUS]            MONEY           NULL,
    [RetailAmount]           MONEY           NULL,
    [GLNaturalAccount]       VARCHAR (5)     NULL,
    [DetailID]               INT             IDENTITY (1, 1) NOT NULL,
    [HeaderID]               INT             NULL,
    [FeeCode]                INT             NULL,
	[FeeCodeSource]          INT             NULL,
    [FSDetailID]             INT             NULL,
	[FeeScheduleName]        VARCHAR(100)    NULL,
	[RptFSSource]            INT             NULL,
    [RptFSGroupID]           INT             NULL,
    [RptFSDetailID]          INT             NULL,
    [RptFeeAmt]              MONEY           NULL,
    [ToDate]                 DateTime        NULL,
    CONSTRAINT [PK_tblAcctDetail] PRIMARY KEY CLUSTERED ([DetailID] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [IX_tblAcctDetail_HeaderIDLineNbr]
    ON [dbo].[tblAcctDetail]([HeaderID] ASC, [LineNbr] ASC);

