CREATE PROCEDURE [dbo].[proc_Info_Progressive_MgtRpt]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255)
AS

IF OBJECT_ID('tempdb..##tmpProgessiveMgtRpt') IS NOT NULL DROP TABLE ##tmpProgessiveMgtRpt

print 'Executing main progressive query ...'
EXEC [dbo].[proc_Info_Progressive_MgtRpt_QueryData] @startDate, @endDate, @ewFacilityIdList
print 'Executing progressive patch data ...'
EXEC [dbo].[proc_Info_Progressive_MgtRpt_PatchData]