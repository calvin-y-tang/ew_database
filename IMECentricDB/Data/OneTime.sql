
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



-- Database: EW_IME_CENTRIC
-- Catalog : EWDataRepository
-- Table   : CompanyPrepay
-- Issue   : IMEC-12653 Add support for optional file CompanyPrepay by adding new table in EWDataRepository
USE [EWDataRepository]

	
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
GO


-- Database: EW_IME_CENTRIC
-- Catalog : IMECentricMaster
-- Table   : GPCompanyPrepay
-- Issue   : IMEC-12653 Add support for optional file CompanyPrepay by adding new table in IMECentricMaster
USE [IMECentricMaster]

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
GO


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