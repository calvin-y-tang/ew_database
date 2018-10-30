

--Determin if a given day is a work day.  Currently it only checks if the day is a weekday, not taking holiday into consideration
CREATE FUNCTION fnIsWorkDay
(
  @Date DATETIME
)
RETURNS BIT
BEGIN

DECLARE @isWorkDay BIT

SELECT
  @isWorkDay =
  CASE (DATEPART(dw, @Date) + @@DATEFIRST) % 7
    WHEN 1 THEN 0 --'Sunday'
    WHEN 2 THEN 1 --'Monday'
    WHEN 3 THEN 1 --'Tuesday'
    WHEN 4 THEN 1 --'Wednesday'
    WHEN 5 THEN 1 --'Thursday'
    WHEN 6 THEN 1 --'Friday'
    WHEN 0 THEN 0 --'Saturday'
  END

RETURN @isWorkDay

END

