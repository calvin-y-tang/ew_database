
-- Sprint 82


-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : EWCompanyType
-- Issue   : IMEC-12652 Add new company type value for IDR 
use [IMECentricMaster]

insert into IMECentricMaster.dbo.EWCompanyType (EWCompanyTypeID, SeqNo, [Name]) values (8,8,'IDR')

go

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : GPCompany
-- Issue   : IMEC-12652 Add new company type id column to table GPCompany for IDR changes
use [IMECentricMaster]

alter table GPCompany add [EWCompanyTypeID] int
go