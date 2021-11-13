CREATE TABLE [dbo].[tblOfficeState](
	[OfficeCode] 	INT 			NOT NULL,
	[State] 		VARCHAR (2) 	NOT NULL,
	[UserIDAdded] 	VARCHAR (15) 	NULL,
	[DateAdded] 	DATETIME 		NULL,
	CONSTRAINT [PK_tblOfficeState] PRIMARY KEY CLUSTERED ([OfficeCode] ASC, [State] ASC)
);