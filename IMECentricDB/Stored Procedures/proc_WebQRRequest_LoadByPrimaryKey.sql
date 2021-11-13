
CREATE PROCEDURE [proc_WebQRRequest_LoadByPrimaryKey]
(
	@QRRequestID int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblWebQRRequest]
	WHERE
		([QRRequestID] = @QRRequestID)

	SET @Err = @@Error

	RETURN @Err
END
