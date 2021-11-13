
CREATE PROCEDURE [proc_GetDefaultOffice]

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT MIN(OfficeCode)

	FROM [tblOffice]
	WHERE Status = 'Active'
	
	SET @Err = @@Error

	RETURN @Err
END
