

--Calculate TAT Elapsed Time in Minutes
CREATE FUNCTION fnGetTATMins
(
 @startDate DATETIME,
 @endDate DATETIME
)
RETURNS INT
AS
BEGIN

--Declare and initialize variables
DECLARE @minStart INT
DECLARE @minEnd INT
DECLARE @days INT


SELECT @minStart = 0
SELECT @minEnd = 0
SELECT @days = 0

--Load system settings
DECLARE @workHourStart INT
DECLARE @workHourEnd INT
SELECT TOP 1 @workHourStart = WorkHourStart, @workHourEnd=WorkHourEnd FROM dbo.tblControl ORDER BY InstallID

--Temp variables used for calculation
DECLARE @hourStart DATETIME
DECLARE @hourEnd DATETIME
DECLARE @tmpDateTime DATETIME

 --Get the working minutes on the start day
 IF dbo.fnIsWorkDay(@startDate) = 1
  BEGIN
   --If the start time of the start date is before working hours start, use working hours start instead
   SELECT @tmpDateTime = DATEADD(hh, @workHourStart, dbo.fnDateValue(@startDate))
   IF @startDate > @tmpDateTime
    SELECT @hourStart = @startDate
   ELSE
    SELECT @hourStart = @tmpDateTime
   
   --if the end date is actually the same date as start AND before the working hours end, then use the end date time,
   --otherwise use the working hours end of the start date portion
   SELECT @tmpDateTime = DATEADD(hh, @workHourEnd, dbo.fnDateValue(@startDate))
   IF @endDate < @tmpDateTime
    SELECT @hourEnd = @endDate
   ELSE
    SELECT @hourEnd = @tmpDateTime

   --in case start and end time are both before working hours start OR both after working hours end
   --hours start can be after hour end, then just ignore and return 0 for minStart
   IF @hourStart < @hourEnd
    SELECT @minStart = DATEDIFF(n, @hourStart, @hourEnd)
  END

    --Only if start and end date are no the same day
    DECLARE @dateToCheck DATETIME
    SELECT @dateToCheck = DateAdd(d, 1, @startDate)
    --loop thru each day in between and see which one is working day
    While @dateToCheck < dbo.fnDateValue(@endDate)
 BEGIN
  If dbo.fnIsWorkDay(@dateToCheck) = 1
   SELECT @days = @days + 1
  SELECT @dateToCheck = DateAdd(d, 1, @dateToCheck)
 END

    --If end date is a working day and is not the same as start date, calculate the working minutes
    If dbo.fnIsWorkDay(@endDate) = 1 And (dbo.fnDateValue(@startDate) < dbo.fnDateValue(@endDate))
    BEGIN
        --Similar logic as minStart, calculate minEnd for end date
        SELECT @tmpDateTime = DateAdd(hh, @workHourStart, dbo.fnDateValue(@endDate))
        If @startDate > @tmpDateTime
            SELECT @hourStart = @startDate
        Else
            SELECT @hourStart = @tmpDateTime

        SELECT @tmpDateTime = DateAdd(hh, @workHourEnd, dbo.fnDateValue(@endDate))
        If @endDate < @tmpDateTime
            SELECT @hourEnd = @endDate
        Else
            SELECT @hourEnd = @tmpDateTime
        If @hourStart < @hourEnd
   SELECT @minEnd = DateDiff(n, @hourStart, @hourEnd)
    END
    
    --Return the total working time in minutes
 RETURN @minStart + (@days * (@workHourEnd - @workHourStart) * 60) + @minEnd
END

