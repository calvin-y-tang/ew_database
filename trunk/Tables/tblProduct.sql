CREATE TABLE [dbo].[tblProduct] (
    [ProdCode]              INT           IDENTITY (1, 1) NOT NULL,
    [Description]           VARCHAR (70)  NULL,
    [LongDesc]              VARCHAR (512) NULL,
    [CPTCode]               VARCHAR (20)  NULL,
    [Status]                VARCHAR (50)  CONSTRAINT [DF_tblproduct_status] DEFAULT ('Active') NULL,
    [Taxable]               BIT           CONSTRAINT [DF_tblproduct_taxable] DEFAULT (0) NULL,
    [INGLAcct]              VARCHAR (50)  NULL,
    [VOGLAcct]              VARCHAR (50)  NULL,
    [DateAdded]             DATETIME      NULL,
    [DateEdited]            DATETIME      NULL,
    [UserIDAdded]           VARCHAR (20)  NULL,
    [UserIDEdited]          VARCHAR (20)  NULL,
    [Modifier]              VARCHAR (15)  NULL,
    [CPTCodeNoShow]         VARCHAR (20)  NULL,
    [CPTCodeCancel]         VARCHAR (20)  NULL,
    [Location]              VARCHAR (10)  NULL,
    [XferToVoucher]         BIT           NULL,
    [QBItemName]            VARCHAR (20)  NULL,
    [Modifier2]             VARCHAR (15)  NULL,
    [Modifier3]             VARCHAR (15)  NULL,
    [Modifier4]             VARCHAR (15)  NULL,
    [UnitOfMeasureCode]     VARCHAR (5)   NULL,
    [AllowVoNegativeAmount] BIT           NULL,
    [AllowInvoice]          BIT           CONSTRAINT [DF_tblProduct_AllowInvoice] DEFAULT ((0)) NOT NULL,
    [AllowVoucher]          BIT           CONSTRAINT [DF_tblProduct_AllowVoucher] DEFAULT ((0)) NOT NULL,
    [IsStandard]            BIT           CONSTRAINT [DF_tblProduct_IsStandard] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_tblproduct] PRIMARY KEY CLUSTERED ([ProdCode] ASC) WITH (FILLFACTOR = 90)
);






GO
CREATE NONCLUSTERED INDEX [IX_tblProduct_Description]
    ON [dbo].[tblProduct]([Description] ASC);

