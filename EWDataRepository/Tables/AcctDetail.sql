CREATE TABLE [dbo].[AcctDetail] (
    [DetailID]          INT             IDENTITY (1, 1) NOT NULL,
    [HeaderID]          INT             NULL,
    [LineNo]            INT             NULL,
    [SourceID]          INT             NULL,
    [EWServiceTypeID]   INT             NULL,
    [ProductCode]       VARCHAR (30)    NULL,
    [Descrip]           VARCHAR (70)    NULL,
    [Qty]               DECIMAL (10, 2) NULL,
    [QtyUnit]           INT             NULL,
    [Amount]            MONEY           NULL,
    [ExtAmount]         MONEY           NULL,
    [ExtAmountUS]       MONEY           NULL,
    [Taxable]           BIT             NULL,
    [DetailType]        VARCHAR (10)    NULL,
    [EWFlashCategoryID] INT             NULL,
    [GLNaturalAccount]  VARCHAR (5)     NULL,
    CONSTRAINT [PK_AcctDetail] PRIMARY KEY CLUSTERED ([DetailID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_AcctDetail_HeaderID]
    ON [dbo].[AcctDetail]([HeaderID] ASC);

