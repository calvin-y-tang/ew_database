CREATE TABLE [dbo].[EWExchangeRate] (
    [PrimaryKey]       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MonetaryUnit]     INT             NOT NULL,
    [ExchangeRateDate] DATETIME        NOT NULL,
    [ExchangeRate]     DECIMAL (15, 7) NOT NULL,
    CONSTRAINT [PK_EWExchangeRate] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_EWExchangeRate_MonetaryUnitExchangeRateDate]
    ON [dbo].[EWExchangeRate]([MonetaryUnit] ASC, [ExchangeRateDate] ASC) WITH (FILLFACTOR = 90);

