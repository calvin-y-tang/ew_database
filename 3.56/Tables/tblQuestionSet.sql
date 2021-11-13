CREATE TABLE [dbo].[tblQuestionSet]
(
	[QuestionSetID] INT				IDENTITY (1, 1) NOT NULL,
	[Name]			VARCHAR(100)	NOT NULL,
	[DateAdded]		DATETIME		NOT NULL, 
	[UserIDAdded]	VARCHAR(15)		NOT NULL, 
	[DateEdited]	DATETIME		NULL, 
	[UserIDEdited]	VARCHAR(15)		NULL, 
    CONSTRAINT [PK_tblQuestionSet] PRIMARY KEY ([QuestionSetID])
)
