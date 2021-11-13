CREATE TABLE [dbo].[tblWebReferralFormSpecialty](
	[WebReferralFormSpecialtyID] [int] IDENTITY(1,1) NOT NULL,
	[WebReferralFormID] [int] NOT NULL,
	[EWSpecialtyID] [int] NULL,
 CONSTRAINT [PK_tblWebReferralFormSpecialty] PRIMARY KEY CLUSTERED 
(
	[WebReferralFormSpecialtyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]