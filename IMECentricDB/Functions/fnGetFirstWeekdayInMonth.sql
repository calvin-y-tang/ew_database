
CREATE FUNCTION [dbo].[fnGetFirstWeekdayInMonth]
(
    @DayOfWeek INT
    ,@ReferenceDate DATETIME2
)
RETURNS DATE
AS
BEGIN
	DECLARE
        @Result DATE = NULL
    ;  

    SELECT @Result =
        DATEADD(
            DAY
            ,7
            ,dbo.[fnGetLastWeekdayInMonth] (@DayOfWeek, DATEADD(MONTH, -1, @ReferenceDate))
        )
    ;

	RETURN @Result;

END