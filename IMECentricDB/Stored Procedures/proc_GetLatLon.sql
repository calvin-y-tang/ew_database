

CREATE PROCEDURE proc_GetLatLon

@zip varchar(7), 
@lat float OUTPUT, 
@lon float OUTPUT 

AS
SELECT @lat = fLatitude, @lon = fLongitude
FROM tblZipCode
WHERE sZip = @zip

