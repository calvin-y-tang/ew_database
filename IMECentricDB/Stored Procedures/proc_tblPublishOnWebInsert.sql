CREATE PROCEDURE [dbo].[proc_tblPublishOnWebInsert]
(
	@PublishID int = NULL output,
	@TableType varchar(50) = NULL,
	@TableKey int = NULL,
	@UserID varchar(50) = NULL,
	@UserType varchar(50) = NULL,
	@UserCode int = NULL,
	@PublishOnWeb bit = NULL,
	@Notify bit = NULL,
	@PublishasPDF bit = NULL,
	@DateAdded datetime = NULL,
	@UseridAdded varchar(50) = NULL
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
		[UseridAdded]
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
		@UseridAdded
	)

	SET @Err = @@Error

	SELECT @PublishID = SCOPE_IDENTITY()

	RETURN @Err
END
