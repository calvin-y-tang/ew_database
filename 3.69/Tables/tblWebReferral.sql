CREATE TABLE [dbo].[tblWebReferral](
	[WebReferralID] [int] IDENTITY(1,1) NOT NULL,
	[JSONModel] [text] NULL,
	[ReferralHTML] [text] NULL,
	[CaseNbr] [int] NULL,
	[ClaimNbr] [varchar](50) NULL,
	[ClaimNbrExt] [varchar](50) NULL,
	[ClientCode] [int] NULL,
	[ClientName] [varchar](100) NULL,
	[ServiceType] [varchar](100) NULL,
	[CaseType] [varchar](100) NULL,
	[Jurisdiction] [varchar](50) NULL,
	[ExamineeFirstName] [varchar](100) NULL,
	[ExamineeLastName] [varchar](100) NULL,
	[WebReferralFormID] [int] NULL,
	[DateCaseCreated] [datetime] NULL,
	[DateAdded] [datetime] NULL,
	[UserIdAdded] [varchar](50) NULL,
	[DateEdited] [datetime] NULL,
	[UserIdEdited] [varchar](50) NULL,
	[Specialty] [varchar](200) NULL,
	[ReferralStatus] [varchar](50)
 CONSTRAINT [PK_tblWebReferral] PRIMARY KEY CLUSTERED 
(
	[WebReferralID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    [DoctorBlockTimeSlotID] INT NULL, 
    [DPSDueDate] DATETIME NULL, 
    [SortModelID] INT NULL, 
    [DPSDeliverWebPortal] BIT NULL, 
    [DPSDeliverEmailLink] BIT NULL, 
    [DPSDeliverOther] BIT NULL, 
    [DPSSpecialInstructions] VARCHAR(500) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO