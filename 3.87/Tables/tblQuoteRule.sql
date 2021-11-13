CREATE TABLE [dbo].[tblQuoteRule](
	[QuoteRuleID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessOrder] [int] NOT NULL,
	[QuoteType] [int] NOT NULL,
	[QuoteHandlingID] [int] NOT NULL,
	[Jurisdiction] [varchar](2) NULL,
	[ParentCompanyID] [int] NULL,
	[CompanyCode] [int] NULL,
	[EWServiceTypeID] [int] NULL,
	[CaseType] [int] NULL,
	[QuoteDocument] [varchar](15) NULL,
	[Required] [bit] NOT NULL,
	[Exclude] [bit] NOT NULL,
	[DateAdded] [datetime] NULL,
	[UserIDAdded] [varchar](15) NULL,
	[DateEdited] [datetime] NULL,
	[UserIDEdited] [varchar](15) NULL,
    [EWSelected]           BIT           CONSTRAINT [DF_tblQuoteRule_EWSelected] DEFAULT ((0)) NULL,
    [InNetwork]            BIT           CONSTRAINT [DF_tblQuoteRule_InNetwork]  DEFAULT ((0)) NULL,
 CONSTRAINT [PK_tblQuoteRule] PRIMARY KEY CLUSTERED ([QuoteRuleID] ASC)
);

