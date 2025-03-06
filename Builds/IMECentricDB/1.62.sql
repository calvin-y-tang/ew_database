

ALTER TABLE [tblAcctDetail]
  ADD [RetailAmount] MONEY
GO


UPDATE tblControl SET DBVersion='1.62'
GO
