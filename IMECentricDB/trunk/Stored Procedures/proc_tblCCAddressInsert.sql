CREATE PROCEDURE [dbo].[proc_tblCCAddressInsert]
(
	@cccode int = NULL output,
	@prefix varchar(5) = NULL,
	@lastname varchar(50) = NULL,
	@firstname varchar(50) = NULL,
	@company varchar(70) = NULL,
	@address1 varchar(50) = NULL,
	@address2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(15) = NULL,
	@phone varchar(15) = NULL,
	@phoneextension varchar(15) = NULL,
	@fax varchar(15) = NULL,
	@email varchar(70) = NULL,
	@status varchar(10) = NULL,
	@useridadded varchar(15) = NULL,
	@dateadded datetime = NULL,
	@useridedited varchar(15) = NULL,
	@dateedited datetime = NULL,
	@officecode int = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCCAddress]
	(
		[prefix],
		[lastname],
		[firstname],
		[company],
		[address1],
		[address2],
		[city],
		[state],
		[zip],
		[phone],
		[phoneextension],
		[fax],
		[email],
		[status],
		[useridadded],
		[dateadded],
		[useridedited],
		[dateedited],
		[officecode]
	)
	VALUES
	(
		@prefix,
		@lastname,
		@firstname,
		@company,
		@address1,
		@address2,
		@city,
		@state,
		@zip,
		@phone,
		@phoneextension,
		@fax,
		@email,
		@status,
		@useridadded,
		@dateadded,
		@useridedited,
		@dateedited,
		@officecode
	)

	SET @Err = @@Error

	SELECT @cccode = SCOPE_IDENTITY()

	RETURN @Err
END
