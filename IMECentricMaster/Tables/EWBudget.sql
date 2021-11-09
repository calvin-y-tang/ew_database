CREATE TABLE [dbo].[EWBudget] (
    [EWFGBusUnitID]    INT      NOT NULL,
    [Month]            DATETIME NOT NULL,
    [WorkingDays]      INT      NULL,
    [OtherDirectCost]  MONEY    NULL,
    [PayrollExpense]   MONEY    NULL,
    [OperatingExpense] MONEY    NULL,
    [EBITDA]           MONEY    NULL,
    [Locked]           BIT      NULL,
    [Approved]         BIT      NULL,
    [UserIDEdited]     INT      NULL,
    [DateEdited]       DATETIME NULL,
    CONSTRAINT [PK_EWBudget] PRIMARY KEY CLUSTERED ([EWFGBusUnitID] ASC, [Month] ASC) WITH (FILLFACTOR = 90)
);

