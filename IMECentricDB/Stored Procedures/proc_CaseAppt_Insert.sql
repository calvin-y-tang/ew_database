CREATE PROCEDURE [proc_CaseAppt_Insert]
(
	@CaseApptId int = NULL output,
	@CaseNbr int,
	@ApptTime datetime,
	@DoctorCode int = NULL,
	@LocationCode int = NULL,
	@SpecialtyCode varchar(50) = NULL,
	@ApptStatusId int,
	@DateAdded datetime = NULL,
	@DateReceived datetime = NULL,
	@UserIdAdded varchar(15) = NULL,
	@DateEdited datetime = NULL,
	@UserIdEdited varchar(15) = NULL,
	@CanceledById int = NULL,
	@Reason varchar(300) = NULL,
	@LastStatusChg datetime = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseAppt]
	(
		[CaseNbr],
		[ApptTime],
		[DoctorCode],
		[LocationCode],
		[SpecialtyCode],
		[ApptStatusId],
		[DateAdded],
		[DateReceived],
		[UserIdAdded],
		[DateEdited],
		[UserIdEdited],
		[CanceledById],
		[Reason],
		[LastStatusChg]
	)
	VALUES
	(
		@CaseNbr,
		@ApptTime,
		@DoctorCode,
		@LocationCode,
		@SpecialtyCode,
		@ApptStatusId,
		@DateAdded,
		@DateReceived,
		@UserIdAdded,
		@DateEdited,
		@UserIdEdited,
		@CanceledById,
		@Reason,
		@LastStatusChg
	)

	SET @Err = @@Error

	SELECT @CaseApptId = SCOPE_IDENTITY()

	RETURN @Err
END