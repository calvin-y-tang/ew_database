CREATE PROCEDURE [dbo].[proc_Info_Generic_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255),
	@feeDetailOption Int = 0,	
	@useCaseCompany Bit = 0
AS
	EXEC [dbo].[proc_Info_Generic_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList, @companyCodeList, @useCaseCompany
	EXEC [dbo].[proc_Info_Generic_MgtRpt_PatchData] @feeDetailOption
GO