-- Sprint 109


-- // new table in EWData Repository - to handle the InvoiceUpdate.txt file for the DR process
USE [EWDataRepository]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AcctInvoiceUpdate](
	[AcctInvoiceUpdateID] [INT] IDENTITY(1,1) NOT NULL,
	[FormatVersion] [INT] NULL,
	[ExportDate] [DATETIME] NULL,
	[SourceID] [INT] NULL,
	[InvoiceNo] [VARCHAR](15) NULL,
	[EWFacilityID] [INT] NULL,
	[CompanyID] [VARCHAR](11) NULL,
	[OldClientID] [VARCHAR](15) NULL,
	[NewClientID] [VARCHAR](15) NULL,
	[ClaimNo] [VARCHAR](50) NULL,
	[CaseNo] [VARCHAR](15) NULL,
	[BatchNo] [INT] NULL,
	[EventDate] [DATETIME] NULL,
	[EventType] [INT] NULL,
	[GPExportStatus] [INT] NULL,
	CONSTRAINT [PK_AcctInvoiceUpdate] PRIMARY KEY CLUSTERED ([AcctInvoiceUpdateID] ASC)
)
GO



-- // new table in IMECentricMaster - to handle the data from AcctInvoiceUpdate for the DR-GP process
USE [IMECentricMaster]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GPInvoiceUpdate](
	[PrimaryKey] [int] IDENTITY(1,1) NOT NULL,
	[FormatVersion] [int] NULL,
	[ProcessedFlag] [BIT] NOT NULL,
	[ExportDate] [datetime] NULL,
	[SourceID] [int] NULL,
	[InvoiceNo] [varchar](15) NULL,
	[EWFacilityID] [int] NULL,
	[GPFacilityID] [varchar](3) NULL,
	[CompanyID] [varchar](11) NULL,
	[GPCustomerID] [varchar](15) NULL,
	[OldClientID] [varchar](15) NULL,
	[NewClientID] [varchar](15) NULL,
	[ClaimNo] [varchar](50) NULL,
	[CaseNo] [varchar](15) NULL,
	[BatchNo] [varchar](15) NULL,
	[EventDate] [datetime] NULL,
	[EventType] [int] NULL,
	CONSTRAINT [PK_GPInvoiceUpdate] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
)
GO