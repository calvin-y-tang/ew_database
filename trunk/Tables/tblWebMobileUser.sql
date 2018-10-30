CREATE TABLE [dbo].[tblWebMobileUser](
	[WebMobileUserID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[WebUserID] [int] NOT NULL,
	[MobileTokenID] NVARCHAR(MAX) NOT NULL,
	[DeviceType] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblWebMobileUser] PRIMARY KEY CLUSTERED 
(
	[WebMobileUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

