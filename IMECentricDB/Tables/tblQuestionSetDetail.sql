CREATE TABLE [dbo].[tblQuestionSetDetail]
(
	[QuestionSetDetailID] INT IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[QuestionSetID]       INT         NOT NULL,
	[DateAdded]           DATETIME    NOT NULL,
	[UserIDAdded]         VARCHAR(15) NOT NULL,
	[DisplayOrder]        INT         NULL,
	[QuestionID]          INT         NULL,
    CONSTRAINT [PK_tblQuestionSetDetail] PRIMARY KEY ([QuestionSetDetailID])
)

GO

CREATE UNIQUE INDEX [IX_U_tblQuestionSetDetail_QuestionSetIDIssueQuestionID] 
	ON [dbo].[tblQuestionSetDetail] ([QuestionSetID], [QuestionID])
