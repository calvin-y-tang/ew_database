CREATE PROCEDURE [proc_GetDefaultOfficeByDefaultFlagByMin]

@ClientCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT MIN(OfficeCode) FROM tblClientOffice WHERE ClientCode = @ClientCode

	SET @Err = @@Error

	RETURN @Err
END
GO