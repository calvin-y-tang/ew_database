CREATE TABLE [dbo].[EWBudgetFlashCategory] (
    [PrimaryKey]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [EWFGBusUnitID]      INT      NOT NULL,
    [Month]              DATETIME NOT NULL,
    [EWFlashCategoryID]  INT      NOT NULL,
    [Units]              INT      NULL,
    [AvePrice]           MONEY    NULL,
    [GrossRevenue]       MONEY    NULL,
    [DiscountPct]        MONEY    NULL,
    [NetRevenue]         MONEY    NULL,
    [DoctorExpensePct]   MONEY    NULL,
    [DoctorExpense]      MONEY    NULL,
    [ContributionMargin] MONEY    NULL,
    [UserIDEdited]       INT      NULL,
    [DateEdited]         DATETIME NULL,
    CONSTRAINT [PK_EWBudgetFlashCategory] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWBudgetFlashCategory_EWFGBusUnitIDMonthEWFlashCategoryID]
    ON [dbo].[EWBudgetFlashCategory]([EWFGBusUnitID] ASC, [Month] ASC, [EWFlashCategoryID] ASC) WITH (FILLFACTOR = 90);

