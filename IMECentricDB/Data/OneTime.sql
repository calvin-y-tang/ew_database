
-- Sprint 84


-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : AcctHeader
-- Issue   : IMEC-12728 Add new ObjectID field to the AcctHeader table
use [EWDataRepository]

alter table AcctHeader
	add ObjectID varchar(30)
go

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : GPInvoice
-- Issue   : IMEC-12728 Add new ObjectID field to the GPInvoice table
use [IMECentricMaster]

alter table GPInvoice
	add ObjectID varchar(30)
go