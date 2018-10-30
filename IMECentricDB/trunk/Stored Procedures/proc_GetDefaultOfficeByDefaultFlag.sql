CREATE PROCEDURE [proc_GetDefaultOfficeByDefaultFlag]

@ClientCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT TOP 1 OfficeCode FROM tblClientOffice WHERE ClientCode = @ClientCode AND IsDefault = 1

	SET @Err = @@Error

	RETURN @Err
END
GO