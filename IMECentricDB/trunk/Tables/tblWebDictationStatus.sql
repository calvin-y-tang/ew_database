CREATE TABLE [dbo].[tblWebDictationStatus](
	[DictationStatusID] [int] IDENTITY(1,1) NOT NULL,
	[CaseNbr] [int] NULL,
	[DoctorCode] [int] NULL,
	[DictationFileName] [varchar](255) NULL,
	[DictationFileSize] [bigint] NULL,
	[DictationStatus] [varchar](50) NULL,
	[UserIDAdded] [varchar](50) NULL,
	[DateAdded] [smalldatetime] NULL,
	[UserIDEdited] [varchar](50) NULL,
	[DateEdited] [smalldatetime] NULL,
	[DictationCompleteDate] [smalldatetime] NULL,
 [Duration] TIME NULL, 
    CONSTRAINT [PK_tblWebDictationStatus] PRIMARY KEY CLUSTERED 
(
	[DictationStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

