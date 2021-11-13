CREATE TABLE [dbo].[tblWebReferralForm](
	[WebReferralFormID] [int] IDENTITY(1,1) NOT NULL,
	[FormKey] [varchar](50) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[UseQuestionEngine] [bit] NOT NULL,
	[DateAdded] [DATETIME] NULL,
	[UserIDAdded] [varchar](15) NULL,
	[DateEdited] [DATETIME] NULL,
	[UserIDEdited] [varchar](15) NULL,
 CONSTRAINT [PK_tblWebReferralForm] PRIMARY KEY CLUSTERED 
(
	[WebReferralFormID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
