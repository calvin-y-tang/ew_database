
-- Sprint 82


-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : EWCompanyType
-- Issue   : IMEC-12652 Add new company type value for IDR 
use [IMECentricMaster]

insert into IMECentricMaster.dbo.EWCompanyType (EWCompanyTypeID, SeqNo, [Name]) values (8,8,'IDR')
go

-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : EWCompanyType
-- Issue   : IMEC-12652 Add new company type value for IDR 
use [EWDataRepository]

insert into EWDataRepository.dbo.EWCompanyType (EWCompanyTypeID, SeqNo, [Name]) values (8,8,'IDR')
go

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : GPCompany
-- Issue   : IMEC-12652 Add new company type id column to table GPCompany for IDR changes
use [IMECentricMaster]

alter table GPCompany add [EWCompanyTypeID] int
go


-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : AcctHeader
-- Issue   : IMEC-12654 Add new ClientRefNo2 column to table AcctHeader
use [EWDataRepository]

alter table AcctHeader add [ClientRefNo2] varchar(50)
go


-- Database: EW_IME_CENTRIC
-- Catalog : [IMECentricMaster]
-- Table   : GPInvoice
-- Issue   : IMEC-12654 Add new ClientRefNo2 column to table GPInvoice
use [IMECentricMaster]

alter table GPInvoice add [ClientRefNo2] varchar(50)
go