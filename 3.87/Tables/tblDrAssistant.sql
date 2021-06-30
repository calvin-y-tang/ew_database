CREATE TABLE [dbo].[tblDrAssistant](
	[DrAssistantID] [int]			IDENTITY(1,1) NOT NULL,
	[LastName]		[varchar](50)	NOT NULL,
	[FirstName]		[varchar](50)	NOT NULL,
	[Email]			[varchar](255)	NOT NULL,
	[Phone]			[varchar](15)	NOT NULL,
	[UserIDAdded]	[varchar](15)	NOT NULL,
	[DateAdded]		[datetime]		NOT NULL,
	[UserIDEdited]	[varchar](15)	NULL,
	[DateEdited]	[datetime]		NULL,
 CONSTRAINT [PK_tblDrAssistant] PRIMARY KEY CLUSTERED ([DrAssistantID] ASC)
);
