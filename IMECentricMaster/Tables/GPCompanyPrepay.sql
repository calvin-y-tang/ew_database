CREATE TABLE [dbo].[GPCompanyPrepay] (
    [PrimaryKey]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FormatVersion]   INT           NOT NULL,
    [ProcessedFlag]   BIT           NOT NULL,
    [ExportDate]      DATETIME      NOT NULL,
    [SourceID]		  INT			NOT NULL,
	[CheckNo]		  VARCHAR(20)	NOT NULL,
	[CheckDate]		  DATETIME		NOT NULL,
	[Comment]		  VARCHAR		NULL,
	[GPFacilityID]	  VARCHAR(3)	NOT NULL,
	[GPLocationID]	  VARCHAR(3)	NOT NULL,
	[CompanyID]		  VARCHAR(11)	NOT NULL,
	[ClaimNo]         VARCHAR(50)	NULL,
	[CaseNo]	      VARCHAR(15)	NOT NULL,
	[BatchNo]         VARCHAR(15)	NOT NULL,
	[TotalAmount]     MONEY			NOT NULL,
	[MonetaryUnit]    INT			NOT NULL,
	[User]            VARCHAR(25)	NULL,
	[Office]		  VARCHAR(15)	NULL,
    CONSTRAINT [PK_GPCompanyPrepay] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);
GO



CREATE NONCLUSTERED INDEX [IX_GPCompanyPrepay_ExportDate]
    ON [dbo].[GPCompanyPrepay]([ExportDate] ASC);
GO
