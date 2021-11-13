CREATE TABLE [dbo].[tblCaseNF10] (
    [CaseNbr]                 INT            NOT NULL,
    [NF10TemplateID]          INT            NOT NULL,
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
    [ExamineeName]            VARCHAR (100)  NULL,
    [ExamineeAddress]         VARCHAR (100)  NULL,
    [NF10Date]                DATETIME       NULL,
    CONSTRAINT [PK_tblCaseNF10] PRIMARY KEY CLUSTERED ([CaseNbr] ASC)
);

