CREATE PROCEDURE [proc_PublishOnWeb_CheckForDupe]
(
	@TableKey int,
	@TableType varchar(50),
	@UserType varchar(50),
	@UserCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT COUNT(*) FROM tblPublishOnWeb WHERE tablekey = @TableKey AND tabletype = @TableType AND UserType = @UserType AND UserCode = @UserCode AND PublishOnWeb = 1

	SET @Err = @@Error

	RETURN @Err
END
GO