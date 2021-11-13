CREATE TABLE [dbo].[tblWebFileUpload](
	[WebFileUploadID] [int] IDENTITY(1,1) NOT NULL,
	[WebUserID] [int] NULL,
	[CaseDocTypeID] [int] NULL,
	[FileName] [varchar](255) NULL,
	[Description] [varchar](1000) NULL,
	[DateUploaded] [smalldatetime] NULL,
 CONSTRAINT [PK_tblWebFileUpload] PRIMARY KEY CLUSTERED 
(
	[WebFileUploadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
) ON [PRIMARY]
GO

