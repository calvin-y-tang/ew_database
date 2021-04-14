CREATE TABLE [dbo].[tblCaseOverviewGroupItem]
(
	[CaseOverviewGroupItemID] INT          IDENTITY (1, 1) NOT NULL, 
	[CaseOverviewGroupID]     INT          NOT NULL,
	[ItemNumber]              INT          NOT NULL, 
	[ResponseValue]           VARCHAR(8)   NOT NULL, 
	[Description]             VARCHAR(MAX) NOT NULL, 
	[IsSelected]              BIT          NULL, 
	[UserIDAdded]             VARCHAR(15)  NOT NULL, 
	[DateAdded]               DATETIME     NOT NULL, 
	[UserIDEdited]            VARCHAR(15)  NULL, 
	[DateEdited]              DATETIME     NULL, 
	CONSTRAINT [PK_tblCaseOverviewGroupItem] PRIMARY KEY CLUSTERED ([CaseOverviewGroupItemID] ASC)
)
