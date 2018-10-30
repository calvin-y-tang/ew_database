CREATE TABLE [dbo].[tblWebReferralFormRule](
	[WebReferralFormRuleID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessOrder]		[int]			NULL,
	[Jurisdiction]		[varchar](2)	NULL,
	[ParentCompanyID]	[int]			NULL,
	[CompanyCode]		[int]			NULL,
	[EWServiceTypeID]	[int]			NULL,
	[ServiceCode]		[int]			NULL,
	[WebReferralFormID] [int]			NULL,
	[EWBusLineID]		[int]			NULL,
 CONSTRAINT [PK_tblWebReferralFormRule] PRIMARY KEY CLUSTERED 
(
	[WebReferralFormRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

