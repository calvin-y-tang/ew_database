


--Format TAT into formatted string
CREATE FUNCTION fnGetTATString 
(
 @tat INT
)
RETURNS VARCHAR(20)
AS
BEGIN

--Declare and initialize variables
DECLARE @days INT
DECLARE @hours INT
DECLARE @mins INT
DECLARE @workHourPerDay INT
 
 SELECT TOP 1 @workHourPerDay = WorkHourEnd-WorkHourStart FROM tblControl ORDER BY InstallID
            
    SELECT @hours = FLOOR(@tat / 60)
    SELECT @mins = @tat % 60
    SELECT @days = FLOOR(@hours / @workHourPerDay)
    SELECT @hours = @hours % @workHourPerDay
            
    --Only return non zero values
    DECLARE @result VARCHAR(20)
    SELECT @result = ''
    If @days > 0
  SELECT @result = CAST(@days AS VARCHAR) + 'd '
    If @hours > 0
  SELECT @result = @result + CAST(@hours AS VARCHAR) + 'h '
    If @mins > 0
  SELECT @result = @result + CAST(@mins AS VARCHAR) + 'm '
    SELECT @result = RTRIM(@result)
    --If all zero, use "< 1m" rather than empty string
    If @result = ''
  SELECT @result = '< 1m'
    RETURN @result
END

