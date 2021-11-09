CREATE TABLE [dbo].[EWFlashInfo] (
    [EWFGBusUnitID]             INT      NOT NULL,
    [LastRepositoryUpdate]      DATETIME NULL,
    [LastRepositoryInvoiceDate] DATETIME NULL,
    [LastRepositoryVoucherDate] DATETIME NULL,
    [LastPortalForecastUpdate]  DATETIME NULL,
    [LastPortalFinancialUpdate] DATETIME NULL,
    [LastPortalARUpdate]        DATETIME NULL,
    CONSTRAINT [PK_EWFlashInfo] PRIMARY KEY CLUSTERED ([EWFGBusUnitID] ASC)
);

