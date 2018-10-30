CREATE PROCEDURE [dbo].[proc_Info_Hartford_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
	EXEC [dbo].[proc_Info_Hartford_MgtRpt_InitData]
	EXEC [dbo].[proc_Info_Hartford_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList
	EXEC [dbo].[proc_Info_Hartford_MgtRpt_PatchData]



