CREATE TABLE [dbo].[AcctInvoiceUpdate] (
	[AcctInvoiceUpdateID]	INT			IDENTITY(1,1) NOT NULL,
	[FormatVersion]			INT			NULL,
	[ExportDate]			DATETIME	NULL,
	[SourceID]				INT			NULL,
	[InvoiceNo]				VARCHAR(15)	NULL,
	[EWFacilityID]			INT			NULL,
	[CompanyID]				VARCHAR(11)	NULL,
	[OldClientID]			VARCHAR(15)	NULL,
	[NewClientID]			VARCHAR(15)	NULL,
	[ClaimNo]				VARCHAR(50)	NULL,
	[CaseNo]				VARCHAR(15)	NULL,
	[BatchNo]				INT			NULL,
	[EventDate]				DATETIME	NULL,
	[EventType]				INT			NULL,
	[GPExportStatus]		INT			NULL,
    CONSTRAINT [PK_AcctInvoiceUpdate] PRIMARY KEY CLUSTERED ([AcctInvoiceUpdateID] ASC)
);

GO

