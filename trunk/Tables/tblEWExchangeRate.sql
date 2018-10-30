CREATE TABLE [dbo].[tblEWExchangeRate] (
    [PrimaryKey]       INT             IDENTITY (1, 1) NOT NULL,
    [MonetaryUnit]     INT             NOT NULL,
    [ExchangeRateDate] DATETIME        NOT NULL,
    [ExchangeRate]     DECIMAL (15, 7) NOT NULL,
    CONSTRAINT [PK_tblEWExchangeRate] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblEWExchangeRate_MonetaryUnitExchangeRateDate]
    ON [dbo].[tblEWExchangeRate]([MonetaryUnit] ASC, [ExchangeRateDate] ASC);

