
CREATE PROCEDURE [proc_WebQRConfig_LoadByPrimaryKey]
(
	@EWFacilityId int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblWebQRConfig]
	WHERE
		([EWFacilityId] = @EWFacilityId)

	SET @Err = @@Error

	RETURN @Err
END
