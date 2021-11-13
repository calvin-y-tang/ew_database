CREATE TABLE [dbo].[tblStorageRetentionRule](
	[StorageRetentionRuleID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessOrder] [int] NOT NULL,
	[DeleteDays] [int] NOT NULL,
	[OfficeCode] [int] NULL,
	[CaseType] [int] NULL,
	[DateAdded] [datetime] NULL,
	[UserIDAdded] [varchar](15) NULL,
	[DateEdited] [datetime] NULL,
	[UserIDEdited] [varchar](15) NULL,
 CONSTRAINT [PK_tblStorageRetentionRule] PRIMARY KEY CLUSTERED ([StorageRetentionRuleID] ASC)
);
