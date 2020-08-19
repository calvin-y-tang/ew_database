CREATE TABLE [dbo].[tblWebSuperUser](
	[SuperUserID] [int] IDENTITY(1,1) NOT NULL,
	[WebUserID] [int] NULL,
	[EWBusLineID] [int] NULL,
	[ParentCompanyID] [int] NULL,
	[CompanyCode] [int] NULL,
	[SuperUserType] [char](2) NULL,
	[DateAdded] [smalldatetime] NULL,
	[UserIDAdded] [varchar](255) NULL,
	[DateEdited] [smalldatetime] NULL,
	[UserIDEdited] [varchar](255) NULL,
 CONSTRAINT [PK_tblWebSuperUser] PRIMARY KEY CLUSTERED 
(
	[SuperUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

