CREATE TABLE [dbo].[tblElectronicMessage] (
	[MessageID] 	INT 			NOT NULL 	IDENTITY(1,1),
	[CaseNbr] 		INT 			NULL,
	[SubjectLine] 	VARCHAR(120) 	NULL,
	[UserIDSent] 	VARCHAR(15) 	NULL,
	[DateSent] 		DATETIME 		NULL,
	[Document] 		VARCHAR(15) 	NULL,
	[To] 			VARCHAR(200) 	NOT NULL, 
	[CC] 			VARCHAR(200) 	NOT NULL, 
	[BCC] 			VARCHAR(200) 	NOT NULL, 
	[RecordType] 	VARCHAR (50) 	NULL,
    CONSTRAINT [PK_tblElectronicMessage] PRIMARY KEY CLUSTERED ([MessageID] ASC)
);

