
CREATE FUNCTION [dbo].[fnGetBusinessDays](@StartDate DATETIME, @EndDate DATETIME ,@startFromBusinessDay bit = 1)
RETURNS INT 
AS
BEGIN
DECLARE @BusinessDays int
DECLARE @iNonWorkingDays int
DECLARE @iWeekendDays int
DECLARE @padStart int
DECLARE @padEnd int

SET @BusinessDays = 0

DECLARE @newStartDate DATETIME
DECLARE @newEndDate DATETIME

if DATEDIFF(Day, @StartDate, @EndDate) > 0 
	Begin

	if @startFromBusinessDay = 1 
		SELECT @iNonWorkingDays=count(NonWorkDay)
		FROM tblNonWorkDays where NonWorkDay >= CONVERT(VARCHAR(10),  @StartDate, 111) and NonWorkDay <= CONVERT(VARCHAR(10),  @EndDate, 111) 
		and DATENAME(dw, NonWorkDay)<>'Sunday' and DATENAME(dw, NonWorkDay)<>'Saturday'		
	else
		SELECT @iNonWorkingDays=count(NonWorkDay)
		FROM tblNonWorkDays where NonWorkDay > CONVERT(VARCHAR(10),  @StartDate, 111) and NonWorkDay <= CONVERT(VARCHAR(10),  @EndDate, 111) 
		and DATENAME(dw, NonWorkDay)<>'Sunday' and DATENAME(dw, NonWorkDay)<>'Saturday'		
		
		SELECT  @padStart = DATEPART(weekday, @StartDate), @padEnd =DATEPART(weekday,@EndDate)
		set @padStart = @padStart-1
		set @padEnd=7-@padEnd
		
		Set @newStartDate = DATEADD (DD , -@padStart , @StartDate ) 		
		Set @newEndDate = DATEADD (DD ,  @padEnd , @EndDate ) 
		

		SELECT @iWeekendDays = (DATEDIFF(dd, @newStartDate, @newEndDate)+1)/7
		select @iWeekendDays = @iWeekendDays *2
		
		if @padStart >0
			select @iWeekendDays = @iWeekendDays -1
		if @padEnd >0
			select @iWeekendDays = @iWeekendDays -1		
		if  @startFromBusinessDay = 0 and (DATENAME(dw, @StartDate) ='Sunday' or DATENAME(dw, @StartDate) ='Saturday')
			 set @iWeekendDays = @iWeekendDays -1	
		
		select @BusinessDays =DATEDIFF(dd, @StartDate, @EndDate) - @iNonWorkingDays - @iWeekendDays		
	End		
RETURN  @BusinessDays
END



GO


