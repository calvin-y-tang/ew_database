
CREATE TABLE [dbo].[tblCustomerData](
	[CustomerDataID] [int] IDENTITY(1,1) NOT NULL,
	[Version] [int] NOT NULL,
	[TableType] [varchar](64) NOT NULL,
	[TableKey] [int] NOT NULL,
	[Param] [varchar](4096) NOT NULL,
	[CustomerName] [varchar](64) NOT NULL,
 CONSTRAINT [PK_tblCustomerData] PRIMARY KEY CLUSTERED 
(
	[CustomerDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE tblEWBulkBilling ADD [UseEDIExport] [bit] NULL
GO
ALTER TABLE tblEWBulkBilling ADD [EDIExportFormat] [varchar](32) NULL
GO
ALTER TABLE tblEWBulkBilling ADD [EDIExportType] [varchar](32) NULL
GO
ALTER TABLE tblAcctHeader ADD [EDISubmissionCount] [int] NULL 
GO
ALTER TABLE tblAcctHeader ADD [EDISubmissionDateTime] [datetime] NULL
GO




UPDATE tblControl SET DBVersion='2.36'
GO
