ALTER TABLE EWDataRepository.dbo.Client ALTER COLUMN Email VARCHAR (150) NULL

ALTER TABLE IMECentricMaster.dbo.GPClient ALTER COLUMN Email VARCHAR (150) NULL

ALTER TABLE IMECentricMaster.dbo.EWParentCompany DROP CONSTRAINT DF_EWParentCompany_RecordRetrievalMethod
ALTER TABLE IMECentricMaster.dbo.EWParentCompany  ALTER COLUMN RecordRetrievalMethod INT NULL
GO




-- For each database using Acct Quote
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
