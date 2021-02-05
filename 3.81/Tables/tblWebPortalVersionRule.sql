CREATE TABLE [dbo].[tblWebPortalVersionRule](
	[WebPortalVersionRule] [int] IDENTITY(1,1) NOT NULL,
	[ProcessOrder] [int] NOT NULL,
	[UserType] [varchar](2) NULL,
	[WebUserID] [int] NULL,
	[CompanyCode] [int] NULL,
	[ParentCompanyID] [int] NULL,
	[EffectiveDate] [datetime] NOT NULL,
	[PortalVersion] [int] NOT NULL,
	[DateAdded] [datetime] NULL,
	[UserIDAdded] [varchar](15) NULL,
	[DateEdited] [datetime] NULL,
	[UserIDEdited] [varchar](15) NULL,
	[AllowScheduling] [bit] CONSTRAINT [DF_tblWebPortalVersionRule_AllowScheduling] DEFAULT (0) NULL,
 CONSTRAINT [PK_tblWebPortalVersionRule] PRIMARY KEY CLUSTERED ([WebPortalVersionRule] ASC)
);