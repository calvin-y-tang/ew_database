CREATE TABLE [dbo].[tblCaseContactRequest](
	[CaseContactReqID] [int] IDENTITY(1,1) NOT NULL,
	[CaseNbr] [int] NULL,
	[Department] [varchar](100) NULL,
	[EWEmailAddress] [varchar](255) NULL,
	[UserEmailAddress] [varchar](255) NULL,
	[Phone] [varchar](50) NULL,
	[Message] [varchar](max) NULL,
	[IMECentricCode] [int] NULL,
	[UserType] [char](2) NULL,
	[NotificationSent] [bit] NULL,
	[DateNotificationSent] [smalldatetime] NULL,
	[DateAdded] [smalldatetime] NULL,
	[UserIDAdded] [varchar](50) NULL,
 CONSTRAINT [PK_tblCaseContactRequest] PRIMARY KEY CLUSTERED 
(
	[CaseContactReqID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]