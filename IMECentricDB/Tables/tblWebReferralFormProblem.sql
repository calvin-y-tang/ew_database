CREATE TABLE [dbo].[tblWebReferralFormProblem](
	[WebReferralFormProblemID] [int] IDENTITY(1,1) NOT NULL,
	[WebReferalFormID] [int] NOT NULL,
	[ProblemCode] [int] NULL,
 CONSTRAINT [PK_tblWebReferralFormProblem] PRIMARY KEY CLUSTERED 
(
	[WebReferralFormProblemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]