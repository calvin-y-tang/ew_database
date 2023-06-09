-- Sprint 112

--
-- IMEC-13566 - Bulk Billing configuration for NYCM
--
USE [IMECentricMaster]
GO
INSERT INTO EWBulkBilling (
	BulkBillingID,
	Descrip,
	CreateInvDocument,
	AutoPrint,
	EDIExportToGPFirst,
	EDIExportAutoBatch,
	UseEDIExport,
	EDIExportFormat,
	EDIExportType,
	EDIERPCaseRequired,
	EDIRequireAttachment, 
	EDICustomParam,
	EDIShowClaimLookup,
	[Param]
)
VALUES (
	19,
	'New York Central Mutual',
	1,
	0,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
)

