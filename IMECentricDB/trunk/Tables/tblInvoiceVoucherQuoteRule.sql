CREATE TABLE [dbo].[tblInvoiceVoucherQuoteRule](
	[InvoiceVoucherQuoteRuleID]     [int] IDENTITY(1,1) NOT NULL,
	[ProcessOrder]					[int]			NOT NULL,
	[CompanyCode]					[int]			NOT NULL,
	[CaseType]						[int]			NULL,
	[Jurisdiction]					[varchar](2)	NULL,
	[EWServiceTypeID]				[int]			NULL,
	[QuoteDocument]				    [varchar] (15)	NOT NULL,
	[eQuoteRequiredWhenScheduled]	[bit]			NOT NULL,
	[Exclude]						[bit]			NOT NULL,
	[QuoteType]						[int]			NOT NULL,
	[ParentCompanyID]				[int]			NOT NULL,
	[Handling]                      [varchar] (20)  NOT NULL,
 CONSTRAINT [PK_tblInvoiceEQuoteFormatFormRule] PRIMARY KEY CLUSTERED 
(
	[InvoiceVoucherQuoteRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



