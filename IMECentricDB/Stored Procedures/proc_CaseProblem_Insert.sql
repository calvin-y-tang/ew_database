CREATE PROCEDURE [proc_CaseProblem_Insert]
(
	@casenbr int,
	@problemcode int,
	@problemareacode int = NULL,
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
		[problemareacode],
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@casenbr,
		@problemcode,
		@problemareacode,
		@dateadded,
		@useridadded
	)

	SET @Err = @@Error


	RETURN @Err
END
GO