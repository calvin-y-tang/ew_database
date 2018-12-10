CREATE PROCEDURE [dbo].[proc_Info_Generic_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255)
AS
	EXEC [dbo].[proc_Info_Generic_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList, @companyCodeList
	EXEC [dbo].[proc_Info_Generic_MgtRpt_PatchData]