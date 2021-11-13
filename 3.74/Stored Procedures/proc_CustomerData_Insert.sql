CREATE PROCEDURE [proc_CustomerData_Insert]
(
	@CustomerDataID int = NULL output,
	@Version int = NULL,
	@TableType varchar(64) = NULL,
	@TableKey int = NULL,
	@Param varchar(max) = NULL,
	@CustomerName varchar(64) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCustomerData]
	(
		[Version],
		[TableType],
		[TableKey],
		[Param],
		[CustomerName]
	)
	VALUES
	(
		@Version,
		@TableType,
		@TableKey,
		@Param,
		@CustomerName
	)

	SET @Err = @@Error

	SELECT @CustomerDataID = SCOPE_IDENTITY()

	RETURN @Err
END
GO