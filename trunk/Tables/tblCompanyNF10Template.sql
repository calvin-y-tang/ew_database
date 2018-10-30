CREATE TABLE [dbo].[tblCompanyNF10Template] (
    [NF10TemplateID]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]                    VARCHAR (25)   NULL,
    [CompanyCode]             INT            NOT NULL,
    [Document]                VARCHAR (15)   NULL,
    [EntireClaimDenied]       BIT            NOT NULL,
    [PartialDenied]           BIT            NOT NULL,
    [LossEarningsDenied]      BIT            NOT NULL,
    [LossEarningsAmt]         VARCHAR (20)   NULL,
    [HealthBenefitDenied]     BIT            NOT NULL,
    [HealthBenefitAmt]        VARCHAR (20)   NULL,
    [NecessaryExpensesDenied] BIT            NOT NULL,
    [NecessaryExpensesAmt]    VARCHAR (20)   NULL,
    [ReasonDenied]            VARCHAR (1000) NULL,
    CONSTRAINT [PK_tblCompanyNF10Template] PRIMARY KEY CLUSTERED ([NF10TemplateID] ASC)
);

