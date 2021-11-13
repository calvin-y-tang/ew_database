CREATE PROCEDURE [proc_ExamineeUpdatePrimaryAddress]
(
	@chartnbr int,
	@addr1 varchar(50) = NULL,
	@addr2 varchar(50) = NULL,
	@city varchar(50) = NULL,
	@state varchar(2) = NULL,
	@zip varchar(10) = NULL,
	@userId varchar(15) = NULL,
	@dateedited datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblExaminee]
	SET
		[addr1] = @addr1,
		[addr2] = @addr2,
		[city] = @city,
		[state] = @state,
		[zip] = @zip,
		[useridedited] = @userid,
		[dateedited] = @dateedited
	WHERE
		[chartnbr] = @chartnbr


	SET @Err = @@Error


	RETURN @Err
END
GO