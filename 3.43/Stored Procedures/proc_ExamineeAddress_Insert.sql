CREATE PROCEDURE [proc_ExamineeAddress_Insert]
(
	@ExamineeAddressID int = NULL output,
	@chartnbr int,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@County varchar(50) = NULL,
	@dateadded datetime = NULL,
	@dateedited datetime = NULL,
	@useridadded varchar(15) = NULL,
	@useridedited varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblExamineeAddresses]
	(
		[chartnbr],
		[addr1],
		[addr2],
		[city],
		[state],
		[zip],
		[County],
		[dateadded],
		[dateedited],
		[useridadded],
		[useridedited]
	)
	VALUES
	(
		@chartnbr,
		@addr1,
		@addr2,
		@city,
		@state,
		@zip,
		@County,
		@dateadded,
		@dateedited,
		@useridadded,
		@useridedited
	)

	SET @Err = @@Error

	SELECT @ExamineeAddressID = SCOPE_IDENTITY()

	RETURN @Err
END
GO