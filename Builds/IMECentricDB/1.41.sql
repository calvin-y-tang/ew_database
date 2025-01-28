
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tblCaseICD9')
 Drop TABLE [tblCaseICD9]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCaseICD9](
	[SeqNo] [int] IDENTITY(1,1) NOT NULL,
	[CaseNbr] [int] NOT NULL,
	[ICD9Code] [varchar](10) NULL,
	[Status] [varchar](50) NULL,
	[Description] [varchar](200) NULL,
	[DateAdded] [datetime] NULL,
	[UserIDAdded] [varchar](50) NULL,
	[DateEdited] [datetime] NULL,
	[UserIDEdited] [varchar](50) NULL,
 CONSTRAINT [PK_tblCaseICD9] PRIMARY KEY CLUSTERED 
(
	[SeqNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Object:  Table [dbo].[tblCodes]    Script Date: 03/04/2011 15:48:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCodes](
	[CodeID] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SubCategory] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Value] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tblCodes] PRIMARY KEY CLUSTERED 
(
	[CodeID] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','SenderID','72602')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ReceiverID','100000')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ReceiverCode','77025')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','SubmitterName','Ricwel of West Virginia')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ContactName','Teri Crossan')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ContactPhone','6148896626')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ContactExtension','1115')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ContactFax','6147937909')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ContactEmail','Teri.Crossan@ExamWorks.com')
INSERT INTO [tblcodes] ([Category],[SubCategory],[Value])VALUES('Brickstreet','ReceiverName','Brickstreet Mutual Insurance')
GO


UPDATE tblCase SET InputSourceID=2
 WHERE InputSourceID IS NULL
 AND casenbr IN
(
SELECT casenbr FROM tblCaseHistory
 WHERE type='Web'
 AND (eventdesc='Case Added' OR eventdesc='Web Portal referral added')
)
GO
UPDATE tblCase SET InputSourceID=1
 WHERE InputSourceID IS NULL
GO



update tblControl set DBVersion='1.41'
GO
