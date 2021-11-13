CREATE PROCEDURE [proc_GetSaveDateTimeByEWTimeZoneID]
(
	@EWTimeZoneID int
)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT dbo.fnGetUTCOffset (EWTimeZoneID, getutcdate()) Offset
		FROM tblEWTimeZone
		WHERE EWTimeZoneID = @EWTimeZoneID

	SET @Err = @@Error

	RETURN @Err
END
GO