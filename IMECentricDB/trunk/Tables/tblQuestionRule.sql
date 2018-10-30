CREATE TABLE [dbo].[tblQuestionRule]
(
	[QuestionRuleID]	INT         IDENTITY (1, 1) NOT NULL,	
	[ProcessOrder]		INT			NOT NULL,
	[CaseType]			INT			NULL,
	[Jurisdiction]		VARCHAR(2)	NULL,
	[ParentCompanyID]	INT			NULL,
	[CompanyCode]		INT			NULL,
	[ServiceCode]		INT			NULL,
	[QuestionSetID]		INT			NOT NULL,
	[ShowQuestions]		BIT			NULL,
	[DateAdded]			DATETIME	NOT NULL, 
	[UserIDAdded]		VARCHAR(15) NOT NULL, 
	[DateEdited]		DATETIME	NULL, 
	[UserIDEdited]		VARCHAR(15) NULL, 
    [OfficeCode] INT NOT NULL, 
    CONSTRAINT [PK_tblQuestionRule] PRIMARY KEY ([QuestionRuleID])

)
