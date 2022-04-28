CREATE TABLE [dbo].[CompanyPrepay] (
    [CompanyPrepayID]   INT         IDENTITY(1,1) NOT NULL,
	[FormatVersion]     INT         NULL,
	[ExportDate]        DATETIME    NULL,
	[SourceID]          INT         NULL,
	[CheckNo]           VARCHAR(20) NULL,
	[CheckDate]         DATETIME    NULL,
	[Comment]           VARCHAR(30) NULL,
	[EWFacilityID]      INT         NULL,
	[EWLocationID]      INT         NULL,
	[CompanyID]         INT			NULL,
	[ClaimNo]           VARCHAR(50) NULL,
	[CaseNo]            VARCHAR(15) NULL,
	[BatchNo]           INT         NULL,
	[TotalAmount]       MONEY       NULL,
	[MonetaryUnit]      INT         NULL,
	[User]              VARCHAR(25) NULL,
	[Office]            VARCHAR(15) NULL,
	[GPExportStatus]    INT         NULL,    
    CONSTRAINT [PK_CompanyPrepay] PRIMARY KEY CLUSTERED ([CompanyPrepayID] ASC)
);

GO

