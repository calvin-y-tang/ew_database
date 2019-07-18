CREATE TABLE [dbo].[tblStorageRetentionRule](
	[StorageRetentionRuleID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessOrder] [int] NOT NULL,
	[Jurisdiction] [varchar](2) NULL,
	[OfficeCode] [int] NULL,
	[ParentCompanyID] [int] NULL,
	[CompanyCode] [int] NULL,
	[CaseType] [int] NULL,
	[Required] [bit] NOT NULL,
	[Exclude] [bit] NOT NULL,
	[DateAdded] [datetime] NULL,
	[UserIDAdded] [varchar](15) NULL,
	[DateEdited] [datetime] NULL,
	[UserIDEdited] [varchar](15) NULL,
 CONSTRAINT [PK_tblStorageRetentionRule] PRIMARY KEY CLUSTERED ([StorageRetentionRuleID] ASC)
);
