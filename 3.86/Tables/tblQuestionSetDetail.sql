CREATE TABLE [dbo].[tblQuestionSetDetail]
(
	[QuestionSetDetailID] INT         IDENTITY (1, 1) NOT NULL,
	[QuestionSetID]			INT			NOT NULL,
	[IssueQuestionID]		INT			NOT NULL,
	[DateAdded]				DATETIME	NOT NULL, 
	[UserIDAdded]			VARCHAR(15)	NOT NULL, 
	[GroupOrder]			INT			NULL,
	[RowOrder]				INT			NULL,
    CONSTRAINT [PK_tblQuestionSetDetail] PRIMARY KEY ([QuestionSetDetailID])

)

GO

CREATE UNIQUE INDEX [IX_U_tblQuestionSetDetail_QuestionSetIDIssueQuestionID] ON [dbo].[tblQuestionSetDetail] ([QuestionSetID], [IssueQuestionID])
