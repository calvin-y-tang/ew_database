CREATE TABLE [dbo].[tblHCAIControl](
	[DBID] [int] NOT NULL,
	[PMSUserName] [varchar](30) NOT NULL,
	[PMSPassword] [varchar](30) NOT NULL,
	[FacilityRegistryID] [varchar](30) NOT NULL,
	[PMSSoftware] [varchar](30) NOT NULL,
	[MakeChequePayableTo] [varchar](100) NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL,
	[LogPath] [varchar](255) NOT NULL,
	[InstallationPath] [varchar](255) NOT NULL,
	[NewVersionPath] [varchar](255) NOT NULL,
	[IsLoggingEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_tblHCAIControl] PRIMARY KEY CLUSTERED 
(
	[DBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

UPDATE tblControl SET DBVersion='2.23'
GO
