CREATE PROCEDURE [proc_PublishOnWeb_Insert]
(
	@PublishID int = NULL output,
	@TableType varchar(50) = NULL,
	@TableKey int = NULL,
	@UserID varchar(50) = NULL,
	@UserType varchar(50) = NULL,
	@UserCode int = NULL,
	@PublishOnWeb bit,
	@Notify bit,
	@PublishasPDF bit,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL,
	@Viewed bit,
	@CaseNbr int = NULL,
	@DateViewed datetime = NULL,
	@UseWidget bit = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	INSERT
	INTO [tblPublishOnWeb]
	(
		[TableType],
		[TableKey],
		[UserID],
		[UserType],
		[UserCode],
		[PublishOnWeb],
		[Notify],
		[PublishasPDF],
		[DateAdded],
		[UseridAdded],
		[DateEdited],
		[UseridEdited],
		[Viewed],
		[CaseNbr],
		[DateViewed],
		[UseWidget]
	)
	VALUES
	(
		@TableType,
		@TableKey,
		@UserID,
		@UserType,
		@UserCode,
		@PublishOnWeb,
		@Notify,
		@PublishasPDF,
		@DateAdded,
		@UseridAdded,
		@DateEdited,
		@UseridEdited,
		@Viewed,
		@CaseNbr,
		@DateViewed,
		@UseWidget
	)

	SET @Err = @@Error

	SELECT @PublishID = SCOPE_IDENTITY()

	RETURN @Err
END
GO