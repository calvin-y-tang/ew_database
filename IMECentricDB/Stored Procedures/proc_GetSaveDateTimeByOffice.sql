CREATE PROCEDURE [proc_GetSaveDateTimeByOffice]
(
	@Officecode int
)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT dbo.fnGetUTCOffset (EWTimeZoneID, getutcdate()) Offset
		FROM tblEWTimeZone
		WHERE EWTimeZoneID = (SELECT EWTimeZoneID FROM tblOffice WHERE OfficeCode = @Officecode)

	SET @Err = @@Error

	RETURN @Err
END