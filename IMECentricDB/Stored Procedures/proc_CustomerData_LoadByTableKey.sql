CREATE PROCEDURE [proc_CustomerData_LoadByTableKey]
(
	@TableKey int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT *

	FROM [tblCustomerData]
	WHERE
		([TableKey] = @TableKey)

	SET @Err = @@Error

	RETURN @Err
END
GO