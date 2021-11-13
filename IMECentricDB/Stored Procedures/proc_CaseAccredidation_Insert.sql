
CREATE PROCEDURE [proc_CaseAccredidation_Insert]
(
	@casenbr int,
	@EWAccreditationID int,
	@Description varchar(50),
	@dateadded datetime = NULL,
	@useridadded varchar(30) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseAccredidation]
	(
		[casenbr],
		[EWAccreditationID],
		[Description],
		[dateadded],
		[useridadded]
	)
	VALUES
	(
		@casenbr,
		@EWAccreditationID,
		@Description,
		@dateadded,
		@useridadded
	)

	SET @Err = @@Error


	RETURN @Err
END
