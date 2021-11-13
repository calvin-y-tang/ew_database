CREATE PROCEDURE [proc_PublishOnWeb_Update]
(
	@PublishID int,
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
	@Viewed bit = NULL,
	@CaseNbr int = NULL,
	@DateViewed datetime = NULL,
	@UseWidget bit = NULL
)
AS
BEGIN

	SET NOCOUNT OFF
	DECLARE @Err int

	UPDATE [tblPublishOnWeb]
	SET
		[TableType] = @TableType,
		[TableKey] = @TableKey,
		[UserID] = @UserID,
		[UserType] = @UserType,
		[UserCode] = @UserCode,
		[PublishOnWeb] = @PublishOnWeb,
		[Notify] = @Notify,
		[PublishasPDF] = @PublishasPDF,
		[DateAdded] = @DateAdded,
		[UseridAdded] = @UseridAdded,
		[DateEdited] = @DateEdited,
		[UseridEdited] = @UseridEdited,
		[Viewed] = @Viewed,
		[CaseNbr] = @CaseNbr,
		[DateViewed] = @DateViewed,
		[UseWidget] = @UseWidget
	WHERE
		[PublishID] = @PublishID


	SET @Err = @@Error


	RETURN @Err
END
GO