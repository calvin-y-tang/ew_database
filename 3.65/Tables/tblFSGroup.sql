CREATE TABLE [dbo].[tblFSGroup]
(
	[FSGroupID]       INT IDENTITY (1, 1) NOT NULL, 
	[FeeScheduleName] VARCHAR(30)  NOT NULL, 
	[DocumentType]    VARCHAR(2)   NOT NULL,
    [DateAdded]       DATETIME     NOT NULL,
    [UserIDAdded]     VARCHAR (30) NOT NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (30) NULL,
	CONSTRAINT [PK_tblFSGroup] PRIMARY KEY CLUSTERED ([FSGroupID] ASC)
)
