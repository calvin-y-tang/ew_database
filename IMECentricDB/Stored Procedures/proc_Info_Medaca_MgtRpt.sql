CREATE PROCEDURE [dbo].[proc_Info_Medaca_MgtRpt]	
	@startDate Date,
	@endDate Date,
	@useEditDate Bit	
AS
	EXEC [dbo].[proc_Info_Medaca_MgtRpt_QueryData] @startDate, @endDate, @useEditDate
	EXEC [dbo].[proc_Info_Medaca_MgtRpt_PatchData] @startDate, @endDate

	