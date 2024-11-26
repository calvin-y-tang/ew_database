CREATE TABLE [dbo].[tblQuestionSet]
(
	[QuestionSetID]   INT		   IDENTITY (1, 1) NOT NULL,
	[DateAdded]		  DATETIME	   NOT NULL, 
	[UserIDAdded]	  VARCHAR(15)  NOT NULL, 
	[DateEdited]      DATETIME	   NULL, 
	[UserIDEdited]	  VARCHAR(15)  NULL, 
	[ProcessOrder]    INT          NULL,
	[ParentCompanyID] INT          NULL,
	[CompanyCode]     INT          NULL,
	[CaseType]        INT          NULL,
	[Jurisdiction]    VARCHAR(2)   NULL,
	[EWServiceTypeID] INT          NULL,
	[ServiceCode]     INT          NULL,
	[OfficeCode]      INT          NULL,
	[Active]          BIT          CONSTRAINT [DF_tblQuestionSet_Active] DEFAULT (0) NULL,
    CONSTRAINT [PK_tblQuestionSet] PRIMARY KEY ([QuestionSetID])
)
