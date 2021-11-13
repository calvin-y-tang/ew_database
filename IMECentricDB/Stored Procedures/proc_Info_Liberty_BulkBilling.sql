CREATE PROCEDURE [dbo].[proc_Info_Liberty_BulkBilling]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
	-- EXEC [dbo].[proc_Info_Liberty_BulkBilling_InitData]
	EXEC [dbo].[proc_Info_Liberty_BulkBilling_QueryData] @startDate, @endDate, @ewFacilityIdList
	EXEC [dbo].[proc_Info_Liberty_BulkBilling_PatchData]

