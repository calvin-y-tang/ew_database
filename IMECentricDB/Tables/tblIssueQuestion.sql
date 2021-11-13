CREATE TABLE [dbo].[tblIssueQuestion]
(
	[IssueQuestionID]	INT				IDENTITY (1, 1) NOT NULL,
	[IssueCode]			INT				NOT NULL,
	[QuestionText]		VARCHAR(1600)	NOT NULL,
	[DateAdded]			DATETIME	NULL, 
	[UserIDAdded]		VARCHAR(15) NULL, 
	[DateEdited]		DATETIME	NULL, 
	[UserIDEdited]		VARCHAR(15) NULL, 
    CONSTRAINT [PK_tblIssueQuestion] PRIMARY KEY ([IssueQuestionID])
)
