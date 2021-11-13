CREATE PROCEDURE [dbo].[proc_tblPublishOnWebUpdate]
(
	@PublishID int,
	@TableType varchar(50) = NULL,
	@TableKey int = NULL,
	@UserID varchar(50) = NULL,
	@UserType varchar(50) = NULL,
	@UserCode int = NULL,
	@PublishOnWeb bit = NULL,
	@Notify bit = NULL,
	@PublishasPDF bit = NULL,
	@DateEdited datetime = NULL,
	@UseridEdited varchar(50) = NULL
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
		[DateEdited] = @DateEdited,
		[UseridEdited] = @UseridEdited
	WHERE
		[PublishID] = @PublishID


	SET @Err = @@Error


	RETURN @Err
END
