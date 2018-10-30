CREATE PROCEDURE [dbo].[proc_tblCompanyUpdate]
(
	@companycode int,
	@extname varchar(70) = NULL,
	@intname varchar(70) = NULL,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@marketercode varchar(15) = NULL,
	@priority varchar(10) = NULL,
	@phone varchar(15) = NULL,
	@status varchar(10) = NULL,
	@dateadded datetime = NULL,
	@useridadded varchar(20) = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(20) = NULL,
	@usdvarchar1 varchar(50) = NULL,
	@usdvarchar2 varchar(50) = NULL,
	@usddate1 datetime = NULL,
	@usddate2 datetime = NULL,
	@usdtext1 text = NULL,
	@usdtext2 text = NULL,
	@usdint1 int = NULL,
	@usdint2 int = NULL,
	@usdmoney1 money = NULL,
	@usdmoney2 money = NULL,
	@credithold bit = NULL,
	@feecode int = NULL,
	@notes text = NULL,
	@preinvoice bit = NULL,
	@invoicedocument varchar(15) = NULL,
	@QARep varchar(15) = NULL,
	@photoRqd bit = NULL,
	@Country varchar(50) = NULL,
	@PublishOnWeb bit = NULL,
	@WebGUID uniqueidentifier = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblCompany]
	SET
		[extname] = @extname,
		[intname] = @intname,
		[addr1] = @addr1,
		[addr2] = @addr2,
		[city] = @city,
		[state] = @state,
		[zip] = @zip,
		[marketercode] = @marketercode,
		[priority] = @priority,
		[phone] = @phone,
		[status] = @status,
		[dateadded] = @dateadded,
		[useridadded] = @useridadded,
		[dateedited] = @dateedited,
		[useridedited] = @useridedited,
		[usdvarchar1] = @usdvarchar1,
		[usdvarchar2] = @usdvarchar2,
		[usddate1] = @usddate1,
		[usddate2] = @usddate2,
		[usdtext1] = @usdtext1,
		[usdtext2] = @usdtext2,
		[usdint1] = @usdint1,
		[usdint2] = @usdint2,
		[usdmoney1] = @usdmoney1,
		[usdmoney2] = @usdmoney2,
		[credithold] = @credithold,
		[feecode] = @feecode,
		[notes] = @notes,
		[preinvoice] = @preinvoice,
		[invoicedocument] = @invoicedocument,
		[QARep] = @QARep,
		[photoRqd] = @photoRqd,
		[Country] = @Country,
		[PublishOnWeb] = @PublishOnWeb,
		[WebGUID] = @WebGUID
	WHERE
		[companycode] = @companycode


	SET @Err = @@Error


	RETURN @Err
END
