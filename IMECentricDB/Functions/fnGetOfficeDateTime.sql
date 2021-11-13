CREATE FUNCTION dbo.fnGetOfficeDateTime()
RETURNS @retOfficeDateTime TABLE 
(
    OfficeCode int PRIMARY KEY NOT NULL, 
    OfficeDateTime DateTime NULL,
    OfficeDate Date NULL
)
AS 
BEGIN
    BEGIN
        INSERT @retOfficeDateTime
        SELECT O.OfficeCode, DATEADD(HOUR, dbo.fnGetUTCOffset(O.EWTimeZoneID, GETUTCDATE()), GETUTCDATE()) AS OfficeDateTime, CONVERT(DATE, DATEADD(HOUR, dbo.fnGetUTCOffset(O.EWTimeZoneID, GETUTCDATE()), GETUTCDATE())) AS OfficeDate
              FROM tblOffice AS O;
    END;
    RETURN;
END
