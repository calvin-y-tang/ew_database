CREATE TABLE [dbo].[tblCaseDetermination]
(
	[CaseNbr]         INT          NOT NULL, 
	[DoctorSummary]   VARCHAR(MAX) NULL, 
	[EWSummary]       VARCHAR(MAX) NULL, 
	[UserIDAdded]     VARCHAR(25)  NOT NULL, 
	[DateAdded]       DATETIME     NOT NULL, 
	[UserIDEdited]    VARCHAR(25)  NULL, 
	[DateEdited]      DATETIME     NULL, 
	[DateSummarySent] DATETIME     NULL,
	CONSTRAINT [PK_tblCaseDetermination] PRIMARY KEY CLUSTERED ([CaseNbr] ASC)
)
