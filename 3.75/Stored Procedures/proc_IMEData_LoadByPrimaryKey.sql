CREATE PROCEDURE [proc_IMEData_LoadByPrimaryKey]
(
	@ImeCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblIMEData
		WHERE ImeCode = @ImeCode

	SET @Err = @@Error

	RETURN @Err
END
GO