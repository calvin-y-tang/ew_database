-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : AcctHeader
-- Issue   : IMEC-12600 Add new column for CaseDocID
--
USE EWDataRepository
ALTER TABLE AcctHeader ADD CaseDocID INT NULL
GO


-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : EWCompanyType
-- Issue   : IMEC-12652 Add new company type value for IDR 
use [IMECentricMaster]

if not exists (select 1 from IMECentricMaster.dbo.EWCompanyType where EWCompanyTypeID = 8 and Name = 'IDR')
begin

	insert into IMECentricMaster.dbo.EWCompanyType (EWCompanyTypeID, SeqNo, [Name]) values (8,8,'IDR')
end
go

-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : GPCompany
-- Issue   : IMEC-12652 Add new company type id column to table GPCompany for IDR changes
use [IMECentricMaster]

if not exists (select 1 from sys.columns where object_id = OBJECT_ID(N'[IMECentricMaster].[dbo].[GPCompany]') and [name] = 'EWCompanyTypeID')
begin	
	alter table GPCompany add [EWCompanyTypeID] int
end
go