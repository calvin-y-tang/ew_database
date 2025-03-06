

--------------------------------------------------------------------------
--Add a new user function for changing the OrigApptTime on the case manually
--------------------------------------------------------------------------


insert into tbluserfunction (functioncode, functiondesc)
 select 'CaseChgOrigApptTime', 'Case - Change Original Appt Time'
 where not exists (select functionCode from tblUserFunction where functionCode='CaseChgOrigApptTime')

GO



--------------------------------------------------------------------------
--Add a table to determine if transaction is in the posting period and is allowed to be finalized
--------------------------------------------------------------------------

CREATE TABLE [tblEWPostingPeriod] (
  [PostingPeriodID] INTEGER IDENTITY(1,1) NOT NULL,
  [OpenMonth] INTEGER NOT NULL,
  [OpenYear] INTEGER NOT NULL,
  CONSTRAINT [PK_tblEWPostingPeriod] PRIMARY KEY ([PostingPeriodID])
)
GO


CREATE UNIQUE INDEX [IdxtblEWPostingPeriod_UNIQUE_OpenYearOpenMonth] ON [tblEWPostingPeriod]([OpenYear],[OpenMonth])
GO

--------------------------------------------------------------------------
--Add fields to store exchange rate and US dollar figures
--------------------------------------------------------------------------

ALTER TABLE [tblAcctDetail]
  ADD [ExtAmountUS] MONEY
GO


ALTER TABLE [tblAcctHeader]
  ADD [MonetaryUnit] INTEGER
GO

ALTER TABLE [tblAcctHeader]
  ADD [ExchangeRate] DECIMAL(15,7)
GO

ALTER TABLE [tblAcctHeader]
  ADD [DocumentTotalUS] MONEY
GO

CREATE TABLE [tblEWExchangeRate] (
  [PrimaryKey] INTEGER IDENTITY(1,1) NOT NULL,
  [MonetaryUnit] INTEGER NOT NULL,
  [ExchangeRateDate] DATETIME NOT NULL,
  [ExchangeRate] DECIMAL(15,7) NOT NULL,
  CONSTRAINT [PK_tblExchangeRate] PRIMARY KEY ([PrimaryKey])
)
GO

CREATE UNIQUE INDEX [IdxtblEWExchangeRate_UNIQUE_MonetaryUnitExchangeRateDate] ON [tblEWExchangeRate]([MonetaryUnit],[ExchangeRateDate])
GO

ALTER TABLE [tblIMEData]
  ADD [MonetaryUnit] INTEGER
GO

UPDATE tblIMEData SET MonetaryUnit=1
GO


UPDATE tblControl SET DBVersion='1.50'
GO
