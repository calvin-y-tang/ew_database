CREATE PROCEDURE [dbo].[proc_tblcaseproblemInsert]
(
	@casenbr int,
	@problemcode int,
	@dateadded datetime = NULL,
	@useridadded varchar(15) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblcaseproblem]
	(
		[casenbr],
		[problemcode],
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@casenbr,
		@problemcode,
		@dateadded,
		@useridadded
	)

	SET @Err = @@Error


	RETURN @Err
END
