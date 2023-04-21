CREATE TABLE [dbo].[GPInvoiceUpdate] (
	[PrimaryKey]		INT			IDENTITY(1,1) NOT NULL,
	[FormatVersion]		INT			NULL,
	[ProcessedFlag]		BIT			NOT NULL,
	[ExportDate]		DATETIME	NULL,
	[SourceID]			INT			NULL,
	[InvoiceNo]			VARCHAR(15)	NULL,
	[EWFacilityID]		INT			NULL,
	[GPFacilityID]		VARCHAR(3)	NULL,
	[CompanyID]			VARCHAR(11)	NULL,
	[GPCustomerID]		VARCHAR(15)	NULL,
	[OldClientID]		VARCHAR(15)	NULL,	
	[NewClientID]		VARCHAR(15)	NULL,	
	[ClaimNo]			VARCHAR(50)	NULL,
	[CaseNo]			VARCHAR(15)	NULL,
	[BatchNo]			VARCHAR(15)	NULL,
	[EventDate]			DATETIME	NULL,
	[EventType]			INT			NULL,
    CONSTRAINT [PK_GPInvoiceUpdate] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);
GO

