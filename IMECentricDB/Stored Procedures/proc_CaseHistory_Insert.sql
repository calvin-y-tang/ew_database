CREATE PROCEDURE [proc_CaseHistory_Insert]
(
	@id int = NULL output,
	@casenbr int,
	@eventdate datetime,
	@eventdesc varchar(50) = NULL,
	@userid varchar(15) = NULL,
	@otherinfo varchar(1000) = NULL,
	@duration int = NULL,
	@type varchar(20) = NULL,
	@status int = NULL,
	@dateedited datetime = NULL,
	@useridedited varchar(30) = NULL,
	@dateadded datetime = NULL,
	@SubCaseID int = NULL,
	@Highlight bit = NULL,
	@Viewed bit,
	@PublishedTo varchar(50) = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblCaseHistory]
	(
		[casenbr],
		[eventdate],
		[eventdesc],
		[userid],
		[otherinfo],
		[duration],
		[type],
		[status],
		[dateedited],
		[useridedited],
		[dateadded],
		[SubCaseID],
		[Highlight],
		[Viewed],
		[PublishedTo]
	)
	VALUES
	(
		@casenbr,
		@eventdate,
		@eventdesc,
		@userid,
		@otherinfo,
		@duration,
		@type,
		@status,
		@dateedited,
		@useridedited,
		@dateadded,
		@SubCaseID,
		@Highlight,
		@Viewed,
		@PublishedTo
	)

	SET @Err = @@Error

	SELECT @id = SCOPE_IDENTITY()

	RETURN @Err
END
GO