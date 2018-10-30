CREATE TABLE [dbo].[tblWebUserChangeRequest](
	[WebUserChgReqID] [int] IDENTITY(1,1) NOT NULL,
	[UserType] [char](2) NULL,
	[IMECentricCode] [int] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[MiddleInitial] [char](1) NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [char](2) NULL,
	[Zip] [varchar](10) NULL,
	[Phone] [varchar](15) NULL,
	[Fax] [varchar](15) NULL,
	[Mobile] [varchar](15) NULL,
	[OfficePhone] [varchar](15) NULL,
	[EmailAddress] [varchar](150) NULL,
	[BankInfoAccountType] [varchar](30) NULL,
	[BankInfoRoutingNumber] [varchar](30) NULL,
	[BankInfoAccountNumber] [varchar](30) NULL,
	[EmailSent] [bit] NULL,
	[EmailSentEmailAddress] [varchar](150) NULL,
	[EmailSentDate] [smalldatetime] NULL,
	[DateAdded] [smalldatetime] NULL,
	[UserIDAdded] [varchar](15) NULL,
	[DateEdited] [smalldatetime] NULL,
	[UserIDEdited] [varchar](15) NULL,
 CONSTRAINT [PK_tblWebUserChangeRequest] PRIMARY KEY CLUSTERED 
(
	[WebUserChgReqID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

