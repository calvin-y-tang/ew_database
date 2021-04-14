CREATE TABLE [dbo].[tblCaseOverviewGroup]
(
	[CaseOverviewGroupID]  INT          IDENTITY (1, 1) NOT NULL, 
	[CaseNbr]              INT          NOT NULL, 
	[FieldNumber]          INT          NOT NULL, 
	[Description]          VARCHAR(100) NOT NULL, 
	[SelectionType]        VARCHAR(50)  NOT NULL,
	[UserIDAdded]          VARCHAR(25)  NOT NULL, 
	[DateAdded]            DATETIME     NOT NULL, 
	[UserIDEdited]         VARCHAR(25)  NULL, 
	[DateEdited]           DATETIME     NULL, 
	CONSTRAINT [PK_tblCaseOverviewGroup] PRIMARY KEY CLUSTERED ([CaseOverviewGroupID] ASC)
)
