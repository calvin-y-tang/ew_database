
-- Issue 12218 - set all voucher quote ClientFeeBudgetAmt to 0
UPDATE tblAcctQuote set ClientFeeBudgetAmt = 0 WHERE QuoteType = 'VO' 
GO
