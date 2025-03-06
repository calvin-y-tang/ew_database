
-- Add column to tblIMEData to enable multiple treating physicians button on case form
ALTER TABLE [dbo].[tblIMEData] ADD
[UseMutipleTreatingPhysicians] [bit] NULL

go

/****** Object:  Table [dbo].[tblTreatingPhysician]    Script Date: 06/06/2011 19:47:02 ******/
CREATE TABLE [dbo].[tblTreatingPhysician](
	[SeqNo] [int] IDENTITY(1,1) NOT NULL,
	[ChartNbr] [int] NOT NULL,
	[Name] [varchar](70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [varchar](70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [varchar](70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneExt] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Fax] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](70) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LicenseNbr] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TaxID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OldKey] [int] NULL,
	[DateAdded] [datetime] NULL,
	[UserIDAdded] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tblTreatingPhysician] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblTreatingPhysician] ON [dbo].[tblTreatingPhysician] 
(
	[ChartNbr] ASC
)WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO


---------------------------------------------------------------------
--Remove unused column and views
---------------------------------------------------------------------
ALTER TABLE tblAcctHeader
 DROP COLUMN BillingCompanyCode
GO
DROP VIEW vwReferralbyMonthCalledIn
GO
DROP VIEW vwReferralbyMonthCalledInDocs
GO



------------------------------------------------------------------------------------------
--Additional fields and table to enable multiple Web Portal site per IME Centric database
------------------------------------------------------------------------------------------

CREATE TABLE [tblWebCompany] (
  [WebCompanyID] INTEGER NOT NULL,
  [Name] VARCHAR(25),
  CONSTRAINT [PK_tblWebCompany] PRIMARY KEY ([WebCompanyID])
)
GO


ALTER TABLE [tblIMEData]
  ADD [MultiPortal] BIT
GO


ALTER TABLE [tblWebUser]
  ADD [WebCompanyID] INTEGER
GO


UPDATE tblControl SET DBVersion='1.53'
GO
