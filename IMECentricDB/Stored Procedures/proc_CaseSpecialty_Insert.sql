
CREATE PROCEDURE [dbo].[proc_CaseSpecialty_Insert]
(
	@casenbr int,
	@Specialtycode varchar(500),
	@dateadded datetime = NULL,
	@useridadded varchar(30) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseSpecialty]
	(
		[casenbr],
		[Specialtycode],
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@casenbr,
		@Specialtycode,
		@dateadded,
		@useridadded
	)

	SET @Err = @@Error


	RETURN @Err
END
