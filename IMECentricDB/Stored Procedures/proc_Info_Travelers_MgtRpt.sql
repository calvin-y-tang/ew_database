CREATE PROCEDURE [dbo].[proc_Info_Travelers_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS
	EXEC [dbo].[proc_Info_Travelers_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList
	EXEC [dbo].[proc_Info_Travelers_MgtRpt_PatchData] @startDate, @endDate, @ewFacilityIdList


	