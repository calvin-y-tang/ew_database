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



-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : CompanyPrepay
-- Issue   : IMEC-12653 Add support for optional file CompanyPrepay by adding new table in EWDataRepository
USE [EWDataRepository]

if not exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'CompanyPrepay')
begin
	
	create table [EWDataRepository].[dbo].[CompanyPrepay] (
		[PrimaryKey] [int] IDENTITY(1,1) NOT NULL,
		[FormatVersion] [int] NOT NULL,
		[ExportDate] [datetime] NOT NULL,
		[SourceID] [int] NOT NULL,
		[CheckNo] [varchar](20) NOT NULL,
		[CheckDate] [datetime] NOT NULL,
		[Comment] [varchar] NULL,
		[EWFacilityID] [int] NOT NULL,
		[EWLocationID] [int] NOT NULL,
		[CompanyID] [varchar](11) NOT NULL,
		[ClaimNo] [varchar](50) NULL,
		[CaseNo] [varchar](15) NOT NULL,
		[BatchNo] [int] NOT NULL,
		[TotalAmount] [money] NOT NULL,
		[MonetaryUnit] [int] NOT NULL,
		[User] [varchar](25) NULL,
		[Office] [varchar](15) NULL,
		[GPExportStatus] [int] NULL,
		constraint [PK_GPCompanyPrepay] PRIMARY KEY CLUSTERED (
			[PrimaryKey] ASC
		) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
end
GO


-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : GPCompanyPrepay
-- Issue   : IMEC-12653 Add support for optional file CompanyPrepay by adding new table in IMECentricMaster
USE [IMECentricMaster]

if not exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE' and TABLE_NAME = 'GPCompanyPrepay')
begin
	
	create table [IMECentricMaster].[dbo].[GPCompanyPrepay] (
		[PrimaryKey] [int] IDENTITY(1,1) NOT NULL,
		[FormatVersion] [int] NOT NULL,
		[ProcessedFlag] [bit] NOT NULL,
		[ExportDate] [datetime] NOT NULL,
		[SourceID] [int] NOT NULL,
		[CheckNo] [varchar](20) NOT NULL,
		[CheckDate] [datetime] NOT NULL,
		[Comment] [varchar](30) NULL,
		[GPFacilityID] [varchar](3) NOT NULL,
		[GPLocationID] [varchar](3) NOT NULL,
		[CompanyID] [varchar](11) NOT NULL,
		[ClaimNo] [varchar](50) NULL,
		[CaseNo] [varchar](15) NOT NULL,
		[BatchNo] [varchar](15) NOT NULL,
		[TotalAmount] [money] NOT NULL,
		[MonetaryUnit] [int] NOT NULL,
		[User] [varchar](25) NULL,
		[Office] [varchar](15) NULL,
		constraint [PK_GPCompanyPrepay] PRIMARY KEY CLUSTERED (
			[PrimaryKey] ASC
		) with (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
end
GO


-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : AcctHeader
-- Issue   : IMEC-12654 Add new ClientRefNo2 column to table AcctHeader
use [EWDataRepository]

if not exists (select 1 from sys.columns where object_id = OBJECT_ID(N'[EWDataRepository].[dbo].[AcctHeader]') and [name] = 'ClientRefNo2')
begin	
	alter table AcctHeader add [ClientRefNo2] varchar(50)
end
go


-- Database: EW_IME_CENTRIC
-- Catalog : [IMECentricMaster]
-- Table   : GPInvoice
-- Issue   : IMEC-12654 Add new ClientRefNo2 column to table GPInvoice
use [IMECentricMaster]

if not exists (select 1 from sys.columns where object_id = OBJECT_ID(N'[IMECentricMaster].[dbo].[GPInvoice]') and [name] = 'ClientRefNo2')
begin	
	alter table GPInvoice add [ClientRefNo2] varchar(50)
end
go