CREATE TABLE [dbo].[tblCaseDetermination]
(
	[CaseNbr]       INT          NOT NULL, 
	[DoctorSummary] VARCHAR(MAX) NULL, 
	[EWSummary]     VARCHAR(MAX) NULL, 
	[UserIDAdded]   VARCHAR(15)  NOT NULL, 
	[DateAdded]     DATETIME     NOT NULL, 
	[UserIDEdited]  VARCHAR(15)  NULL, 
	[DateEdited]    DATETIME     NULL, 
	CONSTRAINT [PK_tblCaseDetermination] PRIMARY KEY CLUSTERED ([CaseNbr] ASC)
)
