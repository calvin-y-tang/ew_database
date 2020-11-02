INSERT INTO tblUserFunction
(
    FunctionCode,
    FunctionDesc,
    DateAdded
)
VALUES
(   'CustomATICExport',
    'Custom - ATIC Export',
    GETDATE()
    )

GO



-- // 11822 - update / patch records where the fee unit is not 'Fee','Hourly','Inch','Each'
with
x as (
	select AcctQuoteID, CaseNbr, FeeUnit,
		(case
			when FeeUnit like '%hr%' then 'Hourly'
			when FeeUnit like '%hour%' then 'Hourly'
			else 'Fee'
			end) as ChangeFeeUnit
	from tblAcctQuote taq
	where FeeUnit not in ('Fee','Hourly','Inch','Each')
)
update tblAcctQuote set FeeUnit = x.ChangeFeeUnit
from tblAcctQuote y join x on y.AcctQuoteID = x.AcctQuoteID
GO



-- // 11822 - update / patch records where the fee unit is not 'Fee','Hourly','Inch','Each'
with
x as (
	select AcctQuoteFeeID, AcctQuoteID, FeeUnit,
		(case
			when FeeUnit like '%hr%' then 'Hourly'
			when FeeUnit like '%hour%' then 'Hourly'
			else 'Fee'
			end) as ChangeFeeUnit
	from tblAcctQuoteFee taqf
	where FeeUnit not in ('Fee','Hourly','Inch','Each')
)
update tblAcctQuoteFee set FeeUnit = x.ChangeFeeUnit
from tblAcctQuoteFee y join x on y.AcctQuoteFeeID = x.AcctQuoteFeeID
GO



-- Issue 11728 - New Quote number token and bookmark
  INSERT INTO tblMessageToken (Name) VALUES ('@QuoteNbr@')

