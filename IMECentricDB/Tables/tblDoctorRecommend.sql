CREATE TABLE [dbo].[tblDoctorRecommend](
	[DoctorRecID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[EmailAddress] [varchar](100) NULL,
	[Specialty] [varchar](50) NULL,
	[StateLicensed] [nchar](10) NULL,
	[FeedbackTo] VARCHAR(50) NULL,
	[Notes] [varchar](max) NULL,
	[NominatedByFullName] [varchar](100) NULL,
	[NominatedByIMECentricCode] [int] NULL,
	[UserTypeAdded] [char](2) NULL,
	[UserIDAdded] [varchar](50) NULL,
	[DateAdded] [datetime] NULL,
	[ForwardedToCred] [bit] NULL,
	[ForwardedToCredEmail] [varchar](100) NULL,
	[ForwardedToCredDate] [datetime] NULL,
 CONSTRAINT [PK_tblDoctorRecommend] PRIMARY KEY CLUSTERED 
(
	[DoctorRecID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

