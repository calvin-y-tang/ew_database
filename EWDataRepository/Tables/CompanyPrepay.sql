CREATE TABLE [dbo].[CompanyPrepay] (
    [CompanyPrepayID]   INT         IDENTITY(1,1) NOT NULL,
	[FormatVersion]     INT         NOT NULL,
	[ExportDate]        DATETIME    NOT NULL,
	[SourceID]          INT         NOT NULL,
	[CheckNo]           VARCHAR(20) NOT NULL,
	[CheckDate]         DATETIME    NOT NULL,
	[Comment]           VARCHAR     NULL,
	[EWFacilityID]      INT         NOT NULL,
	[EWLocationID]      INT         NOT NULL,
	[CompanyID]         VARCHAR(11) NOT NULL,
	[ClaimNo]           VARCHAR(50) NULL,
	[CaseNo]            VARCHAR(15) NOT NULL,
	[BatchNo]           INT         NOT NULL,
	[TotalAmount]       MONEY       NOT NULL,
	[MonetaryUnit]      INT         NOT NULL,
	[User]              VARCHAR(25) NULL,
	[Office]            VARCHAR(15) NULL,
	[GPExportStatus]    INT         NULL,    
    CONSTRAINT [PK_CompanyPrepay] PRIMARY KEY CLUSTERED ([CompanyPrepayID] ASC)
);

GO

