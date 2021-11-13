

--Return the Date value of a date time field
CREATE FUNCTION fnDateValue
(
  @Date datetime
)
RETURNS DATETIME
BEGIN

DECLARE @dateValue DATETIME
 SELECT @dateValue = DATEADD(dd, 0, DATEDIFF(dd, 0, @Date))
 RETURN @dateValue
END

