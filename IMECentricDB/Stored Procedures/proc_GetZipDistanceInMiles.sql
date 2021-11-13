


CREATE PROCEDURE proc_GetZipDistanceInMiles

@zip0 varchar(7), 
@zip1 varchar(7)

AS
DECLARE @lat0 float
DECLARE @lon0 float
DECLARE @lat1 float
DECLARE @lon1 float
DECLARE @lonDiff float
DECLARE @x float
DECLARE @radDist float
DECLARE @miles float
/* PRINT "ERROR: An error occurred getting the ytd_sales." */

set @lat0=0
set @lon0=0

EXEC proc_GetLatLon
  @zip = @zip0, 
  @lat = @lat0 OUTPUT,
  @lon = @lon0 OUTPUT

set @lat1=0
set @lon1=0

EXEC proc_GetLatLon
  @zip = @zip1, 
  @lat = @lat1 OUTPUT,
  @lon = @lon1 OUTPUT
IF (@lat0 = 0 OR @lat1 = 0 OR @lon0 = 0 or @lon1 = 0)
 BEGIN
  SET @miles = -1
  /* Return @miles */
  SELECT  miles = @miles
 END
IF (@lat0 = @lat1 AND @lon0 = @lon1)
 BEGIN
  SET @miles = 0
  /* Return @miles */
  SELECT  miles = @miles
 END
SET @lat0 = @lat0 * PI() / 180
SET @lon0 = @lon0 * PI()/ 180
SET @lat1 = @lat1 * PI() / 180
SET @lon1 = @lon1 * PI() / 180
SET @lonDiff = ABS(@lon0 - @lon1)
SET @x = SIN(@lat0) * SIN(@lat1) + COS(@lat0) * COS(@lat1) * COS(@lonDiff)
SET @radDist = ATAN(-@x / SQRT (-@x * @x + 1)) + 2 * ATAN(1)
SET @miles = @radDist * 3958.754 /* miles */
SELECT  miles = @miles




